include <NopSCADlib/utils/core/core.scad>
use <../lib/utils.scad>

module pulley_spacer(h) {
    stl_name = str(
    "ABS_pulley_spacer_",
    str(str_replace(h, ".", "_"))
    );
    stl(stl_name);

    color("teal") translate_z(h / 2)
    difference() {
        cylinder(d = 7, h = h, center = true);
        cylinder(d = 4.1, h = h + .1, center = true);
    }
}
