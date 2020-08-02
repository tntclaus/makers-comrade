include <NopSCADlib/utils/core/core.scad>



include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>

include <../motors.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>



MOUNT_HOLES = [  [5,  0,  -10,0],
                 [5,  0,   10,0],
                 [5,  0,  0,  0]];

Z_PLATE = [[40,65],    5,      3,   VW_HOLES_20x2, MOUNT_HOLES];

Z_GANTRY = ["", Z_PLATE, [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], 20];

VSLOT_Z_RAIL = ["", Z_GANTRY, E2020];

module gantry_sq_plate_40x65x3_3_dxf() {
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
                translate([0,0,depth/2]) rotate([0,0,90]) extrusion(E2040, depth);
                
                translate([0,14,17])
                    rotate([0,-90,90]) 
                        leadnut(LSN8x8);
            }
        if(mirrored)
            translate([0, 0, positionAdj-20]) printBed();
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