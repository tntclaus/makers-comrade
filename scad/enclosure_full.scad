include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>

use <axes/x-axis.scad>
use <axes/y-axis.scad>
use <axes/z-axis.scad>

MATERIAL_STEEL_THICKNESS = 3;


function ENCLOSURE_FULL_SHAPE(w, h, lh, rc = 0, r = 5) = [
    // corners
        [- (w / 2 - rc), - (h / 2 - rc), rc],
        [- (w / 2 - rc), h / 2 - rc, rc],
        [(w / 2 - rc), h / 2 - rc, rc],
        [(w / 2 - rc), - (h / 2 - rc), rc],

    //bottom pocket
        [(w / 2 - 20), - (h / 2 - r), r],
        [(w / 2 - 20 - r * 2), - (h / 2 + r) + lh, - r],
        [- (w / 2 - 20 - r * 2), - (h / 2 + r) + lh, - r],
        [- (w / 2 - 20), - (h / 2 - r), r],
    ];

function PERFORATION_ROW(start, end, step) = [start : step : end];


module enclosure_base_place_dual_vertical_perforation(width, heigth, overlap) {
    translate([width / 2 - 10 - overlap, 0, 0])
        enclosure_base_place_vertical_perforation(heigth, overlap)
        children();

    translate([- (width / 2 - 10 - overlap), 0, 0])
        enclosure_base_place_vertical_perforation(heigth, overlap)
        children();
}

module enclosure_base_place_vertical_perforation(heigth, overlap = 0) {
    for (i = PERFORATION_ROW(- heigth / 2 + 10, heigth / 2 - 50, (heigth - 60) / 2)) {
        translate([0, i, 0]) children();
    }
}

module enclosure_place_horizontal_perforation(width, overlap = 0) {
    for (i = PERFORATION_ROW(- width / 2 + 65, width / 2 - 65, (width - 130) / 2)) {
//    for (i = PERFORATION_ROW(- width / 2 + 30 + overlap, width / 2 - 30 - overlap, (width - 60 - overlap * 2) / 3)) {
        translate([i, 0, 0]) children();
    }
}

module enclosure_base_place_horizontal_perforation(width, heigth, overlap = 0) {
    translate([0, - (heigth / 2 - 10 - $LEG_HEIGTH), 0])
        enclosure_place_horizontal_perforation(width, overlap) children();
}

module enclosure_side_place_horizontal_top_perforation(width, heigth, overlap = 0) {
//    for (i = PERFORATION_ROW(- width / 2 + 65, width / 2 - 65, (width - 130) / 2)) {
        translate([0, heigth / 2 - 10, 0])
            enclosure_place_horizontal_perforation(width, overlap) children();
//    }
}

module enclosure_front_back_place_horizontal_top_perforation(width, heigth) {
//    for (i = PERFORATION_ROW(- width / 2 + 30 + MATERIAL_STEEL_THICKNESS, width / 2 - 30 - MATERIAL_STEEL_THICKNESS, (
//            width - 60 - MATERIAL_STEEL_THICKNESS * 2) / 3)) {
        translate([0, heigth / 2 - 30, 0])
            enclosure_place_horizontal_perforation(width, MATERIAL_STEEL_THICKNESS) children();
//    }
}
module enclosure_side_window_place_holes(heigth) {
    translate([0, 35]) {
        translate([0, (heigth - 60) / 2, 0]) children();
        translate([0, (heigth - 20) / 2, 0]) children();
        translate([0, - (heigth - 60) / 2, 0]) children();
        translate([0, - (heigth - 20) / 2, 0]) children();
    }
}

