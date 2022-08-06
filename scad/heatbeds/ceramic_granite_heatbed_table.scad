include <NopSCADlib/utils/core/core.scad>

module ceramic_granite_heatbed_table(
    x_work_area_width,
    y_work_area_width,
    thickness = 8
) {
    vitamin(
        str("heatbed_table_ceramic_granite: Ceramic Granite Tile ",
            x_work_area_width, "x", y_work_area_width, "x",
            thickness, "mm"
        )
    );
    translate_z(thickness/2)
    color("#333333")
    cube([x_work_area_width,y_work_area_width, thickness], center = true);
}
