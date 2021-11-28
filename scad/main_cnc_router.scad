include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>


use <NopSCADlib/utils/rounded_polygon.scad>


module extrusion_2x2(type, length, center = true, cornerHole = false) { //! Draw the specified extrusion

    vitamin(str("extrusion(", type[0], ", ", length, arg(cornerHole, false, "cornerHole"), "): Extrusion ", type[0], " x ", length, "mm"));
    w = type[1]/2;
    l = type[2]/2;
    color(grey(90))
        linear_extrude(length, center = center) {
            translate([w,l])
                extrusion_cross_section(type, cornerHole);
            translate([w,-l])
                extrusion_cross_section(type, cornerHole);
            translate([-w,l])
                extrusion_cross_section(type, cornerHole);
            translate([-w,-l])
                extrusion_cross_section(type, cornerHole);
        }
}

PROMPROF_V2020  = [ "020.020.06-С",              20, 20,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];
PROMPROF_V2040  = [ "020.040.06-С",              20, 40,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];
PROMPROF_V20_4040  = [ "040.040.06-С", 20, 20,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];

FRAME_TYPE = PROMPROF_V2020;
FRAME_TYPE_D = PROMPROF_V2040;
FRAME_TYPE_X = PROMPROF_V20_4040;

module STEEL_3mm_axis_y_vertical_plate_dxf() {
    axis_y_vertical_plate();
}

module axis_y_vertical_plate() {
    dxf("STEEL_3mm_axis_y_vertical_plate");
    difference() {
        square([30+40+20, 40], center = true);
        translate([35,10])
            circle(d=5);
        translate([35,-10])
            circle(d=5);

        translate([-35,10])
            circle(d=5);
        translate([-35,-10])
            circle(d=5);

        translate([-15,10])
            circle(d=5);
        translate([-15,-10])
            circle(d=5);
    }
}

module STEEL_3mm_axis_y_front_plate_dxf() {
    axis_y_front_plate();
}

module axis_y_front_plate() {
    dxf("STEEL_3mm_axis_y_front_plate");
    difference() {
        rounded_polygon([
                [1,-9,1],
                [1,9,1],
                [40,79,1],
                [59,79,1],
                [79, 9,1],
                [79,-9,1]
            ]);

        for(i = [0:3])
        translate([10+20*i,0])
            circle(d=5);

        translate([50,50])
            circle(d=5);
        translate([50,70])
            circle(d=5);
    }
}

module axis_y(depth, pos = 0) {
    dx = FRAME_TYPE[1]/2;
    translate([0,0,35])
    rotate([0,90,0])
    translate_z(-3)
    color("silver")
    linear_extrude(3)
        axis_y_vertical_plate();

    translate([-dx*4,depth/2+3])
    rotate([90,0,0])
    linear_extrude(3)
        axis_y_front_plate();

    translate([dx*2,0,0])
    rotate([90,0,0])
    rotate([0,0,90])
        extrusion(FRAME_TYPE_D, depth, center = true);

    translate([dx,0,30+30])
    rotate([90,0,0])
        extrusion(FRAME_TYPE_D, depth, center = true);
}

// ********************************* Z


module axis_z(heigth, pos = 0) {
    extrusion(FRAME_TYPE, heigth, center = true);
}



// ********************************** X
use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <../lib/vwheel_assemblies.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>


function X_PLATE_GEOM(wr = 19) = [
    [-wr, -wr, 1],
    [-wr,  wr, 1],
    [70, 80, 1],
    [145, 80, 1],
    [145, 60, 1],
    [115, 50, -1],

    [115, 10, -1],
    [145, 0, 1],


    [145, -wr, 1],
    [70, -wr, 1],
];

X_VW_HOLES = [
    [5.01,  0, -10, -80],
    [5.01,  0,  68, -80],
    [5.01,  0,  28, -80],
    [7.21,  0,  68, -140],
    [7.21,  0, -10, -140],
];

function X_MOUNTS(w=20/2,l=20/2) = [
        [5.05,0,["circle", [[23,-80], [33,-80]]]],
        [5.05,0,w,l],
        [5.05,0,w,-l],
        [5.05,0,-w,l],
        [5.05,0,-w,-l],
    ];

X_PLATE = [X_PLATE_GEOM(), 5, 3, X_VW_HOLES,  X_MOUNTS()];

S_40_TRIANGLE_GANTRY = ["", X_PLATE,
    [   S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

X_MOTOR_POSITION = [10, -53];
X_MOTOR = NEMA17;

module STEEL_3mm_axis_x_motor_plate_dxf() {
    polygon_plate_sketch(X_PLATE)
        translate(X_MOTOR_POSITION) {
            circle(d = NEMA_boss_radius(X_MOTOR)*2);
            NEMA_screw_positions(X_MOTOR)
            circle(d = 3.1);
        }
}

module axis_x_motor_plate() {

    dxf("STEEL_3mm_axis_x_motor_plate");
    difference() {
        vwheel_gantry(S_40_TRIANGLE_GANTRY) {
            translate(X_MOTOR_POSITION) {
                circle(d = NEMA_boss_radius(X_MOTOR)*2);
                NEMA_screw_positions(X_MOTOR)
                circle(d = 3.1);
            }
            translate([X_MOTOR_POSITION.x,X_MOTOR_POSITION.y,-3])  {
                NEMA(X_MOTOR);
                translate_z(3)
                NEMA_screws(X_MOTOR, M3_dome_screw);
            }
        };
    }


}

module axis_x(width, pos = 0) {
    dx = FRAME_TYPE[1]/2;
    full_width = width + dx*4 + 3;

    module motor_plate() {
        translate([full_width/2,0,0])
            mirror([1,0,0])
                axis_x_motor_plate();
    }

    motor_plate();

    mirror([1,0,0])
    motor_plate();

    rotate([0,90,0])
        extrusion_2x2(FRAME_TYPE_X, full_width, center = true);
}

WIDTH = 600;
DEPTH = 1350;
HEIGTH = 170;


//module main_assembly() {
//    translate([ WIDTH/2, 0, 0])
//    axis_y(depth = DEPTH);
//    mirror([1,0,0])
//    translate([ WIDTH/2, 0, 0])
//    axis_y(depth = DEPTH);
//
//    translate_z(HEIGTH)
//    axis_x(width = WIDTH);
//
//    axis_z(heigth = HEIGTH);
//}
//
//
//
//if($preview)
//    main_assembly();
