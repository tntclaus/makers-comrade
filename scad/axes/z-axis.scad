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
include <../../lib/vslot_rails.scad>

include <../../lib/spherical_nuts.scad>

use <../heatbed.scad>

include <NopSCADlib/vitamins/pillow_blocks.scad>

Z_AXIS_LEADNUT = LSN8x2;

function leadscrew_mount_hole(pos) = [[pos-1.5,10], [pos+1.5,10]];

Z_MOUNT_HOLES = [  
    [7.2,0,20, -24],
    [7.2,0,20,  24],
    
    [3.01, 0,["square",leadscrew_mount_hole(-24)]],
    [3.01, 0,["square",leadscrew_mount_hole(-12)]],
    [3.01, 0,["square",leadscrew_mount_hole(  0)]],
    [3.01, 0,["square",leadscrew_mount_hole( 12)]],    
    [3.01, 0,["square",leadscrew_mount_hole( 24)]],    
//    [3, 0,["square",[[-27+1.5,0], [-21-1.5,0]]]],
//    [3, 0,["square",[[-27+1.5,0], [-21-1.5,0]]]],    
//    [2, 0,["square",[[-27,0], [-18,0]]]],    
];

VW_HOLES_20x3L = [
    [5,  0,-20, 25],
    [7.2,0, 20, 0],
    [5,  0,-20,-25]
];

Z_PLATE = [[60,60],    5,      3,   VW_HOLES_20x3L, Z_MOUNT_HOLES];

Z_GANTRY = ["", Z_PLATE, [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], 20];

VSLOT_Z_RAIL = ["", Z_GANTRY, E2020];

Z_GANTRY_GUIDE_ANGLE = 43.025;



module STEEL_gantry_sq_plate_60x60x3_22_dxf() {
    square_plate_sketch(Z_PLATE);
}

module z_gantry_plate_sketch() {

    translate([-25+3,0,0])
    difference() { 
        hull() {
            translate([22,0])
            square([0.1,60], center = true);
            
            translate([-23.5,0])
            circle(d = 25);
        }
        translate([-23.5,0]) {
            circle(d = 2.2);
            translate([0,-7])
            circle(d = 2.2);
            translate([0, 7])
            circle(d = 2.2);
        }
        
        translate([5+1,0]) {
            circle(d = leadnut_od(Z_AXIS_LEADNUT));
            for(a = [-45:90:315])
            rotate([0,0,a])
            translate([leadnut_hole_pitch(Z_AXIS_LEADNUT),0])
            circle(d = 3.1);
        }
    }
    
    for(y = [-24 : 12 : 24])
    translate([0,y])
    color("red")
    square([6,6], center = true);
}

module z_gantry_plate_support_sketch() {
    translate([-25+3,0,0])
    square([50,60], center = true);
}

module STEEL_z_gantry_plate_60_dxf() {
    z_gantry_plate_sketch();
}

module z_gantry_plate(angle = 0, show_beam = false) {
    dxf("z_gantry_plate_60");
    translate_z(-1.5-10) {
        color("red")
        linear_extrude(3)
        z_gantry_plate_sketch();
        translate([-45.5,0,3]) {
            assert(
            angle == 0 || angle == -1 || angle == 1, 
            str("angle must be either 0, 1 or -1, got ", angle));
            
            if(angle == 0) {
                stl("ABS_PC_z_gantry_block_center");
            } else if(angle == 1) {
                stl("ABS_PC_z_gantry_block_left");
            } else if(angle == -1) {
                stl("ABS_PC_z_gantry_block_right");        
            } 
            
            z_gantry_block_assembly(angle * Z_GANTRY_GUIDE_ANGLE, show_beam);
        }
    }
}

module ABS_PC_z_gantry_block_center_stl() {
    $fn = 90;
    z_gantry_block(0);
}

module ABS_PC_z_gantry_block_left_stl() {
    $fn = 90;
    z_gantry_block(Z_GANTRY_GUIDE_ANGLE);
}

module ABS_PC_z_gantry_block_right_stl() {
    $fn = 90;
    z_gantry_block(-Z_GANTRY_GUIDE_ANGLE);
}

