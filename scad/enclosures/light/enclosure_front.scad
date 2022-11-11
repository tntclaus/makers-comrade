include <enclosure_common.scad>

use <enclosure_angle.scad>
use <enclosure_vslot_mounts.scad>

module enclosure_front(width, heigth, window_w, window_h, window_translate_z) {
    lh = $LEG_HEIGTH;

    width_full = width + MATERIAL_STEEL_THICKNESS * 2;
    angle_length = width_full/3;


    module angle_top() {
        dxf(
        str(
        "STEEL_", MATERIAL_STEEL_THICKNESS,
        "mm_enclosure_front_angle_top_", angle_length)
        );

        color("red", 0.5)
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            steel_top_angle_sketch(length = angle_length);
    }


    module angle_bottom() {
        dxf(
        str(
        "STEEL_", MATERIAL_STEEL_THICKNESS,
        "mm_enclosure_front_angle_bottom_", angle_length, "_lh", lh)
        );

        color("red", 0.5)
        translate([0, -(heigth-lh-40), 0])
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            steel_bottom_angle_sketch(length = angle_length, leg_length = lh);
    }


    translate_z(heigth-30)
    rotate([90, 0, - 90]) {
        translate_z(- MATERIAL_STEEL_THICKNESS){
            translate([-(width_full/2-10-MATERIAL_STEEL_THICKNESS),0,0]) {
                rotate([0, 0, - 90])
                    angle_top();

                    angle_bottom();
            }

            translate([(width_full/2-10-MATERIAL_STEEL_THICKNESS),0,0]) {
                rotate([0, 0, 180])
                    angle_top();

                mirror([1,0,0])
                    angle_bottom();

            }
        }


//        enclosure_shared_parts(width, heigth, MATERIAL_STEEL_THICKNESS);

//        if ($preview_screws) {
//            enclosure_base_place_dual_vertical_perforation(width_full, heigth, MATERIAL_STEEL_THICKNESS)
//            screw(M5_pan_screw, 8);
//
//            enclosure_base_place_horizontal_perforation(width, heigth, lh, MATERIAL_STEEL_THICKNESS)
//            screw(M5_pan_screw, 8);
//
//            enclosure_front_back_place_horizontal_top_perforation(width, heigth)
//            screw(M5_pan_screw, 8);
//        }
    }
}



module STEEL_3mm_enclosure_front_476x490mm_w430x360_lh67_wtz25_dxf() {
    enclosure_front_sketch(width = 476, heigth = 490, window_w = 430, window_h = 360, window_translate_z = 25, lh = 67);
}

//STEEL_3mm_enclosure_front_476x490mm_w430x360_lh67_wtz25_dxf();
