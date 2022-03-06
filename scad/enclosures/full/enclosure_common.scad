include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>

MATERIAL_STEEL_THICKNESS = 3;
CAP_HEIGTH = 135 + 40 + 40;

function enclosure_material_thickness() = MATERIAL_STEEL_THICKNESS;
function enclosure_cap_heigth() = CAP_HEIGTH;

function ENCLOSURE_FULL_SHAPE(w, h, lh, rc = 0, r = 5) = [
    // corners
        [- (w / 2 - rc), - (h / 2 - rc), rc],
        [- (w / 2 - rc), h / 2 - rc, rc],
        [(w / 2 - rc), h / 2 - rc, rc],
        [(w / 2 - rc), - (h / 2 - rc), rc],

    //bottom pocket
        [(w / 2 - 20), - (h / 2 - r), r],
        [(w / 2 - 20 - r * 2), - (h / 2 + r) + lh, - r],
        [- (w / 2 - 20 - r * 2), - (h / 2 + r) + lh, - r],
        [- (w / 2 - 20), - (h / 2 - r), r],
    ];

function PERFORATION_ROW(start, end, step) = [start : step : end];

function enclosure_side_window_shape(w, h, tw, th, r = 5) = [
        [- (w / 2 - r), (h / 2) - r, r],

        [- (tw / 2) - r, (h / 2 - r), r],
        [- (tw / 2) + r, (h / 2 - th) - r, - r],
        [(tw / 2) - r, (h / 2 - th) - r, - r],
        [(tw / 2) + r, (h / 2 - r), r],

        [(w / 2 - r), (h / 2 - r), r],
        [(w / 2 - r), - (h / 2 - r), r],

        [(tw / 2) + r, - (h / 2 - r), r],
        [(tw / 2) - r, - (h / 2 - th - r), - r],
        [- (tw / 2) + r, - (h / 2 - th - r), - r],
        [- (tw / 2) - r, - (h / 2 - r), r],

        [- (w / 2 - r), - (h / 2 - r), r],
    ];


module enclosure_base_place_dual_vertical_perforation(width, heigth, overlap) {
    translate([width / 2 - 10 - overlap, 0, 0])
        enclosure_base_place_vertical_perforation(heigth, overlap)
        children();

    translate([- (width / 2 - 10 - overlap), 0, 0])
        enclosure_base_place_vertical_perforation(heigth, overlap)
        children();
}

module enclosure_base_place_vertical_perforation(heigth, overlap = 0) {
    for (i = PERFORATION_ROW(- heigth / 2 + 10, heigth / 2 - 50, (heigth - 60) / 2)) {
        translate([0, i, 0]) children();
    }
}

module enclosure_place_horizontal_perforation(width, overlap = 0) {
    for (i = PERFORATION_ROW(- width / 2 + 65, width / 2 - 65, (width - 130) / 2)) {
        //    for (i = PERFORATION_ROW(- width / 2 + 30 + overlap, width / 2 - 30 - overlap, (width - 60 - overlap * 2) / 3)) {
        translate([i, 0, 0]) children();
    }
}

module enclosure_base_place_horizontal_perforation(width, heigth, lh, overlap) {
    translate([0, - (heigth / 2 - 10 - lh), 0])
        enclosure_place_horizontal_perforation(width, overlap) children();
}

module enclosure_side_place_horizontal_top_perforation(width, heigth, overlap = 0) {
    translate([0, heigth / 2 - 10, 0])
        enclosure_place_horizontal_perforation(width, overlap) children();
}

module enclosure_front_back_place_horizontal_top_perforation(width, heigth) {
    translate([0, heigth / 2 - 30, 0])
        enclosure_place_horizontal_perforation(width, MATERIAL_STEEL_THICKNESS) children();
}

module enclosure_base_sketch(width, heigth, lh, overlap) {
    difference() {
        union() {
            rounded_polygon(ENCLOSURE_FULL_SHAPE(width, heigth, lh = lh));
            translate([0, heigth / 2 + CAP_HEIGTH / 2 - 10])
                square([width, CAP_HEIGTH + 20], center = true);
        }
        // vertical screw mount perforation
        enclosure_base_place_dual_vertical_perforation(width, heigth, overlap) circle(d = 5);

        // bottom horizontal screw mount perforation
        enclosure_base_place_horizontal_perforation(width, heigth, lh + MATERIAL_STEEL_THICKNESS, overlap) circle(d = 5)
            ;
    }
}

module enclosure_base_front_back_sketch(width, heigth, window_w, lh, overlap) {
    difference() {
        enclosure_base_sketch(width, heigth, lh, overlap);

        enclosure_front_back_place_horizontal_top_perforation(width, heigth) circle(d = 5);

        translate([0, heigth / 2 - 5])
            rounded_square([window_w, 25], 5, center = true);
    }
}
