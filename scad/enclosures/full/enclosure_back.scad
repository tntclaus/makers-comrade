include <enclosure_common.scad>

use <enclosure_vslot_mounts.scad>
use <enclosure_doors_top.scad>
use <parametric_hinge_door_top.scad>

module enclosure_back(width, heigth, window_w) {
    lh = $LEG_HEIGTH - MATERIAL_STEEL_THICKNESS;
    dxf(
    str(
    "STEEL_", MATERIAL_STEEL_THICKNESS,
    "mm_enclosure_back_", width, "x", heigth, "mm_", "w", window_w, "_lh", lh
    ));
    width_full = width + MATERIAL_STEEL_THICKNESS * 2;

    translate_z(heigth / 2)
    rotate([90, 0, 90]) {
        color("red", 0.5)
        translate_z(- MATERIAL_STEEL_THICKNESS)
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            enclosure_back_sketch(width_full, heigth, window_w, lh = lh);

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

module enclosure_back_sketch(width, heigth, window_w, lh) {
    difference() {
        enclosure_base_front_back_sketch(width, heigth, window_w, lh = lh, overlap = MATERIAL_STEEL_THICKNESS);

        translate([-MATERIAL_STEEL_THICKNESS/2, (heigth)/2 + CAP_HEIGTH + 10])
        rotate([0,0,90])
        enclosure_door_top_place_hinges(0, width)
        mirror([1,0,0])
        tool_cutter_fastener_place(4, 1)
        circle(d = 2.3);
    }
}

module STEEL_3mm_enclosure_back_470x490mm_w430_lh67_dxf() {
        enclosure_back_sketch(width = 470, heigth = 490, window_w = 430, lh = 67);
}

//STEEL_3mm_enclosure_back_470x490mm_w430_lh67_dxf();
