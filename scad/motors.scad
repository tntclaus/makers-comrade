include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <screw_assemblies.scad>
include <../lib/leadscrew_couplers.scad>


module steel_ball(d) {
    vitamin(str("steel_ball(): Steel Ball d=", d));
    color("silver")
        sphere(d = d);
}

//! 1. Screw each NEMA17 motor and thurst bearing collet to its respective position.
//! 1. Install thurst bearing.
//! 1. Place flexible coupler on top of thurst bearing and screw it to the motor shaft.
//! 1. Place steel ball inside flexible coupler, this is known as steel ball leadscrew hack.
//! 1. Place leadscrew into flexible coupler so it would touch the steel ball.
// Leadscrew should be able to freely bend coupler.
//! 1. Screw leadscrew in flexible coupler.
module z_axis_motor_assembly(model, leadscrew_length) {
    assembly("z_axis_motor") {
        translate_z($CASE_MATERIAL_THICKNESS)
        z_motor_thurst_bearing_collet_assembly();

        NEMA(model);

        translate([0, 0, 25]) {
            leadscrew_coupler(FLEXIBLE_COUPLER_8_5);
            translate_z(2)
            steel_ball(6);
        }

        if($preview_screws)
        translate_z($CASE_MATERIAL_THICKNESS + 3)
        NEMA_screws(model, M3_pan_screw);

        translate([0, 0, leadscrew_length / 2 + 30])
            leadscrew(
                8,
                leadscrew_length,
                8,
                2,
                center = true
            );
    }
}

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

