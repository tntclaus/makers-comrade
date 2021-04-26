include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>

include <../motors.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <NopSCADlib/vitamins/rod.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>

include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>


Z_MOUNT_HOLES = [  
                 [7.2,0,19.85, -25],
                 [7.2,0,19.85,  25],
];

VW_HOLES_20x3L = [
    [5,  0,-20,25],
    [7.2,0,19.85,  -25],

    [5,  0,-20,-25]
];

Z_PLATE = [[65,65],    5,      3,   VW_HOLES_20x3L, Z_MOUNT_HOLES];

Z_GANTRY = ["", Z_PLATE, [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], 20];

VSLOT_Z_RAIL = ["", Z_GANTRY, E2020];

//gantry_sq_plate_40x65x3_3_dxf();

module gantry_sq_plate_90x65x3_22_dxf() {
    projection() vslot_plate(Z_PLATE);
}

module z_gantry_plate_sketch() {
    translate([-25+3,0,0])
    square([50,60], center = true);
}

module z_gantry_plate_support_sketch() {
    translate([-25+3,0,0])
    square([50,60], center = true);
}

module z_gantry_plate() {
    linear_extrude(3)
    z_gantry_plate_sketch();
}

module zAxisRails(
            position = 0, 
            mirrored = false, 
            diff = false) {
    
    if(!diff) {
        positionAdj = 
                position > workingSpaceSizeMaxZ 
                    ? workingSpaceSizeMaxZ : 
                    position < workingSpaceSizeMinZ ? workingSpaceSizeMinZ :
                    position;
        
        translate([0, -baseLength, 20]) rotate([0,0,-90])
            vslot_rail(
                VSLOT_Z_RAIL, 
                baseFrontSize, 
                pos = positionAdj, 
                mirror = true,
                angles = true
            )   {
                depth = 60;
                difference() {
                    translate([0,-35.5,0]) rotate([0,90,90]) z_gantry_plate();
                    translate([0,-10,17]) rotate([0,-90,90]) drill(5, h=40);
                }
                translate([0,-29,17])
                    rotate([0,-90,90]) 
                        leadnut(LSN8x8);
            }
        if(mirrored)
            translate([0, 0, positionAdj+5]) printBed();
    }
    
    translate([0,0,-23]) 
        zAxisMotor(motorModel = NEMA17, diff = diff);
}

module zAxis(positionZ, diff = false) {
        zAxisRails(positionZ, mirrored = true, diff = diff);
        translate([-workingSpaceSize/2+20,0,0]) {
            mirror([0,1,0]) zAxisRails(positionZ, diff = diff);
            
        }
        translate([workingSpaceSize/2-20,0,0]) {
            mirror([0,1,0]) zAxisRails(positionZ, diff = diff);
        }

}


module zAxisMotor(motorTranslation = 0, motorModel, diff = false) {
    motorScrewY = frontPlateThickness+3;
    
    differ = motorTranslation < 0 ? 4 : 1;
    
    translate([
        0, 
        -baseLength+NEMA_width(motorModel)/2+10, 
        NEMA_length(motorModel)/2
    ]) {
        rotate([0,-90,0])
            motor(motorScrewY, motorModel, diff);
        
//        if(motorTranslation < 0) {    
//            xAxisMotorHolder(motorModel);    
//        } else {
//            rotate([180,0]) translate([0,0,-3])
//            xAxisMotorHolder(motorModel);    
//        }
        
        translate([0,0,workingSpaceSize/2+40]) leadscrew(
            8, 
            workingSpaceSize, 
            8, 
            2, 
            center = true
        );
    }
}


//workingSpaceSizeMaxZ = 600;
//workingSpaceSizeMinZ = 0;
//workingSpaceSize = 600;
//baseFrontSize = 500;
//zAxisLength = 500;
//baseLength = 500;
//frontPlateThickness = 4;
//zAxis(5);