function enclosure_side_window_shape(w, h, tw, th, r = 5) = [
        [- (w / 2 - r), (h / 2) - r, r],

        [- (tw / 2) - r, (h / 2 - r), r],
        [- (tw / 2) + r, (h / 2 - th) - r, - r],
        [(tw / 2) - r, (h / 2 - th) - r, - r],
        [(tw / 2) + r, (h / 2 - r), r],

        [(w / 2 - r), (h / 2 - r), r],
        [(w / 2 - r), - (h / 2 - r), r],

        [(tw / 2) + r, - (h / 2 - r), r],
        [(tw / 2) - r, - (h / 2 - th - r), - r],
        [- (tw / 2) + r, - (h / 2 - th - r), - r],
        [- (tw / 2) - r, - (h / 2 - r), r],

        [- (w / 2 - r), - (h / 2 - r), r],
    ];

module enclosure_side_window_shape(heigth, with_holes = true) {
    tongueOffset = (heigth) / 2;
    //    tongueOffset = 20;

    translate([0, 35]) difference() {
        rounded_polygon(enclosure_side_window_shape(80, heigth, 20, 30));

        //        translate([0, tongueOffset]) rounded_square([20, 60], 5);
        //        translate([0, - tongueOffset]) rounded_square([20, 60], 5);
    }

    if (with_holes) enclosure_side_window_place_holes(heigth) circle(d = 5);
}


module enclosure_base_sketch(width, heigth, overlap = 0) {
    difference() {
        union() {
            rounded_polygon(ENCLOSURE_FULL_SHAPE(width, heigth, lh = $LEG_HEIGTH - MATERIAL_STEEL_THICKNESS));
            translate([0, heigth / 2 + $CAP_HEIGTH / 2 - 10])
                square([width, $CAP_HEIGTH + 20], center = true);
        }
        // vertical screw mount perforation
        enclosure_base_place_dual_vertical_perforation(width, heigth, overlap) circle(d = 5);

        // bottom horizontal screw mount perforation
        enclosure_base_place_horizontal_perforation(width, heigth, overlap) circle(d = 5);
    }
}

module enclosure_base_front_back_sketch(width, heigth, window_w, overlap = 0) {
    difference() {
        enclosure_base_sketch(width, heigth, overlap);

        enclosure_front_back_place_horizontal_top_perforation(width, heigth) circle(d = 5);

        translate([0, heigth / 2 - 5])
            rounded_square([window_w, 25], 5, center = true);
    }
}

module enclosure_base_side_sketch(width, heigth, window_h, overlap = 0) {
    difference() {
        enclosure_base_sketch(width, heigth, overlap);

        enclosure_side_place_horizontal_top_perforation(width, heigth) circle(d = 5);
    }
}


module enclosure_base_side_single_z_sketch(width, heigth, window_h, overlap = 0) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, overlap);
        enclosure_side_window_shape(window_h);
    }
}

module enclosure_side_window_place_dual_windows(x_length) {
    translate([zAxisDualPosition(x_length), 0])
        children();
    translate([- zAxisDualPosition(x_length), 0])
        children();
}


module enclosure_base_side_dual_z_sketch(width, heigth, window_h, x_length, overlap = 0) {
    difference() {
        enclosure_base_side_sketch(width, heigth, window_h, overlap);
        enclosure_side_window_place_dual_windows(x_length)
        enclosure_side_window_shape(window_h);
    }
}

module enclosure_side_dual_z(width, heigth, window_h, x_length) {
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_side_dual_z_", width, "x", heigth, "mm"));

    width_full = width;

    translate_z(heigth / 2)
    rotate([90, 0, 180]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        //        color("orange", 0.5)
        color("green", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_base_side_dual_z_sketch(width_full, heigth, window_h, x_length);

        enclosure_shared_parts(width, heigth);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, 0)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, 0)
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
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_side_single_z_", width, "x", heigth, "mm"));

    width_full = width;

    translate_z(heigth / 2)
    rotate([90, 0, 0]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        //        color("orange", 0.5)
        color("purple", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_base_side_single_z_sketch(width_full, heigth, window_h);

        enclosure_shared_parts(width, heigth);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, 0)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, 0)
            screw(M5_pan_screw, 8);

