include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pcbs.scad>

include <pulley_and_motor_plates.scad>

include <axes/carets.scad>
//use <axes/y-axis.scad>
use <../lib/vslot_wheels/vwheel_plate.scad>
use <../lib/opto_endstop.scad>

module ABS_endstop_x_stl() {
    endstop_x_model();
}

module endstop_x_model() {
    stl("ABS_endstop_x");

    difference() {
        union() {
            hull() {
                translate([0,-2.5,0])
                cube([27,1,3],center = true);
                translate([-12,-10.5,0])
                cylinder(d = 3, h = 3,center = true);
                translate([ 14,-12,0])
                cylinder(d = 0.1, h = 3,center = true);
            }
            translate([10.5,-10,13])
            cube([7,4,26],center = true);
        }

        translate([4,-8,-3.5])
        cube([16,30,7]);

        translate([-5,-7.5,0])
            cylinder(r = M5_clearance_radius, h = 10, center = true);

        translate([7.25,-6,24.6])
            rotate([0,90,0])
                opto_endstop_place_mounts()
                cylinder( r = M3_clearance_radius, h = 50, center = true);
    }


}

module endstop_x() {
    translate([25.5,-6,18.5])
    rotate([-90,0,0])
    opto_endstop();


    stl("ABS_endstop_x_mount");

    color("orange")
    translate([15,0,1.5])
    endstop_x_model();
}



//y_axis_assembly(298, 300, 300);
