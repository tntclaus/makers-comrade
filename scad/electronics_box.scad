include <NopSCADlib/utils/core/core.scad>


include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>


include <NopSCADlib/vitamins/displays.scad>

include <screw_assemblies.scad>

include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/iecs.scad>

include <psus.scad>
use <NopSCADlib/utils/rounded_polygon.scad>

include <NopSCADlib/vitamins/screws.scad>

use <../lib/boxes/chamfer_box.scad>


use <NopSCADlib/printed/camera_housing.scad>
include <NopSCADlib/vitamins/cameras.scad>

//w   27.45-21.3
//l   60.55-54.55
//function PSU_ACDC_5V_COORDS(w = 24.375, l = 57.55) =
PSU_ACDC_5V_COORDS_W = 31.25;
PSU_ACDC_5V_COORDS_L = 64;
function PSU_ACDC_5V_COORDS(w = 31.25, l = 57.55) =
[
for (x = [- 1, 1], y = [- 1, 1])
    [x * w / 2, y * l / 2]
//    [w/2, -w/2],
];

M4_NUT = screw_nut(M4_pan_screw);

LCD12864PCB = ["", "", 78, 70, 1.65, 3, 3, 0, "mediumblue", false, [[3, 3], [- 3, 3], [- 3, - 3], [3, - 3]],
        [[2.75 + 1.27, 37, 90, "2p54header", 20, 2]
        ],
        []];

LCD12864 = ["LCD12864", "LCD display 12864\"", 68, 44, 3.4, LCD12864PCB,
        [0, 0, 0],
        [[- 68 / 2, - 22], [68 / 2, 22, 0.5]],
        [[- 68 / 2, - 44 / 2 + 1], [68 / 2, 44 / 2 + 1, 1]],
    0,
        [[0, - 34.5], [12, - 31.5]],
    ];


PSU_ACDC_5V = [
    "PSU_ACDC_5V",
    "PCB PSU AC/DC 5V 2A",
    24.375,
    57.55, 1.6, 0, 3.3, 0, "#2140BE", false,
        [
            [0.01, 0.01], [- 0.01, 0.01],
            [0.01, - 0.01], [- 0.01, - 0.01],
        ],
        [
        //            [9, 10, 180, "gterm635", 2, 2],
        //            [14, 28, 180, "gterm635", 2, 2],
        ],
        [], [],
        [
            [- PSU_ACDC_5V_COORDS_W / 2, - PSU_ACDC_5V_COORDS_L / 2],
            [- PSU_ACDC_5V_COORDS_W / 2, PSU_ACDC_5V_COORDS_L / 2],
            [PSU_ACDC_5V_COORDS_W / 2, PSU_ACDC_5V_COORDS_L / 2],
            [PSU_ACDC_5V_COORDS_W / 2, - PSU_ACDC_5V_COORDS_L / 2]],
    //    PSU_ACDC_5V_COORDS(),
    M3_pan_screw
    ];

DC_DC_LM2596 = [
    "LM2596",
    "LM2596 DC-DC Converter",
    43,
    21,
    1.6, 0, 3.3, 0, "#2140BE", false,
        [
            [- (4.75 + 3.3 / 2), (0.75 + 3.3 / 2)],
        //        [-4, -4],
            [(4.75 + 3.3 / 2), - (0.75 + 3.3 / 2)],
        //        [4, 4]
        ],

    //   concat(Duex2[11], [
    //     [ 61.5, -81.2,   0, "chip", 10, 10, 2],
    //     [ 36.9, -81.2,   0, "chip", 10, 10, 2],
    //     [ 12.3, -81.2,   0, "chip", 10, 10, 2],
    //
    //     [ 61.5, -96.4,  -90, "molex_hdr", 4],
    //     [ 36.9, -96.4,  -90, "molex_hdr", 4],
    //     [ 14.3, -96.4,  -90, "molex_hdr", 4],

    //    ]),
        [],
        []
    ];

