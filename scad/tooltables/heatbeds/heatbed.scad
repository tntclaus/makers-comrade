include <NopSCADlib/utils/core/core.scad>

use <../tooltable.scad>
use <ceramic_granite_heatbed_table.scad>

module heatbed_table_assembly(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3)
{
    assembly("heatbed_table"){
        tooltable_assembly(
            x_work_area_width = x_work_area_width,
            y_work_area_width = y_work_area_width,
            mount_length = mount_length,
            mount_point_offset = mount_point_offset,
            mounts_num = mounts_num)
                ceramic_granite_heatbed_table(300, 300);
    }
}

//heatbed_table_assembly(300, 300, 11.5, 25);
