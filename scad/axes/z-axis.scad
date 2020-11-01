include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>

include <../motors.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>



Z_MOUNT_HOLES = [  
                 [7.2,0,19.85,  -35],
                 [5,  0,  -10,  -35],
                 [5,  0,   10,  -35],
                 [5,  0,    0,  -35],
                 [5,  0,  -20,  -35/2],
                 [5,  0,   20,  -35/2],                 
                 [5,  0,  -10,  -35/2],
                 [5,  0,   10,  -35/2],
                 [5,  0,    0,  -35/2],
                 [5,  0,  -20,  0],
                 [5,  0,  -10,  0],
                 [5,  0,   10,  0],
                 [5,  0,    0,  0],
                 [5,  0,  -20,  35/2],                 
                 [5,  0,  -10,  35/2],
                 [5,  0,   10,  35/2],
                 [5,  0,   20,  35/2],                 
                 [5,  0,    0,  35/2],  
                 [5,  0,  -10,  35],
                 [5,  0,   10,  35],
                 [5,  0,    0,  35],
                 [7.2,0,19.85,  35],
];

VW_HOLES_20x3L = [
    [5,  0,-19.85,35],
    [7.2,0,19.85,0],
    [5,  0,-19.85,-35]
];

Z_PLATE = [[90,65],    5,      3,   VW_HOLES_20x3L, Z_MOUNT_HOLES];

Z_GANTRY = ["", Z_PLATE, [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], 20];

VSLOT_Z_RAIL = ["", Z_GANTRY, E2020];

//gantry_sq_plate_40x65x3_3_dxf();

module gantry_sq_plate_90x65x3_22_dxf() {
    projection() vslot_plate(Z_PLATE);
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
                    translate([0,0,depth/2]) rotate([0,0,90]) extrusion(E2040, depth);
                    translate([0,-10,17]) rotate([0,-90,90]) drill(5, h=40);
                }
                translate_z(60) zHolderPlugPlate();
                translate([0,14,17])
                    rotate([0,-90,90]) 
                        leadnut(LSN8x8);
            }
        if(mirrored)
            translate([0, 0, positionAdj+5]) printBed();
    }
    
    translate([0,0,-23]) zAxisMotor(diff = diff);
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



module z_holder_plug_plate_dxf() {
    dxf(str("z_holder_plug_plate"));
    difference() {
        rounded_square([40, 20], 2, center=true);
        translate([-10,0,0]) circle(d = 5);
        translate([10,0,0]) circle(d = 5);        
    }
}

module zHolderPlugPlate() {
    linear_extrude(4) z_holder_plug_plate_dxf();
}

