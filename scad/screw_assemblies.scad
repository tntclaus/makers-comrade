include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>

M4_cs_cap_cross_screw  = [
    "M4_cs_cap_cross","М4 DIN 965/ГОСТ 17475", hs_cs,4, 8.0, 0,    1.49,2.5, 20,  M4_washer, M4_nut,   M4_tap_radius,    M4_clearance_radius];

M5_cs_cap_cross_screw  = [
    "M5_cs_cap_cross","М5 DIN 965/ГОСТ 17475", hs_cs,5, 9.2, 3.65,   0,   0, 0,   M5_washer, M5_nut,   M5_tap_radius,    M5_clearance_radius];

module screwmM3x15(rotation = [0,90,0]) {
    rotate(rotation) {
        screw(M3_hex_screw, 15);
        translate([0,0,-2]) spring_washer(M3_washer);
        translate([0,0,-0.65])  washer(M3_washer);
    }
}

module screwM3x15(rotation = [0,90,0]) {
    rotate(rotation) {
        screw(M3_pan_screw, 15);
        translate([0,0,-2]) spring_washer(M3_washer);
    }
}

//screwmM3x15();
//screwM3x15();