include <NopSCADlib/utils/core/core.scad>

use <../tooltable.scad>
use <ceramic_granite_heatbed_table.scad>

use <../../../lib/clips.scad>

module heatbed_table_assembly(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3)
{

    module clip() {
        rotate([0,90,0])
        clip_u(w = 27, d = 20, h = 10, th = 2);
    }
    assembly("heatbed_table") {
        tooltable_assembly(
            x_work_area_width = x_work_area_width,
            y_work_area_width = y_work_area_width,
            mount_length = mount_length,
            mount_point_offset = mount_point_offset,
            mounts_num = mounts_num)
                translate_z(5)
                ceramic_granite_heatbed_table(300, 300);

        for(a = [0, 90, 180, 270])
        rotate([0,0,a])
        for(x = [0, 1, -1])
            translate([x*x_work_area_width/4,-y_work_area_width/2-12,13])
                clip();
    }
}

//heatbed_table_assembly(300, 300, 11.5, 25);

clip_u(w = 27, d = 20, h = 10, th = 2);
