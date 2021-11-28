include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>

include <../motors.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <NopSCADlib/vitamins/rod.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/leadnuts.scad>

include <../../lib/leadscrew_couplers.scad>
include <../../lib/vslot_rails.scad>

include <../../lib/spherical_nuts.scad>

include <NopSCADlib/vitamins/pillow_blocks.scad>

include <../../lib/bearings.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>

use <y-axis.scad>

Z_AXIS_LEADNUT = LSN8x2;

function leadscrew_mount_hole(pos) = [[pos - 1.5, 10], [pos + 1.5, 10]];

Z_MOUNT_HOLES = [
        [7.2, 0, 20, - 24],
        [7.2, 0, 20, 24],

        [3.01, 0, ["square", leadscrew_mount_hole(- 24)]],
        [3.01, 0, ["square", leadscrew_mount_hole(- 12)]],
        [3.01, 0, ["square", leadscrew_mount_hole(0)]],
        [3.01, 0, ["square", leadscrew_mount_hole(12)]],
        [3.01, 0, ["square", leadscrew_mount_hole(24)]],
    //    [3, 0,["square",[[-27+1.5,0], [-21-1.5,0]]]],
    //    [3, 0,["square",[[-27+1.5,0], [-21-1.5,0]]]],
    //    [2, 0,["square",[[-27,0], [-18,0]]]],
    ];

VW_HOLES_20x3L = [
        [5, 0, - 20, 25],
        [7.2, 0, 20, 0],
        [5, 0, - 20, - 25]
    ];

Z_PLATE = [[60, 60], 5, 3, VW_HOLES_20x3L, Z_MOUNT_HOLES];

Z_GANTRY = ["", Z_PLATE, [S_XTREME_VW_SPACER,
    S_XTREME_VW_ECCENT,
    S_XTREME_VW_SPACER], 20];

VSLOT_Z_RAIL = ["", Z_GANTRY, E2020];

Z_GANTRY_GUIDE_ANGLE = 43.025;



module STEEL_gantry_sq_plate_60x60x3_22_dxf() {
    square_plate_sketch(Z_PLATE);
}

module z_gantry_plate_sketch() {

    translate([- 25 + 3, 0, 0])
        difference() {
            hull() {
                translate([22, 0])
                    square([0.1, 60], center = true);

                translate([- 23.5, 0])
                    circle(d = 25);
            }
            translate([- 23.5, 0]) {
                circle(d = 2.2);
                translate([0, - 7])
                    circle(d = 2.2);
                translate([0, 7])
                    circle(d = 2.2);
            }

            translate([5.5, 0]) {
                circle(d = leadnut_od(Z_AXIS_LEADNUT));
                for (a = [- 45:90:315])
                rotate([0, 0, a])
                    translate([leadnut_hole_pitch(Z_AXIS_LEADNUT), 0])
                        circle(d = 3.1);
            }
        }

    for (y = [- 24 : 12 : 24])
    translate([0, y])
        color("red")
            square([6, 6], center = true);
}

module z_gantry_plate_support_sketch() {
    translate([- 25 + 3, 0, 0])
        square([50, 60], center = true);
}

module STEEL_z_gantry_plate_60_dxf() {
    z_gantry_plate_sketch();
}

module z_gantry_plate(angle = 0, show_beam = false) {
    dxf("STEEL_z_gantry_plate_60");
    translate_z(- 1.5 - 10) {
        color("red")
            linear_extrude(3)
                z_gantry_plate_sketch();
        translate([- 46, 0, 3]) {
            assert(
            angle == 0 || angle == - 1 || angle == 1,
            str("angle must be either 0, 1 or -1, got ", angle));

            if (angle == 0) {
                stl("ABS_PC_z_gantry_block_center");
            } else if (angle == 1) {
                stl("ABS_PC_z_gantry_block_left");
            } else if (angle == - 1) {
                stl("ABS_PC_z_gantry_block_right");
            }

            z_gantry_block_assembly(angle * Z_GANTRY_GUIDE_ANGLE, show_beam);
        }
    }
}

module ABS_PC_z_gantry_block_center_stl() {
    $fn = 90;
    z_gantry_block(0);
}

module ABS_PC_z_gantry_block_left_stl() {
    $fn = 90;
    z_gantry_block(Z_GANTRY_GUIDE_ANGLE);
}

