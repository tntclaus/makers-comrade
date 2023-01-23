include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/leadnuts.scad>

use <NopSCADlib/utils/rounded_polygon.scad>



SFU1605 = ["SFU1610", "Leadscrew nut for SFU1605", 16, 28, 42.5, 48, 10, 0, 6, 6, 38 / 2, M6_cap_screw, 5, 5, 40,
    "#DFDAC5"];


PROMPROF_V2020 = ["020.020.06-С", 20, 20, 4.2, 3, 8, 6, 12.0, 2, 2, 1];
PROMPROF_V2040 = ["020.040.06-С", 20, 40, 4.2, 3, 8, 6, 12.0, 2, 2, 1];
PROMPROF_V20_4040 = ["040.040.06-С", 20, 20, 4.2, 3, 8, 6, 12.0, 2, 2, 1];

FRAME_TYPE = PROMPROF_V2020;
FRAME_TYPE_D = PROMPROF_V2040;
FRAME_TYPE_X = PROMPROF_V20_4040;

MATERIAL_THICKNESS = 5;

WIDTH = 400;
DEPTH = 650;
HEIGTH = 170;

/**
*  Размер крепежной закладной полосы ШхВ: 10.5х1.5
*/

module vslot_mount_line_sketch(length, mounts) {
    difference() {
        rounded_square([10.5, length], r = 1, center = true);
        for(mount = mounts)
        translate([0, mount])
            circle(r = screw_pilot_hole(M5_cs_cap_screw));
    }
}
module vslot_mount_line(name, length, mounts) {
    dxf(str("STEEL_1_5mm_vslot_mount_", name, "_", length, "mm"));

    color("teal")
    linear_extrude(1.5)
    vslot_mount_line_sketch(length, mounts);

    for(mount = mounts)
    translate([0, mount, 6])
        screw(M5_cap_screw, 8);
}


/**
* SPINDLE
* https://aliexpress.ru/item/4001266416766.html?_ga=2.40636514.1117746723.1664970575-1492022082.1663164478&item_id=4001266416766&sku_id=12000028091795292&spm=a2g2w.orderdetails.0.0.729c4aa6wgcC3R
*/
SPINDLE_SCREW = M6_cs_cap_screw;
SPINDLE_BOSS_D = 52;

function SPINDLE_MOUNTS(x = 70 / 2, y = 20 / 2) = [
        [x, y, 0],
        [x, - y, 0],
        [- x, - y, 0],
        [- x, y, 0]
    ];


Z_LEADSCREW_SCREW = M5_cs_cap_screw;

function Z_LEADSCREW_MOUNTS(x = 40 / 2, y = 24 / 2) = [
        [x, y, 0],
        [x, - y, 0],
        [- x, - y, 0],
        [- x, y, 0]
    ];

module place_spindle_screws() {
    for (loc = SPINDLE_MOUNTS())
    translate(loc)
        children();
}

module spindle_mount() {
    vitamin("52mm_spindle_mount");
    color("silver")
    difference() {
        union() {
            translate_z(54 / 2)
            cube([90, 40, 54], center = true);
            hull() {
                translate_z(54 / 2)
                cube([55, 40, 54], center = true);
                translate_z(68 / 2)
                cube([27, 40, 68], center = true);
            }
        }

        translate([0,-30,52/2+8])
        cube([300,300,3]);

        place_spindle_screws()
        cylinder(d = 6.5, h = 200, center = true);

        translate_z(52/2+8)
        rotate([90,0,0])
        cylinder(d = 52, h = 200, center = true);
    }
}



/**
* FRAME
*/


module extrusion_2x2(type, length, center = true, cornerHole = false) {//! Draw the specified extrusion

    vitamin(str("extrusion(", type[0], ", ", length, arg(cornerHole, false, "cornerHole"), "): Extrusion ", type[0],
    " x ", length, "mm"));
    w = type[1] / 2;
    l = type[2] / 2;
    color(grey(90))
        linear_extrude(length, center = center) {
            translate([w, l])
                extrusion_cross_section(type, cornerHole);
            translate([w, - l])
                extrusion_cross_section(type, cornerHole);
            translate([- w, l])
                extrusion_cross_section(type, cornerHole);
            translate([- w, - l])
                extrusion_cross_section(type, cornerHole);
        }
}

module STEEL_5mm_axis_y_vertical_plate_dxf() {
    axis_y_vertical_plate();
}

