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

CASE_MATERIAL_THICKNESS = 4;

if ($preview)
main_assembly();

module main_assembly() {
    km_3d_printer(zpos = 160, xypos = 150);
}

module km_3d_printer(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;

    km_frame(zpos, xypos);
}

module km_frame(zpos = 0, xypos = 0) {
    $CASE_MATERIAL_THICKNESS = CASE_MATERIAL_THICKNESS;
    $Z_AXIS_OFFSET = 25;

    outerXAxisWidth = outerXAxisWidth(AXIS_X_SIZE) - 20;
    outerYAxisWidth = realYAxisLength(AXIS_Y_SIZE) + 20;

    zAxis(positionZ = zpos, lengthZ = AXIS_Z_SIZE, lengthX = AXIS_X_SIZE, lengthY = AXIS_Y_SIZE){
        rotate([0, 0, 180])
            heatbed_table_assembly(AXIS_X_SIZE, 11.2, $Z_AXIS_OFFSET);
    }

    module xAxisExtrusions() {
        translate([0, outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);

        translate([0, - outerYAxisWidth / 2, 0])
            rotate([0, 90, 0])
                extrusion(E2020, outerXAxisWidth);
    }

    translate_z(10 + $CASE_MATERIAL_THICKNESS){
        translate_z(realZAxisLength(AXIS_Z_SIZE) + 20)
        rotate([0, 0, 90])
            yAxisRails(xypos, AXIS_Y_SIZE, AXIS_X_SIZE) {
                //                toolhead_spindle_assembly(
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
            belts(outerXAxisWidth / 2, outerYAxisWidth / 2, xypos, xypos);
        }
        translate([outerXAxisWidth / 2 + 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));

        translate([- outerXAxisWidth / 2 - 10, 0, 0])
            rotate([90, 0, 0])
                extrusion(E2020, realYAxisLength(AXIS_Y_SIZE));


        translate_z(realZAxisLength(AXIS_Z_SIZE) / 2 - 20) {
            x = outerXAxisWidth / 2 + 10;
            y = outerYAxisWidth / 2;
            for (ix = [x, - x])
            for (iy = [y, - y])
            translate([ix, iy, 0])
                extrusion(E2020, realZAxisLength(AXIS_Z_SIZE) + 100);
        }
    }
}

module km_frame_corner_plates(x, y) {
    translate([- (x - 20), - y - 10, 10]) {
        rotate([0, 0, 90])
            color("silver")
                linear_extrude(3)
                    pulley_corner_plate();
    }

    translate([x + 20, - y + 30, 10]) {
        rotate([0, 0, 180])
            color("silver")
                linear_extrude(3)
                    pulley_corner_plate();
    }

    translate([x + 10, y + 37, 10]) xyAxisMotor(left = true);
    translate([- (x + 10), y + 37, 10]) xyAxisMotor(left = false);
}

module belts(outerXAxisWidth, outerYAxisWidth, posX, posY) {
    wallThickness = 3;
    beltsSpacing = 18;
    motorAxialShiftY = 31+wallThickness;
    motorAxialShiftX = outerXAxisWidth + 10;

//    translate([0,-baseLength,0]) {
//        rotate([0,90,0])
//            extrusion_w_angle(E2020, baseFrontSize, sides = [0,1,1,0]);
//
//        translate([-baseLength, -motorAxialShiftY, 10]) xyAxisMotor(left = true);
//        translate([baseLength, -motorAxialShiftY, 10+beltsSpacing]) xyAxisMotor(left = false);
//    }


//    translate([0,baseLength,0]) {
//        rotate([0,90,0])
//            extrusion_w_angle(E2020, baseFrontSize, sides = [1,1,0,0]);
//    }

    baseWAxialShift = outerXAxisWidth + 10;
    idler = GT2x20_plain_idler;

//    corner1 = [-baseWAxialShift-10, baseWAxialShift-30,10];
//    corner2 = [baseWAxialShift-30, baseWAxialShift+10,10];
//
//
//    translate(corner1) corner_pulley_block(6, 26);
//    translate(corner2) {
//        rotate([0,0,-90]) corner_pulley_block(6, 26);
//        translate([-10,-31,-5])
//            rotate([0,-90,180]) endstop_y();
//    }

//    corner_elevation_assembly(baseWAxialShift);
//    translate_z(3) corner_elevation_assembly(baseWAxialShift);
//    translate_z(6) corner_elevation_assembly(baseWAxialShift);
//    translate_z(9) corner_elevation_assembly(baseWAxialShift);
//    translate_z(12) corner_elevation_assembly(baseWAxialShift);
//    translate_z(15) corner_elevation_assembly(baseWAxialShift);

    adjAdjY = 5;
    caretThick = 3 * 2 + 6*2 + 11;
    beltThick = belt_thickness(GT2x6);
    pulleyPR = pulley_pr(idler);
    adjPosY = outerYAxisWidth - (posY - pulleyPR) - 0.5 + adjAdjY;
    adjPosY1 = outerYAxisWidth - (posY + caretThick + beltThick) + adjAdjY;
    adjPosY2 = outerYAxisWidth - (posY + pulleyPR + beltThick + caretThick) + adjAdjY;

    adjPosX = posX+75;

    path1 = [
        //motor
            [motorAxialShiftX, -baseWAxialShift-motorAxialShiftY, pulley_pr(GT2x16_toothed_idler)],
            [baseWAxialShift-12, adjPosY2, -pulley_pr(idler)],
            [baseWAxialShift-adjPosX+75/2, adjPosY1, 1],
            [baseWAxialShift-adjPosX, adjPosY - pulleyPR + beltThick, 1],
            [-baseWAxialShift-1, adjPosY, pulley_pr(idler)],
            [-baseWAxialShift-1, baseWAxialShift+1, pulley_pr(GT2x20_plain_idler)],
            [baseWAxialShift+1, baseWAxialShift+1, pulley_pr(GT2x20_plain_idler)],
        ];


    echo(caretThick, belt_thickness(GT2x6));

    path2 = [
        //motor
            [-motorAxialShiftX, -baseWAxialShift-motorAxialShiftY, pulley_pr(GT2x16_toothed_idler)],
            [-baseWAxialShift-1, baseWAxialShift+1, pulley_pr(idler)],
            [baseWAxialShift+1, baseWAxialShift+1, pulley_pr(idler)],
            [baseWAxialShift+1, adjPosY, pulley_pr(idler)],
            [baseWAxialShift-adjPosX+75/2, adjPosY - pulleyPR + beltThick, 1],
            [baseWAxialShift-adjPosX, adjPosY1, 1],
            [-baseWAxialShift+12, adjPosY2 , -pulley_pr(idler)],
        ];
    translate([0,0,24.1+beltsSpacing])
        color("#ff000099") belt(GT2x6, path1);


    translate([0,0,24.1])
        color("#00ff0099") belt(GT2x6, path2);

}
