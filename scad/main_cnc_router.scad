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

MATERIAL_THICKNESS = 3;

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

module axis_x_caret() {

}

module STEEL_3mm_axis_y_front_plate_dxf() {
    axis_y_front_plate();
}

module axis_y_front_plate() {
    dxf(str("STEEL_",MATERIAL_THICKNESS,"mm_axis_y_front_plate"));

    linear_extrude(MATERIAL_THICKNESS)
        axis_y_front_plate_sketch();
}
module axis_y_front_plate_sketch() {
    difference() {
        rounded_polygon([
                [1,-9,1],
                [1,9,1],
                [40,79,1],
                [40,89,1],
                [59,89,1],
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

        translate([50,77]) hull() {
            translate([-2.5,0])
            circle(d = 2);
            translate([ 2.5,0])
            circle(d = 2);
        }
    }
}

module axis_y(depth, pos = 0) {
    dx = FRAME_TYPE[1]/2;


    module vertical_plate() {
        translate([0, 0, 35])
            rotate([0, 90, 0])
                translate_z(- 3)
                color("silver")
                    linear_extrude(3)
                        axis_y_vertical_plate();
    }
    module front_plate() {
        translate([-dx*4,depth/2+MATERIAL_THICKNESS])
            rotate([90,0,0])
                    axis_y_front_plate();
    }

    vertical_plate_spacing = 250;

    for(y = [vertical_plate_spacing : vertical_plate_spacing : depth-vertical_plate_spacing]) {
        translate([0,y-(depth-vertical_plate_spacing/2)/2,0])
            vertical_plate();
    }

    front_plate();
    mirror([0,1,0])
    front_plate();


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
    axis_z_plate_motor_plate();
//    extrusion(FRAME_TYPE, heigth, center = true);
}



// ********************************** X
use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <../lib/vwheel_assemblies.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <gears/belt_pulleys.scad>



/**
* X GANTRY
*/
X_GANTRY_WIDTH = 100;
X_GANTRY_HEIGTH = 150;

function X_PLATE_GEOM(h = X_GANTRY_HEIGTH, w = X_GANTRY_WIDTH, wr = 20, r = 1) = [
        [-3+r, -w/2+r, r],
        [-3+r, -(w/2-20)+r, r],
        [20+r, 0, -10],
        [-3+r, (w/2-20)+r, r],
        [-3+r, w/2+r, r],
//        [50-r, w/2-r, r],
        [h+r, w/2+r, r],
        [h+r, -w/2+r, r],
        [70+r, -w/2+r, r],
    ];

function X_VW_HOLES(w = X_GANTRY_WIDTH) = [
        [5.01,  0, -10-w/2+20, -80],
        [5.01,  0,  68-w/2+20, -80],
        [5.01,  0,  28-w/2+20, -80],
        [7.21,  0,  68-w/2+20, -140],
        [7.21,  0, -10-w/2+20, -140],
    ];

function X_MOUNTS(w=X_GANTRY_WIDTH,l=20/2) = [
        [5.05,0,["circle", [[23-w/2+20,-80], [33-w/2+20,-80]]]],
        [5.05,0,10-w/2+20,l],
        [5.05,0,10-w/2+20,-l],
        [5.05,0,-10-w/2+20,l],
        [5.05,0,-10-w/2+20,-l],
    ];

function X_VW_HOLES_FRONT(w = X_GANTRY_WIDTH) = [
        [5.01,  0, -10-w/2+20, -80],
        [5.01,  0,  68-w/2+20, -80],
        [7.21,  0,  68-w/2+20, -140],
        [7.21,  0, -10-w/2+20, -140],
    ];

function X_MOUNTS_FRONT(w=X_GANTRY_WIDTH,l=20/2) = [
        [5.05,0,10-w/2+20,l],
        [5.05,0,10-w/2+20,-l],
        [5.05,0,-10-w/2+20,l],
        [5.05,0,-10-w/2+20,-l],
    ];

X_PLATE = [X_PLATE_GEOM(), 5, 3, X_VW_HOLES(),  X_MOUNTS()];
X_PLATE_FRONT = [X_PLATE_GEOM(), 5, 3, X_VW_HOLES_FRONT(),  X_MOUNTS_FRONT()];

X_GANTRY = ["", X_PLATE,
        [   S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

X_GANTRY_FRONT = ["", X_PLATE_FRONT,
        [   S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

/**
* Y GANTRY
*/

function Y_PLATE_GEOM(wr = 19) = [
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

Y_VW_HOLES = [
    [5.01,  0, -10, -80],
    [5.01,  0,  68, -80],
    [5.01,  0,  28, -80],
    [7.21,  0,  68, -140],
    [7.21,  0, -10, -140],
];

function Y_MOUNTS(w=20/2,l=20/2) = [
        [5.05,0,["circle", [[23,-80], [33,-80]]]],
        [5.05,0,w,l],
        [5.05,0,w,-l],
        [5.05,0,-w,l],
        [5.05,0,-w,-l],
    ];

Y_PLATE = [Y_PLATE_GEOM(), 5, 3, Y_VW_HOLES,  Y_MOUNTS()];

Y_GANTRY = ["", Y_PLATE,
    [   S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_SPACER,
        S_XTREME_VW_ECCENT,
        S_XTREME_VW_ECCENT,
        ], 40];

X_MOTOR_POSITION = [-20, -53];
X_MOTOR = NEMA17;
X_PIVOT_MOTOR = NEMA17P;

module STEEL_3mm_axis_x_motor_plate_dxf() {
    polygon_plate_sketch(Y_PLATE)
        translate(X_MOTOR_POSITION) {
            circle(d = NEMA_boss_radius(X_MOTOR)*2);
            NEMA_screw_positions(X_MOTOR)
            circle(d = 3.1);
        }
}

module axis_x_motor_plate() {

    dxf("STEEL_3mm_axis_x_motor_plate");
    difference() {
        vwheel_gantry(Y_GANTRY) {
            translate(X_MOTOR_POSITION) {
                circle(d = NEMA_boss_radius(X_MOTOR)*2);
                NEMA_screw_positions(X_MOTOR)
                circle(d = 3.1);
            }

            mirror([0,0,1])
            translate([X_MOTOR_POSITION.x,X_MOTOR_POSITION.y,0])  {
                NEMA(X_MOTOR);
                translate_z(3)
                NEMA_screws(X_MOTOR, M3_dome_screw);
            }
        };
    }


}

X_PIVOT_AXIS_POSITION = [0,-X_GANTRY_HEIGTH/2+10,0];
X_PIVOT_MOTOR_POSITION = [-X_GANTRY_WIDTH/2+20,-40,0];

module axis_z_plate_motor_plate() {
    module place_extrusion() {
        translate([-40,-10,-43/2-MATERIAL_THICKNESS])
            rotate([0,0,90])
                extrusion(E2020, 40+3);
    }

    offs = 21.5+MATERIAL_THICKNESS;

    dxf("STEEL_3mm_axis_x_motor_plate_front");
    translate([ offs,0,0])
    mirror([0,1,0])
    difference() {
//        color("silver")
        vwheel_gantry(X_GANTRY_FRONT) {
            union() {
//                translate(X_PIVOT_MOTOR_POSITION) {
//                    circle(d = NEMA_boss_radius(X_PIVOT_MOTOR) * 2);
//                    NEMA_screw_positions(X_PIVOT_MOTOR)
//                    circle(d = 3.1);
//                }

//                translate(X_PIVOT_AXIS_POSITION) {
//                    circle(d = NEMA_boss_radius(X_PIVOT_MOTOR) * 2);
//                    //                NEMA_screw_positions(X_MOTOR)
//                    //                circle(d = 3.1);
//                }
            }


            place_extrusion();
            mirror([1,0,0])
            place_extrusion();
//            translate(X_PIVOT_MOTOR_POSITION) {
            translate([0,0,-NEMA_width(X_PIVOT_MOTOR)/2])
            translate_z(-MATERIAL_THICKNESS)
            rotate([-90,0,0])
            NEMA(X_PIVOT_MOTOR);
////                translate_z(-3)
//                NEMA_screws(X_PIVOT_MOTOR, M3_dome_screw);
//            }
        };
    }

    dxf("STEEL_3mm_axis_x_motor_plate");
    translate([-offs,0,0])
    rotate([0,0,180])
    difference() {
        vwheel_gantry(X_GANTRY) {
            translate(X_MOTOR_POSITION) {
                circle(d = NEMA_boss_radius(X_MOTOR)*2);
                NEMA_screw_positions(X_MOTOR)
                circle(d = 3.1);
            }

            mirror([0,0,1])
                translate([X_MOTOR_POSITION.x,X_MOTOR_POSITION.y,0])  {
                    NEMA(X_MOTOR);
                    translate_z(3)
                    NEMA_screws(X_MOTOR, M3_dome_screw);
                }
        };
    }
}


module axis_x(width, pos = 0) {
    dx = FRAME_TYPE[1]/2;
    full_width = width + dx*4 + MATERIAL_THICKNESS;

    module motor_plate() {
        translate([-(full_width/2+MATERIAL_THICKNESS),0,0])
            mirror([1,0,0])
                axis_x_motor_plate();
    }

    motor_plate();

    mirror([1,0,0])
    motor_plate();

    rotate([0,90,0])
        extrusion_2x2(FRAME_TYPE_X, full_width, center = true);

}

WIDTH = 650;
DEPTH = 1300;
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
//    translate([0,0,HEIGTH + 147 - 40])
//    rotate([0,0,90])
//    axis_z(heigth = HEIGTH);
//}
//
//
//
//if($preview)
//    main_assembly();



