include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

include <NopSCADlib/vitamins/pcbs.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>
include <../endstops_xy.scad>

use <../mk8_hot_end.scad>

use <../extruder_mount.scad>

include <carets.scad>
use <../fan_duct/fan_duct.scad>




module gantry_sq_plate_75x75x3_48_dxf() {
    projection()     vslot_plate(X_PLATE);
}

//gantry_sq_plate_75x75x3_48_dxf();



module xAxisRails(position = 0, xAxisLength) {
    positionAdj = 
    position > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        position < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        position;
    
    translate([xAxisLength/2,0,0]) rotate([-90,0,90]) {
        vslot_rail(
                X_RAIL, 
                xAxisLength, 
                pos = positionAdj, 
                mirror = false
            ) {
//                translate([0,0,20]) rotate([-90,0,90]) mk8_hot_end_assembly();

                translate([5.25,-4.4,25])
                rotate([90,0,-90])
                    titan_extruder_assembly();
                    
                rotate([90,0,-90])
                translate([4.4,25,-64]) {
//                    translate([17,-53.5,54])
//                    rotate([90,0,0])
//                    screw(M6_cap_screw, 4);
//                    
//                    translate([-14.4,-53.5,63.9])
//                    rotate([90,0,0])
//                    screw(M6_cap_screw, 4);

                    translate([0,-1,0]) 
                    fanduct();
                }
                

                
                translate([33,35.2,-28])
                rotate([0,180,0])
                endstop_x();
            }
    }
}


workingSpaceSizeMaxX  = 1000;
workingSpaceSizeMinX = 0;
xAxisRails(20, 150);