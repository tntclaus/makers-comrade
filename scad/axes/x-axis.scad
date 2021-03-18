include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
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

use <../spindle_mount.scad>


use <../../lib/opto_endstop.scad>


module D16T_x_caret_dxf() {
    $fn = 180;
    polygon_plate_sketch(X_PLATE);
}

//D16T_x_caret_dxf();

module D16T_x_caret_with_cable_chain_dxf() {
    $fn = 180;
    x_caret_with_cable_chain_sketch();
}
//D16T_x_caret_with_cable_chain_dxf();


module xAxisRails(position = 0, xAxisLength, railsWidth = 30) {
    positionAdj = 
    position > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        position < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        position;
    // 1/2 of 2020  + 3mm plate + 1.2mm offset between plate and 2020 extrusion 
    materialsThinkness = 10 + 3 + 1.2; 
    
    railsAdjustedWidth = railsWidth + materialsThinkness;
    
    translate([xAxisLength/2,railsAdjustedWidth,0]) rotate([-90,0,90]) {
        vslot_rail(
                X_RAIL, 
                xAxisLength, 
                pos = positionAdj, 
                mirror = false
            ) {
                x_caret_2_stl(stl = false);


                translate([-43,0,railsAdjustedWidth+1.87-16])
                rotate([90,0,-90]) {
                    rotate([0,0,180])
                    translate_z(-48.15)
                    titan_extruder_assembly(
                        width =	railsWidth*2, 
                        length = 100, 
                        inset_length =	80, 	
                        inset_depth =	8, 
                        heigth =	29
                    );

                    translate_z(-48.15)
                    spindle_assembly(
                        width =	railsWidth*2, 
                        length = 100, 
                        inset_length =	80, 	
                        inset_depth =	8, 
                        heigth =	29
                    );
                }
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
                x_caret_1_assembly() {
                    translate([-8.85-1,-X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
                    rotate([90,90,0])
                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);

                    translate([-8.85-1,X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
                    rotate([90,90,0])
                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = true);
                }

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

module piezo_shield_25_stl() {
    $fn=180;
    piezo_shield(d = 25);
}
module piezo_shield(d = 25) {
    stl(str(
        "piezo_shield", "_",
        d));

    color("blue") difference() {
        union() {
            cylinder(d = d, h =0.5, center = true);
            translate_z(0.75) difference() {
                union() {
                    cylinder(d =   d, h=1.5, center = true);
                    translate([-10,0,-0.25/2])
                        cube([30,6,1.75], center = true);
                }
                translate([-120/2,0,120/2-0.5])
                cube([120,3,120], center = true);
            }
        }
        translate_z(-1)
        cylinder(d=X_VW_HOLES[1][0], h=5);


    }
}



module toolhead_support_top_3mm_drawing() {
    projection()
    difference() {
        mount1 = X_VW_HOLES[0];
        mount2 = X_VW_HOLES[2];
        
        rounded_rectangle([8,80,1], r = 2, center = true);

        translate([0, mount1[3], -1])
        cylinder(d = mount1[0], h = 6);
        
        translate([0, mount2[3], -1])
        cylinder(d = mount2[0], h = 6);
    }
}

module STEEL_toolhead_support_bottom_3mm_dxf() {
    $fn = 180;
    toolhead_support_bottom_3mm_drawing();
}

module STEEL_toolhead_support_top_3mm_dxf() {
    $fn = 180;
    toolhead_support_top_3mm_drawing();
}

module toolhead_support_bottom_3mm_drawing() {
    yo = X_PLATE_SUPPORT_B_OFFSET_Y;
    width = X_PLATE_SUPPORT_B_HEIGTH;
    length = X_PLATE_SUPPORT_B_LENGTH;
    r = X_PLATE_SUPPORT_B_CORNER_RADIUS;
    w = width/2 - r;
    l = length/2 - r;
    polygon_path = [
        [   w, -l, r],
        [  -w, -l, r],
        [  -w,0-r, r],
        [  yo,  0, 0],
        [yo+r,  l, r],

//        [-w+3,l-5,r],    
//        [-w,  l-5,r],        
        [ w,  l,r],
        
    ];
    
    difference() {
        rounded_polygon(polygon_path);
        translate([X_PLATE_SUPPORT_B_SCREWS_Y_RELATIVE_POS, X_PLATE_SUPPORT_B_SCREW_OFFSET,0])
        circle(d = X_PLATE_SUPPORT_B_SCREW_DIA-0.7);
        translate([X_PLATE_SUPPORT_B_SCREWS_Y_RELATIVE_POS,-X_PLATE_SUPPORT_B_SCREW_OFFSET,0])
        circle(d = X_PLATE_SUPPORT_B_SCREW_DIA-0.7);


//        translate([0, mount1[3], -1])
//        cylinder(d = mount1[0], h = 6);
//        
//        translate([0, mount2[3], -1])
//        cylinder(d = mount2[0], h = 6);
    }
}

module toolhead_support_top() {
    dxf("STEEL_toolhead_support_top_3mm");
    
    linear_extrude(3)
    toolhead_support_top_3mm_drawing();
}

module toolhead_support_bottom() {
    dxf("STEEL_toolhead_support_bottom_3mm");
    
    translate([0,X_PLATE_SUPPORT_A_LENGTH/2,0])
    linear_extrude(3)
    toolhead_support_bottom_3mm_drawing();
}

module toolhead_supports() {
    color("silver") 
    translate([X_VW_HOLES[0][2],0,0])
    toolhead_support_top();

    color("white") {
    translate([X_VW_HOLES[0][2]+28.5,0,0])
    toolhead_support_bottom();

    mirror([0,1,0])
    translate([X_VW_HOLES[0][2]+28.5,0,0])
    toolhead_support_bottom();
    }

}
module x_caret_with_cable_chain_sketch() {
    module cable_chain_connector() {        
        // колонна держателя кабельной цепи
        color("#effe00")                
        difference() {
            hull() {
                translate([-20,0,0])
                square([1,22], center = true);
                
                translate([-100,0,0])
                square([10,30], center = true);
            }
            translate([-80,0,-10]) {
                circle(d = 4);
            }
            translate([-40,0,-10]) {
                circle(d = 4);
            }
        }
            
        
        // держатель кабельной цепи
        color("#effe90")
        translate([-115,0,-1.5]) {
            difference() {
                square([20,30], center = true);        
                translate([0,6,0]) circle(d = 2.3);
                translate([0,-6,0]) circle(d = 2.3);
            }
        }
    }
    
    polygon_plate_sketch(X_RAIL[1][1]);
    cable_chain_connector();
}
module x_caret_with_cable_chain() {
    dxf("D16T_x_caret_with_cable_chain");
    translate_z(-X_RAIL[1][1][2])
    linear_extrude(X_RAIL[1][1][2]) x_caret_with_cable_chain_sketch();
}
//x_caret_with_cable_chain();

module x_caret_1_assembly() {
    x_caret_with_cable_chain();

    // стальные опоры
    toolhead_supports();
    
    children();
}
    
module x_caret_2_stl(stl = true) {
    dxf("D16T_x_caret");
    
    module addons() {
//        x_caret_strnghteners();
//        belt_clamps();
        rotate([180,0,0])
        translate([X_VW_HOLES[1][2], X_VW_HOLES[1][1], -1.5])
        piezo_shield(25);
    }

    if (stl) {
        vslot_plate(X_RAIL[1][1]) addons();
    } else {
        addons();
    }    
    
    // стальные опоры
    toolhead_supports();
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


module D16T_x_caret_connector_w60_eh8_ed3_dxf()  {
    $fn = 180;
    x_caret_connector_sketch(width = 60, heigth = 27.85,ear_heigth=8,ear_depth=3);
}

module x_caret_connector_lock_sketch(width, heigth, line_width = 6) {

    difference() {
        union() {
            rounded_square([line_width,heigth], r = 1);

            translate([-width/4, -(heigth/2-line_width/2)])
            rounded_square([width/2,line_width], r = 1);

            translate([width/4, heigth/2-line_width/2])
            rounded_square([width/2,line_width], r = 1);
        }
        translate([0,-0.5])
        circle(d = 3.01);
    }
}

module D16T_x_caret_connector_lock_26x23_6_dxf() {
    $fn = 180;
    x_caret_connector_lock_sketch(width = 26, heigth = 23, line_width = 6);
}

module x_caret_connector_lock(width, heigth, line_width = 6) {
    dxf_name = str(
        "D16T_x_caret_connector_lock", "_",
        width, "x",
        heigth, "_",
        line_width
    );
    dxf(dxf_name);
    linear_extrude(3)
    x_caret_connector_lock_sketch(width, heigth, line_width);
}

module x_caret_connector_sketch(width, heigth,ear_heigth=8,ear_depth=3) {
    name = str(
        "D16T_x_caret_connector", "_",
         "w", width, "_",
        "eh", ear_heigth, "_",
        "ed", ear_depth
    );

    dxf(name);
    
    r = 1;
    w = width/2 - r;
    l = heigth/2 - r;
    
    polygon_path = [
        [  w+r,          -(l-ear_heigth+r), 0],
        [  w+ear_depth,  -(l-ear_heigth+2*r), r],
        [  w+ear_depth,   -l, r],    
    
        [ -(w+ear_depth), -l, r],    
        [ -(w+ear_depth),-(l-ear_heigth+2*r), r],
        [ -(w+r),        -(l-ear_heigth+r), 0],

//        [  -w, -l, r],
    
        [  -(w+r),         l-ear_heigth+r, 0],
        [  -(w+ear_depth), l-ear_heigth+2*r, r],
        [  -(w+ear_depth), l, r],

        [  (w+ear_depth),  l, r],    
        [  (w+ear_depth), (l-ear_heigth+2*r), r],
        [  (w+r),         (l-ear_heigth+r), 0],
    ];
    
    bh1 = heigth/2-4-1;
    bh2 = heigth/2-4-18;    
    bo = 10;
    
    difference() {
        union() {
            rounded_polygon(polygon_path);
            translate([-width/2+10,14.25,0])
            square([10,17], center = true);
        }
        projection()
        drillHoles([
            [BELT_H_D, 0, ["square", [[-bo,bh1-2], [-bo,bh1+2]]]],
            [BELT_H_D, 0, ["square", [[ bo,bh1-2], [ bo,bh1+2]]]],
            [BELT_H_D, 0, ["square", [[-bo,bh2-2], [-bo,bh2+2]]]],
            [BELT_H_D, 0, ["square", [[ bo,bh2-2], [ bo,bh2+2]]]],
        
            [BELT_H_D, 0, ["square", [[ 0,bh1-2], [ 0,bh1+2]]]],
            [BELT_H_D, 0, ["square", [[ 0,bh2-2], [ 0,bh2+2]]]],

            [2.3, 0, 0, 0],
            [2.3, 0, bo/2, bh1],
            [2.3, 0, bo/2, bh2],
            [2.3, 0,-bo/2, bh1],
            [2.3, 0,-bo/2, bh2],        
        
        
            // opto endstop
            [2.3, 0,-width/2+10, heigth/2-14],
            [2.3, 0,-width/2+10, heigth/2+19-14],        
        ], 3);
    }
    
}

module x_caret_connector(width, heigth, thickness = 3, endstop = false) {
    translate_z(-thickness/2) {
        color("#a3b3a3")
        linear_extrude(thickness)
        x_caret_connector_sketch(width, heigth);

    
        translate([0,0.5,-thickness])
        x_caret_connector_lock(26,23,6);
    }
    
    if(endstop) {
        translate([-width/2+10,14.25,-thickness])
        rotate([180,0,0])
        opto_endstop();
    }
}

//rotate([0,0,-90])
//x_caret_1_stl() {
//    railsWidth = 30;
//                    translate([-8.85-1,-X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = false);
//
//                    translate([-8.85-1,X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = true);
//}

////x_caret_2_stl();
//railsWidth = 30;
//x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = true);

//D16T_x_caret_connector_lock_26x23_6();


//workingSpaceSizeMaxX  = 1000;
//workingSpaceSizeMinX = 0;
//xAxisRails(200, 400);

//piezo_shield_25_stl();
//endstop_x_stl();