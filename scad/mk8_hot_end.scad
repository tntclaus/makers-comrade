include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/hot_ends.scad>
include <NopSCADlib/vitamins/tubings.scad>
include <NopSCADlib/vitamins/zipties.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <NopSCADlib/utils/rounded_polygon.scad>

MK8_HE     = ["MK8",     e3d,   "MK8 direct",       62,  3.7, 16,  42.7, "silver",   12,    6,    15, [1, 5,  -4.5], 14,   21];


use <NopSCADlib/utils/tube.scad>

rad_dia = 22; // Diam of the part with ailettes
rad_nb_ailettes = 11;
rad_len = 26;

nozzle_h = 5;

module e3d_nozzle(type) {
    color(brass) {
        rotate_extrude()
            polygon([
                [0.2,  0],
                [0.2,  2],
                [1.5,  2],
                [0.65, 0]
            ]);

        translate_z(2)
            cylinder(d = 8, h = nozzle_h - 2, $fn=6);
    }
}

resistor_len = 22;
resistor_dia = 6;

heater_width  = 16;
heater_length = 20;
heater_height = 11.5;

heater_x = 4.5;
heater_y = heater_width / 2;

fan_x_offset = rad_dia / 2 + 4;

module e3d_resistor(type, naked = false, resistor_wire_rotate = [0,0,0]) {
    translate([11 - heater_x, -3 - heater_y, heater_height / 2 + nozzle_h]) {
        color("grey")
            rotate([-90, 0, 0])
                cylinder(r = resistor_dia / 2, h = resistor_len);

        if(!naked)
            color("red")
                translate([0, resistor_len + 3.5/2 + 1, 0]) {
                rotate(resistor_wire_rotate) {
                    translate([-3.5/2, 0, 0]) {
                        cylinder(d = 3.5, h = 36);

                        translate([3.5, 0, 0])
                            cylinder(r = 3.5 / 2, h = 36);
                    }
                }
            }
    }
}

module heater_block(type, naked = false, resistor_wire_rotate = [0,0,0]) {
    translate_z(-hot_end_length(type))  {
        translate_z(nozzle_h)
            color("lightgrey")
                translate([-heater_x, -heater_y, 0])
                    cube([heater_length, heater_width, heater_height]);

        e3d_resistor(type, naked, resistor_wire_rotate);
        e3d_nozzle(type);
    }
}



module mk8_fan_duct(type) {
    radiator_path = [
        for (y = [0 : 3 : 39]) each [
        [0, 0+y, 0], 
        [10, 0+y, 0], 
        [10, 1+y, 0], 
        [2, 1+y, 0], 

        [2, 2+y, 0], 
        [10, 2+y, 0], 
        [10, 3+y, 0], 
        [0.01, 3+y, 0], 
        ]
    ];

//    echo (radiator_path);
    color("#ff9000")
    render() difference() {
        union() {
            translate([-12, -42 / 2 - 7, 0])
                cube([16.5, 42, 42]);

            translate([-11.5+16, -42 / 2 - 7, 0]) 
                linear_extrude(42) 
                    rounded_polygon(radiator_path);
        }
       cylinder(d = 6, h = 200);

//        translate_z(20)
//            rotate([0, 90, 0])
//                cylinder(d = 35, h = 150);
    }
}

module mk8_fan(type) {
    mk8_fan_duct(type);

    translate([fan_x_offset + 5 + eps, -7, 20])
        rotate([0, 90, 0])
             not_on_bom()
                fan(fan40x11);
}

module mk8_hot_end(type, filament, naked = false, resistor_wire_rotate = [-40,30,0]) {
    insulator_length = hot_end_insulator_length(type);
    inset = hot_end_inset(type);
    h_ailettes = rad_len / (2 * rad_nb_ailettes - 1);

    vitamin(str("mk8_hot_end(", type[0], ", ", filament, "): Hot end ", hot_end_part(type), " ", filament, "mm"));

    translate_z(inset - insulator_length - 30)
        color(hot_end_insulator_colour(type))
            cylinder(d = 6, h = 35);

    rotate(180)
        translate_z(-25)
            heater_block(type, naked, resistor_wire_rotate);

    if(!naked)
        translate_z(inset - insulator_length)
            mk8_fan();
}

module mk8_hot_end_assembly() {
    translate_z(-3) {
        mk8_hot_end(MK8_HE, 1.7, false);
        translate([-12,-7,-18]) rotate([0,90,0]) 
            not_on_bom() NEMA(NEMA17M);
    }
}