            enclosure_side_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);

            enclosure_side_window_place_holes(window_h)
            screw(M5_pan_screw, 8);
        }
    }
}

module enclosure_shared_parts(width, heigth, overlap = 0) {
    translate_z(-MATERIAL_STEEL_THICKNESS*2-1.8){
        translate([width/2-10,0,0])
            enclosure_vslot_mount_line_vertical(heigth);
        translate([-(width/2-10),0,0])
            enclosure_vslot_mount_line_vertical(heigth);

        translate([0, -(heigth/2-10)+$LEG_HEIGTH,0])
            enclosure_vslot_mount_line_horizontal(width, overlap);

        translate([0, (heigth/2-30),0])
            enclosure_vslot_mount_line_horizontal(width, overlap);
    }
}

module enclosure_front(width, heigth, window_w, window_h, window_translate_z) {
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_front_", width, "x", heigth, "mm"));

    width_full = width + MATERIAL_STEEL_THICKNESS * 2;

    translate_z(heigth / 2)
    rotate([90, 0, - 90]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        //        color("orange", 0.5)
        color("red")
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_front_sketch(width_full, heigth, window_w, window_h, window_translate_z);

        enclosure_shared_parts(width, heigth, MATERIAL_STEEL_THICKNESS);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_front_back_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);
        }
    }
}

module enclosure_front_sketch(width, heigth, window_w, window_h, window_translate_z) {
    difference() {
        enclosure_base_front_back_sketch(width, heigth, window_w = window_w, overlap = MATERIAL_STEEL_THICKNESS);

        translate([0, window_translate_z]) {
            rounded_square([window_w, window_h], 10, center = true);

            for (pos = door_hinge_pos(door_width(window_w), door_heigth(window_h)))
            translate(pos)
                tool_cutter_fastener_place(6, 1) circle(d = 2.2);

            mirror([1, 0])
                for (pos = door_hinge_pos(door_width(window_w), door_heigth(window_h)))
                translate(pos)
                    tool_cutter_fastener_place(6, 1) circle(d = 2.2);
        }
    }
}
module enclosure_back(width, heigth, window_w) {
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_back_", width, "x", heigth, "mm"));
    width_full = width + MATERIAL_STEEL_THICKNESS * 2;

    translate_z(heigth / 2)
    rotate([90, 0, 90]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            enclosure_back_sketch(width_full, heigth, window_w);

        enclosure_shared_parts(width, heigth, MATERIAL_STEEL_THICKNESS);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_front_back_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);
        }
    }
}

module enclosure_back_sketch(width, heigth, window_w) {
    enclosure_base_front_back_sketch(width, heigth, window_w, overlap = MATERIAL_STEEL_THICKNESS);
}

function door_hinge_pos(door_width, door_heigth) = [
        [door_width / 2, door_heigth / 2 - 80, 0],
        [door_width / 2, - (door_heigth / 2 - 80), 0]
    ];

module PC_5mm_door_220x370_dxf() {
    plastic_door_sketch(440, 370);
}

module plastic_door_sketch(door_width, door_heigth) {

    dxf(str("PC_5mm_door_", door_width / 2, "x", door_heigth));

    translate([door_width / 2, 0, 0])
        difference() {
            rounded_square([door_width, door_heigth], 15);

            translate([door_width / 2, 0, 0])
                square([door_width, door_heigth + 1], center = true);

            for (pos = door_hinge_pos(- door_width, door_heigth))
            translate(pos)
                //            mirror([1, 0])
                tool_cutter_fastener_place(6, 1) circle(d = 3);



            // магнит
            translate([- 10, door_heigth / 2 - 10 - DOOR_OVERLAP / 2, 0])
                circle(d = 3);

            translate([- 10, - door_heigth / 2 + 10 + DOOR_OVERLAP / 2, 0])
                circle(d = 3);
        }
}

