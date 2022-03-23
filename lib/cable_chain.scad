include <NopSCADlib/core.scad>

module cable_chain_section(l, w, h) {
    cable_chain_section_cap(l, w, h);
    cable_chain_section_body(l, w, h);
}

module cable_chain_section_cap(l, w, h, expansion = 0) {
    name = str("ABS_cable_chain_section_cap_",
    "l", l, "w", w, "h", h
    );
    stl(name);
    module mount() {
         difference() {
             union() {
                 translate([- 1.5 / 4, 0, 0])
                     cube([1.5 / 2, l / 3, 4], center = true);
                if(expansion == 0) {
                    translate([- 0.75, 0, - 2.2])
                        cube([1.5, l / 3, 2], center = true);
                } else {
                    translate([- 0.75, 0, - 2])
                        cube([1.5, l / 3, 2], center = true);
                }
             }
             if(expansion == 0) {
                 translate([- 0.75, 0, - 3])
                 rotate([0,-45,0])
                 cube([1.5, l / 2, 4], center = true);
             }
        }
    }
    translate([0,l/12,h/2]) {
        difference() {
            cube([w, l / 3, 2], center = true);

            translate([w / 2, 0, 1])
            rotate([0,45,0])
            cube([2, l / 2, 1], center = true);

            translate([-w / 2, 0, 1])
            rotate([0,-45,0])
            cube([2, l / 2, 1], center = true);
        }

        translate([w / 2, 0, - 2])
            mount();

        translate([-w / 2, 0, - 2])
            mirror([1,0,0])
            mount();
    }
}

module cable_chain_section_body(l, w, h) {
    name = str("ABS_cable_chain_section_body_",
    "l", l, "w", w, "h", h
    );
    stl(name);
    module ear_mount() {
        translate_z(h/2)
        cube([2, h/2, h/2], center = true);
        translate_z(-h/2)
        cube([2, h/2, h/2], center = true);
        rotate([0, 90, 0])
            difference() {
                cylinder(d = h, h = 2, center = true);
                cylinder(d = 3, h = 3, center = true);
            }
    }
//    render()
    difference() {
        hull() {
            cube([w, l, h], center = true);
            translate([0, l / 2, 0])
                rotate([0, 90, 0])
                    cylinder(d = h, h = w, center = true);

            translate([0, -l / 2 + h/4, 0])
                rotate([0, 90, 0])
                    cylinder(d = h, h = w, center = true);
        }

        translate([0, l / 2, 0])
            rotate([0, 90, 0])
                cylinder(d = 3, h = w*2, center = true);

//        translate([0, l / 3, 1])
//            cube([w - 4, l, h], center = true);


        translate([0, l * 0.8, 0])
            cube([w - 2, l, h*2], center = true);

        translate([0, 0, 1])
            cube([w - 4, l*2, h], center = true);

        translate([-w/2, -l / 2, 0])
            ear_mount();
        translate([w/2, -l / 2, 0])
            ear_mount();

        cable_chain_section_cap(l, w, h, expansion = 0.1);
    }


}

//color("red")
//cable_chain_section(l = 20, w = 20, h = 10);
//translate([0,-20,0])
difference() {
    cable_chain_section_body(l = 30, w = 20, h = 10);
    translate_z(-15)
    cube([30,30,30]);
}

//cable_chain_section(l = 30, w = 20, h = 10);

color("blue") cable_chain_section_cap(l = 30, w = 20, h = 10);
