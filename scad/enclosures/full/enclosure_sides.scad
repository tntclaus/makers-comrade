include <enclosure_common.scad>

use <parametric_hinge_door_front.scad>
use <../../axes/z-axis.scad>
use <enclosure_vslot_mounts.scad>

include <NopSCADlib/utils/core/rounded_rectangle.scad>

use <../../electronics_box.scad>
use <../../spool_holder.scad>


module enclosure_side_window_place_holes(heigth) {
    translate([0, 35]) {
        translate([0, (heigth - 60) / 2, 0]) children();
        //        translate([0, (heigth - 20) / 2, 0]) children();
        translate([0, 0, 0]) children();
        //        translate([0, - (heigth - 60) / 2, 0]) children();
        translate([0, - (heigth - 20) / 2, 0]) children();
    }
}


module enclosure_side_window_shape(heigth, lh, with_holes = true) {
    tongueOffset = (heigth) / 2;

    translate([- 20, 35]) difference() {
        rounded_square([20, heigth], 5);
    }
    translate([20, 35]) difference() {
        rounded_square([20, heigth], 5);
    }

    if (with_holes)
    enclosure_side_window_place_holes(heigth)
    circle(r = M5_clearance_radius);
}

module enclosure_base_side_sketch(width, heigth, window_h, lh, overlap) {
    difference() {
        enclosure_base_sketch(width, heigth, lh, overlap);

        enclosure_side_place_horizontal_top_perforation(width, heigth) circle(r = M5_clearance_radius);



        translate([width/2-10, heigth/2+CAP_HEIGTH])
            enclosure_cap_place_mounts()
            circle(r = M5_clearance_radius);

        translate([-(width/2-10), heigth/2+CAP_HEIGTH])
            enclosure_cap_place_mounts()
            circle(r = M5_clearance_radius);
    }
}


module enclosure_base_side_single_z_sketch(width, heigth, window_h, lh, overlap) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, lh, overlap);
        enclosure_side_window_shape(window_h, lh);
    }
}

module enclosure_side_window_place_dual_windows(x_length) {
    translate([zAxisDualPosition(x_length), 0])
        children();
    translate([- zAxisDualPosition(x_length), 0])
        children();
}

function MOTOR_WINDOW_COORDINATES() = [
        [0, -0.3, 0],
        [0, 23, 0],
        [17, 20, 3],
        [20, 3.5, 0],
        [35, 3.5, 0],
        [35, -0.3, 0],
    ];

function MOTOR_LEFT_ELEVATION_PLATES_COUNT() = 5;

/**
* move outta here
*/
module gas_lift_mounts() {
    for(a  = [0, 120, 240])
    rotate([0,0,a])
    translate([0, 10])
    children();
}


module enclosure_side_place_gas_lift_door(width, depth) {
    translate([-(width/2-10), depth/2 - 90])
        children();
}
module enclosure_side_place_gas_lift_wall(width, heigth) {
    translate([-width/2+255-MATERIAL_STEEL_THICKNESS, heigth/2 + CAP_HEIGTH-20])
        children();
}

module enclosure_base_side_dual_z_sketch(width, heigth, window_h, x_length, lh, overlap) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, lh, overlap);
        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_window_shape(window_h, lh);

        translate([- width / 2, heigth / 2])
            rounded_polygon(MOTOR_WINDOW_COORDINATES());

        translate([width / 2, heigth / 2 + MOTOR_LEFT_ELEVATION_PLATES_COUNT() * 3, 0])
            mirror([1, 0, 0])
                rounded_polygon(MOTOR_WINDOW_COORDINATES());

        translate([0, heigth/2, 0])
        electronics_box_mounts();

        enclosure_side_place_spool_holder(x_length)
        spool_holder_mounts()
        circle(r = M5_tap_radius);

        enclosure_side_place_psu_case()
        electronics_box_psu_case_mounts()
        circle(r = M4_clearance_radius);

        enclosure_side_place_gas_lift_wall(width-10, heigth)
        gas_lift_mounts()
        circle(r = M4_tap_radius);
    }
}



module enclosure_side_z_axis_mount_line(length, lh) {
    name = str("STEEL_3mm_enclosure_slot_z_mount_line_l", length);
    dxf(name);

    translate([0, 35, - MATERIAL_STEEL_THICKNESS * 2.5])
        color("silver")
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                screw_mount_line_sketch(length, true)
                translate([0, - 35, 0])
                    enclosure_side_window_place_holes(length) circle(r = M5_tap_radius);
}



module enclosure_side_place_spool_holder(x_length) {
    pos = zAxisDualPosition(x_length) > 195 ? 195 : zAxisDualPosition(x_length)+70;