module ABS_PC_z_gantry_block_right_stl() {
    $fn = 90;
    z_gantry_block(- Z_GANTRY_GUIDE_ANGLE);
}

module z_gantry_block(angle = 0) {
    block_h = 8;
    block_w = 20;
    block_w_i = 8;
    translate_z(block_h / 2)
    difference() {
        hull() {
            translate([- 2, 0, 0])
                cylinder(d = block_w, h = block_h, center = true);
            translate([27, 0, 0])
                cube([.1, block_w + 5, block_h], center = true);
        }

        rotate([0, 0, angle])
            translate([- 1, 0, - block_h / 2])
                {
                    translate([0, 3.8, 5 + 1])
                        vtulka(22);
                    translate([0, - 3.8, 5 + 1])
                        vtulka(22);
                }

        translate([0, 0, 3])
            rotate([0, 0, angle])
                cube([16, block_w_i + 1, 3], center = true);

        translate([0, 0, 2])
            rotate([0, 0, angle])
                color("blue")
                    hull() {
                        translate([- 8, 0, 0])
                            cube([.1, block_w_i, block_h], center = true);

                        translate([8, 0, 0])
                            cube([.1, block_w_i, block_h], center = true);

                    }

        // center point mount
        translate_z(- 4){
            cylinder(d = 3, h = 0.35 * 2, center = true);
            hull() {
                cylinder(d = 3, h = 0.01, center = true);
                translate_z(1.65 + 1)
                cylinder(d = 6, h = 2, center = true);
            }
        }

        translate([29.5, 0, 0]) {
            cylinder(d = leadnut_od(Z_AXIS_LEADNUT), h = 100, center = true);
            for (a = [- 45:90:315])
            rotate([0, 0, a])
                translate([leadnut_hole_pitch(Z_AXIS_LEADNUT), 0])
                    cylinder(d = 3, h = 100, center = true);
        }
    }

}

module vtulka(l = 20) {
    rotate([0, 90, 0])
        color("silver")
            cylinder(d = 2, h = l, center = true);
}

module z_gantry_block_assembly(angle = 0, show_beam = false) {
    z_gantry_block(angle);
    // nut
    rotate([0, 0, angle]) {
        translate([0, 0, 16.05])
            rotate([180, 0, 0])
                spherical_nut_DIN_1587(NUT_DIN_1587_M5);

        //
        translate([0, 3.8, 5 + 1])
            vtulka();
        translate([0, - 3.8, 5 + 1])
            vtulka();
        //magnets
        color("gray") {
            translate([4, 0, 2])
                cylinder(d = 8, h = 3);
            translate([- 4, 0, 2])
                cylinder(d = 8, h = 3);
        }
        if (show_beam)
            rotate([0, - 90, 0])
                cylinder(d = 1, h = 600);
    }

}

Z_TABLE_MOUNTS_HEIGTH = 40;
Z_COUPLER_HEIGHT = 50;
function safeMarginZAxis() = Z_COUPLER_HEIGHT;
function realZAxisLength(length) = length + Z_TABLE_MOUNTS_HEIGTH + safeMarginZAxis() - 30;

module zAxisRails(
position = 0,
length,
mirrored = false,
diff = false,
angle = 0
) {
    realZAxisLength = realZAxisLength(length);

    if (!diff) {
        translate([0, 0, realZAxisLength + $CASE_MATERIAL_THICKNESS + 20])
            rotate([0, 180, -90]) {
                vslot_rail(
                VSLOT_Z_RAIL,
                realZAxisLength,
                pos = position,
                mirror = true,
                safe_margin = safeMarginZAxis()
                )   {
                    let();
                    depth = 60;
                    difference() {
                        translate([0, 0, 1.5]) rotate([180, 90, 90]) z_gantry_plate(angle, false);
//                        translate([0, - 10, 17]) rotate([0, - 90, 90]) drill(5, h = 40);
                    }
                    translate([0, 15, 18])
                        rotate([90, - 0, 0])
                            leadnut(Z_AXIS_LEADNUT);
                }
            }

        translate([0,30,length + 70])
        rotate([0, 0, 90])
            color("blue")
                pillow_block();
    }

    translate([0, 0, - 23])
        zAxisMotor(motorModel = NEMA17, leadscrew_length = length + 50, diff = diff);
}

