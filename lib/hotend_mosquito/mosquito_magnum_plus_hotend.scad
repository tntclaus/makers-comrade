include <NopSCADlib/utils/core/core.scad>
use <heatbreak.scad>
use <../nozzles/e3d_nozzles.scad>

module mosquito_magnum_plus_hotend_assembly() {
    mosquito_heatbreak_assembly();

    translate_z(-30.5)
    color("silver")
    rotate([90,0,0])
    import("slice_magnum_plus_heatblock.stl");

//    translate_z(-33.5)
    translate_z(-52.5)
    e3d_nozzle_v6();
}

//mosquito_magnum_plus_hotend_assembly();
