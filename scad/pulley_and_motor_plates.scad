include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>

include <screw_assemblies.scad>

use <pulley_spacer.scad>


CORNER_PLATE_COORDS = [
    [3,3,3],
    [3,37,3],
    [37,37,3],
    [37,23,3],
//    [23,17,-3],
    [17,3,3],
    ];


module pulley_corner_plate() {
    dxf("STEEL_3mm_pulley_corner_plate");

    difference() {
        rounded_polygon(CORNER_PLATE_COORDS);
        translate([10,10,0]) circle(r = M5_clearance_radius);
        translate([30,30,0]) circle(r = M5_clearance_radius);
        translate([10,30,0]) circle(r = M4_tap_radius);
    }
}

module STEEL_3mm_pulley_corner_plate_dxf() {
    pulley_corner_plate();
}

module ABS_pulley_spacer_5_stl() {
    $fn = 180;
    pulley_spacer(5);
}
module ABS_pulley_spacer_8_2_stl() {
    $fn = 180;
    pulley_spacer(8.2);
}

module corner_pulley_assembly(pos1, pos2, length, plate_thickness) {
//    mirror([0,0,1])
    translate_z(length)
        screw(M4_cs_cap_cross_screw, length);

//    translate_z(plate_thickness) nut(M4_nut);

    translate_z(plate_thickness) pulley_spacer(8.5);
    translate_z(plate_thickness+3.5+pos1+5) pulley_spacer(8.5);

    translate_z(plate_thickness+pos1) pulley(GT2x20_plain_idler);
    translate_z(plate_thickness+pos2) pulley(GT2x20_plain_idler);
}

module corner_pulley_block(pos1, pos2, length = 40, plate_thickness=3) {
    color("#e1e1e1") linear_extrude(plate_thickness) pulley_corner_plate();
    translate([10,30,0]) corner_pulley_assembly(pos1,pos2,length,plate_thickness);

}

module STEEL_3mm_nema17_mount_plate_dxf() {
    motorMountPlate(NEMA17M, 3);
}

module motorMountPlate(model, distance = 3) {
    dxf("STEEL_3mm_nema17_mount_plate");

    hd = 4;
    mw = NEMA_width(model)/2;

    cl = mw;
    coords = [
            [3,3,3],
            [-3,41,-3],
            [-cl+13,47,3],
            [-cl+13,40+mw*2-3+distance,3],
            [cl+7,40+mw*2-3+distance,3],
            [cl+13,40,-3],
            [37,   34,3],
            [37,   23,3],
        //    [23,17,-3],
            [17,    3,3],
        ];
    shift =  40+mw+distance;

    module mountHull(d = 5) {
        hull() {
            circle(d = d);
            translate([0,-3,0]) circle(d = d);
        }
    }

    difference() {
        translate([-10,-shift,0]) rounded_polygon(coords);
        translate([0,-shift,0]) {
            translate([0,10,0]) mountHull();
            translate([20,30,0]) mountHull();
            translate([0,30,0]) mountHull();
        }

        circle(d = NEMA_boss_radius(model)*2);
        NEMA_screw_positions(model, 4) circle(d=hd);
        //        translate([0,1,0]) {
        //            circle(d = NEMA_boss_radius(model)*2);
        //            NEMA_screw_positions(model, 4) circle(d=hd);
        //        }
        //        translate([0,2,0]) {
        //            circle(d = NEMA_boss_radius(model)*2);
        //            NEMA_screw_positions(model, 4) circle(d=hd);
        //        }

    }
}


module motor_assembly(motorScrewY, model) {
    tr = NEMA_hole_pitch(model)/2;
    rotate([0,90,0]) {
        NEMA(model);
        translate_z(7)
        pulley(GT2x16_pulley);

        translate([-tr-6,-tr,3])
            xy_belt_tensioner_assembly();
    }



    translate([motorScrewY,tr,tr]) screwmM3x15();
    translate([motorScrewY,tr,-tr]) screwmM3x15();
    translate([motorScrewY+4,-tr,tr])  rotate([0,90,0]) screw(M3_hex_screw, 16);
    translate([motorScrewY,-tr,-tr]) screwmM3x15();
}


