include <vwheels.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>

M5_dome_screw    = ["M5_dome", "M5 dome",       hs_dome,  5, 8.5, 2.5,  1.5, 3, 22,  M5_washer, M5nS_thin_nut,   M5_tap_radius,    M5_clearance_radius];


S_XTREME_VW_SPACER = ["", 6, false, S_XTREME_2RS, M5_dome_screw, false];
S_XTREME_VW_ECCENT = ["", 6, true, S_XTREME_2RS, M5_dome_screw, false];
D_XTREME_VW_SPACER = ["", 6, false, S_XTREME_2RS, M5_dome_screw, true];
D_XTREME_VW_ECCENT = ["", 6, true, S_XTREME_2RS, M5_dome_screw, true];


use <vwheel_assembly.scad>

module gantry_cart_spacer_6_35_stl() spacer(6.35);
module gantry_cart_spacer_6_stl() spacer(6);

//vwheel_assembly(D_XTREME_VW_ECCENT);
//vwheel_assembly(S_XTREME_VW_ECCENT);