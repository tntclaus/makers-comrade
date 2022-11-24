include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>

include <../../lib/utils.scad>

OVERHANG = 4;
WALL_TH = 2;
SCREW = M3_cs_cap_screw;

HEATER_CUP_OFFSET = 10;


function CALCULATE_HEATER_H(w, d) = 2;

function get_wall_color(a) = a == 0 ? "red" : a == 180 ? "red" : "green";

/**
* Casted concrete heated table for conductive ink heater.
*/
module concrete_heatbed_table(w, d, h1 = 10, h2 = 4) {
    translate_z(WALL_TH * 2)
    for (a = [0,
        90, 180, 270
        ])
    rotate([0, 0, a]) {
        concrete_mold_quarter_section(w / 2, d / 2, h1, h2);
        color(get_wall_color(a))
            if (w == d) {
                translate([w / 2 + 1.5, 0, 0])
                    rotate([0, 0, 90])
                        concrete_mold_quarter_wall(w, h1, 1.5, w);
                translate([w / 2 + 3, 0, 0])
                    rotate([0, 0, 90])
                        concrete_mold_quarter_wall(w + 3, h1 + h2, 1.5, w);
            }
    }


}

module place_mold_mounts_line(d) {
    translate([d - 7.5, 0, 0])
        children();
    translate([d / 4 * 3, 0, 0])
        children();
    translate([d / 2, 0, 0])
        children();
    translate([d / 4, 0, 0])
        children();
}

module place_mold_mounts(w, d) {
    translate([d - 7.5, w, 0])
        children();
    translate([d / 4 * 3, w, 0])
        children();
    translate([d / 2, w, 0])
        children();
    translate([d / 4, w, 0])
        children();

    translate([d, w - 7.5, 0])
        children();
    translate([d, w / 4 * 3, 0])
        children();
    translate([d, w / 2, 0])
        children();
    translate([d, w / 4, 0])
        children();
}

module concrete_mold_quarter_wall(w, h, th, tw) {
    name = str_replace(str(
    "ABS_concrete_mold_quarter_wall_",
    "w", w, "_",
    "h", h, "_",
    "th", th, "_",
    "tw", tw
    ), ".","_");
//    echo(name);
    stl(name);

    translate_z(h / 2)
    hull() {
        translate([0, th, 0])
            cube([w, .01, h], center = true);
        cube([w + th * 2, .01, h], center = true);
    }

    module mounts() {
        translate([th / 2, th / 2, - WALL_TH])
            place_mold_mounts_line(tw / 2)
            cube([th * 2, th, WALL_TH * 2], center = true);
    }

    mounts();
    mirror([1, 0, 0])
        mounts();
}


module concrete_mold_quarter_section(w, d, h1, h2) {
    name = str(
    "ABS_concrete_mold_quarter_section_",
    "w", w, "_",
    "d", d, "_",
    "h1", h1, "_",
    "h2", h2
    );
//    echo(name);
    stl(name);

    w_o = w + OVERHANG + WALL_TH;
    w_oi = w + OVERHANG;
    d_o = d + OVERHANG + WALL_TH;
    d_oi = d + OVERHANG;


    module base_mounts(h = 2, cut = false) {
        size = 10;
        place_mold_mounts(w = w, d = 10)

        translate_z(h / 2)
        if (cut) {
            difference() {
                cube([10 - 0.25, 20 - 0.5, h], center = true);
                translate([0, 5, 0])
                    cylinder(d = 3, h = 10, center = true);
            }
        } else {
            cube([10 + 0.25, 20 + 0.5, h], center = true);
        }
    }

    // Основание
    translate_z(- WALL_TH * 2)
    difference() {
        cube([w_o, d_o, WALL_TH * 2]);
        place_mold_mounts(w + 1.5, d + 1.5)
        cube([3.1, 3.1, 10], center = true);
    }

    difference() {
        hull() {
            translate_z(CALCULATE_HEATER_H(w * 2, d * 2))
            cube([w - HEATER_CUP_OFFSET - WALL_TH, d - HEATER_CUP_OFFSET - WALL_TH, .1]);
            cube([w - HEATER_CUP_OFFSET, d - HEATER_CUP_OFFSET, .1]);
        }
    }
}

module ABS_concrete_mold_quarter_section_w150_d150_h110_h24() {
    translate_z(WALL_TH*2)
    concrete_mold_quarter_section(w=150,d=150,h1=10,h2=4);
}

module ABS_concrete_mold_quarter_wall_w300_h10_th1_5_tw300() {
    rotate([90,0,0])
    concrete_mold_quarter_wall(w=300,h=10,th=1.5,tw=300);
}

module ABS_concrete_mold_quarter_wall_w303_h14_th1_5_tw300() {
    rotate([90,0,0])
    concrete_mold_quarter_wall(w=303,h=14,th=1.5,tw=300);
}

//render()
//concrete_heatbed_table(300, 300, 10, 4);

//ABS_concrete_mold_quarter_wall_w300_h10_th1_5_tw300();
//ABS_concrete_mold_quarter_wall_w303_h14_th1_5_tw300();
//ABS_concrete_mold_quarter_section_w150_d150_h110_h24();

//s=303;
//color("green")
//cube([s,s,10], center = true);


