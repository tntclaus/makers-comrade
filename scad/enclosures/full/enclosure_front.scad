include <enclosure_common.scad>

use <parametric_hinge_door_front.scad>

use <enclosure_doors.scad>
use <enclosure_vslot_mounts.scad>

module enclosure_front(width, heigth, window_w, window_h, window_translate_z) {
    lh = $LEG_HEIGTH - MATERIAL_STEEL_THICKNESS;

    width_full = width + MATERIAL_STEEL_THICKNESS * 2;

    dxf(
    str(
    "STEEL_", MATERIAL_STEEL_THICKNESS,
    "mm_enclosure_front_", width_full, "x", heigth, "mm_", "w", window_w, "x", window_h, "_lh", lh, "_wtz", window_translate_z)
    );


    translate_z(heigth / 2)
    rotate([90, 0, - 90]) {
        translate_z(- MATERIAL_STEEL_THICKNESS)
        //        color("orange", 0.5)
        color("red", 0.5)
            linear_extrude(MATERIAL_STEEL_THICKNESS)
                enclosure_front_sketch(width_full, heigth, window_w, window_h, window_translate_z, lh = lh);

        enclosure_shared_parts(width, heigth, MATERIAL_STEEL_THICKNESS);

        if ($preview_screws) {
            enclosure_base_place_dual_vertical_perforation(width_full, heigth, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_base_place_horizontal_perforation(width, heigth, lh, MATERIAL_STEEL_THICKNESS)
            screw(M5_pan_screw, 8);

            enclosure_front_back_place_horizontal_top_perforation(width, heigth)
            screw(M5_pan_screw, 8);
        }
    }
}

module enclosure_front_sketch(width, heigth, window_w, window_h, window_translate_z, lh) {
    difference() {
        enclosure_base_front_back_sketch(width, heigth, window_w = window_w, lh = lh, overlap = MATERIAL_STEEL_THICKNESS
        );

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

module STEEL_3mm_enclosure_front_476x490mm_w430x360_lh67_wtz25_dxf() {
    enclosure_front_sketch(width = 476, heigth = 490, window_w = 430, window_h = 360, window_translate_z = 25, lh = 67);
}
