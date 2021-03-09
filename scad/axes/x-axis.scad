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
    
//    module connection_ear() {
//        fanduct_placed(stl);
//    }
    
    
    difference() {
//        translate([33,35.2,-28])
        rotate([0,180,0])
        if(stl) {
            render()
            endstop_x_mount_stl();
        } else
            endstop_x(); 

//        translate([0,0,-0.35])
//        fanduct_placed(stl);
//        
//        fanduct_placed(stl);

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


module xAxisRails(position = 0, xAxisLength, railsWidth = 20) {
    positionAdj = 
    position > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        position < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        position;
    
    railsAdjustedWidth = railsWidth + 6 + 10;
    
    translate([xAxisLength/2,railsAdjustedWidth,0]) rotate([-90,0,90]) {
        vslot_rail(
                X_RAIL, 
                xAxisLength, 
                pos = positionAdj, 
                mirror = false
            ) {
                  x_caret_2_stl(stl = false);


                translate([-43,0,railsWidth+1.87])
                rotate([90,0,-90])
                    titan_extruder_assembly(railsWidth);
//                    
//                fanduct_placed();
                
//                endstop_x_placed();
            }
    }
    
        translate([xAxisLength/2,-railsAdjustedWidth,0]) rotate([-90,0,90]) {
        vslot_rail(
                X_RAIL, 
                xAxisLength, 
                pos = positionAdj, 
                mirror_plate = [1,0,0]
            ) {
                x_caret_1_stl(stl = false);          

//                translate([25,-48,0]) 
//                rotate([180,0,0])
//                endstop_x_placed();
        }
    }
}



module x_caret_strnghteners(piezo_mount = false) {
    difference() {
        hull() {            
            translate([-5.3,0,1])
            cube([42,92,2], center = true);
            translate([29,0,1])
            cube([2,60,2], center = true);
        }
        drillHoles(X_VW_HOLES, 5, 2.5);
        if(piezo_mount)
            drillHoles([X_VW_HOLES[1]], 5, 12.5);        

        drillHoles(X_MOUNTS, 5);    
    }
//    translate([X_VW_HOLES[1][2],0,0]) cylinder(d = 12.5*2+7.2, h = 20);

}

module x_caret_2_stl(stl = true) {
    module addons() {
        x_caret_strnghteners();
        belt_clamps();
    }

    if (stl) {
        vslot_plate(X_RAIL[1][1]) addons();
    } else {
        addons();
    }    
}

//RAMPSEndstop = ["RAMPSEndstop", "RAMPS Endstop Switch",
//    40.0, 16.0, 1.6, 0.5, 2.54, 0, "red",  false,
//    [
//        [2, 2], [2, 13.5], [17, 13.5,false], [36, 13.5]
//    ],
//    [
//        [ 11.6,  8,   -90, "jst_xh", 3, true, "white", "silver"],
//        [ 26.5, 12.75,  0, "microswitch", small_microswitch],
//        [ 27.5, 17.5,  15, "chip", 15, 0.5, 4.5, "silver"],
//    ],
//    []];

module belt_clamps() {
    module clamp() {
        coords = [
            [0,0,0],
            [11.5,0,0],
            [0,12,0],    
        ];
        coords_wall = [
            [0,0,0],
            [13,0,0],
            [0,12,0],    
        ];
        color("red")
        rotate([0,-90,0])
        linear_extrude(8)
        rounded_polygon(coords);
        
        
        color("red")
        translate([0,0,0])
        rotate([0,-90,0])
        linear_extrude(1)
        rounded_polygon(coords_wall);

        color("red")
        translate([-8,0,0])
        rotate([0,-90,0])
        linear_extrude(1)
        rounded_polygon(coords_wall);
    }
    
    module clamp_pair() {
        color("red")
        translate([0,-55,0])    {
            translate([4.3,0,0])
            clamp();
            translate([-16,0,0]) 
            difference()
            { 
                cube([11.4,5,7.5]);
                translate([5.7,6,4.1])
                rotate([90,0,0]) {
                    cylinder(d = 4, h = 12);
                    rotate([0,0,90])
                    nut_trap(M4_cap_screw, M4_nut, depth = 3, h = 6);
                }
            }
            translate([-16,0,0])
            clamp();
        }
    }
    
    clamp_pair();
    
    mirror([0,1,0]) clamp_pair();
}

module x_caret_1_stl(stl = true) {

    module addons() {
        translate([24.5,-52,-3]) 
        rotate([180,0,0])
        endstop_x_placed(true);
        
        
//        translate([5,-46.5,0])         
//         translate_z(0) {
//            pcb_screw_positions(RAMPSEndstop){                
//                difference() {
//                    cylinder(d = 6, h = 7.5);
//                    translate_z(-1)
//                    cylinder(d = 4, h = 10.5);
//                }
//            }
//            translate_z(7.5)
//            pcb(RAMPSEndstop);
//        }
        belt_clamps();
        
        x_caret_strnghteners(piezo_mount = true);


        // колонна держателя кабельной цепи
        color("#effe00")                
        difference() {
            hull() {
                translate([0,0,-1.5])
                cube([1,20,3], center = true);
                
                translate([-100,0,2])
                cube([10,30,10], center = true);
            }
            translate([-80,0,-10]) {
                cylinder(d = 4, h=100);
                translate_z(14.5)
                nut_trap(M3_cap_screw, M3_nut, depth = 3, h = 6);
            }
            translate([-40,0,-10]) {
                cylinder(d = 4, h=100);
                translate_z(14.5)
                nut_trap(M3_cap_screw, M3_nut, depth = 3, h = 6);
            }
        }
            
        
        // держатель кабельной цепи
        color("#effe90")
        translate([-115,0,-0.5]) {
            difference() {
                cube([20,30,5], center = true);        
                translate([0,6,-10]) cylinder(d = 4, h = 100);
                translate([0,-6,-10]) cylinder(d = 4, h = 100);
            }
        }
    }

    if (stl) {
        vslot_plate(X_RAIL[1][1]) addons();
    } else {
        addons();
    }
}

//x_caret_1_stl();
//x_caret_2_stl();

//workingSpaceSizeMaxX  = 1000;
//workingSpaceSizeMinX = 0;
//xAxisRails(200, 400);

//endstop_x_stl();