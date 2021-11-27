include <NopSCADlib/utils/core/core.scad>


include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>


include <NopSCADlib/vitamins/displays.scad>

include <screw_assemblies.scad>

include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/iecs.scad>

include <NopSCADlib/vitamins/psus.scad>
use <NopSCADlib/utils/rounded_polygon.scad>

include <NopSCADlib/vitamins/screws.scad>

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

module RAMPS(stl = false) {
    translate([0, - 60, 0])
        if (!stl) {
            pcb_assembly(ArduinoMega, 4, 4);
            translate_z(16)
            pcb(RAMPS_1_4);
        } else {
            translate_z(- 4)
            pcb_base_frame(ArduinoMega, 8, 2);
            //        pcb_base_frame(RPI3, 8);
        }
}
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

module RPI(cutouts = false, stl = false) {
    translate([0, 5, 0])
        rotate([0, 0, 180]) {
            if (cutouts) {
                translate_z(4)
                difference() {
                    pcb_cutouts(RPI3);
                    translate([- 100, 10, 0])
                        cube([1000, 100, 1000]);

                    translate([- 100, 200, 0])
                        cube([200, 1000, 1000]);

                    translate([- 180, - 200, 0])
                        cube([200, 1000, 1000]);
                }
            } else {
                if (!stl) {
                    pcb_assembly(RPI3, 4, 4);
                } else {
                    pcb_base_frame(RPI3, 8);
                }

            }
        }
}

module electronics_case() {
    w = 150;
    l = 400;
    h = 60;

    module mesh() {
        //        for (x = [- w / 2 + 8:20:w / 2 - 8])
        //        for (y = [- l / 2 + 8:13:l / 2 - 8])
        //        translate([x, y, 0])
        //            cylinder(d = 12, h = 100, $fn = 6, center = true);

        //        for (x = [- w / 2 + 18:20:w / 2 - 16])
        //        for (y = [- l / 2 + 15:13:l / 2 - 16])
        //        translate([x, y, 0])
        //            cylinder(d = 12, h = 100, $fn = 6, center = true);


        for (x = [- w / 2 + 8:20:w / 2 - 8])
        for (y = [8:13:h - 8])
        translate([x, 0, y]) rotate([90, 0, 0])
            cylinder(d = 12, h = l * 2.1, $fn = 6, center = true);

        for (x = [- w / 2 + 18:20:w / 2 - 16])
        for (y = [15:13:h - 16])
        translate([x, 0, y]) rotate([90, 0, 0])
            cylinder(d = 12, h = l * 2.1, $fn = 6, center = true);

        for (x = [8:20:h - 8])
        for (y = [- l / 2 + 8:13:l / 2 - 8])
        translate([0, y, x]) rotate([0, 90, 0])
            cylinder(d = 12, h = l * 2.1, $fn = 6, center = true);

        for (x = [18:20:h - 16])
        for (y = [- l / 2 + 15:13:l / 2 - 16])
        translate([0, y, x]) rotate([0, 90, 0])
            cylinder(d = 12, h = l * 2.1, $fn = 6, center = true);
    }

    translate([-20,40,0])
    difference() {
        translate_z(- 4)
        rounded_rectangle([w, l, h], r = 5);

        translate_z(- 4 + .4)
        rounded_rectangle([w - 2, l - 2, h + .2], r = 5);

        mesh();
        mains_inlet(cutouts = true);
    }

    RPI(stl = true);
    RAMPS(stl = true);
}

module caseLCD(cutouts = false) {
    translate([- 135, - 110, 40])
        rotate([90, 90, 90]) {
            if (cutouts) {
                display_aperture(LCD12864, 0, true);
            } else {
                display(LCD12864);
            }
        }
}

module mains_inlet(cutouts = false) {
    translate([65, 155, 25])
        rotate([0, 90, 0])
            if (!cutouts) {
                iec_assembly(IEC_inlet_atx, 4);
            } else {
                iec_holes(IEC_inlet_atx);
            }
}

module electronics_case_assembly() {
//    electronics_case();


    translate([0, 150, 0])
        rotate([0, 0, 90])
                psu(PD_150_12);

//    translate([5,270,0])
//        rotate([0,0,180])
//            psu(PD_150_12);

    mains_inlet();



    RAMPS();
    RPI();

    RPI(stl = true);
    RAMPS(stl = true);
}

module lcd_holder() {
    module half_sphere(d = 10) {
        difference() {
            sphere(d = d);
            translate_z(-d/2)
            cube([d,d,d], center = true);
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

        translate_z(-.1) {
            nut_d = nut_radius(M4_NUT)*2+.2;
            cylinder(d = 4, h = 21);
            cylinder(d = nut_d, h = 5, $fn = 6);
            translate_z(16)
            cylinder(d = nut_d, h = 5, $fn = 6);

            translate([0, -12, 0]) {
                cylinder(d = 4, h = 21);
                translate_z(6)
                cylinder(d = 9, h = 5);
            }
            translate([0,  12, 0]) {
                cylinder(d = 4, h = 21);
                translate_z(6)
                cylinder(d = 9, h = 5);
            }
        }
    }
}

lcd_holder();



nut(M4_NUT);

//pcb_base(DC_DC_LM2596, 3, 1);
//pcb(DC_DC_LM2596);

//electronics_case_assembly();

//caseLCD();

//sliding_t_nut(M5_sliding_t_nut);
//display(SSD1963_4p3);

//rocker(small_rocker);



//extrusion_corner_bracket_assembly(E20_corner_bracket, grub_screws = true);
