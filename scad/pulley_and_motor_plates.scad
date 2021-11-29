include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <screw_assemblies.scad>

use <pulley_spacer.scad>


CORNER_PLATE_COORDS = [
    [3,3,3],
    [3,37,3],
    [37,37,3],
    [37,23,3],
//    [23,17,-3],
    [17,3,3],
    ];


module pulley_corner_plate() {
    dxf("STEEL_3mm_pulley_corner_plate");

    difference() {
        rounded_polygon(CORNER_PLATE_COORDS);
        translate([10,10,0]) circle(d = 5);
        translate([30,30,0]) circle(d = 5);
        translate([10,30,0]) circle(d = 4);
    }
}

module STEEL_3mm_pulley_corner_plate_dxf() {
    pulley_corner_plate();
}

module ABS_pulley_spacer_5_stl() {
    $fn = 180;
    pulley_spacer(5);
}
module ABS_pulley_spacer_8_2_stl() {
    $fn = 180;
    pulley_spacer(8.2);
}

module corner_pulley_assembly(pos1, pos2, length, plate_thickness) {
    mirror([0,0,1]) screw(M4_cs_cap_cross_screw, length);
    translate_z(plate_thickness) nut(M4_nut);

    translate_z(plate_thickness+3.5) pulley_spacer(5);
    translate_z(plate_thickness+3.5+pos1+5.1) pulley_spacer(8.2);

    translate_z(plate_thickness+pos1) pulley(GT2x20_plain_idler);
    translate_z(plate_thickness+pos2) pulley(GT2x20_plain_idler);
}

module corner_pulley_block(pos1, pos2, length = 40, plate_thickness=3) {
    color("#e1e1e1") linear_extrude(plate_thickness) pulley_corner_plate();
    translate([10,30,0]) corner_pulley_assembly(pos1,pos2,length,plate_thickness);

}

module STEEL_3mm_nema17_mount_plate_dxf() {
    motorMountPlate(NEMA17M, 3);
}

module motorMountPlate(model, distance = 3) {
    dxf("STEEL_3mm_nema17_mount_plate");

    hd = 4;
    mw = NEMA_width(model)/2;

    cl = mw;
    echo(cl);
    coords = [
            [3,3,3],
            [-3,41,-3],
            [-cl+13,47,3],
            [-cl+13,40+mw*2-3+distance,3],
            [cl+7,40+mw*2-3+distance,3],
            [cl+13,40,-3],
            [37,   34,3],
            [37,   23,3],
        //    [23,17,-3],
            [17,    3,3],
        ];
    shift =  40+mw+distance;

    module mountHull(d = 5) {
        hull() {
            circle(d = d);
            translate([0,-3,0]) circle(d = d);
        }
    }

    difference() {
        translate([-10,-shift,0]) rounded_polygon(coords);
        translate([0,-shift,0]) {
            translate([0,10,0]) mountHull();
            translate([20,30,0]) mountHull();
            translate([0,30,0]) mountHull();
        }

        circle(d = NEMA_boss_radius(model)*2);
        NEMA_screw_positions(model, 4) circle(d=hd);
        //        translate([0,1,0]) {
        //            circle(d = NEMA_boss_radius(model)*2);
        //            NEMA_screw_positions(model, 4) circle(d=hd);
        //        }
        //        translate([0,2,0]) {
        //            circle(d = NEMA_boss_radius(model)*2);
        //            NEMA_screw_positions(model, 4) circle(d=hd);
        //        }

    }
}


module motorPulley(motorScrewY, model, pulley, pulleyElevation) {
    rotate([0,90,0]) {
        NEMA(model);
        translate([0,0,pulleyElevation])
            pulley(pulley);
    }

    tr = NEMA_hole_pitch(model)/2;

    translate([motorScrewY,tr,tr]) screwmM3x15();
    translate([motorScrewY,tr,-tr]) screwmM3x15();
    translate([motorScrewY,-tr,tr]) screwmM3x15();
    translate([motorScrewY,-tr,-tr]) screwmM3x15();
}

module xyAxisMotor(left = false, wallThickness = 3) {
    color("silver") if(left) {
        linear_extrude(3) mirror([1,0,0])
            motorMountPlate(NEMA17M, wallThickness);
    } else {
        linear_extrude(3)
            motorMountPlate(NEMA17M, wallThickness);
    }

    rotate([0,-90,0]) motorPulley(6, NEMA17M, GT2x16_toothed_idler, 11);
    //    motorPulley(6, NEMA17M, GT2x16_toothed_idler, 4);
}
