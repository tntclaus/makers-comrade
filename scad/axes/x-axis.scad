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
//                    translate_z(-29)
//                    titan_extruder_assembly(railsWidth);

//                    translate_z(-48.15)
//                    spindle_assembly(
//                        width =	railsWidth*2, 
//                        length = 100, 
//                        inset_length =	80, 	
//                        inset_depth =	6, 
//                        heigth =	29
//                    );
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
                x_caret_1_stl(stl = false) {
                    translate([-8.85-1,-X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
                    rotate([90,90,0])
                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);

                    translate([-8.85-1,X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
                    rotate([90,90,0])
                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);
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
//                translate([-120/2,0,120/2])
//                cube([120,3,120], center = true);

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

module toolhead_support_bottom_3mm_dxf() {
    $fn = 180;
    toolhead_support_bottom_3mm_drawing();
}

module toolhead_support_top_3mm_dxf() {
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
    dxf("toolhead_support_top_3mm");
    
    linear_extrude(3)
    toolhead_support_top_3mm_drawing();
}

module toolhead_support_bottom() {
    dxf("toolhead_support_bottom_3mm");
    
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

module x_caret_1_stl() {

    module cable_chain_connector() {
        // todo: заменить на оптический концевик
//        translate([24.5,-52,0]) 
//        rotate([180,0,0])
//        linear_extrude(3) projection() endstop_x_placed(true);


        
        // колонна держателя кабельной цепи
        color("#effe00")                
        difference() {
            hull() {
                translate([-20,0,-1.5])
                cube([1,22,3], center = true);
                
                translate([-100,0,-1.5])
                cube([10,30,3], center = true);
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
        translate([-115,0,-1.5]) {
            difference() {
                cube([20,30,3], center = true);        
                translate([0,6,-10]) cylinder(d = 2.3, h = 100);
                translate([0,-6,-10]) cylinder(d = 2.3, h = 100);
            }
        }
    }

//    translate([0,-13,0])
    cable_chain_connector();


//    cube([20,20,5]);
    // стальные опоры
    toolhead_supports();
    
    children();
}
    
module x_caret_2_stl(stl = true) {

    
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


module x_caret_connector_dxf()  {
    assert("TODO");
}

module x_caret_connector_sketch(width, heigth,ear_heigth=8,ear_depth=3) {
    dxf(str(
        "x_caret_connector"
    ));
    
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
    
    rounded_polygon(polygon_path);
}

module x_caret_connector(width, heigth, thickness = 3) {

    color("#a3b3a3")
    translate_z(-thickness/2)
    linear_extrude(thickness)
    x_caret_connector_sketch(width, heigth);
//    rounded_rectangle([width,heigth,thickness], r = 3, center=true);
//    cube()
}

//rotate([0,0,-90])
//x_caret_1_stl() {
//    railsWidth = 30;
//                    translate([-8.85-1,-X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);
//
//                    translate([-8.85,X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);
//}

////x_caret_2_stl();

workingSpaceSizeMaxX  = 1000;
workingSpaceSizeMinX = 0;
xAxisRails(200, 400);

//piezo_shield_25_stl();
//endstop_x_stl();