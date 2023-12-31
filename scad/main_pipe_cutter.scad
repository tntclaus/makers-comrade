include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>


use <NopSCADlib/utils/rounded_polygon.scad>

include <../lib/bearings.scad>

module y_axis() {

}


module roller(bearing = BB625_ZZ, width = 60) {
    stl(str(
    "ABS_","roller_w",width,
    "_b", bb_name(bearing)
    ));

    d_i = bb_diameter(bearing);
    d_i_h = bb_bore(bearing);
    b_width = bb_width(bearing);



    rotate([0,90,0])
    difference() {
        cylinder(d = 50, h = width, center = true);
        cylinder(d = d_i_h + 2, h = width*2, center = true);
        translate_z(width/2)
        cylinder(d = d_i, h = b_width*2, center = true);
        translate_z(-width/2)
        cylinder(d = d_i, h = b_width*2, center = true);
    }
}

module x_axis() {
    roller();
}


//module main_assembly() {
//    x_axis();
//}
//
//if($preview)
//    main_assembly();
