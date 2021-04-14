include <NopSCADlib/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>


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

    difference() {
        rounded_polygon(BOTTOM_PLATE(width, length, inset_length, inset_depth));
                
        plate_corner_position(width, length, 10)
        mount_magnet_mount_hole(0);
        


    }
}

module toolhead_top_plate_sketch(
        width, inset_length
    ) {

    difference() {
        rounded_polygon(TOP_PLATE(width, inset_length));

        plate_corner_position(width, inset_length, 10)
            mount_magnet_mount_hole(0);
    }    
}
//toolhead_bottom_plate_sketch(44, 100, 80, 4);

module mount_magnet() {
    if(show_magnets) {
        translate_z(2.5)
        screw(M3_cs_cap_screw, 5);
        magnet_round_hole(10,3,3,7);
    }
}



module mount_magnet_mount_hole(thickness) {
    d = 2;
    if(thickness == 0)
        circle(d = d);
    else
        cylinder(d = d, h=thickness*2);
}



module magnet_round_hole(d, h, dia_inner1, dia_inner2) {
    // https://mirmagnitov.ru/product/nyeodimovyy-magnit-disk-10kh3-mm-s-zyenkovkoy-3-5-7-mm-n35uh/
    vitamin(str(
        "Magnet N35UH", "_",
        d, "x", h, "_",
        dia_inner1,"x",dia_inner2
    ));
    
    difference() {
        cylinder(d = d, h = h);

        translate_z(-0.01)
            cylinder(r1 = dia_inner1/2, r2 = dia_inner2/2, h = h+0.02);
    }

}

module magnet_square(
        width, 
        length,
        heigth
) {
    vitamin(str(
        "Magnet", "_",
        width, "x",
        length, "x",
        heigth
    ));
    
    translate_z(heigth/2)
    cube([width, length, heigth], center = true);
}


module toolhead_screw_mount_locations(locations, z = 0) {
    for(location = locations)
        translate([location.x, location.y, z])
        children();
}

