include <NopSCADlib/utils/core/core.scad>

use <../../../lib/pronged_t_nuts/pronged_t_nut.scad>

module printed_milltable_with_pronged_nuts(
    x_work_area_width,
    y_work_area_width,
    pronged_nut_type,
    heigth = 10
) {
    stl(str(
    "printed_milltable_with_pronged_nuts_", x_work_area_width,
    "x", y_work_area_width, "_M", pronged_t_nut_d(pronged_nut_type)));
//    x_step =

    difference() {
        translate_z(heigth / 2)
        cube([x_work_area_width, y_work_area_width, heigth], center = true);

        for(x = [-x_work_area_width/2+25 : 50 : x_work_area_width/2])
            for(y = [-y_work_area_width/2+25 : 50 : y_work_area_width/2])
                translate([x,y,-0.01]) {
                    pronged_t_nut(pronged_nut_type);
                    cylinder(d = pronged_t_nut_d(pronged_nut_type)+.1, h = heigth*2);
                }
    }
}