module axis_y_vertical_plate() {
    name = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_y_vertical_plate");
    dxf(name);

    difference() {
        square([30 + 40 + 20, 40], center = true);
        translate([35, 10])
            circle(d = 5);
        translate([35, - 10])
            circle(d = 5);

        translate([- 35, 10])
            circle(d = 5);
        translate([- 35, - 10])
            circle(d = 5);

        translate([- 15, 10])
            circle(d = 5);
        translate([- 15, - 10])
            circle(d = 5);
    }
}

module axis_x_caret() {

}

module STEEL_5mm_axis_y_front_plate_dxf() {
    axis_y_front_plate_sketch();
}

module axis_y_front_plate() {
    dxf(str("STEEL_", MATERIAL_THICKNESS, "mm_axis_y_front_plate"));

    linear_extrude(MATERIAL_THICKNESS)
        axis_y_front_plate_sketch();
}
module axis_y_front_plate_sketch() {
    difference() {
        rounded_polygon([
                [1, - 9, 1],
                [1, 9, 1],
                [40, 79, 1],
                [40, 89, 1],
                [59, 89, 1],
                [59, 79, 1],
                [79, 9, 1],
                [79, - 9, 1]
            ]);

        for (i = [0:3])
        translate([10 + 20 * i, 0])
            circle(d = 5);

        translate([50, 50])
            circle(d = 5);
        translate([50, 70])
            circle(d = 5);

        translate([50, 77]) hull() {
            translate([- 2.5, 0])
                circle(d = 2);
            translate([2.5, 0])
                circle(d = 2);
        }
    }
}

TOTAL_DEPTH = DEPTH+80;
VERTICAL_PLATE_SPACING = 200;

VERTICAL_PLATE_LOCATIONS = [VERTICAL_PLATE_SPACING : VERTICAL_PLATE_SPACING : TOTAL_DEPTH - VERTICAL_PLATE_SPACING];
VERTICAL_PLATE_COORDS = concat(
    [for(y = VERTICAL_PLATE_LOCATIONS) y - (TOTAL_DEPTH - VERTICAL_PLATE_SPACING / 2) / 2 - 10],
    [for(y = VERTICAL_PLATE_LOCATIONS) y - (TOTAL_DEPTH - VERTICAL_PLATE_SPACING / 2) / 2 + 10]
);

FRONT_VSLOT_MOUNT_COORDS = [-WIDTH/2+10, -WIDTH/2+30, WIDTH/2-10, WIDTH/2-30];

module axis_y_vslot_mount_line() {
    rotate([0, - 90, 0])
        vslot_mount_line("axis_y_vslot_mount", TOTAL_DEPTH, VERTICAL_PLATE_COORDS);
}

module STEEL_1_5mm_vslot_mount_axis_y_vslot_mount_730mm_dxf() {
    vslot_mount_line_sketch(TOTAL_DEPTH, VERTICAL_PLATE_COORDS);
}

module axis_y_vslot_front_mount_line() {
    rotate([0,90,90])
    vslot_mount_line("axis_y_vslot_front_mount", WIDTH, FRONT_VSLOT_MOUNT_COORDS);
}

module STEEL_1_5mm_vslot_mount_axis_y_vslot_front_mount_400mm_dxf() {
    vslot_mount_line_sketch(WIDTH, FRONT_VSLOT_MOUNT_COORDS);
}

module axis_y(pos = 0, is_mirror = false) {
    size = DEPTH;
    depth = TOTAL_DEPTH;
    dx = FRAME_TYPE[1] / 2;


    module vertical_plate() {
        translate([0, 0, 35])
            rotate([0, 90, 0])
                translate_z(- MATERIAL_THICKNESS)
                color("silver")
                    linear_extrude(MATERIAL_THICKNESS)
                        axis_y_vertical_plate();
    }


    module front_plate() {
        translate([- dx * 4, depth / 2 + MATERIAL_THICKNESS]) {
            rotate([90, 0, 0])
                axis_y_front_plate();


            if(!is_mirror) {
                translate([dx*4-WIDTH/2, -7, 0])
                axis_y_vslot_front_mount_line();
            }

        }
    }


    translate([2,0,0]) {
        axis_y_vslot_mount_line();

        translate_z(50)
        axis_y_vslot_mount_line();

        translate_z(70)
        axis_y_vslot_mount_line();
    }

