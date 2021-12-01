include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <screw_assemblies.scad>


module motor(motorScrewY, model, diff = false) {
    tr = NEMA_hole_pitch(model) / 2;

    module scr() {
        cylinder(d = 4, h = 30);
    }

    rotate([0, 90, 0]) if (!diff) {
        NEMA(model);
        translate([0, 0, 25]) {
            leadscrew_coupler(FLEXIBLE_COUPLER_8_5);
            translate_z(3)
            steel_ball(8);
        }
    } else {
        cylinder(d = NEMA_boss_radius(model) * 2, h = 30);
    }

    if (!diff) {
        translate([motorScrewY, tr, tr]) screwmM3x15();
        translate([motorScrewY, tr, - tr]) screwmM3x15();
        translate([motorScrewY, - tr, tr]) screwmM3x15();
        translate([motorScrewY, - tr, - tr]) screwmM3x15();
    } else {
        translate([0, tr, tr]) rotate([0, 90, 0]) scr();
        translate([0, tr, - tr]) rotate([0, 90, 0]) scr();
        translate([0, - tr, tr]) rotate([0, 90, 0]) scr();
        translate([0, - tr, - tr]) rotate([0, 90, 0]) scr();
    }
}