module zAxis(positionZ, lengthZ, lengthX, lengthY, diff = false) {
    outerXAxisWidth = outerXAxisWidth(lengthX)-20;
    outerYAxisWidth = realYAxisLength(lengthY)+20;

    translate([0, -outerYAxisWidth/2, 0])
        zAxisRails(positionZ, length = lengthZ, mirrored = true, diff = diff, angle = 0);

    translate([- lengthX / 2 + $Z_AXIS_OFFSET, outerYAxisWidth/2, 0]) {
        mirror([0, 1, 0])
            zAxisRails(positionZ, length = lengthZ, diff = diff, angle = - 1);

    }

    translate([lengthX / 2 - $Z_AXIS_OFFSET, outerYAxisWidth/2, 0]) {
        mirror([0, 1, 0])
            zAxisRails(positionZ, length = lengthZ, diff = diff, angle = 1);
    }

    translate([0, 0, positionZ + safeMarginZAxis() + $CASE_MATERIAL_THICKNESS + 20 + 6])
        children();
}


module zAxisMotor(
    motorTranslation = 0,
    motorModel,
    leadscrew_length,
    diff = false) {
    motorScrewY = $CASE_MATERIAL_THICKNESS + 3;

    differ = motorTranslation < 0 ? 4 : 1;

    translate([
        0, NEMA_width(motorModel) / 2 + 10,
            NEMA_length(motorModel) / 2
        ]) {
        rotate([0, - 90, 0])
            motor(motorScrewY, motorModel, diff);

        translate_z(4)
        z_motor_thurst_bearing_collet_assembly();

        translate([0, 0, leadscrew_length/2+30])
            leadscrew(
            8,
            leadscrew_length,
            8,
            2,
            center = true
            );
    }
}

module ABS_PC_z_motor_thurst_bearing_collet_type_51101_stl() {
    $fn = 180;
    z_motor_thurst_bearing_collet(BB51101, NEMA17S);
}

module z_motor_thurst_bearing_collet(bearing_type, motor_type) {
    stl(str("ABS_PC_z_motor_thurst_bearing_collet_type_", bearing_type[0]));

    difference() {
        linear_extrude(3)
            NEMA_outline(motor_type);
        translate_z(- .1)
        cylinder(d = 6, h = 6);
        translate_z(- 1)
        cylinder(d = bb_diameter(bearing_type), h = 6);

        translate_z(- 1)
        NEMA_screw_positions(motor_type)
        cylinder(d = 3, h = 6);
    }
}

module z_motor_thurst_bearing_collet_assembly(type = BB51101) {
    translate_z(4.5)
    ball_bearing(type);
    z_motor_thurst_bearing_collet(type, NEMA17S);
}

module pillow_block_stl() {
    $fn = 180;
    pillow_block();
}

module pillow_block() {
    //    translate([-20.35 - 10,0,0])
    //    extrusion(E2020, 100);


    translate([- 20.35, 0, 0])
        linear_extrude(10) {
            translate([- 1.5, 0])
                square([3, 5.5], center = true);
        }

    stl("pillow_block");

    translate([- 18.35, 0, 0]) {
        rounded_cube_yz([4, 20, 10], r = 1, xy_center = true, z_center = false);
        translate_z(8) difference() {
            rounded_cube_yz([4, 12, 22], r = 1, xy_center = true, z_center = false);
            translate_z(16)
            rotate([0, 90, 0])
                cylinder(d = 5.2, h = 100, center = true);
        }
    }



    difference() {
        union() {
            translate([- 10, 0, 5])
                cube([14, 8, 10], center = true);
            cylinder(d = 15, h = 10);
        }
        translate_z(- .1)
        cylinder(d = 9.5, h = 10.2);
    }
}

//pillow_block_stl();
//
//CASE_MATERIAL_THICKNESS = 4;
//zAxis(300, lengthZ = 300, lengthX = 300, lengthY = 300);


//ABS_PC_z_motor_thurst_bearing_collet_type_51101_stl();
//z_gantry_plate();
//ABS_PC_z_gantry_block_center_stl();
//ABS_PC_z_gantry_block_left_stl();
//ABS_PC_z_gantry_block_right_stl();
//STEEL_gantry_sq_plate_60x60x3_22_dxf();
//STEEL_z_gantry_plate_60_dxf();