ArduinoMega = [
    "ArduinoMega",
    "Arduino Mega 256",
    101.6, 53.34, 1.6, 0, 3.3, 0, "#2140BE", false,
        [
            [15.24, 50.8],
            [- 9.64 - 1.5, 50.8],
            [66.04, 35.56], [66.04, 7.62],
            [13.97, 2.54],
            [- 3.4 - 1.5, 2.54]
        ],
        [[30.226, - 2.54, 0, "2p54socket", 10, 1],
            [54.61, - 2.54, 0, "2p54socket", 8, 1],
            [79.61, - 2.54, 0, "2p54socket", 8, 1],
            [96.31, 28.64, 90, "2p54socket", 18, 2],
            [36.83, 2.54, 0, "2p54socket", 8, 1],
            [57.15, 2.54, 0, "2p54socket", 6, 1],
            [79.61, 2.54, 0, "2p54socket", 8, 1],
            [64.91, 27.89, 0, "2p54header", 2, 3],
            [18.796, - 7.00, 0, "2p54header", 3, 2],
            [6.5, - 3.5, 0, "button_6mm"],
            [4.7625, 7.62, 180, "barrel_jack"],
            [1.5875, 37.78, 180, "usb_B"],
            [49.9, - 22.0, 0, "chip", 20, 20, 2],
        ],
        [], [],
    inch([
            [- 2, - 1.05],
            [- 2, 1.05],
            [1.84, 1.05],
            [1.9, 0.99],
            [1.9, 0.54],
            [2, 0.44],
            [2, - 0.85],
            [1.95, - 0.95],
            [1.95, - 1.05],
        ]),
    M2p5_pan_screw
    ];

RAMPS_1_4 = [
    "RAMPS_1_4",
    "RAMPS v1.4",
    101.6,
    59.34, 1.6, 0, 3.3, 0, "#2140BE", false,
        [
            [15.24, 53.8], [- 3.4, 5.54]
        ],
        [
            [9, 10, 180, "gterm635", 2, 2],
            [14, 28, 180, "gterm635", 2, 2],
        ],
        [], [],
    inch([
            [- 2, - 1.15],
            [- 2, 1.05],
            [2, 1.05],
            [2, 0.44],
            [2, - 1.15],
        ]),
    M2p5_pan_screw
    ];

function next_hole(total, i) = i > total ? 0 : i;

module pcb_base_frame(type, heigth, wall = 2) {
    holes = pcb_holes(type);
    screw = pcb_screw(type);
    ir = screw_clearance_radius(screw);
    or = corrected_radius(ir) + wall;

    difference() {

        union() {
            linear_extrude(heigth)
                pcb_screw_positions(type)
                poly_circle(or);

            linear_extrude(wall) {
                total = len(holes) - 1;
                for ($i = [0 : 1 : total]) {
                    //                    hole = holes[$i];


                    hull() {
                        translate(pcb_coord(type, holes[next_hole(total, $i)]))
                            square([or, or], center = true);
                        translate(pcb_coord(type, holes[next_hole(total, $i + 1)]))
                            square([or, or], center = true);
                    }
                }
                //                hull() {
                //                    translate(pcb_coord(type, holes[1]))
                //                        square([or, or], center = true);
                //                    translate(pcb_coord(type, holes[2]))
                //                        square([or, or], center = true);
                //                }
                //                hull() {
                //                    translate(pcb_coord(type, holes[2]))
                //                        square([or, or], center = true);
                //                    translate(pcb_coord(type, holes[3]))
                //                        square([or, or], center = true);
                //                }
                //                hull() {
                //                    translate(pcb_coord(type, holes[3]))
                //                        square([or, or], center = true);
                //                    translate(pcb_coord(type, holes[0]))
                //                        square([or, or], center = true);
                //                }
            }
            //                pcb_base(RPI3, 8, 2);
        }

        translate_z(- .1)
        linear_extrude(heigth + 1)
            pcb_screw_positions(type)
            poly_circle(ir);
    }
}

module mains_inlet(cutouts = false) {
    //    translate([65, 155, 25])
    //        rotate([0, 90, 0])
    if (!cutouts) {
        iec_assembly(IEC_inlet_atx, 4);
    } else {
        iec_holes(IEC_inlet_atx);
    }
}




ELECTRONICS_BOX_CAMERA = rpi_camera_v1;
ELECTRONICS_BOX_PSU = SOMPOM_S_480_24;
ELECTRONICS_BOX_THICKNESS = 3;
ELECTRONICS_BOX_WIDTH = 120;
ELECTRONICS_BOX_LENGTH = 180;
ELECTRONICS_BOX_HEIGTH = 135;

function ELECTRONICS_BOX_WIDTH() = ELECTRONICS_BOX_WIDTH;
function ELECTRONICS_BOX_LENGTH() = ELECTRONICS_BOX_LENGTH;
function ELECTRONICS_BOX_HEIGTH() = ELECTRONICS_BOX_HEIGTH;
function ELECTRONICS_BOX_THICKNESS() = ELECTRONICS_BOX_THICKNESS;

