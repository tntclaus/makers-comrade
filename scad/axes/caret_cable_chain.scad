include <../../lib/cable_chain/cable_chains.scad>

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/fans.scad>


//                                          name,  l,  w,  h,hook,  smnts,  lh,    of
CABLE_CHAIN =            ["cable_chain"        , 40, 30, 18, 0, 30];
CABLE_CHAIN_2 =            ["cable_chain"      , 60, 30, 18, 0, 30];

module caret_cable_chain_mounts() {
    translate([0, 6, 0]) children();
    translate([0, - 6, 0]) children();
}

module cable_chain_caret_section() {
    type = CABLE_CHAIN;
    d_o = 30;

    name = str("ABS_cable_chain_caret_section");
    stl(name);

    w = cable_chain_segment_width(CABLE_CHAIN);
    h = cable_chain_segment_heigth(CABLE_CHAIN);
    l = cable_chain_segment_length(CABLE_CHAIN);

    module fan_duct_path() {
        translate([- d_o + 2, 6.5, 0])
            rotate([0, 00, 0])
                translate([d_o - 2, 0, 0])
                    rotate_extrude(angle = - 90, convexity = 10)
                        translate([- (w / 2 + d_o / 2 - 2), 0, 0])
                            children();
    }

    translate_z(h / 2)
    difference() {
        color("red")
            union() {
                cable_chain_section_body_base(CABLE_CHAIN_2, end = false);
                translate_z(- 8.5){
                    hull() {
                        translate([15, 0, -1])
                            cube([3, 30, 3], center = true);
                        translate([72, 0, -1])
                            cylinder(d = 8, h = 3, center = true);
                    }
                    translate([72, 0, 1])
                        cylinder(d = 8, h = 2, center = true);

                    translate([0, 0, -1])
                        cube([w, 51, 3], center = true);

                    translate([15, -21, -2.5])
                        cube([3, 7, h]);

                }
            }

        translate([72, 0, - 8])
            cylinder(d = 5.2, h = 5, center = true);

        translate([25, 0, 1]) {
            cube([40, 33, 18], center = true);
            translate([- 5, 15, 0])
                cube([50, 10, 18], center = true);
        }

        color("red")
            translate([0, l / 2 + 10, 0])
                cube([w * 2, w, h * 2], center = true);


        caret_cable_chain_mounts()
        cylinder(r = M3_clearance_radius, h = h * 2, center = true);

        translate_z(- h / 2)
        fan_duct_path() circle(d = d_o - .1);
    }


    translate([- (w / 2 + d_o / 2 - 2), 2, 0])
        rotate([90, 0, 0]) difference() {
            cylinder(d = d_o, h = 10, center = true);
            cylinder(d = 25.5, h = 10 * 2, center = true);
        }

    fan_duct_path() {
        difference() {
            circle(d = d_o, $fn = 100);
            circle(d = 25.5, $fn = 100);
        }
    }

}

module ABS_cable_chain_caret_section_stl() {
    $fn = 90;
    cable_chain_caret_section(CABLE_CHAIN);
}


module ABS_cable_chain_section_body_and_cap_with_coil_l30w30h18_stl() {
    //    cable_chain_section_body_and_cap(30, 30, 18, coil = true);
    cable_chain_section_body(30, 30, 18, coil = true);
}


module ABS_cable_chain_section_body_and_cap_no_coil_l30w30h18_stl() {
    cable_chain_section_body(30, 30, 18, coil = false);
    //    cable_chain_section_body_and_cap(30, 30, 18, coil = false);
}

//module cable_chain_assembly() {
//    assembly("cable_chain") {
//        cable_chain([])
//        translate([0,20,-8])
//        cable_chain_caret_section();
//    }
//}
//
//
//cable_chain_assembly();

//ABS_cable_chain_caret_section_l40xw30xh18_stl();
//ABS_cable_chain_section_body_and_cap_with_coil_l30w30h18_stl();
//ABS_cable_chain_caret_section_l40xw30xh18_stl();



module extra_fan_shtuzer(type, d_i, d_o) {
    w = fan_width(type);
    difference() {
        union() {
            translate_z(20)
            cylinder(d = d_o, h = 10);
            hull() {
                translate_z(20)
                cylinder(d = d_o, h = 1);
                cylinder(d = fan_bore(type) + 2, h = 1);
            }
        }

        cylinder(d = d_i, h = 100, center = true);
        hull() {
            translate_z(20)
            cylinder(d = d_i, h = 1);
            cylinder(d = fan_bore(type), h = 1, center = true);
        }
    }
    difference() {
        cube([w, w, 4], center = true);
        cylinder(d = fan_bore(type), h = 10, center = true);
        fan_holes(type);
    }
}

module extra_fan_inlet(type) {
    extra_fan_shtuzer(type = type, d_i = 24, d_o = 28);
}
module extra_fan_outlet(type) {
    extra_fan_shtuzer(type = type, d_i = 22, d_o = 24);
}

module extra_fan(type = fan40x11) {
    translate_z(8)
    extra_fan_outlet(type = type);
    fan(type);
    translate_z(- 8)
    rotate([180, 0, 0])
        extra_fan_inlet(type = type);
}

module ABS_extra_fanlets() {
    $fn = 180;
    type = fan40x11;

    translate([fan_width(type) / 2+1, 0, 0])
        extra_fan_outlet(type = type);
    translate([- fan_width(type) / 2-1, 0, 0])
        extra_fan_inlet(type = type);
}
//ABS_extra_fanlets();
//extra_fan();

//cable_chain_caret_section();
