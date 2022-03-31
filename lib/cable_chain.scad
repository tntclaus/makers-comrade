include <NopSCADlib/core.scad>

/**
* STL helper
*/
module cable_chain_section_body_and_cap(l, w, h, coil) {
    $fn = 90;
    translate([0,0,h/2]) {
            translate([0, - l, -h+1.5])
            rotate([0, 0, 0])
                cable_chain_section_cap(l, w, h);

        cable_chain_section_body(l, w, h, coil = coil);
    }
}

module cable_chain_section(l, w, h, color = "yellow", coil = true) {

    has_coil = coil ? "with_coil" : "no_coil";

    name = str("ABS_cable_chain_section_body_and_cap_", has_coil, "_",
    "l", l, "w", w, "h", h
    );
    stl(name);

    color("blue")
    render()
    cable_chain_section_cap(l, w, h);

    color(color)
    render()
    cable_chain_section_body(l, w, h, coil = coil);
}

module cable_chain_section_cap(l, w, h, expansion = 0) {
    translate([0,l/12,h/2-1/2-.25]) {
            cube([w-7, l / 3, 1.5+expansion], center = true);
            cube([w-3+expansion*10, l / 3 / 2, 1.5+expansion], center = true);
    }
}

module cable_chain_section_body_base(
    l, w, h, start = true, end = true) {
    module ear_mount() {
        translate_z(h/2)
        cube([3.2, h/2, h/2], center = true);
        translate_z(-h/2)
        cube([3.2, h/2, h/2], center = true);
        rotate([0, 90, 0])
            difference() {
                cylinder(d = h+.2, h = 3.2, center = true);
                cylinder(d = 3, h = 4, center = true);
            }
    }

    difference() {
        union() {
            hull() {
                cube([w, l, h], center = true);
                if(end) {
                    translate([0, l / 2, 0])
                        rotate([0, 90, 0])
                            cylinder(d = h, h = w, center = true);
                }
                if(start) {
                    translate([0, - l / 2 + h / 4, 0])
                        rotate([0, 90, 0])
                            cylinder(d = h, h = w, center = true);
                }
            }

            if(start) {
                translate([0, - l / 2, 0])
                    rotate([0, 90, 0])
                        cylinder(d = 3, h = w + 1, center = true);
            }

        }

        if(end) {
            translate([0, l / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = 3.5, h = w * 2, center = true);

            translate([0, l * 0.8, 0])
                cube([w - 3.1, l, h*2], center = true);
        }

        if(start) {
            translate([- w / 2, - l / 2, 0])
                ear_mount();
            translate([w / 2, - l / 2, 0])
                ear_mount();

            translate([0, 0, 2])
                cube([w - 6, l*2, h], center = true);

        }
    }
}

module cable_chain_section_body(
    l, w, h,
    d_cooler = 24.5,
    d_filament_feeder = 4.5,
    coil = true
) {
    coil_th = 8;
    coil_h = 4;

    module attach_coil(d, cooler = false) {
        difference() {
            union() {
                difference() {
                    hull() {
                        cylinder(d = d + coil_th, h = coil_h, center = true);
                        translate([0, - d / 2 - coil_th / 2, - coil_h / 2])
                            cube([d / 2, d / 2, coil_h]);
                    }
                    cylinder(d = d, h = coil_h * 2, center = true);
                }
//                if(cooler) {
//                    difference() {
//                        cylinder(d = d + 1, h = 1, center = true);
//                        cylinder(d = d - 1.5, h = 2, center = true);
//                    }
//                }
            }
            translate([- d / 4, - d / 6, - d / 2])
                cube([d * 2, d * 2, d * 2]);

        }
    }

    difference() {
        union() {
            cable_chain_section_body_base(l = l, w = w, h = h);
            if(coil) {
                if (d_cooler > 0) {
                    translate([(d_cooler / 2 + w / 2), 0, d_cooler / 2 + coil_th / 2 - h / 2])
                        rotate([90, 0, 180])
                            attach_coil(d = d_cooler, cooler = true);
                }

//                if (d_filament_feeder > 0) {
//                    translate([(d_cooler / 2 + w / 2), 0, 0]) {
//                        translate([(d_filament_feeder / 2 + d_cooler / 2) + coil_th / 2, 0, d_filament_feeder / 2 +
//                                coil_th
//                                / 2 - h / 2]) {
//                            rotate([90, 0, 180])
//                                attach_coil(d = d_filament_feeder);
//                        }
//                        translate([coil_th / 2, 0, - h / 2 + coil_th / 4])
//                            cube([d_cooler, coil_h, coil_th / 2], center = true);
//                    }
//                }
            }
        }


        translate_z(-1.5)
        cable_chain_section_cap(l, w, h, expansion = 1);
    }

}

function cable_chain_segment_length(type) = type[0];
function cable_chain_segment_width(type) = type[1];
function cable_chain_segment_heigth(type) = type[2];
function cable_chain_segment_angles(type) = type[3];

module cable_chain(type) {
    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);
    angles =   cable_chain_segment_angles(type);

    module rotated_section(angles = 0, coil) {
        angle = angles[0];

        set_color = coil ? "green" : "white";

        rotate([angle,0,0])
            translate([0, l/2,0])
                cable_chain_section(l = l, w = w, h = h, color = set_color, coil = coil);

        if(len(angles) > 1) {
            remaining_angles = [for (a = [1 : len(angles) - 1]) angles[a]];
            rotate([angle,0,0])
                translate([0,l,0])
                    rotated_section(remaining_angles, coil = !coil)
                        children();

        } else {
            children();
        }
    }


    rotated_section(angles, coil = false)
    children();
}

//CABLE_CHAIN = [40, 30, 16, [30,45,10]];
//cable_chain(CABLE_CHAIN);
//cable_chain([]);

//color("blue")
//render()
//cable_chain_section_body_and_cap(l = 30, w = 30, h = 18);
//cable_chain_section_body(l = 30, w = 30, h = 16);
