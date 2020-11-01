include <NopSCADlib/utils/core/core.scad>


include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>


include <NopSCADlib/vitamins/displays.scad>

include <screw_assemblies.scad>

include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/rockers.scad>
include <NopSCADlib/vitamins/iecs.scad>


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

module cncController() {
    pcb(ArduinoMega);
    translate_z(12) pcb(RAMPS_1_4);
}


//cncController();

//sliding_t_nut(M5_sliding_t_nut);
//display(SSD1963_4p3);

rocker(small_rocker);

translate([50,0,0]) iec_assembly(IEC_inlet_atx, 4);

//extrusion_corner_bracket_assembly(E20_corner_bracket, grub_screws = true);