function ELECTRONICS_BOX_CAMERA() = ELECTRONICS_BOX_CAMERA;
function ELECTRONICS_BOX_PSU() = ELECTRONICS_BOX_PSU;



//module lcd_holder_socket_stl() {
//    lcd_holder_socket();
//}

module lcd_holder_socket() {
    stl("lcd_holder_socket");
    th = 3;
    w = 15;

    module ear() {
        color("red")
            difference() {
                hull() {
                    cylinder(d = w, h = th);
                    translate([w / 2, 0, th / 2])
                        cube([1, w, th], center = true);
                }
                cylinder(d = 4, h = th * 3, center = true);
            }
    }

    union() {
        ear();
        translate([w / 2, 0, w / 2 + th])
            rotate([0, 90, 0])
                ear();

        translate([w / 2 + th / 2, 0, th / 2])
            cube([th, w, th], center = true);
    }
}

module lcd_holder_base_stl() {
    lcd_holder_base();
}

module lcd_holder_base() {
    stl("lcd_holder_base");

    module half_sphere(d = 10) {
        difference() {
            sphere(d = d);
            translate_z(- d / 2)
            cube([d, d, d], center = true);
        }
    }

    difference() {
        union() {
            hull() {
                translate([0, - 10, 0])
                    half_sphere(20);

                translate([0, 10, 0])
                    half_sphere(20);
            }

            cylinder(d = 15, h = 20);
        }

        translate_z(- .1) {
            nut_d = nut_radius(M4_NUT) * 2 + .2;
            cylinder(d = 4, h = 21);
            cylinder(d = nut_d, h = 5, $fn = 6);
            translate_z(16)
            cylinder(d = nut_d, h = 5, $fn = 6);

            translate([0, - 12, 0]) {
                cylinder(d = 4, h = 21);
                translate_z(6)
                cylinder(d = 9, h = 5);
            }
            translate([0, 12, 0]) {
                cylinder(d = 4, h = 21);
                translate_z(6)
                cylinder(d = 9, h = 5);
            }
        }
    }
}





//nut(M4_NUT);

//pcb_base(DC_DC_LM2596, 3, 1);
//pcb(DC_DC_LM2596);

//electronics_case_assembly();

//caseLCD();

//sliding_t_nut(M5_sliding_t_nut);
//display(SSD1963_4p3);

//rocker(small_rocker);



//extrusion_corner_bracket_assembly(E20_corner_bracket, grub_screws = true);


// NEW

module PSU_ACDC_5V_position() {
    translate([
                (ELECTRONICS_BOX_WIDTH - pcb_length(PSU_ACDC_5V)) / 2 - 10,
        - (ELECTRONICS_BOX_LENGTH / 2 - 4),
        60
        ])
        rotate([- 90, 0, 0])
            children();
}

module PSU_ACDC_5V() {
    PSU_ACDC_5V_position()
    pcb(PSU_ACDC_5V);
}

module RPI3_position() {
    translate([ELECTRONICS_BOX_WIDTH() / 2 - 4, 0, 35])
        rotate([- 90, 0, 90])
            children();
}

module RPI3() {
    RPI3_position()
    translate(RPI_OFFSET)
        pcb(RPI3);

    //                                pcb_assembly(RPI3, 4, 4);
    //                    pcb_base_frame(RPI3, 8);
}

module RAMPS_position() {
    translate([- (ELECTRONICS_BOX_WIDTH() / 2 - 4), 0, 50])
        rotate([- 90, 180, - 90])
            children();
}

module RAMPS(stl = false) {
    RAMPS_position()
    translate(RAMPS_OFFSET) {
        pcb(ArduinoMega);
        translate_z(14)
        pcb(RAMPS_1_4);

        //        pcb(BTT_SKR_V1_4_TURBO);
    }
}

module electronics_box_place_screws(w, l, rot = [0, 0, 0, 0]) {
    th = ELECTRONICS_BOX_THICKNESS;
    p = [
    for (x = [- 1, 1], y = [1, - 1])
        [x, y]
    ];

    for (i = [0 : 1 : 3]) {
        a = rot[i];
        translate([(w - th) / 2 * p[i].x, (l - th) / 2 * p[i].y, 0])
            rotate([0, 0, a])
                children();
    }
}

