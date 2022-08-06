include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>

OVERHANG = 4;
WALL_TH = 2;
SCREW = M3_cs_cap_screw;

HEATER_CUP_OFFSET = 10;


function CALCULATE_HEATER_H(w, d) = 2;

/**
* Casted concrete heated table for conductive ink heater.
*
*/
module concrete_heatbed_table(w, d, h1 = 10, h2 = 4) {
    for (a = [0,
//                90, 180, 270
        ])
    rotate([0, 0, a]) {
        concrete_mold_quarter_section(w / 2, d / 2, h1, h2);

//        place_mold_mounts(w = w / 2, d = 10)
//        translate([0, 5, CALCULATE_HEATER_H(w, d)]) {
//                screw(SCREW, 8);
//                translate_z(-nut_thickness(screw_nut(SCREW))-WALL_TH*2)
//                nut(screw_nut(SCREW));
//        }
    }
}

module place_mold_mounts(w, d) {
    w_max = w - HEATER_CUP_OFFSET * 2 - d;
    translate([d, 0, 0])
        children();
    translate([w_max / 2, 0, 0])
        children();
    translate([w_max, 0, 0])
        children();
}


module concrete_mold_quarter_section(w, d, h1, h2) {
    stl(str(
    "ABS_concrete_mold_quarter_section_",
    "w",w,"_",
    "d",w,"_",
    "h1",w,"_",
    "h2",w,"_"
    ));

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
                cube([10-0.25, 20-0.5, h], center = true);
                translate([0, 5, 0])
                    cylinder(d = 3, h = 10, center = true);
            }
        } else {
            cube([10+0.25, 20+0.5, h], center = true);
        }
    }

    // Основание
    translate_z(- WALL_TH)
    render() difference() {
        union() {
            cube([w_o, d_o, WALL_TH]);
            rotate([0, 0, 90])
                base_mounts(cut = true);
        }
        base_mounts();
    }

    difference() {
        hull() {
            translate_z(CALCULATE_HEATER_H(w * 2, d * 2))
            cube([w - HEATER_CUP_OFFSET - WALL_TH, d - HEATER_CUP_OFFSET - WALL_TH, .1]);
            cube([w - HEATER_CUP_OFFSET, d - HEATER_CUP_OFFSET, .1]);

        }

        place_mold_mounts(w = w, d = 10)
        translate([0, 5, CALCULATE_HEATER_H(w, d)-WALL_TH]) {
            translate_z(2)
            cylinder(d = screw_head_radius(SCREW) * 2, h = 3);
            hull() {
                translate_z(2)
                cylinder(d = screw_head_radius(SCREW) * 2, h = .1);
                cylinder(d = screw_radius(SCREW) * 2, h = .1);
            }
            translate_z(-2)
            cylinder(d = screw_radius(SCREW) * 2, h = 3);
        }
    }



    render() difference() {
        difference() {
            cube([w_o, d_o, h1 + h2]);
            //                translate_z(WALL_TH)
            translate_z(h1)
            cube([w_oi, w_oi, h2 * 2]);
            cube([w, d, h1]);
        }
    }
}

//render()
concrete_heatbed_table(300, 300, 10, 4);
