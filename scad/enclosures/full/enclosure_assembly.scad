include <NopSCADlib/utils/core/core.scad>
include <enclosure_common.scad>
use <enclosure_front.scad>
use <enclosure_back.scad>
use <enclosure_bottom.scad>
use <enclosure_sides.scad>
use <enclosure_doors.scad>
use <enclosure_doors_top.scad>
use <enclosure_vslot_mounts.scad>

use <../../axes/x-axis.scad>
use <../../axes/y-axis.scad>
use <../../axes/z-axis.scad>

module enclosure_assembly(
AXIS_X_SIZE,
AXIS_Y_SIZE,
AXIS_Z_SIZE,
BASE_HEIGTH) {

    outerXAxisWidth = outerXAxisWidth(AXIS_X_SIZE) - 20;
    outerYAxisWidth = realYAxisLength(AXIS_Y_SIZE) + 20;

    assembly("enclosure") {
//        translate([- outerXAxisWidth(AXIS_X_SIZE) / 2 - 13, 0, 0]) {
//            enclosure_front(
//            width = realYAxisLength(AXIS_Y_SIZE) + 40,
//            heigth = BASE_HEIGTH,
//            window_w = realYAxisLength(AXIS_Y_SIZE),
//            window_h = realZAxisLength(AXIS_Z_SIZE) - 20,
//            window_translate_z = 25
//            );
//
//            plastic_doors_assembly(
//            width = realYAxisLength(AXIS_Y_SIZE),
//            heigth = realZAxisLength(AXIS_Z_SIZE) - 20,
//            side = 0,
//            thickness = 5,
//            angle = 0
//            );
//        }
//
//        translate([outerXAxisWidth(AXIS_X_SIZE) / 2 + 13, 0, 0])
//            enclosure_back(
//            width = realYAxisLength(AXIS_Y_SIZE) + 40,
//            heigth = BASE_HEIGTH,
//            window_w = realYAxisLength(AXIS_Y_SIZE)
//            );
//
        translate([0, outerYAxisWidth / 2 + 13, 0]) {
            enclosure_side_dual_z(
            width = outerXAxisWidth + 40,
            heigth = BASE_HEIGTH,
            window_h = realZAxisLength(AXIS_Z_SIZE),
            x_length = AXIS_X_SIZE
            );
        }

//        translate([0, - (outerYAxisWidth / 2 + 13), 0])
//        enclosure_side_single_z(
//            width = outerXAxisWidth + 40,
//            heigth = BASE_HEIGTH,
//            window_h = realZAxisLength(AXIS_Z_SIZE)
//        );

        translate_z(-MATERIAL_STEEL_THICKNESS)
        enclosure_bottom_plate(
            outerXAxisWidth + 40,
            realYAxisLength(AXIS_Y_SIZE) + 40,
            realYAxisLength(AXIS_Y_SIZE) + 20,
            AXIS_X_SIZE
        );

//        rotate([0,0,180])
//        translate_z(BASE_HEIGTH + enclosure_cap_heigth() - 5)
//        enclosure_door_top(
//            outerXAxisWidth+40,outerYAxisWidth+20, angle = 40
//        //, $preview_screws = false
//        );
    }
}


//STEEL_3mm_enclosure_back_476x490mm_w430_lh67_dxf();