module electronics_box_place_camera() {
    translate([0, 25, 0])
        rotate([0, 180, 180])
            translate_z(3)
            children();
}

include <NopSCADlib/vitamins/blowers.scad>

//
//                                                   l     w   d   b     s              h   a            s    s                               e    h    b    t    w    l
//                                                   e     i   e   o     c              u   x            c    c                               x    u    a    o    a    u
//                                                   n     d   p   r     r              b   i            r    r                               i    b    s    p    l    g
//                                                   g     t   t   e     e                  s            e    e                               t         e         l
//                                                   t     h   h         w              d                w    w                                              t
//                                                   h                                                   h    s                                         t         t
RB7530 = ["RB7530", "Blower Runda RB7530", 73.4, 75.5, 30, 48.5, M4_cap_screw, 35, [39.5, 37.5], 4.5, [[3.05, 61.05], [
    70.4, 15.4]], 40, 24, 3.15, 2.0, 1.92, 30];

ELETRONIC_BOX_BLOWER = RB7530;

module blower_centered(type) {
    pos_x = - blower_width(type) / 2;
    pos_y = - blower_length(type) / 2;

    translate([pos_x, pos_y, 0])
        children();
}

module electronics_box_plastic_case_top_w120_l180_th3_stl() {
    electronics_box_plastic_case_top(width = 120, length = 180, th = 3);
}

module electronics_box_place_blower_part_cooler(l, axial = false) {
    pos_y2 = - l / 2 + blower_length(ELETRONIC_BOX_BLOWER) / 2 + 10;

    if (axial) {
        translate([0, pos_y2, 0])
            rotate([0, 0, 90])
                children();
    } else {
        translate([0, pos_y2, 0])
            rotate([0, 0, 90])
                blower_centered(ELETRONIC_BOX_BLOWER)
                children();
    }
}

module electronics_box_place_blower_hotend_cooler(l, axial = false) {
    pos_y1 = l / 2 - blower_length(ELETRONIC_BOX_BLOWER) / 2 - 10.5;

    if (axial) {
        translate([0, pos_y1, 0])
            rotate([0, 0, 180])
                children();
    } else {
        translate([0, pos_y1, 0])
            rotate([0, 0, 180])
                blower_centered(ELETRONIC_BOX_BLOWER)
                children();
    }
}

use <fan_duct/fan_duct.scad>

module electronics_box_plastic_case_top(width, length, th) {
    name = str(
    "electronics_box_plastic_case_top_",
    "w", width, "_",
    "l", length, "_",
    "th", str_replace(str(th), ".", "_")
    );
    stl(name);
//    echo(name);

    w = width + th * 2;
    l = length + th * 2;


    cooler_fanduct_offset_x = (w - blower_width(ELETRONIC_BOX_BLOWER)) / 2 - 10;

    module place_part_cooler_fanduct() {
        electronics_box_place_blower_part_cooler(l)
        translate([blower_exit(ELETRONIC_BOX_BLOWER) / 2, 5, blower_depth(ELETRONIC_BOX_BLOWER) / 2])
            rotate([90, 0, 0])
                children();
    }

    module place_hotend_cooler_fanduct() {
        electronics_box_place_blower_hotend_cooler(l)
        translate([blower_exit(ELETRONIC_BOX_BLOWER) / 2, 5, blower_depth(ELETRONIC_BOX_BLOWER) / 2])
            rotate([90, 0, 0])
                children();
    }

    place_part_cooler_fanduct() difference() {
        color("blue", 0.5)
            fanduct(ELETRONIC_BOX_BLOWER,
            height = cooler_fanduct_offset_x,
            offcenter = 6);
        translate([0, 0, 1])
            color("green")
                cube([40, 40, 10], center = true);
    }

    module hotend_cooler_fanduct(make_hull = false)
    difference() {
        fanduct(
        ELETRONIC_BOX_BLOWER,
        make_hull = make_hull,
        circles = 1,
        hole_odia = 24,
        hole_idia = 21,
        height = 9.5
        );
        translate([0, 0, 1])
            color("green")
                cube([40, 40, 10], center = true);
    }

    //    color("blue", 0.5)
    place_hotend_cooler_fanduct()
    hotend_cooler_fanduct();

