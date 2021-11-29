include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/pulleys.scad>

use <axes/z-axis.scad>
use <axes/y-axis.scad>
use <axes/x-axis.scad>

use <heatbed.scad>

use <toolheads/toolhead_extruder_orbiter_mosquito.scad>
use <toolheads/toolhead_extruder_titan_e3d.scad>
use <toolheads/toolhead_spindle.scad>

use <pulley_and_motor_plates.scad>


AXIS_Z_SIZE = 300;
AXIS_X_SIZE = 300;
AXIS_Y_SIZE = 300;

LEG_HEIGTH = 70;
$CAP_HEIGTH = 160;
BASE_HEIGTH = realZAxisLength(AXIS_Z_SIZE) + 40 + LEG_HEIGTH;
FULL_HEIGTH = realZAxisLength(AXIS_Z_SIZE) + 40 + LEG_HEIGTH + $CAP_HEIGTH;

CASE_MATERIAL_THICKNESS = 3;

if ($preview)
main_assembly();

$preview_table = !$preview || false;
$preview_belts = !$preview || false;
$preview_tool = !$preview || false;

module main_assembly() {
    km_3d_printer(zpos = 200, xypos = 0);
}

module km_3d_printer(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;

    km_frame(zpos, xypos);
    case();
}

module km_frame(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;
    $Z_AXIS_OFFSET = 25;

    outerXAxisWidth = outerXAxisWidth(AXIS_X_SIZE) - 20;
    outerYAxisWidth = realYAxisLength(AXIS_Y_SIZE) + 20;

    translate_z(- $CASE_MATERIAL_THICKNESS)
    zAxis(positionZ = zpos, lengthZ = AXIS_Z_SIZE, lengthX = AXIS_X_SIZE, lengthY = AXIS_Y_SIZE){
        if ($preview_table)
            rotate([0, 0, 180])
                heatbed_table_assembly(AXIS_X_SIZE, AXIS_Y_SIZE, 11.2, $Z_AXIS_OFFSET);
    }

    module xAxisExtrusions() {
        translate([0, outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);

        translate([0, - outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);
    }

    translate_z(10){
        translate_z(realZAxisLength(AXIS_Z_SIZE) + 20)
        rotate([0, 0, 90])
            yAxisRails(xypos, AXIS_Y_SIZE, AXIS_X_SIZE) {
                //                toolhead_spindle_assembly(
                if ($preview_tool)
                toolhead_extruder_orbiter_mosquito_assembly(
                width = 60,
                length = 100,
                inset_length = 80,
                inset_depth = 8,
                heigth = 29
                );
            }

        xAxisExtrusions();

        translate_z(realZAxisLength(AXIS_Z_SIZE) + 20){
            xAxisExtrusions();
            km_frame_corner_plates(outerXAxisWidth / 2, outerYAxisWidth / 2);

            if ($preview_belts)
            corexy_belts(outerXAxisWidth, outerYAxisWidth, xypos, AXIS_Y_SIZE - xypos);
        }
        translate([outerXAxisWidth / 2 + 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));

        translate([- outerXAxisWidth / 2 - 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));


        translate_z(realZAxisLength(AXIS_Z_SIZE) / 2 + 10 - LEG_HEIGTH / 2) {
            x = outerXAxisWidth / 2 + 10;
            y = outerYAxisWidth / 2;
            for (ix = [x, - x])
            for (iy = [y, - y])
            translate([ix, iy, 0])
                extrusion(E2020, BASE_HEIGTH);
        }
    }
}

module km_frame_corner_plates(x, y) {
    translate([- (x - 20), - y - 10, 10]) {
        rotate([0, 0, 90])
            color("silver")
                linear_extrude(3)
                    pulley_corner_plate();

        translate([- 30, + 10, 0])
            corner_pulley_assembly(8.5, 25.5, 40, 3);
    }

    translate([x + 20, - y + 30, 10]) {
        rotate([0, 0, 180])
            color("silver")
                linear_extrude(3)
                    pulley_corner_plate();
        translate([- 10, - 30, 0])
            corner_pulley_assembly(8.5, 25.5, 40, 3);
    }

    translate([x + 10, y + 37, 10]) xyAxisMotor(left = true);
    translate([- (x + 10), y + 37, 10]) xyAxisMotor(left = false);
}

include <NopSCADlib/utils/core_xy.scad>
coreXY_GT2_16_16 = ["coreXY_16_16", GT2x6, GT2x16_pulley, GT2x20_toothed_idler, GT2x20_plain_idler, [0, 0, 1], [0, 0,
    0.5, 1], [0, 1, 0], [0, 0.5, 0, 1]];

module corexy_belts(width_x, width_y, xpos, ypos) {
    coreXY_type = coreXY_GT2_16_16;
    plain_idler = coreXY_plain_idler(coreXY_type);
    toothed_idler = coreXY_toothed_idler(coreXY_type);

    coreXYPosBL = [0, 0, 0];
    coreXYPosTR = [width_x + 20, width_y + 37, 0];
    separation = [0, coreXY_coincident_separation(coreXY_type).y, pulley_height(plain_idler) + 8.2];
    pos = [xpos, safeMarginYAxis() + ypos + 10];

    upper_drive_pulley_offset = [0, 0];
    lower_drive_pulley_offset = [0, 0];

    translate([- width_x / 2 - 10, - width_y / 2, 30 + 8.2 / 2])
        coreXY_belts(
        coreXY_type,
        carriagePosition = pos,
        coreXYPosBL = coreXYPosBL,
        coreXYPosTR = coreXYPosTR,
        separation = separation,
        x_gap = 10,
        upper_drive_pulley_offset = upper_drive_pulley_offset,
        lower_drive_pulley_offset = lower_drive_pulley_offset,
        show_pulleys = true,
        left_lower = true);

}

use <enclosure_full.scad>

module case() {
//    color("red", 0.5)
//    color("#ffffff")
    color("red")
    translate_z(- LEG_HEIGTH){
        translate([- outerXAxisWidth(AXIS_X_SIZE) / 2 - 13, 0, 0])
                enclosure_front(
                width = realYAxisLength(AXIS_Y_SIZE) + 40,
                heigth = BASE_HEIGTH,
                window_w = realYAxisLength(AXIS_Y_SIZE),
                window_h = realZAxisLength(AXIS_Z_SIZE) - 20,
                window_translate_z = 25
                );

        translate([outerXAxisWidth(AXIS_X_SIZE) / 2 + 13, 0, 0])
            enclosure_back(
            width = realYAxisLength(AXIS_Y_SIZE) + 40,
            heigth = BASE_HEIGTH,
            window_w = realYAxisLength(AXIS_Y_SIZE)
            );
    }
}
