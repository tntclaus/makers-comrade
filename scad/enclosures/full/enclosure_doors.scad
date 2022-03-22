include <enclosure_common.scad>

use <parametric_hinge_door_front.scad>

use <../../../lib/magnet.scad>
include <NopSCADlib/vitamins/screws.scad>


C_CONSTANT = 0 + 0;

C_FEMALE = C_CONSTANT + 0;
C_MALE = C_CONSTANT + 1;


module ABS_door_hinge_stl() {
    $fn = 90;
    hinge();
}

module hinge(angle = 0) {
    stl("ABS_door_hinge");

    color("teal")
    rotate([0.0, 0.0, 0.0]) {
        leaf(C_FEMALE);
        rotate([0.0, angle, 0.0]) leaf(C_MALE);
    }
}

//! Doors are made from transparent Polycarbonate
//!
//! 1. First to first;
//! 2. Then do second;
//! 3. See? Simple!
//
module door_hinge_assembly(angle = 0) {
    assembly("door_hinge") {
        hinge(angle);

        if ($preview_screws)
        translate_z(- 1) {
            tool_cutter_fastener_place(3, 1) screw(M3_pan_screw, 12);

            rotate_about_pt(y = angle, pt = [0, 0, 0])
            mirror([1, 0, 0]) tool_cutter_fastener_place(3, 1) {
                screw(M3_pan_screw, 12);
                translate_z(- 12)
                nut(screw_nut(M3_pan_screw));
            }
        }
    }
}

DOOR_OVERLAP = 10;
function door_width(width) = width + DOOR_OVERLAP;
function door_heigth(heigth) = heigth + DOOR_OVERLAP;


module plastic_door_assembly(width, heigth, thickness, angle = 0) {
    assembly("plastic_door") {
        door_width = door_width(width);
        door_heigth = door_heigth(heigth);

        translate([- door_width / 2, 0, 0])
            rotate_about_pt(y = - angle, pt = [0, 0, 10])   {
                color("blue", 0.5)
                linear_extrude(thickness)
                    plastic_door_sketch(door_width, door_heigth);

                translate([door_width / 2, 0, -3])
                plastic_door_place_magnet(door_heigth) {
                    magnet_round_with_cone_hole(d = 10, h = 3, dia_inner1 = 3, dia_inner2 = 7);
                }

                translate([door_width / 2, 0,5])
                plastic_door_place_handle()
                plastic_door_handle();
            }

        translate_z(5 + thickness) {
            for (pos = door_hinge_pos(door_width, door_heigth))
            translate(pos) {
                door_hinge_assembly(angle);
                translate_z(- (5 + thickness)) color("blue")
                    mirror([1, 0, 0]) platic_door_hinge_spacer();
            }
        }
    }
}

function door_hinge_pos(door_width, door_heigth) = [
        [door_width / 2, door_heigth / 2 - 80, 0],
        [door_width / 2, - (door_heigth / 2 - 80), 0]
    ];

module PC_5mm_door_220x370_dxf() {
    plastic_door_sketch(440, 370);
}

module plastic_door_place_magnet(door_heigth) {
    translate([- 6, door_heigth / 2 - 5 - DOOR_OVERLAP / 2, 0])
        children();

    translate([- 6, - door_heigth / 2 + 5 + DOOR_OVERLAP / 2, 0])
        children();
}

module plastic_door_place_handle(){
    translate([-20, 0, 0])
    children();
}
module plastic_door_handle_mounts(){
    dy = 50;
    translate([0, -dy, 0])
        children();
    translate([0, dy, 0])
        children();
}
module plastic_door_handle(){

    module part() {
        translate_z(5)
        sphere(d = 10);
        cylinder(d = 7, h = 5, center = true);
    }

    translate_z(2.5)
    difference() {
        hull() {
            translate([0, -50, 0])
                part();
            translate([0, 50, 0])
                part();
        }

        plastic_door_handle_mounts(){
            cylinder(r = screw_clearance_radius(M3_pan_screw), h = 100, center = true);
            translate_z(5)
            cylinder(r = screw_head_radius(M3_pan_screw), h = 100);
        }
    }
}


module plastic_door_sketch(door_width, door_heigth) {
    dxf(str("PC_5mm_door_", door_width / 2, "x", door_heigth));

    translate([door_width / 2, 0, 0])
        difference() {
            rounded_square([door_width, door_heigth], 15);

            translate([door_width / 2, 0, 0])
                square([door_width, door_heigth + 1], center = true);

            for (pos = door_hinge_pos(- door_width, door_heigth))
                translate(pos)
                    tool_cutter_fastener_place(3, 1) circle(r = M3_clearance_radius);

            // магнит
            plastic_door_place_magnet(door_heigth)
                circle(r = M3_tap_radius);

            // ручка
            plastic_door_place_handle()
            plastic_door_handle_mounts()
                circle(r = M3_tap_radius);
        }
}

module platic_door_hinge_spacer() {
    dxf("PC_5mm_door_hinge_spacer")
    difference() {
        rotate([0.0, 180.0, 0.0])
            leaf(C_FEMALE);

        translate([35 / 2 - 5, 0, 1])
            cube([35, 100, 20], center = true);
    }
}

module PC_5mm_door_hinge_spacer_dxf() {
    projection()
        platic_door_hinge_spacer();
}

use <../../utils.scad>

module plastic_doors_assembly(width, heigth, side, thickness, angle = 0) {
    translate_z(heigth / 2 + $LEG_HEIGTH + 20)
    rotate([90, 0, - 90]) {
        plastic_door_assembly(width, heigth, thickness, angle);
        mirror([1, 0, 0]) plastic_door_assembly(width, heigth, thickness, angle);
    }
}

//$LEG_HEIGTH = 0;
//$preview_screws = true;
//plastic_doors_assembly(440, 370, 0, 5, 0);
//PC_5mm_door_220x370_dxf();
