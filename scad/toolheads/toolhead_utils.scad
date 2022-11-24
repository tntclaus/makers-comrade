include <NopSCADlib/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>
include <../../lib/utils.scad>

show_magnets = true;
TOOLHEAD_PLATES_BELT_INSET = 10;

function BOTTOM_PLATE(width, length, inset_length, inset_depth, belt_inset = TOOLHEAD_PLATES_BELT_INSET, r = 1) = [
    [-(length-r*2)/2, (width-r*2)/2, r],

    // карман
    [-(length+2)/2+(length-inset_length)/2, (width-2)/2, 1],
    [-(length-2)/2+(length-inset_length)/2, (width-2)/2-(inset_depth-2), -1],
    [ (length-2)/2-(length-inset_length)/2, (width-2)/2-(inset_depth-2), -1],
    [ (length+2)/2-(length-inset_length)/2, (width-2)/2, 1],


    // вершина X+ Y+
    [ (length-r*2)/2, (width-r*2)/2, r],

    // вырез под ремни
    [ (length-r*2)/2, (width-r*2)/2 - belt_inset, r],
    [ (length-r*2)/2 - belt_inset + r, (width-r*2)/2 - belt_inset - r*2 - inset_depth/2, -r],
    [ (length-r*2)/2 - belt_inset + r, -(width-r*2)/2 + belt_inset + r*2 + inset_depth/2, -r],
    [ (length-r*2)/2,-(width-r*2)/2 + belt_inset, r],

    // вершина X+ Y-
    [ (length-r*2)/2,-(width-r*2)/2, r],

    // карман
    [ (length+2)/2-(length-inset_length)/2, -(width-2)/2, 1],
    [ (length-2)/2-(length-inset_length)/2, -(width-2)/2+(inset_depth-2), -1],
    [-(length-2)/2+(length-inset_length)/2, -(width-2)/2+(inset_depth-2), -1],
    [-(length+2)/2+(length-inset_length)/2, -(width-2)/2, 1],

    // вершина X- Y-
    [-(length-r*2)/2,-(width-r*2)/2, r],

    // вырез под ремни
    [-(length-r*2)/2,                 -(width-r*2)/2 + belt_inset, r],
    [-(length-r*2)/2 + belt_inset - r,-(width-r*2)/2 + belt_inset + r*2 + inset_depth/2, -r],
    [-(length-r*2)/2 + belt_inset - r, (width-r*2)/2 - belt_inset - r*2 - inset_depth/2, -r],
    [-(length-r*2)/2,                  (width-r*2)/2 - belt_inset, r],
];

function TOP_PLATE(width, length, r = 1) = [
    [-(length-r*2)/2, (width-r*2)/2, r],
    [ (length-r*2)/2, (width-r*2)/2, r],
    [ (length-r*2)/2,-(width-r*2)/2, r],
    [-(length-r*2)/2,-(width-r*2)/2, r],
];


function PLATE_SCREW_CONNECTORS(width, length, padding) = [
    [-(length-padding)/2, (width-padding)/2, 0],
    [ (length-padding)/2, (width-padding)/2, 0],
    [ (length-padding)/2,-(width-padding)/2, 0],
    [-(length-padding)/2,-(width-padding)/2, 0],
];


function hose_position(length, hose_size, y_shift = 0, m = -1) = [m*(length/2-hose_size/2-4.5-TOOLHEAD_PLATES_BELT_INSET),y_shift,0];

module plate_corner_position(width, length, padding) {
    for(position = PLATE_SCREW_CONNECTORS(width, length, padding))
        translate(position)
        children();
}


module toolhead_bottom_plate_sketch(
    width,
    length,
    inset_length,
    inset_depth) {

    rounded_polygon(BOTTOM_PLATE(width, length, inset_length, inset_depth));
}

module toolhead_top_plate_sketch(
        width, inset_length
    ) {
    rounded_polygon(TOP_PLATE(width, inset_length));
}
//toolhead_bottom_plate_sketch(44, 100, 80, 4);

module mount_magnet() {
    if(show_magnets) {
        translate_z(2.5)
        screw(M3_cs_cap_screw, 5);
        magnet_round_hole(10,3,3,7);
    }
}



//module mount_magnet_mount_hole(thickness) {
//    d = 2;
//    if(thickness == 0)
//        circle(d = d);
//    else
//        cylinder(d = d, h=thickness*2);
//}


module magnet_round_hole(d, h, dia_inner1, dia_inner2) {


    difference() {
        cylinder(d = d, h = h);

        translate_z(-0.01)
            cylinder(r1 = dia_inner1/2, r2 = dia_inner2/2, h = h+0.02);
    }

}




module toolhead_screw_mount_locations(locations, z = 0) {
    for(location = locations)
        translate([location.x, location.y, z])
        children();
}

piezo_disc_thick = 0.45;
PIEZO_DISC_TH = 0.45;

PIEZO_DISC_DIA = 16;
PIEZO_DISC_DIA_MAX = 25.5;

module piezo_disc(d = 20) {
    vitamin(str("piezo_disc_d", d));

    difference() {
        union() {
            translate_z(0.25)
            cylinder(d = d, h = 0.2);
            translate_z(0)
            color("white")
            cylinder(d = PIEZO_DISC_DIA, h = 0.25);
        }
        cylinder(d = 4, h = 1, center = true);
    }
}

module ABS_toolhead_piezo_groove_20x16x2_1_stl() {
    $fn=180;
    toolhead_piezo_groove(d_out = 20, d_in = 16, h = 2.1);
}

module toolhead_piezo_groove(
    d_out = 20,
    d_in = 16,
    h = 2.1
) {

    stl_name = str(
    "ABS_toolhead_piezo_groove", "_",
    d_out, "x", d_in, "x", str_replace(h, ".", "_")
    );
    stl(stl_name);

    difference() {
        cylinder(d = d_out,h = h, center = true);
        cylinder(d = d_in,h = h + .1, center = true);
    }
}
