include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>

use <../tooltable.scad>
use <printed_milltable_with_nuts.scad>

include <../../../lib/pronged_t_nuts/pronged_t_nuts.scad>


module router_table_corner_limit(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset
) {
    x_width = tooltable_width(x_work_area_width);
    y_width = tooltable_width(y_work_area_width);

    stl(str("ABS_router_table_corner_limit_", x_width, "x", y_width));


    linear_extrude(5) {
        translate([x_width / 2 - mount_point_offset - TABLE_BASE_BORDER(), - y_width / 2, 0])
            rotate([0, 0, 180])
                tooltable_mount(mount_point_offset, mount_length);

        difference() {
            rounded_square([x_width, y_width], TABLE_BASE_BORDER(), center = true);
            square([x_work_area_width, y_work_area_width], center = true);

            translate([- 80, 0])
                square([x_width + 10, y_width + 10], center = true);

            translate([20, 80])
                square([x_width + 10, y_width + 10], center = true);


            translate(fixture_mount_points(x_width, y_width)[0])
                circle(r = M4_clearance_radius);
        }
    }
}


module router_table_assembly(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3)
{
    assembly("router_table"){
//        tooltable_assembly(
//            x_work_area_width = x_work_area_width,
//            y_work_area_width = y_work_area_width,
//            mount_length = mount_length,
//            mount_point_offset = mount_point_offset,
//            mounts_num = mounts_num) {
//                printed_milltable_with_pronged_nuts(
//                    x_work_area_width,
//                    y_work_area_width,
//                    PRONGED_T_NUT_M4
//                );


//                color("white")
//                translate_z(10)
                router_table_corner_limit(
                    x_work_area_width,
                    y_work_area_width,
                    mount_length,
                    mount_point_offset
                );

//            }
    }
}

router_table_assembly(300, 300, 11.5, 25);
