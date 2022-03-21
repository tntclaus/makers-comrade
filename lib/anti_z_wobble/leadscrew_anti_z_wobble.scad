include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/leadnuts.scad>

/**
* ! Anti wobble ring for 8mm leadscrew.
* ! Requires glueing parts.
*
*
* Credits:
* Anti Z-wobble ring idea borrowed from here:
* https://www.thingiverse.com/thing:2815337
* Screw-less design borrowed from here:
* https://www.thingiverse.com/thing:4374450
*/
module leadscrew_anti_z_wobble_assembly() {
    assembly("leadscrew_anti_z_wobble"){
        translate_z( 7)
        leadscrew_anti_z_wobble_base();

        leadscrew_anti_z_wobble_middle();

        translate_z(-7)
        rotate([180, 0, 90])
            leadscrew_anti_z_wobble_base();
    }
}

module leadscrew_anti_z_wobble_base() {
    leadscrew_anti_z_wobble_base_lock();
    leadscrew_anti_z_wobble_base_nut_mount();
}

module leadscrew_anti_z_wobble_base_nut_mount_stl() {
    $fn = 180;
    leadscrew_anti_z_wobble_base_nut_mount();
}

module leadscrew_anti_z_wobble_base_nut_mount() {
    stl("ABS_leadscrew_anti_z_wobble_base_nut_mount");
    translate_z(2.25)
    difference() {
        union() {
            cylinder(d = 22, h = 1.5, center = true);
            translate_z(-leadnut_flange_t(LSN8x2)+.75)
            leadnut_screw_positions(LSN8x2)
            cylinder(d = 3, h = 5.5);
        }

        cylinder(d = 10.4, h = 50, center = true);
    }
}

module leadscrew_anti_z_wobble_base_lock_stl() {
    $fn = 180;
    rotate([180,0,0])
    leadscrew_anti_z_wobble_base_lock();
}

module leadscrew_anti_z_wobble_base_lock() {
    stl("ABS_leadscrew_anti_z_wobble_base_lock");
    rotate([180, 0, 0])
        difference() {
            union() {
                cylinder(d = 22, h = 3, center = true);
                translate_z(2.1 - 0.75)
                rotation_tooth();
            }
            cylinder(d = 10.4, h = 50, center = true);
            difference() {
                cylinder(d = 30, h = 50, center = true);
                cylinder(d = 22, h = 51, center = true);

            }
        }
}

module leadscrew_anti_z_wobble_middle() {
    //    translate_z( .5)
    leadscrew_anti_z_wobble_middle_half();
//        translate_z(-.5)
    rotate([180, 0, 90])
        leadscrew_anti_z_wobble_middle_half();
}

module leadscrew_anti_z_wobble_middle_half_stl() {
    $fn = 180;
    leadscrew_anti_z_wobble_middle_half();
}
module leadscrew_anti_z_wobble_middle_half() {
    stl("ABS_leadscrew_anti_z_wobble_middle_half");

    rotate([180, 0, 0])
        translate_z(- 5)

        difference() {
            difference() {
                translate_z(2.5)
                cylinder(d = 22, h = 5, center = true);
                translate_z(- .3)
                rotation_tooth();

                cube([10, 200, 5], center = true);
            }
            cylinder(d = 10.4, h = 50, center = true);

//            rotate([0, 0, 45])
//                translate([8, 0, 0])
//                    cylinder(d = 1, h = 50, center = true);
//
//            rotate([0, 0, - 45 - 90])
//                translate([8, 0, 0])
//                    cylinder(d = 1, h = 50, center = true);
        }
}


module rotation_tooth() {
    translate_z(1.8 + 1.8 / 2)
    rotate([0, 90, 0])
        translate_z(- 11)
        linear_extrude(22, convexity = 3) {
            rotation_tooth_sketch();
        }
}

module rotation_tooth_sketch() {
    union() {
        hull() {
            circle(d = 2.5);
            translate([1.8, 0])
                square([.01, 3.5], center = true);
        }
        difference() {
            hull() {
                translate([1.8, 0])
                    square([.01, 3.5], center = true);
                translate([2.7, 0])
                    square([.1, 5], center = true);
            }
            translate([1, 3.585])
                circle(d = 4);

            translate([1, - 3.585])
                circle(d = 4);

        }
    }
}

//leadscrew_anti_z_wobble_assembly();

//translate([50,0,0])
leadscrew_anti_z_wobble_base_nut_mount_stl();
//leadscrew_anti_z_wobble_base_lock_stl();
//translate([-50,0,0])
//leadscrew_anti_z_wobble_middle_half_stl();
