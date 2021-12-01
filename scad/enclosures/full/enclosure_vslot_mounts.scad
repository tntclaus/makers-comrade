include <enclosure_common.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

module enclosure_vslot_mount_line_vertical(length) {
    color("silver")
        enclosure_vslot_mount_line(length, "vertical")
        enclosure_base_place_vertical_perforation(length) circle(d = 4.1);
}

module enclosure_vslot_mount_line_horizontal(length, overlap) {
    color("silver")
        enclosure_vslot_mount_line(length - 40, str("horizontal_bottom_o", overlap, "_leg", $LEG_HEIGTH), vertical =
        false)
        enclosure_base_place_horizontal_perforation(length + overlap * 2, $LEG_HEIGTH * 2 + 20, $LEG_HEIGTH, 0)
        circle(d = 4.1);
}

module enclosure_vslot_mount_line(length, name, vertical = true) {
    name = str("STEEL_3mm_enclosure_slot_mount_line_l", length, "_", name);
    dxf(name);

    linear_extrude(MATERIAL_STEEL_THICKNESS)
        screw_mount_line_sketch(length, vertical)
        children();
}

module screw_mount_line_sketch(length, vertical = true) {
    difference() {
        if (vertical)
        rounded_square([8, length], r = 2, center = true);
        else
        rounded_square([length, 8], r = 2, center = true);

        children();
    }
}

module enclosure_shared_parts(width, heigth, overlap = 0, top_horizontal_shift = 0) {
    translate_z(- MATERIAL_STEEL_THICKNESS * 2 - 1.8){
        translate([width / 2 - 10, 0, 0])
            enclosure_vslot_mount_line_vertical(heigth);
        translate([- (width / 2 - 10), 0, 0])
            enclosure_vslot_mount_line_vertical(heigth);

        translate([0, - (heigth / 2 - 10) + $LEG_HEIGTH, 0])
            enclosure_vslot_mount_line_horizontal(width, overlap);

        translate([0, (heigth / 2 - 30) + top_horizontal_shift, 0])
            enclosure_vslot_mount_line_horizontal(width, overlap);
    }
}

module STEEL_3mm_enclosure_slot_mount_line_l430_horizontal_bottom_o3_leg70_dxf() {
    screw_mount_line_sketch(430, vertical = false)
    enclosure_base_place_horizontal_perforation(430 + 40 + 3 * 2, 160, 70, 0)
    circle(d = 4.1);
}

module STEEL_3mm_enclosure_slot_mount_line_l430_horizontal_bottom_o0_leg70_dxf() {
    screw_mount_line_sketch(430, vertical = false)
    enclosure_base_place_horizontal_perforation(430 + 40, 160, 70, 0)
    circle(d = 4.1);
}
module STEEL_3mm_enclosure_slot_mount_line_l460_horizontal_bottom_o0_leg70_dxf() {
    screw_mount_line_sketch(460, vertical = false)
    enclosure_base_place_horizontal_perforation(460 + 40, 160, 70, 0)
    circle(d = 4.1);
}
module STEEL_3mm_enclosure_slot_mount_line_l490_vertical_dxf() {
    screw_mount_line_sketch(490, vertical = true)
    enclosure_base_place_vertical_perforation(490) circle(d = 4.1);
}
