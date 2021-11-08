include <NopSCADlib/utils/core/core.scad>
use <heatbreak.scad>
use <../nozzles/e3d_nozzles.scad>

module mosquito_magnum_hotend_assembly() {
    mosquito_heatbreak_assembly();

    translate_z(-25)
    color("silver")
    rotate([90,0,90])
    import("Mellow_NF_Crazy_heating_block.stl");

    translate_z(-33.5)
    e3d_nozzle_v6();
}

mosquito_magnum_hotend_assembly();