BB682   =  ["624",   2,  5, 2.3,   "blue",      0.3, 0.4];  // ball bearing for idlers

//TENSIONER_BB = BB682;
TENSIONER_BB = BB624;
TENSIONER_BB_SCREW = M4_cs_cap_screw;
TENSIONER_BB_SCREW_L = 10;

module xy_belt_tensioner_assembly() {
    WHEEL_LOC = [15,0,9];
    rotate([0,0,5]) {
        difference() {
            xy_belt_tensioner();
//            cube([100,100,20]);
        }
        translate(WHEEL_LOC) {
            pulley(GT2x16_plain_idler);

//            ball_bearing(TENSIONER_BB);
//            translate_z(2.3)
//            ball_bearing(TENSIONER_BB);

            translate_z(-5){
                rotate([180, 0, 0])
                    screw(TENSIONER_BB_SCREW, TENSIONER_BB_SCREW_L);
                translate_z(TENSIONER_BB_SCREW_L - 2)
                nut(screw_nut(TENSIONER_BB_SCREW));
            }
        }
//        translate(WHEEL_LOC)
//        translate_z(1)
//        xy_belt_tensioner_wheel();
    }
}

module ABS_xy_belt_tensioner_wheel_stl() {
    xy_belt_tensioner_wheel();
}
module xy_belt_tensioner_wheel() {
    stl("ABS_xy_belt_tensioner_wheel");
    difference() {
        cylinder(d = bb_diameter(TENSIONER_BB)+4, h = 5.6, center = true);
        cylinder(d = bb_diameter(TENSIONER_BB)+.2, h = 10, center = true);
    }
}

module ABS_xy_belt_tensioner_stl() {
    xy_belt_tensioner();
}

module xy_belt_tensioner() {
    stl("ABS_xy_belt_tensioner");

    l = 15;
    d = 8;
    d_in = 3.2;
//    d_in2 = 2.2;

    d_ten = screw_radius(TENSIONER_BB_SCREW)*2;
    d_ten_out = screw_head_radius(TENSIONER_BB_SCREW)*2;

    h_base = 7;

    difference() {
        union() {
            hull() {
                translate([l, 0, 0]) {
                    cylinder(d = d, h = h_base);
//                    cylinder(d = d_in+1, h = 10);
                }

                cylinder(d = d, h = h_base);
            }
            translate([l, 0, 0]) {
                translate_z(h_base)
                hull() {
                    translate_z(2)
                    cylinder(d = d_ten, h = .1);
                    cylinder(d = d_ten_out + 2, h = .01);
                }

                cylinder(d = d_ten_out + 3, h = h_base);
            }
        }


        hull() {
            translate([l/2, 0, 0])
                cylinder(d = d_in, h = h_base+2);

            translate([0, 0, 0])
            cylinder(d = d_in, h = h_base+2);
        }
        translate([l, 0, 0]) {
            cylinder(d = d_ten, h = h_base + 3);
            cylinder(r = screw_head_radius(TENSIONER_BB_SCREW)+.2, h = h_base-2);
            translate_z(h_base-2)
            hull() {
                translate_z(screw_socket_af(TENSIONER_BB_SCREW))
                cylinder(r = screw_radius(TENSIONER_BB_SCREW)+.2, h = .01);
                cylinder(r = screw_head_radius(TENSIONER_BB_SCREW)+.2, h = .01);
            }
        }
    }
}

module xyAxisMotor(left = false, wallThickness = 3) {
    color("silver") if(left) {
        linear_extrude(3) mirror([1,0,0])
            motorMountPlate(NEMA17M, wallThickness);
    } else {
        linear_extrude(3)
            motorMountPlate(NEMA17M, wallThickness);
    }

    rotate([0,-90,0]) motor_assembly(6, NEMA17M);
}

//
//rotate([0, 0, 90])
//    color("silver")
//        linear_extrude(3)
//            pulley_corner_plate();
//
//translate([- 30, + 10, 0])
//    corner_pulley_assembly(8.5, 25.5, 40, 3);

//pulley_spacer(8.5);


//STEEL_3mm_pulley_corner_plate_dxf();
//xyAxisMotor();


//ABS_xy_belt_tensioner_wheel_stl();
ABS_xy_belt_tensioner_stl();