    for (y = VERTICAL_PLATE_LOCATIONS) {
        translate([0, y - (depth - VERTICAL_PLATE_SPACING / 2) / 2, 0])
            vertical_plate();
    }

    front_plate();
    mirror([0, 1, 0])
        front_plate();


    translate([dx * 2, 0, 0])
        rotate([90, 0, 0])
            rotate([0, 0, 90])
                extrusion(FRAME_TYPE_D, depth, center = true);

    translate([dx, 0, 30 + 30])
        rotate([90, 0, 0])
            extrusion(FRAME_TYPE_D, depth, center = true);
}

// ********************************* Z

BK12M_SCREWS = M5_cs_cap_screw;

module place_block_BF12() {
    translate([0,30-X_GANTRY_ELEVATION,0])
        children();
}

module place_block_BK12() {
    translate([0,-X_GANTRY_HEIGTH+50-X_GANTRY_ELEVATION,0])
        children();
}

module place_block_BK12_mounts() {
    x = 46/2;
    y = 0;
    for(lx = [-1,1])
    for(ly = [-1,1])
    translate([x*lx, y*ly])
        children();
}

module block_BK12() {
    vitamin("block_BK12");
    color("#404040")
    difference() {
        translate_z(43/2)
        cube([60,20,43], center = true);
        translate_z(25)
        rotate([90,0,0])
            cylinder(d = 12, h = 100, center = true);

        place_block_BK12_mounts()
            cylinder(d = 5, h = 100, center = true);
    }
}

module place_block_BF12_mounts() {
    x = 46/2;
    y = 13/2;
    for(lx = [-1,1])
        for(ly = [-1,1])
            translate([x*lx, y*ly])
                children();
}

module block_BF12() {
    vitamin("block_BF12");
    color("#404040")
    difference() {
        translate_z(43/2)
        cube([60,25,43], center = true);

        translate_z(25)
        rotate([90,0,0])
            cylinder(d = 12, h = 100, center = true);

        place_block_BF12_mounts()
            cylinder(d = 5, h = 100, center = true);
    }
}

module STEEL_5mm_axis_z_gantry_dxf() {
    polygon_plate_sketch(Z_PLATE);
//    function wheelHoles(w = 100+v_wheel_dia2(D_STEEL_ZZ[3])) = [
//            [1, 0, w / 2, - 17],
//            [1, 0, - w / 2, - 17],
//            [1, 0, - w / 2, 17 - Z_GANTRY_HEIGTH],
//            [1, 0, w / 2, 17 - Z_GANTRY_HEIGTH],
//        ];
//    drillHoles(wheelHoles(), 0);
}

module axis_z(heigth, pos = 0) {
    //    extrusion(FRAME_TYPE, heigth, center = true);
    translate([0,-10,0])
    leadnut(SFU1605);
//    place_spindle_screws()
    name = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_z_gantry");
    dxf(name);

    translate([0, 14.5, 0])
        rotate([0, 0, 90])
            vwheel_gantry(Z_GANTRY) {
                union() {
                }


//                translate([0,-30,0])
//                spindle_mount();
            }

    //    leadscrew(LSN8x2);
}



// ********************************** X
use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <../lib/vwheel_assemblies.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

//include <gears/belt_pulleys.scad>



/**
* X GANTRY
*/
X_GANTRY_ELEVATION = 30;
X_GANTRY_WIDTH = 100;
X_GANTRY_HEIGTH = 200;
Z_GANTRY_WIDTH = 80;

function X_PLATE_GEOM(h = X_GANTRY_HEIGTH, w = X_GANTRY_WIDTH, wr = 20, r = 1, offs = X_GANTRY_ELEVATION) = [
        [- 0 + r - offs, - w / 2 + r, r],
        [- 0 + r - offs, - (w / 2 - 20) + r, r],
        [20 + r - offs, 0, - 10],
        [- 0 + r - offs, (w / 2 - 20) + r, r],
        [- 0 + r - offs, w / 2 + r, r],
        [h + r - offs, w / 2 + r, r],
        [h + r - offs, - w / 2 + r, r],
        [70 + r - offs, - w / 2 + r, r],
    ];

