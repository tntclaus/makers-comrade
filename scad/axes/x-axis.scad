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


module endstop_x_stl() {
    render()
        translate([25,-30,-28])
    rotate([0, -180, 0])
    endstop_x_placed(stl = true);
}

module endstop_x_placed(stl = false) {
    stl("endstop_x");
    
    module connection_ear() {
        fanduct_placed(stl);
    }
    
    
    difference() {
        translate([33,35.2,-28])
        rotate([0,180,0])
        if(stl) {
            render()
            endstop_x_mount_stl();
        } else
            endstop_x();

        translate([0,0,-0.35])
        fanduct_placed(stl);
        
        fanduct_placed(stl);

    }
}

module fanduct_placed(stl = false) {
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
        if(stl) {
            fanduct(onlyEar = true);
        } else {
            fanduct_assembly();
        }        
        children();
    }
                
}

module cableChainHolder_stl() {
    cableChainHolder();
}

module cableChainHolder() {

    stl("cableChainHolder");
    
    difference() {
        translate([0.1,0,12]) 
        color("blue")
        union() {
            translate_z(-10) 
            cube([12,10,40]);
            translate_z(-10) 
            cube([24,4,60]);
            translate_z(3) 
            cube([33,4,47]);
        }
        
        color("red")
        translate([-40,5.5,31.2]) {
            rotate([0,90,0]) {
                cylinder(d = 4.2, h = 58);
                translate([0,0,52])
                nut_trap(M4_cap_screw, M4_nut, depth = 6, h = 6);
            }
        }
        
        color("red")        
        translate([17.1,2,10])
        rotate([-90,0,0])
        cylinder(d = 10,h = 20);
        
        color("red")        
        translate([17.1,-1,10])
        rotate([-90,0,0])
        cylinder(d = 5,h = 20);

        color("red")        
        translate([7.1,-2,20])
        rotate([-90,0,0])
        cylinder(d = 5.2,h = 20);


        color("red")        
        translate([27.1,-2,20])
        rotate([-90,0,0])
        cylinder(d = 5.2,h = 20);
        
        color("red")        
        translate([27.1,-2,30])
        rotate([-90,0,0])
        cylinder(d = 5.2,h = 20);        


        
    }
}


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
                    
                fanduct_placed();
                
                endstop_x_placed();
                
                rotate([90,180,-90])
                translate([3.1,27.9])

                cableChainHolder();
            }
    }
}


workingSpaceSizeMaxX  = 1000;
workingSpaceSizeMinX = 0;
xAxisRails(20, 150);

//endstop_x_stl();