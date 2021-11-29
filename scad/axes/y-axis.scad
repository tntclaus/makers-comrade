include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>
use <x-axis.scad>
include <brackets.scad>

use <../pulley_spacer.scad>


//include <NopSCADlib/vitamins/pulleys.scad>
//use <NopSCADlib/vitamins/pulley.scad>
include <carets.scad>


module D16T_y_caret_60_dxf() {
    $fn = 180;
    polygon_plate_sketch(GET_Y_PLATE(w = CARET_LENGTH_X));
}

module ABS_pulley_spacer_19_stl() {
    $fn = 180;
    pulley_spacer(19);
}

module ABS_pulley_spacer_2_stl() {
    $fn = 180;
    pulley_spacer(2);
}

module y_pulley_block(length, plate_thickness) {
    translate_z(- plate_thickness)
    mirror([0, 0, 1]) screw(M4_cs_cap_cross_screw, length);

    translate_z(1)
    nut(M4_nut);

    spring_washer(M4_washer);

    translate_z(length - 14 + .5)
    pulley(Y_PULLEY);

    translate_z(4.4)
    pulley_spacer(length - 4.4 - 13.6);
}

SENSOR_DEPTH = 10;

function safeMarginYAxis() = Y_CARET_WIDTH / 2 + SENSOR_DEPTH;
function realYAxisLength(length) = length + Y_CARET_WIDTH + SENSOR_DEPTH * 2;
function outerXAxisWidth(length) = realXAxisLength(length) + 50;

module yAxisRails(
position = 0,
size,
xAxisLength,
railSpacing = 60) {
    dxf(str("D16T_y_caret_", railSpacing));
    dxf(str("D16T_y_caret_", railSpacing));

    outerXAxisWidth = outerXAxisWidth(xAxisLength);

    railsRealLength = realYAxisLength(size);
    caretSafeMargin = safeMarginYAxis();

    translate([railsRealLength / 2, outerXAxisWidth / 2, 0])
        rotate([0, - 90, 0]) {
            vslot_rail(
            GET_Y_RAIL(railSpacing),
            railsRealLength,
            pos = xAxisLength-position,
            safe_margin = caretSafeMargin
            ) {
                let();

                translate([- outerXAxisWidth / 2, 0, 10])
                    rotate([0, 0, 180])
                        xAxisRails(position, xAxisLength, railSpacing / 2)
                        children();

                translate([0, PULLEY_Y_COORDINATE2, 0]) y_pulley_block(37, 3);
                translate([- PULLEY2_X_COORDINATE, - PULLEY_Y_COORDINATE, 0]) y_pulley_block(20, 3);
            }
        }

    translate([railsRealLength / 2, -outerXAxisWidth / 2, 0])
        mirror([0,1,0])
        rotate([0, - 90, 0]) {
            vslot_rail(
            GET_Y_RAIL(railSpacing),
            railsRealLength,
            pos = xAxisLength-position,
            safe_margin = caretSafeMargin
            ) {
                let();

                translate([0, PULLEY_Y_COORDINATE2, 0]) y_pulley_block(20, 3);
                translate([- PULLEY2_X_COORDINATE, - PULLEY_Y_COORDINATE, 0]) y_pulley_block(37, 3);
            }
        }
}

//yAxisRails(300, 300, 10, 300);
