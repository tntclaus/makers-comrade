include <NopSCADlib/vitamins/extrusions.scad>
include <vwheel_gantries.scad>

VSLOT_RAIL_2020_S = ["", S_20_TRIANGLE_GANTRY, E2020];
VSLOT_RAIL_2040_S = ["", S_40_TRIANGLE_GANTRY, E2040];
VSLOT_RAIL_2040_SH = ["", S_20_TRIANGLE_GANTRY, E2040];
VSLOT_RAIL_2020_D = ["", D_20_TRIANGLE_GANTRY, E2020];
VSLOT_RAIL_2040_D = ["", D_40_TRIANGLE_GANTRY, E2040];



use <vslot_rail.scad>

//vslot_rail(VSLOT_RAIL_2040_SH, 200)   {
//    translate([0,0,10]) cube(20, center=true);
//}