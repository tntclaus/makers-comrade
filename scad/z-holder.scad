include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <screw_assemblies.scad>
include <../lib/leadscrew_couplers.scad>

module motor(motorScrewY, model, diff=false) {
    tr = NEMA_hole_pitch(model)/2;

    module scr() {
        cylinder(d = 5, h = 30);
    }

    rotate([0,90,0]) if(!diff) {
        NEMA(model);
        translate([0,0,30])
            leadscrew_coupler(FLEXIBLE_COUPLER_8_5);



    } else {
        cylinder(d = NEMA_boss_radius(model)*2, h = 30);
    }

    if(!diff) {
        translate([motorScrewY,tr,tr]) screwmM3x15();
        translate([motorScrewY,tr,-tr]) screwmM3x15();
        translate([motorScrewY,-tr,tr]) screwmM3x15();
        translate([motorScrewY,-tr,-tr]) screwmM3x15();
    } else {
        translate([motorScrewY,tr,tr]) rotate([0,90,0]) scr();
        translate([motorScrewY,tr,-tr]) rotate([0,90,0]) scr();
        translate([motorScrewY,-tr,tr]) rotate([0,90,0]) scr();
        translate([motorScrewY,-tr,-tr]) rotate([0,90,0]) scr();
    }
}

//module motorPulley(motorScrewY, model, pulley, pulleyElevation) {
//    rotate([0,90,0]) {
//        NEMA(model);
//        translate([0,0,pulleyElevation])
//            pulley(pulley);
//    }
//
//    tr = NEMA_hole_pitch(model)/2;
//
//    translate([motorScrewY,tr,tr]) screwmM3x15();
//    translate([motorScrewY,tr,-tr]) screwmM3x15();
//    translate([motorScrewY,-tr,tr]) screwmM3x15();
//    translate([motorScrewY,-tr,-tr]) screwmM3x15();
//}
//
