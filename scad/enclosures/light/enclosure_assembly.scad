include <NopSCADlib/utils/core/core.scad>
use <enclosure_front.scad>
use <enclosure_back.scad>
use <enclosure_bottom.scad>
use <enclosure_sides.scad>
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

    assembly("enclosure_light") {
        translate([- outerXAxisWidth(AXIS_X_SIZE) / 2 - 13, 0, 0]) {
            enclosure_front(
            width = realYAxisLength(AXIS_Y_SIZE) + 40,
            heigth = BASE_HEIGTH,
            window_w = realYAxisLength(AXIS_Y_SIZE),
            window_h = realZAxisLength(AXIS_Z_SIZE) - 20,
            window_translate_z = 25
            );
        }

//        translate([outerXAxisWidth(AXIS_X_SIZE) / 2 + 13, 0, 0])
//            enclosure_back(
//            width = realYAxisLength(AXIS_Y_SIZE) + 40,
//            heigth = BASE_HEIGTH,
//            window_w = realYAxisLength(AXIS_Y_SIZE)
//            );
//
//        translate([0, outerYAxisWidth / 2 + 13, 0]) {
//            enclosure_side_dual_z(
//            width = outerXAxisWidth + 40,
//            heigth = BASE_HEIGTH,
//            window_h = realZAxisLength(AXIS_Z_SIZE),
//            x_length = AXIS_X_SIZE
//            );
//        }
//
//        translate([0, - (outerYAxisWidth / 2 + 13), 0])
//            enclosure_side_single_z(
//            width = outerXAxisWidth + 40,
//            heigth = BASE_HEIGTH,
//            window_h = realZAxisLength(AXIS_Z_SIZE)
//            );
//
        enclosure_bottom_plate(
            outerXAxisWidth + 40,
            realYAxisLength(AXIS_Y_SIZE) + 40,
            realYAxisLength(AXIS_Y_SIZE) + 20,
        AXIS_X_SIZE
        );
    }
}


//STEEL_3mm_enclosure_back_476x490mm_w430_lh67_dxf();