    difference() {
        h = blower_depth(ELETRONIC_BOX_BLOWER) + th;
        union() {
            translate_z(- th)
            difference() {
                chamfer_box([w, l, h], th, 25, true);

                electronics_box_place_blower_hotend_cooler(l, true){
                    cylinder(d = blower_bore(ELETRONIC_BOX_BLOWER), h = th * 4, center = true);

                    blower_hole_positions(ELETRONIC_BOX_BLOWER)
                    blower_centered(ELETRONIC_BOX_BLOWER)
                    cylinder(d = 4.5, h = th * 4, center = true);
                }

                electronics_box_place_blower_part_cooler(l, true){
                    cylinder(d = blower_bore(ELETRONIC_BOX_BLOWER), h = th * 4, center = true);

                    blower_hole_positions(ELETRONIC_BOX_BLOWER)
                    blower_centered(ELETRONIC_BOX_BLOWER)
                    cylinder(d = 4.5, h = th * 4, center = true);
                }
            }

            place_hotend_cooler_fanduct()
            translate([0, 0, 16.5])
                hull() {
                    translate([0, - 7, 4])
                        cube([21, 1, 10], center = true);

                    translate([0, - 12.5, 4])
                        cube([18, 1, 10], center = true);

                    translate([0, - 17.5, 2])
                        cube([10, 1, 10], center = true);
                }

            place_part_cooler_fanduct()
            translate([0, 0, 22])
                hull() {
                    ox = cooler_fanduct_offset_x - 10 - 2;
                    translate([0, 0, ox])
                        cube([16, 1, 8], center = true);

                    translate([0, - 5.5, ox])
                        cube([16, 1, 8], center = true);

                    translate([0, - 15, ox])
                        cube([16, 1, 8], center = true);
                }
        }
        // крепеж к корпусу
        electronics_box_place_screws(w - 10, l - 10, rot = [0, 90, - 90, 180]) difference() {
            cylinder(d = 3.1, h = th * 4, center = true);
        }

        // отверстие для HDMI кабеля
        translate([0, - 10 + RPI_OFFSET.x, h - th])
            rotate([0, - 90, 0])
                cylinder(d = 15, h = 1000);

        place_part_cooler_fanduct()
        linear_extrude(100, convexity = 3)
            fanduct_two_circles(10, offcenter = 6);

        place_hotend_cooler_fanduct()
        linear_extrude(100, convexity = 3)
            fanduct_circles(24, 1);
    }


}


module electronics_box_plastic_case_top_assembly(w, l, th) {
    translate_z(.01) {
        electronics_box_place_blower_hotend_cooler(l + th * 2)
        blower(ELETRONIC_BOX_BLOWER);

        electronics_box_place_blower_part_cooler(l + th * 2)
        blower(ELETRONIC_BOX_BLOWER);
    }

    electronics_box_plastic_case_top(w, l, th);
}

use <../lib/utils.scad>

module electronics_box_plastic_case_w126_l186_th3_stl() {
    $fn = 90;
    electronics_box_plastic_case(w = 126, l = 186, th = 3);
}

RAMPS_OFFSET = [30, 0, 0];
RPI_OFFSET = [- 10, 0, 0];

module electronics_box_plastic_case(w, l, th) {
    name = str(
    "electronics_box_plastic_case_",
    "w", w, "_",
    "l", l, "_",
    "th", str_replace(str(th), ".", "_")
    );
    stl(name);
    //    echo(name);


    module hanging_mount() {
        hull() {
            rotate([180, 0, 0])
                cylinder(d = 6, h = 4);

            translate([0, 10, - 5])
                cylinder(d = 1, h = 1);
        }
    }

    module vent_hole(h = 7) {
        rotate([0, 90, 0]) hull() {
            translate([- 3 - h, 0, 0])
                cylinder(d = 3, h = ELECTRONICS_BOX_WIDTH * 2);
            translate([- 3, 0, 0])
                cylinder(d = 3, h = ELECTRONICS_BOX_WIDTH * 2);
        }
    }


