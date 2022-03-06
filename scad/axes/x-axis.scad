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

include <carets.scad>
use <../fan_duct/fan_duct.scad>

use <../../lib/opto_endstop.scad>


include <NopSCADlib/vitamins/stepper_motors.scad>

module D16T_x_caret_dxf() {
    $fn = 180;
    polygon_plate_sketch(X_PLATE);
}

module D16T_x_caret_with_cable_chain_dxf() {
    $fn = 180;
    x_caret_with_cable_chain_sketch();
}

SENSOR_DEPTH = 10;
function safeMarginXAxis() = X_PLATE_LENGTH/2 + SENSOR_DEPTH;
function realXAxisLength(length) = length + X_PLATE_LENGTH + SENSOR_DEPTH*2;

module x_axis_assembly(position = 0, xAxisLength, railsWidth = 30) {
    assembly("x_axis"){
        // 1/2 of 2020  + 3mm plate + 1.4mm offset between plate and 2020 extrusion
        materialsThinkness = 10 + X_CARET_PLATE_GAP;

        railsAdjustedWidth = railsWidth + materialsThinkness;

        railsRealLength = realXAxisLength(xAxisLength);
        caretSafeMargin = safeMarginXAxis();

        // endstop y
        translate([- railsRealLength / 2 - 2, - railsAdjustedWidth, 0])
            rotate([0, 90, 0])
                y_caret_endstop_anchor();

        // endstop x
        translate([- railsRealLength / 2 - 2, railsAdjustedWidth, 0])
            rotate([0, 90, 0])
                x_caret_endstop_anchor();



        translate([railsRealLength / 2, - railsAdjustedWidth, 0]) rotate([- 90, 0, 90]) {
            vslot_rail(
            X_RAIL,
            railsRealLength,
            pos = position,
            mirror = false,
            safe_margin = caretSafeMargin,
            safe_margin_top = caretSafeMargin
            ) {
                let();
                x_caret_2_stl(stl = false);


                translate([- 43, 0, railsWidth])
                    rotate([90, 0, - 90]) {
                        translate_z(- 48.15)
                        children();
                    }
            }
        }

        translate([railsRealLength / 2, railsAdjustedWidth, 0]) rotate([- 90, 0, 90]) {
            vslot_rail(
            X_RAIL,
            railsRealLength,
            pos = position,
            mirror_plate = [1, 0, 0],
            safe_margin = caretSafeMargin,
            safe_margin_top = caretSafeMargin
            ) {
                let();
                x_caret_1_assembly() {
                    translate([- 8.85 - 1, - X_PLATE_CONNECTOR_MOUNT_X, railsWidth])
                        rotate([90, 90, 0])
                            x_caret_connector(width = railsWidth * 2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH);

                    translate([- 8.85 - 1, X_PLATE_CONNECTOR_MOUNT_X, railsWidth])
                        rotate([90, 90, 0])
                            x_caret_connector(width = railsWidth * 2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop =
                            true);
                }
            }
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

//module piezo_shield_25_stl() {
//    $fn=180;
//    piezo_shield(d = 25);
//}
//
//module piezo_shield(d = 25) {
//    stl(str(
//        "piezo_shield", "_",
//        d));
//
//    color("blue") difference() {
//        union() {
//            cylinder(d = d, h =0.5, center = true);
//            translate_z(0.75) difference() {
//                union() {
//                    cylinder(d =   d, h=1.5, center = true);
//                    translate([-10,0,-0.25/2])
//                        cube([30,6,1.75], center = true);
//                }
//                translate([-120/2,0,120/2-0.5])
//                cube([120,3,120], center = true);
//            }
//        }
//        translate_z(-1)
//        cylinder(d=X_VW_HOLES[1][0], h=5);
//
//
//    }
//}



module toolhead_support_top_3mm_drawing() {
    difference() {
        mount1 = X_VW_HOLES[0];
        mount2 = X_VW_HOLES[2];

        rounded_square([8,80], r = 2, center = true, $fn = 90);

        translate([0, mount1[3]])
        circle(d = mount1[0]-0.6);

        translate([0, mount2[3]])
        circle(d = mount2[0]-0.6);

        hull() {
            translate([0, mount2[3]/3*2])
            circle(d = 3);
            translate([0, mount1[3]]/3*2)
            circle(d = 3);
        }
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

//STEEL_toolhead_support_top_3mm_dxf();

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
        rounded_polygon(polygon_path, $fn = 90);
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
            translate([-60,0]) {
                rotate([0,0,45])
                NEMA_screw_positions(NEMA17S) {
                    circle(d = 4);
                }

                hull() {
                    translate([ 10,0])
                    circle(d = 8);
                    translate([-10,0])
                    circle(d = 8);
                }

                translate([-32,0])
                hull() {
                    translate([0, 6])
                    circle(d = 8);
                    translate([0,-6])
                    circle(d = 8);
                }
            }
        }



        // держатель кабельной цепи
        color("#effe90")
        translate([-110,0]) {
            difference() {
                rounded_square([20,30], r = 1, center = true);
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
    linear_extrude(X_RAIL[1][1][2])
        x_caret_with_cable_chain_sketch();
}
//x_caret_with_cable_chain();

module x_caret_1_assembly() {
    x_caret_with_cable_chain();

    // стальные опоры
    toolhead_supports();

//    translate([-48.1,0,-3]) {
//        rotate([0,180,180]) {
//            color("blue")
//            precision_piezo_holder_stl();
//            translate([8.2,0,3])
//            screw(M5_pan_screw, 5);
//        }
//    }
//
    children();
}

module x_caret_2_stl(stl = true) {
    dxf("D16T_x_caret");

    module addons() {
//        x_caret_strnghteners();
//        belt_clamps();
//        rotate([180,0,0])
//        translate([X_VW_HOLES[1][2], X_VW_HOLES[1][1], -1.5])
//        piezo_shield(25);
    }

    if (stl) {
        vslot_plate(X_RAIL[1][1]) addons();
    } else {
        addons();
    }

    // стальные опоры
    toolhead_supports();
}

module D16T_x_caret_connector_w60_eh8_ed3_dxf()  {
    $fn = 180;
    x_caret_connector_sketch(width = 60, heigth = 27.85, ear_heigth=8, ear_depth=3);
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

module D16T_x_caret_connector_lock_26x27_6_dxf() {
    $fn = 180;
    x_caret_connector_lock_sketch(width = 26, heigth = 27, line_width = 6);
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

module x_caret_connector_sketch(width, heigth, ear_heigth=8, ear_depth=3) {
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
            rounded_square([10,17], r = 4.9, center = true);
        }
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

            // excess weight
            [12, 0, width/3,         0],
            [ 7, 0,-width/3, -heigth/4],
            [ 7, 0,-width/3,  heigth/4],
        ], 0);
    }

}

module x_caret_connector(width, heigth, thickness = 3, endstop = false) {
    translate_z(-thickness/2) {
        color("#a3b3a3")
        linear_extrude(thickness)
        x_caret_connector_sketch(width, heigth);

        rotate([0,0,90])
        translate([0,0.5,-thickness])
        x_caret_connector_lock(26,27,6);
    }

    if(endstop) {
        translate([-width/2+10,14.25,-thickness])
        rotate([180,0,0])
        opto_endstop();
    }
}



module precision_piezo_holder_stl() {
    stl("precision_piezo_holder");
    difference() {
        translate([-100,-10,-1.5])
        import("../../libstl/pp_uni_2.75_holder.stl");
        translate_z(-2)
        cube([100,100,4], center = true);
    }
}

module x_caret_endstop_anchor_stl() {
    x_caret_endstop_anchor();
}

module y_caret_endstop_anchor_stl() {
    y_caret_endstop_anchor();
}

module x_caret_endstop_anchor() {
    stl("x_caret_endstop_anchor");
    caret_endstop_anchor(anchor_width = 20);
}

module y_caret_endstop_anchor() {
    stl("y_caret_endstop_anchor");
    caret_endstop_anchor(anchor_width = 30);
}

module caret_endstop_anchor(anchor_width) {
    heigth = 5;

    color("blue")
    render()
    difference() {
        union() {
            rounded_rectangle([20,20,heigth], r = 1);
            translate([0,anchor_width/2,heigth/2])
            cube([1.6,anchor_width,heigth], center = true);
        }
        translate_z(heigth+2)
        not_on_bom() extrusion(E2020, heigth*2);
    }
}

//x_caret_endstop_anchor_stl();

////x_caret_2_stl();
//railsWidth = 30;
//x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = true);

//D16T_x_caret_connector_lock_26x23_6();


//xAxisRails(50, 300);


//rotate([0,0,-90])
//x_caret_2_assembly() {
//    railsWidth = 30;
//                    translate([-8.85-1,-X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = false);
//
//                    translate([-8.85-1,X_PLATE_CONNECTOR_MOUNT_X,railsWidth])
//                    rotate([90,90,0])
//                    x_caret_connector(width = railsWidth*2, heigth = X_PLATE_CARET_CONNECTOR_HEIGTH, endstop = true);
//}

//D16T_x_caret_dxf();
//D16T_x_caret_with_cable_chain_dxf();
//STEEL_toolhead_support_top_3mm_dxf();
//D16T_x_caret_connector_w60_eh8_ed3_dxf();
//D16T_x_caret_connector_lock_26x23_6_dxf();


//piezo_shield_25_stl();
//endstop_x_stl();

