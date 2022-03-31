include <../../lib/cable_chain.scad>

include <NopSCADlib/utils/core/core.scad>

module caret_cable_chain_mounts() {
    translate([0,6,0]) children();
    translate([0,-6,0]) children();
}

module cable_chain_caret_section(
l = 40,
w = 30,
h = 18
) {

    d_o = 30;

    name = str("ABS_cable_chain_caret_section_",
    "l", l, "x",
    "w", w, "x",
    "h", h
    );
    stl(name);

    module fan_duct_path() {
        translate([-d_o+2,6.5,0])
        rotate([0, 00, 0])
        translate([d_o-2,0,0])
            rotate_extrude(angle = -90, convexity = 10)
                translate([- (w / 2 + d_o / 2 - 2), 0, 0])
                    children();
    }

    translate_z(h/2)
    difference() {
        color("red")
        cable_chain_section_body_base(l = l, w = w, h = h, end = false);

        color("red")
        translate([0,l/2+10,0])
            cube([w*2,w,h*2], center = true);


        caret_cable_chain_mounts()
        cylinder(r = M3_clearance_radius, h = h * 2, center = true);

        translate_z(-h/2)
        fan_duct_path() circle(d = d_o-.1);
    }


//    translate([7.5,d_o+4.5,0])
//    rotate([0,90,0]) difference() {
//        cylinder(d = d_o, h = 15, center = true);
//        cylinder(d = 25.5, h = 10*2, center = true);
//    }

    translate([-(w/2+d_o/2-2),2,0])
    rotate([90,0,0]) difference() {
        cylinder(d = d_o, h = 10, center = true);
        cylinder(d = 25.5, h = 10*2, center = true);
    }

    fan_duct_path() {
        difference() {
            circle(d = d_o, $fn = 100);
            circle(d = 25.5, $fn = 100);
        }
    }

}

module ABS_cable_chain_caret_section_l40xw30xh18_stl() {
    $fn = 90;
    cable_chain_caret_section(
        l = 40,
        w = 30,
        h = 18
    );
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
ABS_cable_chain_section_body_and_cap_no_coil_l30w30h18_stl();
//import("~/Downloads/")