    difference() {
        union() {
            chamfer_walls([w, l, ELECTRONICS_BOX_HEIGTH()], th, 25);

            PSU_ACDC_5V_position()
            pcb_screw_positions(PSU_ACDC_5V)
            hanging_mount();

            RPI3_position()
            translate(RPI_OFFSET)
                pcb_screw_positions(RPI3)
                hanging_mount();

            RAMPS_position()
            translate(RAMPS_OFFSET)
                pcb_screw_positions(ArduinoMega)
                rotate([0, 0, 180])
                    hanging_mount();

            RAMPS_position()
            pcb_screw_positions(BTT_SKR_V1_4_TURBO)
            rotate([0, 0, 180])
                hanging_mount();

        }

        for (i = [- 82 : 8 : - 56])
        translate([0, i, 0])
            vent_hole();

        for (i = [- 40 : 8 : 0])
        translate([0, i, 0])
            vent_hole();

        for (i = [17 : 8 : 84])
        translate([0, i, 5])
            vent_hole();

        rotate([0, 0, 180]) {
            for (i = [- 78 : 8 : - 56])
            translate([0, i, 5])
                vent_hole();

            for (i = [- 40 : 8 : 40])
            translate([0, i, 0])
                vent_hole();

            for (i = [60 : 8 : 78])
            translate([0, i, 0])
                vent_hole();
        }

//        rotate([0, 0, 90]) {
//            w = (ELECTRONICS_BOX_WIDTH - 16);
//            for (i = [- w / 2 : 8 : w / 2])
//            translate([0, i, 0])
//                vent_hole(15);
//        }

//        rotate([0, 0, - 90]) {
//            w = (ELECTRONICS_BOX_WIDTH - 16);
//            for (i = [- w / 2 : 8 : - 16])
//            translate([0, i, 0])
//                vent_hole(15);
//
//            for (i = [16 : 8 : w / 2])
//            translate([0, i, 0])
//                vent_hole(15);
//        }

        // нижнее отверстие для проводов
        rotate([90, 0, 0])
            cylinder(d = 20, h = 1000);

        // отверстие для HDMI кабеля
        translate([0, - 10 + RPI_OFFSET.x, ELECTRONICS_BOX_HEIGTH])
            rotate([0, 90, 0])
                cylinder(d = 15, h = 1000);

        // отверстие для шлейфа к X/Y моторам
        translate([0, 55, 0])
            rotate([0, 90, 0]) hull() {
                translate([0, 20, 0])
                    cylinder(d = 5, h = ELECTRONICS_BOX_WIDTH * 2, center = true);
                cylinder(d = 5, h = ELECTRONICS_BOX_WIDTH * 2, center = true);
            }

        PSU_ACDC_5V_position()
        pcb_screw_positions(PSU_ACDC_5V)
        cylinder(d = 3, h = 100, center = true);

        RPI3_position()
        translate(RPI_OFFSET)
            pcb_screw_positions(RPI3)
            cylinder(d = 3, h = 100, center = true);

        RAMPS_position()
        translate(RAMPS_OFFSET)
            pcb_screw_positions(ArduinoMega)
            cylinder(d = 3, h = 100, center = true);

        RAMPS_position()
        pcb_screw_positions(BTT_SKR_V1_4_TURBO)
        cylinder(d = 3, h = 100, center = true);
    }

    module mount_profile() {
        hull() {
            cylinder(d = 10, h = 2);
            translate([0, 4.5, 1])
                cube([10, 1, 2], center = true);

            translate([- 4.5, 0, 1])
                cube([1, 10, 2], center = true);
        }
    }

    electronics_box_place_screws(w - 10, l - 10, rot = [0, 90, - 90, 180]) difference() {
        mount_profile();
        cylinder(d = 3, h = 5, center = true);
    }

    translate_z(ELECTRONICS_BOX_HEIGTH - th + 1)
    electronics_box_place_screws(w - 10, l - 10, rot = [0, 90, - 90, 180]) difference() {
        hull() {
            mount_profile();
            translate([- 5, 5, - 20])
                sphere(d = 1);
        }
        cylinder(d = 4.2, h = 1.5, center = true);
        cylinder(d = 3, h = 30, center = true);
    }

    module lcd_hinge_mount() {
        rotate([90, 0, 0])
            difference() {
                hull() {
                    cylinder(d = 10, h = 30, center = true);
                    translate([- 4.95, - 5, 0])
                        cube([0.1, 20, 30], center = true);
                }
                cylinder(d = 5, h = 51, center = true);
            }
    }
    module lcd_hinge_mounts() {
//        translate([10 / 2, - 30, - 10 / 2])
//            lcd_hinge_mount();

        translate([10 / 2, 30, - 10 / 2])
            lcd_hinge_mount();
    }

    translate([ELECTRONICS_BOX_WIDTH / 2 + ELECTRONICS_BOX_THICKNESS, 40, ELECTRONICS_BOX_HEIGTH])
        lcd_hinge_mounts();

}

