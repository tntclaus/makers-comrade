include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

use <../axes/x-axis.scad>
use <../axes/y-axis.scad>
use <../axes/z-axis.scad>

include <enclosure_common.scad>
use <enclosure_vslot_mounts.scad>

use <../electronics_box.scad>



module enclosure_side_place_psu_case() {
    translate([-100,60, 0])
        rotate([0,0,-90])
            children();
}



module enclosure_bottom_plate_place_mounts(width, length) {
    translate([0,length / 2 - 10])
        children(0);

    translate([0,-(length / 2 - 10)])
        children(0);

    translate([width / 2 - 10,0])
        rotate([0,0,90])
            children(1);

    translate([-(width / 2 - 10),0])
        rotate([0,0,90])
            children(1);
}


module enclosure_bottom_plate(width, length, xAxisSize, lengthX) {
    dxf(str(
    "STEEL_", MATERIAL_STEEL_THICKNESS,
    "mm_enclosure_bottom_plate_", width, "x", length, "_xa", xAxisSize, "_xl", lengthX));

    translate_z($LEG_HEIGTH){
        color("#3d7424", 0.5)
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            enclosure_bottom_plate_sketch(width, length, xAxisSize, lengthX);

        translate_z(MATERIAL_STEEL_THICKNESS + 1.8)
        enclosure_bottom_plate_place_mounts(width, length){
            enclosure_vslot_mount_line_horizontal(width, 0);
            enclosure_vslot_mount_line_horizontal(length, 0);
        }

        rotate([180,0,0])
        enclosure_side_place_psu_case()
        electronics_box_psu_case_assembly();
    }
}

module enclosure_bottom_plate_sketch(width, length, xAxisSize, lengthX) {
    difference() {
        difference() {
            square([width, length], center = true);

            for (xi = [- 1, 1])
            for (yi = [- 1, 1])
            translate([xi * (width / 2), yi * (length / 2), 0])
                square(40, center = true);

            enclosure_bottom_plate_place_mounts(width, length){
                enclosure_place_horizontal_perforation(width)
                circle(r = M5_clearance_radius);
                enclosure_place_horizontal_perforation(length)
                circle(r = M5_clearance_radius);
            }
        }

        z_axis_place(xAxisSize, lengthX) {
            z_axis_motor_place() z_axis_motor_outline();
            z_axis_motor_place() z_axis_motor_outline();
            z_axis_motor_place() z_axis_motor_outline();
        }


        enclosure_side_place_psu_case()
        electronics_box_psu_case_mounts()
        circle(r = M4_clearance_radius);
    }
}

module STEEL_3mm_enclosure_bottom_plate_500x470_xa450_xl300_dxf() {
    enclosure_bottom_plate_sketch(width = 500, length = 470, xAxisSize = 450, lengthX = 300);
}