module z_gantry_block(angle = 0) {
    block_h = 8;
    block_w = 20;    
    block_w_i = 8;
    translate_z(block_h/2)
    difference() {
        hull() {
            translate([-2,0,0])
            cylinder(d = block_w,  h = block_h, center = true);
            translate([27,0,0])
            cube([.1,block_w+5,block_h], center = true);
        }
        
        rotate([0,0,angle])
        translate([-1,0,-block_h/2]) 
         {           
            translate([0, 3.8,5+1])
            vtulka(22);
            translate([0,-3.8,5+1])
            vtulka(22);
        }
        
        translate([0,0,3])
        rotate([0,0,angle])
        cube([16, block_w_i+1, 3], center = true);

        translate([0,0,2])
        rotate([0,0,angle])
        color("blue")
        hull() {
            translate([-8,0,0])
            cube([.1,block_w_i,block_h], center = true);
            
            translate([8,0,0])            
            cube([.1,block_w_i,block_h], center = true);
            
        }
        
        // center point mount
        translate_z(-4){
            cylinder(d = 3, h = 0.35*2, center = true);
            hull() {
                cylinder(d = 3, h = 0.01, center = true);
                translate_z(1.65+1)
                cylinder(d = 6, h = 2, center = true);
            }
        }
        
        translate([29.5,0,0]) {
            cylinder(d = leadnut_od(Z_AXIS_LEADNUT), h = 100, center = true);
            for(a = [-45:90:315])
            rotate([0,0,a])
            translate([leadnut_hole_pitch(Z_AXIS_LEADNUT),0])
            cylinder(d = 3, h = 100, center = true);
        }
    }
    
}

module vtulka(l = 20) {
    rotate([0,90,0])
    color("silver")
    cylinder(d = 2, h = l, center = true);        
}

module z_gantry_block_assembly(angle = 0, show_beam = false) {
    z_gantry_block(angle);
    // nut
    rotate([0,0,angle]) {
        translate([0,0,16.05])
        rotate([180,0,0])
        spherical_nut_DIN_1587(NUT_DIN_1587_M5);
        
        // 
        translate([0, 3.8,5+1])
        vtulka();
        translate([0,-3.8,5+1])
        vtulka();
        //magnets
        color("gray") {
            translate([ 4,0,2])
            cylinder(d = 8, h = 3);
            translate([-4,0,2])
            cylinder(d = 8, h = 3);
        }
        if(show_beam)
            rotate([0,-90,0])
            cylinder(d = 1, h = 600);
    }

}


module zAxisRails(
    position = 0, 
    mirrored = false, 
    diff = false,
    angle = 0
) {
    
    if(!diff) {
        positionAdj = 
                position > workingSpaceSizeMaxZ 
                    ? workingSpaceSizeMaxZ : 
                    position < workingSpaceSizeMinZ ? workingSpaceSizeMinZ :
                    position;
        
        translate([0, -baseLength, 20]) rotate([0,0,-90]) {
            vslot_rail(
                VSLOT_Z_RAIL, 
                baseFrontSize, 
                pos = positionAdj, 
                mirror = true,
                angles = true
            )   {
                depth = 60;
                difference() {
                    translate([0,-20,0]) rotate([180,90,90]) z_gantry_plate(angle, false);
                    translate([0,-10,17]) rotate([0,-90,90]) drill(5, h=40);
                }
                translate([0,-4.4,17-1.15])
                    rotate([90,-0,0]) 
                        leadnut(Z_AXIS_LEADNUT);
            }

//            translate([-30.35,0,30])
//            rotate([0,0,-90])
//            kp_pillow_block_assembly(KP08_18);
        }
        
//        if(mirrored)
//            translate([0, 0, positionAdj+87.5]) 
//                rotate([0,0,180])
//                heatbed_table_assembly(600, 10, 25);
    }
    
    translate([0,0,-23]) 
        zAxisMotor(motorModel = NEMA17, diff = diff);
}

module zAxis(positionZ, diff = false) {
        zAxisRails(positionZ, mirrored = true, diff = diff, angle = 0);
        translate([-workingSpaceSize/2+20,0,0]) {
            mirror([0,1,0]) 
            zAxisRails(positionZ, diff = diff, angle = -1);
            
        }
        translate([workingSpaceSize/2-20,0,0]) {
            mirror([0,1,0]) 
            zAxisRails(positionZ, diff = diff, angle = 1);
        }
    
}


module zAxisMotor(motorTranslation = 0, motorModel, diff = false) {
    motorScrewY = frontPlateThickness+3;
    
    differ = motorTranslation < 0 ? 4 : 1;
    
    translate([
        0, 
        -baseLength+NEMA_width(motorModel)/2+10-.8, 
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

//
//workingSpaceSizeMaxZ = 600;
//workingSpaceSizeMinZ = 0;
//workingSpaceSize = 600;
//baseFrontSize = 600;
//zAxisLength = 500;
//baseLength = 360;
//frontPlateThickness = 4;
//zAxis(100);

//z_gantry_plate();
//ABS_PC_z_gantry_block_center_stl();
//ABS_PC_z_gantry_block_left_stl();
//ABS_PC_z_gantry_block_right_stl();
//STEEL_gantry_sq_plate_60x60x3_22_dxf();
//STEEL_z_gantry_plate_60_dxf();