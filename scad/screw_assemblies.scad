include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>


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