function X_PLATE_FRONT_GEOM(h = X_GANTRY_HEIGTH, w = X_GANTRY_WIDTH, wr = 20, r = 1, offs = X_GANTRY_ELEVATION) = [
        [- 0 + r - offs, - w / 2 + r, r],
        [- 0 + r - offs, - (w / 2 - 20) + r, r],
        [- 0 + r - offs, (w / 2 - 20) + r, r],
        [- 0 + r - offs, w / 2 + r, r],
        [h + r - offs, w / 2 + r, r],
        [h + r - offs, - w / 2 + r, r],
        [70 + r - offs, - w / 2 + r, r],
    ];

function X_VW_HOLES(w = X_GANTRY_WIDTH, h = X_GANTRY_HEIGTH) = [
        [5.01, 0, - 10 - w / 2 + 20, - 80],
        [5.01, 0, 68 - w / 2 + 20, - 80],
        [5.01, 0, 28 - w / 2 + 20, - 80],
        [7.21, 0, 68 - w / 2 + 20, - 140],
        [7.21, 0, - 10 - w / 2 + 20, - 140],
    ];

function X_MOUNTS(w = X_GANTRY_WIDTH, l = 20 / 2-X_GANTRY_ELEVATION) = [
        [5.05, 0, ["circle", [[23 - w / 2 + 20, - 80], [33 - w / 2 + 20, - 80]]]],
        [5.05, 0, 10 - w / 2 + 20, l],
        [5.05, 0, - 10 - w / 2 + 20, l],
        [5.05, 0, - 10 - w / 2 + 20, - l],
        [5.05, 0, 10 + w / 2 - 20, - l],
    ];

function X_VW_HOLES_FRONT(w = X_GANTRY_WIDTH) = [
        [4.11, 0, - 10 - w / 2 + 20, - 80],
        [4.11, 0, 68 - w / 2 + 20, - 80],
        [7.21, 0, 68 - w / 2 + 20, - 140],
        [7.21, 0, - 10 - w / 2 + 20, - 140],
    ];


function X_MOUNTS_FRONT(w = X_GANTRY_WIDTH, l = 20 / 2-X_GANTRY_ELEVATION) = [
        [5.05, 0, - Z_GANTRY_WIDTH / 2, - 30],
        [5.05, 0, Z_GANTRY_WIDTH / 2, - 30],
        [5.05, 0, - Z_GANTRY_WIDTH / 2, - 160],
        [5.05, 0, Z_GANTRY_WIDTH / 2, - 160],
    ];

X_PLATE = [X_PLATE_GEOM(h = X_GANTRY_HEIGTH-50+X_GANTRY_ELEVATION), 5, MATERIAL_THICKNESS, X_VW_HOLES(), X_MOUNTS()];
X_PLATE_FRONT = [X_PLATE_FRONT_GEOM(), 5, MATERIAL_THICKNESS, X_VW_HOLES_FRONT(), X_MOUNTS_FRONT()];

