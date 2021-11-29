include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

use <axes/x-axis.scad>
use <axes/y-axis.scad>
use <axes/z-axis.scad>

MATERIAL_STEEL_THICKNESS = 3;


function ENCLOSURE_FULL_SHAPE(w, h, lh, rc = 0, r = 5) = [
    // corners
    [-(w/2-rc),-(h/2-rc), rc],
    [-(w/2-rc), h/2-rc, rc],
    [ (w/2-rc), h/2-rc, rc],
    [ (w/2-rc),-(h/2-rc), rc],

    //bottom pocket
    [ (w/2-20),-(h/2-r), r],
    [ (w/2-20-r*2),-(h/2-r)+lh, -r],
    [ -(w/2-20-r*2),-(h/2-r)+lh, -r],
    [ -(w/2-20),-(h/2-r), r],
];

function PERFORATION_ROW(start, end, step) = [start : step : end];



module enclosure_base_sketch(width, heigth, leg_offset = 60, overlap = 0) {
    difference() {
        union() {
            rounded_polygon(ENCLOSURE_FULL_SHAPE(width, heigth, lh = leg_offset - MATERIAL_STEEL_THICKNESS));
            translate([0, heigth / 2 + $CAP_HEIGTH / 2 - 10])
                square([width, $CAP_HEIGTH + 20], center = true);
        }
        // vertical screw mount perforation
        for(i = PERFORATION_ROW(-heigth/2+10, heigth/2-10, (heigth-20) / 4)) {
            translate([width / 2 - 10 - overlap, i, 0]) circle(d = 5);
            translate([-(width / 2 - 10 - overlap), i, 0]) circle(d = 5);
        }

        // bottom horizontal screw mount perforation
        for(i = PERFORATION_ROW(-width/2+30+overlap, width/2-30-overlap, (width-60-overlap*2) / 3)) {
            translate([i, -(heigth / 2 - 20 - leg_offset), 0]) circle(d = 5);
        }
    }
}

module enclosure_base_front_back_sketch(width, heigth, window_w, leg_offset = 60, overlap = 0) {
    difference() {
        enclosure_base_sketch(width, heigth, leg_offset, overlap);

        translate([0, heigth/2-5])
            rounded_square([window_w, 25], 5, center = true);
    }
}

module enclosure_front(width, heigth, window_w, window_h, window_translate_z) {
    dxf(str("STEEL_",MATERIAL_STEEL_THICKNESS,"mm_enclosure_front_", width, "x", heigth, "mm"));

    translate_z(heigth/2)
    rotate([90,0,-90])
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            enclosure_front_sketch(width + MATERIAL_STEEL_THICKNESS*2, heigth, window_w, window_h, window_translate_z);
}

module enclosure_front_sketch(width, heigth, window_w, window_h, window_translate_z) {
    difference() {
        enclosure_base_front_back_sketch(width, heigth, window_w = window_w, overlap = MATERIAL_STEEL_THICKNESS);

        translate([0, window_translate_z])
        rounded_square([window_w, window_h], 10, center = true);

        for(i = PERFORATION_ROW(-width/2+30+MATERIAL_STEEL_THICKNESS, width/2-30-MATERIAL_STEEL_THICKNESS, (width-60-MATERIAL_STEEL_THICKNESS*2) / 3)) {
            translate([i, heigth / 2 - 30, 0]) circle(d = 5);
        }
    }
}
module enclosure_back(width, heigth, window_w) {
    dxf(str("STEEL_",MATERIAL_STEEL_THICKNESS,"mm_enclosure_back_", width, "x", heigth, "mm"));

    translate_z(heigth/2)
    rotate([90,0,-90])
        linear_extrude(MATERIAL_STEEL_THICKNESS)
            enclosure_back_sketch(width + MATERIAL_STEEL_THICKNESS*2, heigth, window_w);
}

module enclosure_back_sketch(width, heigth, window_w) {
    difference() {
        enclosure_base_front_back_sketch(width, heigth, window_w, overlap = MATERIAL_STEEL_THICKNESS);

        for(i = PERFORATION_ROW(-width/2+30+MATERIAL_STEEL_THICKNESS, width/2-30-MATERIAL_STEEL_THICKNESS, (width-60-MATERIAL_STEEL_THICKNESS*2) / 3)) {
            translate([i, heigth / 2 - 30, 0]) circle(d = 5);
        }
    }
}

