include <NopSCADlib/core.scad>


function chamfered_coordinates(w, l, o) = [
        [ w/2, l/2-o],
        [ w/2-o, l/2],

        [-w/2+o, l/2],
        [-w/2, l/2-o],

        [-w/2, -l/2+o],
        [-w/2+o, -l/2],

        [ w/2-o, -l/2],
        [ w/2, -l/2+o]
    ];

module chamfered_polygon(w, l, o) {
    polygon(chamfered_coordinates(w, l, o));
}

module chamfered_cube(dimensions, o, center = false, convexity = 3) {
    assert(len(dimensions) == 3, "must be 3-dimensional");

    w = dimensions.x;
    l = dimensions.y;
    h = dimensions.z;

    if(!center)
        translate([w/2,l/2,0])
            linear_extrude(h, convexity = convexity)
                chamfered_polygon(w, l, o);
    else
        translate_z(-h/2)
        linear_extrude(h, convexity = convexity)
        chamfered_polygon(w, l, o);
}

/**
* Accepts 2 children:
*/
module chamfer_box(dimensions, thickness, chamfer_angle = 45, chamfer_inside = false, convexity = 3) {
    assert(len(dimensions) == 3, "must be 3-dimensional");

    width = dimensions.x;
    length = dimensions.y;
    heigth = dimensions.z;

    base_offset = tan(chamfer_angle)*thickness;
    base_width = width - base_offset*2;
    base_length = length - base_offset*2;

    assert(base_width >= 0, str("angle must be less than ",chamfer_angle, "; width = ", width, "; base offset = ", base_offset));

    difference() {
        hull() {
            translate_z(thickness-.1/2)
            chamfered_cube([width, length, .1], base_offset, center = true);
            translate_z(.1/2)
            cube([base_width, base_length, .1], center = true);
        }
    }
    echo(tan(chamfer_angle));

//    color("blue")
    translate_z(thickness)
    chamfer_walls([width, length, heigth-thickness], thickness, chamfer_angle = chamfer_angle,chamfer_inside = chamfer_inside, convexity = convexity);
}

module chamfer_walls(dimensions, thickness, chamfer_angle = 45, chamfer_inside = false, convexity = 3) {
    assert(len(dimensions) == 3, str("must be 3-dimensional: ", dimensions));

    width = dimensions.x;
    length = dimensions.y;
    heigth = dimensions.z;
    base_offset = tan(chamfer_angle)*thickness;

    linear_extrude(heigth, convexity = convexity) difference() {
        w = width;
        l = length;
        o = base_offset;
        t = thickness;

        chamfered_polygon(w, l, o);
        if(chamfer_inside)
            chamfered_polygon(w-t*2, l-t*2, o);
        else
            square([w-t*2, l-t*2], center = true);
    }
}


chamfer_walls([50,50,30],3,25);
//chamfer_box([50,50,30],2,45, chamfer_inside = true);
