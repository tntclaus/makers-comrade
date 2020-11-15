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


LCD12864PCB = ["", "", 78, 70, 1.65, 3, 3, 0, "mediumblue", false, [[3, 3], [-3, 3], [-3, -3], [3, -3]],
    [ [2.75 + 1.27, 37, 90, "2p54header", 20, 2]
    ],
    []];

LCD12864 = ["LCD12864", "LCD display 12864\"", 68, 44, 3.4, LCD12864PCB,
        [0, 0, 0],
        [[-68 / 2, -22], [68 / 2, 22, 0.5]],
        [[-68 / 2, -44 / 2 + 1], [68 / 2, 44 / 2 + 1, 1]],
        0,
        [[0, -34.5], [12, -31.5]],
        ];


ArduinoMega = [
    "ArduinoMega", 
    "Arduino Mega 256", 
    101.6,  53.34, 1.6, 0, 3.3, 0, "#2140BE", false, 
    [
    [15.24, 50.8],    [-9.64, 50.8],
    [66.04, 35.56],    [66.04, 7.62],
    [13.97, 2.54],     [-3.4, 2.54]
    ],
    [[30.226, -2.54, 0, "2p54socket", 10, 1],
     [54.61,  -2.54, 0, "2p54socket", 8, 1],
     [79.61,  -2.54, 0, "2p54socket", 8, 1],
     [96.31,  28.64, 90, "2p54socket", 18, 2],     
     [36.83,   2.54, 0, "2p54socket", 8, 1],
     [57.15,   2.54, 0, "2p54socket", 6, 1],
     [79.61,   2.54, 0, "2p54socket", 8, 1],
     [64.91,  27.89, 0, "2p54header", 2, 3],
     [18.796, -7.00, 0, "2p54header", 3, 2],
     [ 6.5,   -3.5,  0, "button_6mm"],
     [4.7625,  7.62, 180,"barrel_jack"],
     [1.5875, 37.78, 180,"usb_B"],
     [49.9, -22.0,   0, "chip", 20, 20, 2],
    ],
    [],[],
    inch([
     [-2, -1.05],
     [-2,  1.05],
     [ 1.84,  1.05],
     [ 1.9,  0.99],
     [ 1.9,  0.54],
     [ 2,  0.44],
     [ 2, -0.85],
     [ 1.95, -0.95],
     [ 1.95, -1.05],
    ]),
    M2p5_pan_screw
   ];

RAMPS_1_4 = [
    "RAMPS_1_4", 
    "RAMPS v1.4", 
    101.6,
    59.34, 1.6, 0, 3.3, 0, "#2140BE", false, 
    [
    [15.24, 53.8],  [-3.4, 5.54]
    ],
    [
        [ 9, 10,  180, "gterm635", 2, 2],
        [ 14, 28,  180, "gterm635", 2, 2],        
    ],
    [],[],
    inch([
     [-2, -1.15],
     [-2,  1.05],
     [ 2,  1.05],
     [ 2,  0.44],
     [ 2, -1.15],
    ]),
    M2p5_pan_screw
   ];

module RAMPS(stl = false) {
    translate([50,-30,0])
    if(!stl) {
        pcb_assembly(ArduinoMega, 4, 4);
        translate_z(16) 
        pcb(RAMPS_1_4);
    } else {
        translate_z(-4)
        pcb_base(ArduinoMega, 8, 4);    
    }
}

module RPI(cutouts = false, stl = false) {
    translate([-52,72,0])
    rotate([0,0,180]) {
        if(cutouts) {
            translate_z(4)
            difference() {
                pcb_cutouts(RPI3);
                translate([-100,10,0])
                cube([1000,100,1000]);
                
                translate([-100,200,0])
                cube([200,1000,1000]);

                translate([-180,-200,0])
                cube([200,1000,1000]);
            }
        } else {
            if(!stl) {
                pcb_assembly(RPI3, 4, 4);    
            } else {
                translate_z(-4)
                pcb_base(RPI3, 8, 4);
            }

        }
    }
}

module electronics_case() {
    r = 5;
    points = [
        [-132,  48,   r],
        [-132,   62-r,  r],
        [-102-r, 62+r, -r],
        [-102+r,  352,  r],
        [122,352, r],
        [122,-62, r],
        [-2,-62, r],
    ];

    points2 = [
        [-130,  50,   r],
        [-130,   60-r,  r],
        [-100-r, 60+r, -r],
        [-100+r,  350,  r],
        [120,350, r],
        [120,-60, r],
        [0,-60, r],
    ];

    difference() {
        translate_z(-4)
        linear_extrude(60)
        rounded_polygon(points);

        translate_z(-2)
        linear_extrude(60)
//        resize([250 + 2*r - 4, 410  + 2*r - 6, 0])
        rounded_polygon(points2);
        
//        caseLCD(true);
        RPI(true);
        
        mains_inlet(cutouts = true);
    }
    
    RPI(stl = true);
    RAMPS(stl = true);
}

module caseLCD(cutouts = false) {
    translate([-135, -110, 40])
    rotate([90,90,90]) {
        if(cutouts) {
            display_aperture(LCD12864, 0, true);
        } else {
            display(LCD12864);
        }
    }
}

module mains_inlet(cutouts = false) {
    translate([125,335,25])
    rotate([0,90,0])
    if(!cutouts) {
    iec_assembly(IEC_inlet_atx, 4);
    } else {
        iec_holes(IEC_inlet_atx);
    }
}

module electronics_case_assembly() {
    electronics_case();
    
    RAMPS();
    RPI();

    translate([5,160,0])
    rotate([0,0,180])
    psu(PD_150_12);

    translate([5,270,0])
    rotate([0,0,180])
    psu(PD_150_12);
    
    mains_inlet();
}



//case_assembly();

electronics_case();

//caseLCD();

//sliding_t_nut(M5_sliding_t_nut);
//display(SSD1963_4p3);

//rocker(small_rocker);



//extrusion_corner_bracket_assembly(E20_corner_bracket, grub_screws = true);