module cooling_hose_mounts() {
    // hotend cooling hose mounts
    translate([-24,0])
        children();
    translate([ 24,11])
        children();

    translate([-24,-50])
        children();
    translate([ 24,-50])
        children();
}

module cooling_hose_perforation(mount_radius, hotend_cooling_dia = 30) {
    // hotend cooling hose ø24mm
    circle(d = hotend_cooling_dia);

    cooling_hose_mounts() circle(r = mount_radius);

    // part cooling hose 2 x ø10 mm
    translate([0,-30])
        hull() {
            translate([-10,0]) circle(d = 10);
            translate([ 10,0]) circle(d = 10);
        }
    translate([0,-50])
        hull() {
            translate([-10,0]) circle(d = 10);
            translate([ 10,0]) circle(d = 10);
        }

}

module electronics_box_mounts(w = ELECTRONICS_BOX_WIDTH + ELECTRONICS_BOX_THICKNESS * 2, l = ELECTRONICS_BOX_LENGTH +
        ELECTRONICS_BOX_THICKNESS * 2) {
    module screw_mount() circle(d = 2.5);

    electronics_box_place_camera() {
        // hole for camera flat cable
        hull() {
            for (x = [- 12.5, 12.5])
            translate([x, 0, 0])
                circle(d = 3);
        }

        camera_bracket_position(ELECTRONICS_BOX_CAMERA)
        camera_bracket_screw_positions(ELECTRONICS_BOX_CAMERA)
        screw_mount();
    }

    translate([0, ELECTRONICS_BOX_LENGTH/2 + 75, 0]) {
        cooling_hose_perforation(mount_radius = 3.1/2);
    }

    translate([0, ELECTRONICS_BOX_LENGTH/2-20, 0]) {
        hull() {
            for (x = [- 20, 20])
            translate([x, 0, 0])
                circle(d = 10);
        }
    }

    electronics_box_place_screws(w - 10, l - 10)
    screw_mount();
}

module electronics_box() {
    th = ELECTRONICS_BOX_THICKNESS;
    w = ELECTRONICS_BOX_WIDTH + th * 2;
    l = ELECTRONICS_BOX_LENGTH + th * 2;

    color("orange")
        electronics_box_plastic_case(w, l, th);

    if ($preview_screws)
    electronics_box_place_screws(w - 10, l - 10)
    translate_z(2)
    screw(M3_pan_screw, 5);


    //    rotate([0,-30,0])

}

module electronics_box_assembly() {
    assembly("electronics_box") {
        electronics_box();

        translate_z(ELECTRONICS_BOX_HEIGTH() + 60)
        rotate([0, 180, 0])
            electronics_box_plastic_case_top_assembly(ELECTRONICS_BOX_WIDTH(), ELECTRONICS_BOX_LENGTH(),
            ELECTRONICS_BOX_THICKNESS);

        RAMPS();
        RPI3();
        PSU_ACDC_5V();


        electronics_box_place_camera() {
            camera_fastened_assembly(ELECTRONICS_BOX_CAMERA, 3, 10);

            if ($preview_screws)
            camera_bracket_position(ELECTRONICS_BOX_CAMERA)
            camera_bracket_screw_positions(ELECTRONICS_BOX_CAMERA)
            screw(M3_pan_screw, 5);
        }
    }
}

//$preview_screws = false;
//electronics_box_assembly();



//blower(RB7530);

//PSU_SOMPOM_24_360 = ["", "PSU SOMPOM AC/DC 24V 15A", ];

//function psu_function_name(type) = type[0];
//function psu_name(type) = type[1];
//function psu_width(type) = type[2];
//function psu_length(type) = type[3];
//function psu_heigth(type) = type[4];
//function psu_(type) = type[2];
//function psu_(type) = type[2];



module electronics_box_psu_case_mains_inlet(size, cutouts = false) {
    translate([- (size.x / 2 + 30), - size.y / 2 - ELECTRONICS_BOX_THICKNESS, 0])
        rotate([90, 180, 0])
            mains_inlet(cutouts = cutouts);
}

module electronics_box_psu_case_mounts() {
    psu_screw_positions(ELECTRONICS_BOX_PSU, 0)
        children();
}