    translate([pos, 0, 0])
    children();
}

module enclosure_side_place_psu_case() {
    translate([-25,-50, 0])
        rotate([0,0,-90])
    children();
}

module enclosure_side_window(heigth) {
    name = str("PC_", MATERIAL_SIDE_WINDOW_THICKNESS, "mm", "_enclosure_side_window_h", heigth);
    dxf(name);

    translate([0,35,0])
    color("blue", 0.5)
    enclosure_side_window_sketch(heigth);
}
module enclosure_side_window_sketch(heigth) {
    difference() {
        rounded_square([60 + 2, heigth+2], 5);

//        translate([0,35,0])
        circle(r = screw_head_radius(M5_cap_screw)+1);

        translate([0,-35,0])
        enclosure_side_window_place_holes(heigth)
        circle(r = M5_clearance_radius);
    }
}

module enclosure_side_dual_z(width, heigth, window_h, x_length) {
    lh = $LEG_HEIGTH - MATERIAL_STEEL_THICKNESS;
    dxf(str(
    "STEEL_", MATERIAL_STEEL_THICKNESS,
    "mm_enclosure_side_dual_z_", width, "x", heigth, "mm_", "w", window_h, "_xl", x_length, "_lh", lh
    ));

    width_full = width;

    translate_z(heigth / 2)
    rotate([90, 0, 180]) {

        if($preview_left_side_parts) {
            translate([0, heigth / 2, 0])
                electronics_box_assembly();

            enclosure_side_place_spool_holder(x_length)
            spool_holder_assembly();
            //            spool_holder_assembly(type = false);


            enclosure_side_place_psu_case()
            electronics_box_psu_case_assembly();
        }


        translate_z(- MATERIAL_STEEL_THICKNESS)
        color("green", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_base_side_dual_z_sketch(width_full, heigth, window_h, x_length, lh = lh, overlap = 0);

        enclosure_shared_parts(width, heigth, top_horizontal_shift = 20);

        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_z_axis_mount_line(window_h, lh);

        translate_z(MATERIAL_SIDE_WINDOW_THICKNESS/4)
        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_window(window_h);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, 0)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, lh, 0)
            screw(M5_pan_screw, 8);

            enclosure_side_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);

            enclosure_side_window_place_dual_windows(x_length)
            enclosure_side_window_place_holes(window_h)
            screw(M5_pan_screw, 8);
        }
    }
}


module enclosure_side_single_z(width, heigth, window_h) {
    lh = $LEG_HEIGTH - MATERIAL_STEEL_THICKNESS;
    dxf(str(
    "STEEL_", MATERIAL_STEEL_THICKNESS,
    "mm_enclosure_side_single_z_", width, "x", heigth, "mm_", "w", window_h, "_lh", lh
    ));

    width_full = width;


    translate_z(heigth / 2)
    rotate([90, 0, 0]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        color("purple", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_base_side_single_z_sketch(width_full, heigth, window_h, lh = lh, overlap = 0);

        enclosure_shared_parts(width, heigth, top_horizontal_shift = 20);

        enclosure_side_z_axis_mount_line(window_h, lh);

        translate_z(MATERIAL_SIDE_WINDOW_THICKNESS/2)
        enclosure_side_window(window_h);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, 0)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, lh, 0)
            screw(M5_pan_screw, 8);

            enclosure_side_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);

            enclosure_side_window_place_holes(window_h)
            screw(M5_pan_screw, 8);
        }
    }
}

module STEEL_3mm_enclosure_side_dual_z_500x490mm_w380_xl300_lh67_dxf() {
    enclosure_base_side_dual_z_sketch(width = 500, heigth = 490, window_h = 380, x_length = 300, lh = 67, overlap = 0);
}
module STEEL_3mm_enclosure_side_single_z_500x490mm_w380_lh67_dxf() {
    enclosure_base_side_single_z_sketch(width = 500, heigth = 490, window_h = 380, lh = 67, overlap = 0);
}

module STEEL_3mm_enclosure_slot_z_mount_line_l380_dxf() {
    length = 380;
    screw_mount_line_sketch(length, true)
    translate([0, - 35, 0])
        enclosure_side_window_place_holes(length) circle(r = M5_tap_radius);
}

module PC_2mm_enclosure_side_window_h380_dxf() {
    enclosure_side_window_sketch(heigth = 380);
}

//enclosure_side_single_z(
//500, 490, 380, $LEG_HEIGTH = 70,
//$preview_left_side_parts = true,
//$preview_screws = false
//);