module platic_door_hinge_spacer() {
    dxf("PC_5mm_door_hinge_spacer")
    difference() {
        rotate([0.0, 180.0, 0.0]) leaf(C_FEMALE);

        translate([35 / 2 - 5, 0, 1])
            cube([35, 100, 20], center = true);
    }
}

module PC_5mm_door_hinge_spacer_dxf() {
    projection()
        platic_door_hinge_spacer();
}

use <utils.scad>

module plastic_doors_assembly(width, heigth, side, thickness, angle = 0) {
    translate_z(heigth / 2 + $LEG_HEIGTH + 20)
    rotate([90, 0, - 90]) {
        plastic_door_assembly(width, heigth, thickness, angle);
        mirror([1, 0, 0]) plastic_door_assembly(width, heigth, thickness, angle);
    }
}

use <parametric_butt_hinge_3.7.scad>

C_CONSTANT = 0 + 0;

C_FEMALE = C_CONSTANT + 0;
C_MALE = C_CONSTANT + 1;


module ABS_door_hinge_stl() {
    $fn = 90;
    hinge();
}

module hinge(angle = 0) {
    stl("ABS_door_hinge");

    color("teal") rotate([0.0, 0.0, 0.0]) {
        leaf(C_FEMALE);
        rotate([0.0, angle, 0.0]) leaf(C_MALE);
    }
}

module enclosure_vslot_mount_line_vertical(length) {
    color("silver")
    enclosure_vslot_mount_line(length, "vertical")
    enclosure_base_place_vertical_perforation(length) circle(d = 4.1);
}

module enclosure_vslot_mount_line_horizontal(length, overlap) {
    color("silver")
    enclosure_vslot_mount_line(length-40, "horizontal_bottom", vertical = false)
    enclosure_base_place_horizontal_perforation(length + overlap*2, $LEG_HEIGTH * 2 + 20)
    circle(d = 4.1);
}

module enclosure_vslot_mount_line(length, name, vertical = true) {
    name = str("STEEL_3mm_enclosure_slot_mount_line_l", length, "_", name);
    dxf(name);

    linear_extrude(MATERIAL_STEEL_THICKNESS)
    screw_mount_line_sketch(length, vertical)
    children();
}

module screw_mount_line_sketch(length, vertical = true) {
    difference() {
        if(vertical)
            rounded_square([8, length], r = 2, center = true);
        else
            rounded_square([length, 8], r = 2, center = true);

        children();
    }
}

//! Doors are made from transparent Polycarbonate
//!
//! 1. First to first;
//! 2. Then do second;
//! 3. See? Simple!
//
module door_hinge_assembly(angle = 0) {
    assembly("door_hinge") {
        hinge(angle);

        if ($preview_screws)
        translate_z(- 1) {
            tool_cutter_fastener_place(6, 1) screw(M3_pan_screw, 12);

            rotate_about_pt(y = angle, pt = [0, 0, 0])
            mirror([1, 0, 0]) tool_cutter_fastener_place(6, 1) {
                screw(M3_pan_screw, 12);
                translate_z(- 12)
                nut(screw_nut(M3_pan_screw));
            }
        }
    }
}

DOOR_OVERLAP = 10;
function door_width(width) = width + DOOR_OVERLAP;
function door_heigth(heigth) = heigth + DOOR_OVERLAP;


module plastic_door_assembly(width, heigth, thickness, angle = 0) {
    assembly("plastic_door") {
        door_width = door_width(width);
        door_heigth = door_heigth(heigth);

        color("blue", 0.5)
            translate([- door_width / 2, 0, 0])
                render()
                    rotate_about_pt(y = - angle, pt = [0, 0, 10])
                    linear_extrude(thickness)
                        plastic_door_sketch(door_width, door_heigth);

        translate_z(5 + thickness) {
            for (pos = door_hinge_pos(door_width, door_heigth))
            translate(pos) {
                door_hinge_assembly(angle);
                translate_z(- (5 + thickness)) color("blue")
                    mirror([1, 0, 0]) platic_door_hinge_spacer();
            }
        }
    }
}


