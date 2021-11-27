

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/quadrant.scad>

use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <axes/carets.scad>

include <utils.scad>

use <axes/x-axis.scad>

use <fan_duct/fan_duct.scad>


// Hot end descriptions
//
//                        s       p                    l    i    d      i l  c           s g    g     d   d              d a   d a
//                        t       a                    e    n    i      n e  o           c r    r     u   u              u t   u t
//                        y       r                    n    s    a      s n  l           r o    o     c   c              c     c
//                        l       t                    g    e           u g  o           e o    o     t   t              t n   t f
//                        e                            t    t           l t  u           w v    v                          o     a
//                                                     h                a h  r             e    e     r   o              h z   h n
//                                                                      t                p            a   f              e z   e
//                                                                      o                i d    w     d   f              i l   i
//                                                                      r                t i    i     i   s              g e   g
//                                                                                       c a    d     u   e              h     h
//                                                                                       h      t     s   t              t     t
//                                                                                              h
//
E3DVulcano= ["E3D Volcano", e3d, "E3D Volcano direct",  62,  3.7, 16,  42.7, "silver",   12,    6,    15, [1, 5,  -4.5], 14,   21];


internal_face_w = 38;
rad_dia = 23; // Diam of the part with ailettes
rad_nb_ailettes = 11;
rad_len = 26;

nozzle_h = 5;

heater_width  = 5.75*2;
heater_length = 21.2;
heater_height = 20;

heater_x = -15.5 + heater_length;
heater_y = heater_width / 2;

module nozzle_cooler_top_stl(stl = true) {
    difference() {
        nozzle_cooler(E3DVulcano, stl);
        translate([0,0,-55])
        color("black")
        cube([120,120,20], center = true);
    }
}

module nozzle_cooler_bottom_stl(stl = true) {
    l = (heater_length+15)/2-2;
    w = 7-2;
    translate([48.5,0,-44])
    tube_adapter_square2square([w,l,1], [w+2,l+2,10], 2, 2, 0);
    difference() {
        nozzle_cooler(E3DVulcano, stl);
        translate([0,0,-7.5+10])
        color("black")
        cube([120,120,95], center = true);
    }
}



module e3d_hot_end_cooler_assembly() {
    volcano_hot_end(E3DVulcano, 1.75, naked = true);
//    volcano_heater_block(E3DVulcano, naked = true);
}


module volcano_hot_end(type, filament, naked = false, resistor_wire_rotate = [0,0,0], bowden = false) {
    insulator_length = hot_end_insulator_length(type);
    inset = hot_end_inset(type);
    h_ailettes = rad_len / (2 * rad_nb_ailettes - 1);

    vitamin(str("e3d_hot_end(", type[0], ", ", filament, "): Hot end ", hot_end_part(type), " ", filament, "mm"));

    translate_z(inset - insulator_length)
        color(hot_end_insulator_colour(type))
            rotate_extrude()
                difference() {
                    union() {
                        for (i = [0 : rad_nb_ailettes - 1])
                            translate([0, (2 * i) * h_ailettes])
                                square([rad_dia / 2, h_ailettes]);

                        square([hot_end_insulator_diameter(type) / 2,  insulator_length]);

                        translate([0, -10])
                            square([2, 10]);
                    }
                    square([3.2 / 2, insulator_length]);  // Filament hole

                    translate([hot_end_groove_dia(type) / 2, insulator_length - inset - hot_end_groove(type)])
                        square([100, hot_end_groove(type)]);
            }

    if(bowden)
        translate_z(inset)
            bowden_connector();

    volcano_heater_block(type, naked, resistor_wire_rotate);

    if(!naked)
        translate_z(inset - insulator_length)
            e3d_fan();
}

module volcano_heater_block(type, naked = false, resistor_wire_rotate = [0,0,0]) {

    translate_z(-hot_end_length(type))  {
        translate_z(nozzle_h)
            color("lightgrey")
                translate([-heater_x, -heater_y, -heater_height + 11.5])
                    cube([heater_length, heater_width, heater_height]);

        translate([4,10.75,5])
        rotate([90,0,0])
        e3d_resistor(type, naked, resistor_wire_rotate);
        translate_z(-heater_height + 11.5)
        e3d_nozzle(type);
    }
}

e3d_hot_end_cooler_assembly();
//nozzle_cooler_top_stl(true);
//nozzle_cooler_bottom_stl(true);

//nozzle_cooler_stl(false);
