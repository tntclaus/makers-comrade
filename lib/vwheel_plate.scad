include <NopSCADlib/utils/core/core.scad>
include <geometries.scad>
include <utils.scad>

function vslot_plate_size(geometry) = geometry[0];

/**
 * First object should be 2D, will be subtracted from plate sketch.
 * Don't pass 3D objects as child == 0.
 */
module vslot_plate(geometry, center = false, mirror_plate = [0,0,0]) {
    verticles = len(vslot_plate_size(geometry));
    mirror(mirror_plate) {
        if(verticles == 3) {
            triangle_plate(geometry, center) {
                children(0);
                if($children > 1)
                    children([1:$children-1]);
            }
        } else if (verticles == 2) {
            square_plate(geometry, center) {
                children(0);
                if($children > 1)
                    children([1:$children-1]);
            }
        } else if (verticles > 3) {
            polygon_plate(geometry, center) {
                children(0);
                if($children > 1)
                    children([1:$children-1]);
            }
        } else {
            assert(false, str("Unsupported plate size: ", verticles));
        }
    }
}

module square_plate_sketch(geometry, center = false) {
    geom = geometry[0];
    radius = geometry[1];


    wheelHoles = geometry[3];
    mountHoles = geometry[4];


    rect_geom = [geom[0], geom[1]];
    difference() {
        rotate([0,0,-90])
        rounded_square(rect_geom, r = radius, center = true);

        drillHoles(wheelHoles, 0);
        drillHoles(mountHoles, 0);

        children();
    }
}

module square_plate(geometry, center = false) {
    geom = geometry[0];
    radius = geometry[1];
    plate_thickness = geometry[2];


    wheelHoles = geometry[3];
    mountHoles = geometry[4];
    zTranslate = center ? 0 : -plate_thickness/2;


    translate([0,0,zTranslate])  {
        translate_z(-plate_thickness/2)
        linear_extrude(plate_thickness)
        square_plate_sketch(geometry, center = true)
        children(0);

        if($children > 1) {
            children([1:$children - 1]);
        }
    }

}

module triangle_plate(geometry, center = false) {
    tri_geom = geometry[0];
    radius = geometry[1];
    plate_thickness = geometry[2];

    wheelHoles = geometry[3];
    mountHoles = geometry[4];

    zTranslate = center ? 0 : -plate_thickness/2;

    rotate([180,0,0])  translate([0,0,plate_thickness])  children();
    translate([0,0,zTranslate]) difference() {
        translate([5,0,0]) rotate([0,0,-90]) {
            triangle(tri_geom, r = radius, h = plate_thickness, center = true);
        }


        renderGantryHoles = true;

        if(renderGantryHoles) {
            drillHoles(wheelHoles, plate_thickness);
            drillHoles(mountHoles, plate_thickness);
        }
    }
}

/**
 * Difference on 2D children. Don't pass 3D objects as children.
 */
module polygon_plate_sketch(geometry, center = false) {
    geom = geometry[0];
    radius = geometry[1];


    wheelHoles = geometry[3];
    mountHoles = geometry[4];



    difference() {
        rotate([0,0,-90]) {
            rounded_polygon(geom);
        }

        drillHoles(wheelHoles, 0);
        drillHoles(mountHoles, 0);

        children();
    }
}

/**
 * First object should be 2D, will be subtracted from sketch.
 Don't pass 3D objects as child == 0.
 */
module polygon_plate(geometry, center = false) {
    plate_thickness = geometry[2];
    zTranslate = center ? 0 : -plate_thickness;

    translate_z(zTranslate)
    linear_extrude(plate_thickness, convexity = 3)
    polygon_plate_sketch(geometry, center)
    children(0);

    if($children > 1) {
        children([1:$children - 1]);
    }
}