X_GANTRY = ["", X_PLATE,
        [S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

X_GANTRY_FRONT = ["", X_PLATE_FRONT,
        [S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

/**
* Y GANTRY
*/
Y_GANTRY_H = 20;

function Y_PLATE_GEOM(wr = Y_GANTRY_H) = [
        [- (wr - 1), - 19, 1],
        [- (wr - 1), 19, 1],
        [70, 140, 1],
        [145, 140, 1],

        [145, 110, 1],
        [115, 100, - 1],

        [115, 10, - 1],
        [145, 0, 1],


        [145, - 19, 1],
        [70, - 19, 1],
    ];

Y_VW_HOLES = [
        [5.01, 0, - 10, - 80],
        [5.01, 0, 125, - 80],
        [5.01, 0, 28, - 80],
        [7.21, 0, 125, - 140],
        [7.21, 0, - 10, - 140],
    ];

function Y_MOUNTS(w = 20 / 2, l = 20 / 2) = [
        [5.05, 0, ["circle", [[23, - 80], [33, - 80]]]],
        [2.05, 0, ["circle", [[-7, 17], [-13, 17]]]],
        [5.05, 0, w, l],
        [5.05, 0, w, - l],
        [5.05, 0, - w, l],
        [5.05, 0, - w, - l],
    ];

Y_PLATE = [Y_PLATE_GEOM(), 5, MATERIAL_THICKNESS, Y_VW_HOLES, Y_MOUNTS()];

Y_GANTRY = ["", Y_PLATE,
        [S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

Y_MOTOR_POSITION = [20, - 53];
Y_MOTOR = NEMA17;
X_MOTOR_POSITION = [- 20, - 53];
X_MOTOR = NEMA17;
Z_MOTOR = NEMA17P;

/**
* Z GANtRY
*/
Z_GANTRY_HEIGTH = 60;

function Z_PLATE_GEOM(h = Z_GANTRY_HEIGTH, w = Z_GANTRY_WIDTH + 60, wr = 20, r = 1) = [
        [- 0 + r, - w / 2 + r, r],
        [- 0 + r, w / 2 + r, r],
        [h + r, w / 2 + r, r],
        [h + r, - w / 2 + r, r],
    ];

function Z_VW_HOLES(w = 100+v_wheel_dia2(D_STEEL_ZZ[3])) = [
        [7.21, 0, w / 2, - 10],
        [5.01, 0, - w / 2, - 10],
        [5.01, 0, - w / 2, 10 - Z_GANTRY_HEIGTH],
        [7.21, 0, w / 2, 10 - Z_GANTRY_HEIGTH],
    ];

Z_SPINDLE_MOUNTS = [for(l = SPINDLE_MOUNTS()) [screw_pilot_hole(SPINDLE_SCREW)*2, 0, l.x, l.y-30]];
Z_PLATE_LEADSCREW_MOUNTS = [for(l = Z_LEADSCREW_MOUNTS()) [screw_radius(Z_LEADSCREW_SCREW)*2, 0, l.x, l.y-30]];

function Z_MOUNTS(l = 20 / 2) = concat(
        Z_VW_HOLES(),
        Z_SPINDLE_MOUNTS,
        Z_PLATE_LEADSCREW_MOUNTS
    );


Z_PLATE = [Z_PLATE_GEOM(), 5, MATERIAL_THICKNESS, Z_VW_HOLES(), Z_MOUNTS()];

Z_WHEEL_SPACER = ["", 6, false, D_STEEL_2RS, M5_dome_screw, false, MATERIAL_THICKNESS];
Z_WHEEL_ECCENTRIC = ["", 6, true, D_STEEL_2RS, M5_dome_screw, false, MATERIAL_THICKNESS];


Z_GANTRY = ["", Z_PLATE,
        [
        Z_WHEEL_ECCENTRIC,
        Z_WHEEL_SPACER,
        Z_WHEEL_SPACER,
        Z_WHEEL_ECCENTRIC,
        ], 40];

/**
* Other stuff
*/

module STEEL_5mm_axis_y_motor_plate_dxf() {
    axis_y_motor_plate_sketch()
    translate(X_MOTOR_POSITION) {
        circle(d = NEMA_boss_radius(X_MOTOR) * 2);
        NEMA_screw_positions(X_MOTOR)
        circle(d = 3.1);
    };
}

module axis_y_motor_plate_sketch() {
    polygon_plate_sketch(Y_PLATE)
    translate(Y_MOTOR_POSITION) {
        circle(d = NEMA_boss_radius(X_MOTOR) * 2);
        NEMA_screw_positions(X_MOTOR)
        circle(d = 3.1);
    }
}

module axis_y_motor_plate() {
    name = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_y_motor_plate");
    dxf(name);
    difference() {
        vwheel_gantry(Y_GANTRY) {
            translate(Y_MOTOR_POSITION) {
                circle(d = NEMA_boss_radius(Y_MOTOR) * 2);
                NEMA_screw_positions(Y_MOTOR)
                circle(d = 3.1);
            }

            mirror([0, 0, 1])
                translate([Y_MOTOR_POSITION.x, Y_MOTOR_POSITION.y, 0]) {
                    NEMA(Y_MOTOR);
                    translate_z(3)
                    NEMA_screws(Y_MOTOR, M3_dome_screw);
                }
        };
    }
}

X_PIVOT_AXIS_POSITION = [0, - X_GANTRY_HEIGTH / 2 + 10, 0];
X_PIVOT_MOTOR_POSITION = [- X_GANTRY_WIDTH / 2 + 20, - 40, 0];

module STEEL_5mm_axis_x_motor_plate_dxf() {
    polygon_plate_sketch(X_PLATE)
    translate(X_MOTOR_POSITION) {
        circle(d = NEMA_boss_radius(X_MOTOR) * 2);
        NEMA_screw_positions(X_MOTOR)
        circle(d = 3.1);
    };
}
module STEEL_5mm_axis_x_motor_plate_front_dxf() {
    polygon_plate_sketch(X_PLATE_FRONT)
    translate([0,X_GANTRY_ELEVATION-10,0])
        union() {
            place_block_BF12()
            place_block_BF12_mounts()
            circle(r = screw_pilot_hole(BK12M_SCREWS));

            place_block_BK12()
            place_block_BK12_mounts()
            circle(r = screw_pilot_hole(BK12M_SCREWS));
        };
}

use <../lib/gears.scad>


module gear_with_mounts(modul, tooth_number, width, bore) {
    module gear_mount() {
        rotate([90,0,0]) {
            cylinder(d = 3, h = 40);
            cylinder(d = 7.6, h = bore, $fn = 6);
        }
    }
    difference() {
        spur_gear(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, optimized = true);
        translate_z(width/2) {
            for(y = [0, 72*2])
            rotate([0, 0, 17.5 + y])
                gear_mount();
        }
    }
}

module gear_with_latch(modul, tooth_number, width, bore) {
    spur_gear(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, optimized = true);
    translate([0,width/2-bore/2,width/2])
    cube([bore,bore/3,width], center = true);
}

module axis_x_plate_motor_plate() {

    module place_extrusion() {
        translate([- 40, - 10+X_GANTRY_ELEVATION, - 43 / 2 - MATERIAL_THICKNESS])
            rotate([0, 0, 90])
                extrusion(E2020, 40 + 3);
    }

    offs = 21.5 + MATERIAL_THICKNESS;
    name = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_x_motor_plate_front");
    dxf(name);

    translate([offs, 0, 0])
        mirror([0, 1, 0])
            vwheel_gantry(X_GANTRY_FRONT) {
                translate([0,X_GANTRY_ELEVATION-10,0])
                union() {
                    place_block_BF12()
                    place_block_BF12_mounts()
                    circle(r = screw_pilot_hole(BK12M_SCREWS));

                    place_block_BK12()
                    place_block_BK12_mounts()
                    circle(r = screw_pilot_hole(BK12M_SCREWS));
                }


                place_extrusion();
                mirror([1, 0, 0])
                    place_extrusion();

                translate([0, X_GANTRY_ELEVATION, - NEMA_width(Z_MOTOR) / 2])
                    translate_z(- MATERIAL_THICKNESS)
                    rotate([- 90, 0, 0])
                        NEMA(Z_MOTOR);

                translate([0,X_GANTRY_ELEVATION-10,0]) {
                    place_block_BF12()
                    block_BF12();

                    place_block_BK12()
                    block_BK12();



                    color("gray")
                    translate([0,30,25])
                        rotate([90,0,0])
                            gear_with_mounts(2, 39, 10, 10);



                    color("green")
                    translate([0,30,-26.5])
                    rotate([0,9,0])
                        rotate([90,0,0])
                            gear_with_latch(2, 12, 10, 5);
                }
            };


    for (i = [- 1, 1])
    translate([offs + 20, i * Z_GANTRY_WIDTH / 2, - X_GANTRY_HEIGTH / 2+X_GANTRY_ELEVATION])
        rotate([0,0,90])
        extrusion(E2040, X_GANTRY_HEIGTH, center = true);

    name_motor_plate = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_x_motor_plate");
    dxf(name_motor_plate);
    translate([- offs, 0, 0])
        rotate([0, 0, 180])
            difference() {
                vwheel_gantry(X_GANTRY) {
                    translate(X_MOTOR_POSITION) {
                        circle(d = NEMA_boss_radius(X_MOTOR) * 2);
                        NEMA_screw_positions(X_MOTOR)
                        circle(d = 3.1);
                    }

                    mirror([0, 0, 1])
                        translate([X_MOTOR_POSITION.x, Y_MOTOR_POSITION.y, 0]) {
                            NEMA(X_MOTOR);
                            translate_z(3)
                            NEMA_screws(X_MOTOR, M3_dome_screw);
                        }
                };
            }

    translate_z(X_GANTRY_ELEVATION)
    axis_z_plate_motor_plate();
}

module axis_z_plate_motor_plate_place_holes() {
    x = X_GANTRY_WIDTH/2-10;

    for(y = [10, -10])
        for(xl = [-1,1])
            translate([y, x*xl])
                children();
}

axis_z_plate_motor_plate_vslot_mount_holes = [10, -10];

module STEEL_1_5mm_vslot_mount_axis_z_plate_motor_plate_43mm_dxf() {
    vslot_mount_line_sketch(43, axis_z_plate_motor_plate_vslot_mount_holes);
}

module axis_z_plate_motor_plate_vslot_mount() {
    vslot_mount_line("axis_z_plate_motor_plate", 43, axis_z_plate_motor_plate_vslot_mount_holes);
}

module axis_z_plate_motor_plate_sketch() {

    module place_holes() {
        x = X_GANTRY_WIDTH/2-10;
        for(y = [31.5 + MATERIAL_THICKNESS, 51.5 + MATERIAL_THICKNESS])
            for(xl = [-1,1])
        translate([y, x*xl])
            children();

    }

    difference() {
        union() {
            rounded_square([40 + 3 + MATERIAL_THICKNESS * 2, X_GANTRY_WIDTH], r = 1, center = true);
            translate([20,-(X_GANTRY_WIDTH/2-10),0])
            rounded_square([80 + 3 + MATERIAL_THICKNESS * 2, 20], r = 1, center = true);
            translate([20, X_GANTRY_WIDTH/2-10,0])
            rounded_square([80 + 3 + MATERIAL_THICKNESS * 2, 20], r = 1, center = true);
        }

        circle(d = NEMA_boss_radius(Z_MOTOR) * 2);
        NEMA_screw_positions(Z_MOTOR)
        circle(d = 3.1);

        place_holes()
            circle(d = 5.1);

        axis_z_plate_motor_plate_place_holes()
            circle(d = 5.1);
    }
}

module STEEL_5mm_axis_z_motor_plate_dxf() {
    axis_z_plate_motor_plate_sketch();
}

module axis_z_plate_motor_plate() {
    name = str("STEEL_",MATERIAL_THICKNESS,"mm_axis_z_motor_plate");
    dxf(name);

    linear_extrude(MATERIAL_THICKNESS)
        axis_z_plate_motor_plate_sketch();

    translate_z(MATERIAL_THICKNESS)
    NEMA_screws(Z_MOTOR, M3_dome_screw);


    x = X_GANTRY_WIDTH/2-10;
    for(xl = [-1,1])
    translate([0, x*xl,-3])
    rotate([0,0,90])
    axis_z_plate_motor_plate_vslot_mount();
}


module axis_x(width, pos = 0) {
    dx = FRAME_TYPE[1] / 2;
    full_width = width + dx * 4 + MATERIAL_THICKNESS;

    module y_motor_plate() {
        translate([- (full_width / 2 + MATERIAL_THICKNESS), 0, 0])
            mirror([1, 0, 0])
                axis_y_motor_plate();
    }

    y_motor_plate();

    mirror([1, 0, 0])
        y_motor_plate();

    rotate([0, 90, 0])
        extrusion_2x2(FRAME_TYPE_X, full_width, center = true);

    translate([0, 0, 110])
        rotate([0, 0, 90])
            axis_x_plate_motor_plate();

}

module axis_y_assembly() {
    assembly("axis_y") {
        translate([WIDTH / 2, 0, 0])
            axis_y();
        mirror([1, 0, 0])
            translate([WIDTH / 2, 0, 0])
                axis_y(is_mirror = true);

        for (i = [- 1, 1]) {
            translate([0, i * (DEPTH + 40) / 2, 0]) {
                rotate([0, 90, 0])
                    extrusion(FRAME_TYPE_D, WIDTH, center = true);
            }
        }
    }
}

module cnc_router_assembly() {
    assembly("cnc_router") {
        axis_y_assembly();

        translate_z(HEIGTH)
        axis_x(width = WIDTH);

        translate([0, 48.5 + MATERIAL_THICKNESS * 2, HEIGTH + 147 - 40])
            axis_z(heigth = HEIGTH);
    }
}

//if ($preview)
//    cnc_router_assembly();
//
//
//module main_assembly() {
//    cnc_router_assembly();
//}
//gear_with_mounts(2, 32, 10, 10);

//gear_with_latch(2, 20, 10, 5);

translate([-60,0,0])
gear_with_mounts(2, 39, 10, 10);
gear_with_latch(2, 12, 10, 5);

//translate([0,100,277])    b
//color("blue")
//rotate([90,0,180])
//import("../dxfs/STEEL_5mm_axis_z_gantry.dxf");
