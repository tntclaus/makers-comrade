include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>

use <axes/z-axis.scad>
use <axes/y-axis.scad>
use <axes/x-axis.scad>

use <heatbed.scad>

use <toolheads/toolhead_extruder_orbiter_mosquito.scad>
use <toolheads/toolhead_extruder_titan_e3d.scad>
use <toolheads/toolhead_spindle.scad>


AXIS_Z_SIZE = 300;
AXIS_X_SIZE = 300;
AXIS_Y_SIZE = 300;

CASE_MATERIAL_THICKNESS = 4;

if ($preview)
    main_assembly();

module main_assembly() {
    km_3d_printer(zpos = 260, xypos = 0);
}

module km_3d_printer(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;

    km_frame(zpos, xypos);
}

module km_frame(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;
    $Z_AXIS_OFFSET = 25;

    outerXAxisWidth = outerXAxisWidth(AXIS_X_SIZE)-20;
    outerYAxisWidth = realYAxisLength(AXIS_Y_SIZE)+20;

    zAxis(positionZ = zpos, lengthZ = AXIS_Z_SIZE, lengthX = AXIS_X_SIZE, lengthY = AXIS_Y_SIZE){
        rotate([0, 0, 180])
            heatbed_table_assembly(AXIS_X_SIZE, 11.2, $Z_AXIS_OFFSET);
    }

    module xAxisExtrusions() {
        translate([0, outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);

        translate([0, -outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);
    }

    translate_z(10 + $CASE_MATERIAL_THICKNESS){
        translate_z(realZAxisLength(AXIS_Z_SIZE) + 20)
        rotate([0, 0, 90])
            yAxisRails(xypos, AXIS_Y_SIZE, AXIS_X_SIZE) {
//                toolhead_spindle_assembly(
                toolhead_extruder_orbiter_mosquito_assembly(
                    width =	60,
                    length = 100,
                    inset_length =	80,
                    inset_depth =	8,
                    heigth =	29
                );
            }

        xAxisExtrusions();

        translate_z(realZAxisLength(AXIS_Z_SIZE) + 20)
        xAxisExtrusions();

        translate([outerXAxisWidth / 2 + 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));

        translate([- outerXAxisWidth / 2 - 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));


        translate_z(AXIS_Z_SIZE / 2 + 70) {
            x = outerXAxisWidth / 2 + 10;
            y = outerYAxisWidth / 2;
            for (ix = [x, - x])
            for (iy = [y, - y])
            translate([ix, iy, 0])
                extrusion(E2020, realZAxisLength(AXIS_Z_SIZE) + 260);
        }
    }
}
