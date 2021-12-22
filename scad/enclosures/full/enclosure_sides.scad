include <enclosure_common.scad>

use <parametric_hinge_door_front.scad>
use <../../axes/z-axis.scad>
use <enclosure_vslot_mounts.scad>

include <NopSCADlib/utils/core/rounded_rectangle.scad>

module enclosure_side_window_place_holes(heigth) {
    translate([0, 35]) {
        translate([0, (heigth - 60) / 2, 0]) children();
//        translate([0, (heigth - 20) / 2, 0]) children();
        translate([0, 0, 0]) children();
//        translate([0, - (heigth - 60) / 2, 0]) children();
        translate([0, - (heigth - 20) / 2, 0]) children();
    }
}


module enclosure_side_window_shape(heigth, with_holes = true) {
    tongueOffset = (heigth) / 2;

    //        rounded_polygon(enclosure_side_window_shape(80, heigth, 20, 30));
    translate([-20, 35]) difference() {
        rounded_square([20, heigth], 5);
    }
    translate([ 20, 35]) difference() {
        rounded_square([20, heigth], 5);
    }

    if (with_holes) enclosure_side_window_place_holes(heigth) circle(d = 5);
}

module enclosure_base_side_sketch(width, heigth, window_h, lh, overlap) {
    difference() {
        enclosure_base_sketch(width, heigth, lh, overlap);

        enclosure_side_place_horizontal_top_perforation(width, heigth) circle(d = 5);
    }
}


module enclosure_base_side_single_z_sketch(width, heigth, window_h, lh, overlap) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, lh, overlap);
        enclosure_side_window_shape(window_h);
    }
}

module enclosure_side_window_place_dual_windows(x_length) {
    translate([zAxisDualPosition(x_length), 0])
        children();
    translate([- zAxisDualPosition(x_length), 0])
        children();
}


module enclosure_base_side_dual_z_sketch(width, heigth, window_h, x_length, lh, overlap) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, lh, overlap);
        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_window_shape(window_h);
    }
}



module enclosure_side_z_axis_mount_line(length) {
    name = str("STEEL_3mm_enclosure_slot_z_mount_line_l", length);
    dxf(name);

    translate([0,35,-MATERIAL_STEEL_THICKNESS*2.5])
    color("silver")
    linear_extrude(MATERIAL_STEEL_THICKNESS)
    screw_mount_line_sketch(length, true)
    translate([0,-35,0])
    enclosure_side_window_place_holes(length) circle(d = 4.1);
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
        translate_z(- MATERIAL_STEEL_THICKNESS)
        color("green", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_base_side_dual_z_sketch(width_full, heigth, window_h, x_length, lh = lh, overlap = 0);

        enclosure_shared_parts(width, heigth, top_horizontal_shift = 20);

        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_z_axis_mount_line(window_h);

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

        enclosure_side_z_axis_mount_line(window_h);

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
    translate([0,-35,0])
    enclosure_side_window_place_holes(length) circle(d = 4.1);
}
