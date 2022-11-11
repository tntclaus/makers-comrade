include <enclosure_common.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

module place_top_angle_mount_holes(length, leg = 0) {
    translate([0, -leg])
        children();

    translate([0, 30])
        children();

    translate([0, length - 20])
        children();

    translate([30, 0])
        children();

    translate([length - 20, 0])
        children();
}

module steel_top_angle_sketch(length, width = 20) {
    difference() {
        translate([length / 2 - width / 2, length / 2 - width / 2])
            difference() {
                rounded_square([length, length], r = 2, center = true);
                translate([width, width])
                    rounded_square([length, length], r = 2, center = true);

            }
        place_top_angle_mount_holes(length = length)
        circle(d = M5_mount_d);

    }
}

module steel_bottom_angle_sketch(length, leg_length, width = 20) {
    w = width;
    l = length - w/2;
    ll = leg_length + width / 2;
    r = 2;
    smt = MATERIAL_STEEL_THICKNESS;
    difference() {
        rounded_polygon([
                [- (w / 2 - r), l - r, r],
                [w / 2 - r, l - r, r],
                [w / 2 + r, w / 2 + r, - r],
                [l - r, w / 2 - r, r],
                [l - r, - (w / 2 - r) - smt, r],
                [w / 2 + r, - (w / 2 + r) - smt, -r],
                [w / 2 - r, - (ll - r), r],
                [-(w / 2 - r), - (ll - r), r],
            //                [, -w / 2, 2],
            ]);

        place_top_angle_mount_holes(length = length, leg = leg_length)
        circle(d = M5_mount_d);

    }
}

//steel_top_angle_sketch(length = 140);
//steel_bottom_angle_sketch(length = 140, leg_length = 70);
