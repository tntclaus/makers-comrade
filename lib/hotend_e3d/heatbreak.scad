include <NopSCADlib/core.scad>



module e3d_v6_heatbreak(filament) {
    rad_dia = 22; // Diam of the part with ailettes
    rad_nb_ailettes = 11;
    rad_len = 26;

    hot_end_insulator_diameter = 16;
    hot_end_groove_dia = 12;
    hot_end_groove = 6;
    insulator_length = 42.7;
    inset = 3.7;
    h_ailettes = rad_len / (2 * rad_nb_ailettes - 1);

    vitamin(str("e3d v6 radiator, ", filament, "mm"));

    translate_z(inset - insulator_length)
    color("silver")
        render()
            rotate_extrude()
                difference() {
                    union() {
                        for (i = [0 : rad_nb_ailettes - 1])
                        translate([0, (2 * i) * h_ailettes])
                            square([rad_dia / 2, h_ailettes]);

                        square([hot_end_insulator_diameter / 2, insulator_length]);

                        translate([0, - 10])
                            square([2, 10]);
                    }
                    square([3.2 / 2, insulator_length]);  // Filament hole

                    translate([hot_end_groove_dia / 2, insulator_length - inset - hot_end_groove])
                        square([100, hot_end_groove]);
                }
}