module electronics_box_psu_case_assembly(type = ELECTRONICS_BOX_PSU) {
    assembly("electronics_box_psu_case") {
        psu(type);
        size = psu_size(type);
        electronics_box_psu_case(type, th = ELECTRONICS_BOX_THICKNESS);
        translate_z(size.z / 2)
        electronics_box_psu_case_mains_inlet(size);
        if ($preview_screws) {
            psu_screw_positions(type, 4) {translate_z(ELECTRONICS_BOX_THICKNESS) screw(M4_pan_screw, 5);}
            psu_screw_positions(type, 5) {translate_z(ELECTRONICS_BOX_THICKNESS) screw(M4_pan_screw, 5);}
            electronics_box_psu_case_mounts() {translate_z(3) screw(M4_pan_screw, 5);}
        }
    }
}

module electronics_box_psu_case_stl() {
    $fn = 90;
    electronics_box_psu_case(type = ELECTRONICS_BOX_PSU, th = ELECTRONICS_BOX_THICKNESS);
}

module electronics_box_psu_case(type, th) {
    stl("electronics_box_psu_case");

    size = psu_size(type);

    extra_length = 60;

    size_x = size.x + th * 2 + extra_length * 2;

    translate_z(size.z / 2)
    difference() {
        translate_z(size.z / 2 + th)
        rotate([0, 180, 0])
            chamfer_box([size_x, size.y + th * 2, size.z + th], th);
        translate([size.x / 2 - th - extra_length / 2, 0, 0])
            cube([size.x + th + extra_length, size.y * 2, size.z * 2], center = true);
        cube([size.x + extra_length * 2, size.y, size.z + .1], center = true);

        electronics_box_psu_case_mains_inlet(size, true);

        translate_z(- size.z / 2)
        psu_screw_positions(type, 4) {cylinder(d = 4.5, h = 10, center = true);}
        translate([6.5, 0, - size.z / 2])
            psu_screw_positions(type, 5) {cylinder(d = 4.5, h = 10, center = true);}

        translate([- size_x / 2, - (size.y / 2 - 30), 0])
            rotate([0, 90, 0])
                cylinder(d = 10, h = 10, center = true);
    }
}

module vesa_cross_shape(type = 75, d_center = 30) {
    l = type / 2;
    d_c = d_center*cos(45);
    module vesa_place_mounts() {
        for (x = [- 1, 1], y = [- 1, 1])
        translate([l * x, l * y])
            children();
    }

    difference() {
        union() {
            hull() {
                translate([- l, - l])
                    circle(d = 15);

                rotate([0,0,45])
                square(d_c, center = true);

                translate([l, l])
                    circle(d = 15);
            }
            hull() {
                translate([l, - l])
                    circle(d = 15);

                rotate([0,0,45])
                square(d_c, center = true);

                translate([- l, l])
                    circle(d = 15);
            }
        }

        vesa_place_mounts() circle(d = 4);
    }
}

module electronics_box_lcd_vesa_75() {

    h = 15;
    h_base = 30;

    linear_extrude(4, convexity = 3)
        vesa_cross_shape(d_center = h_base);


    difference() {
        union() {
            hull() {
                translate_z(50)
                rotate([0, 90, 0])
                    cylinder(d = 10, h = h, center = true);

                translate_z(50 - 10)
                rounded_rectangle([h, 10, 1], r = 3, center = true);
            }
            hull() {
                translate_z(50 - 10)
                rounded_rectangle([h, 10, 1], r = 3, center = true);

                translate_z(4)
                cylinder(d = h_base, h = .1);
            }
        }
        translate_z(50)
        rotate([0, 90, 0])
            cylinder(d = 5, h = 33, center = true);
    }
}

//translate([ELECTRONICS_BOX_WIDTH / 2 + 60, 40, ELECTRONICS_BOX_HEIGTH])
//    rotate([90, 0, - 90])
//        electronics_box_lcd_vesa_75();

//rotate([0,180,0])
//electronics_box_psu_case_assembly();
//electronics_box_psu_case_stl();

//color("orange")
//electronics_box_plastic_case_w126_l186_th3_stl();

electronics_box_plastic_case(w = 126, l = 186, th = 3);

//electronics_box_mounts();

//
//translate_z(180)
//rotate([0,180,0])
//electronics_box_plastic_case_top_w120_l180_th3_stl();


//projection()
//pcb(PSU_ACDC_5V);
//echo (PSU_ACDC_5V_COORDS());
//blower(ELETRONIC_BOX_BLOWER);

//camera_bracket(ELECTRONICS_BOX_CAMERA);
//camera_back(ELECTRONICS_BOX_CAMERA);
//camera_front(ELECTRONICS_BOX_CAMERA);
