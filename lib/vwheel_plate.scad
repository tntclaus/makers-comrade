include <NopSCADlib/utils/core/core.scad>
include <geometries.scad>
include <utils.scad>

function vslot_plate_size(geometry) = geometry[0];

module vslot_plate(geometry, center = false, mirror_plate = [0,0,0]) {
    verticles = len(vslot_plate_size(geometry));
    mirror(mirror_plate) {
        if(verticles == 3) {
            triangle_plate(geometry, center) children();
        } else if (verticles == 2) {
            square_plate(geometry, center) children();
        } else if (verticles > 3) {    
            polygon_plate(geometry, center) children();
        } else {
            assert(false, str("Unsupported plate size: ", verticles));
        }
    }
}

module square_plate(geometry, center = false) {
    geom = geometry[0];
    radius = geometry[1];
    plate_thickness = geometry[2];

    
    wheelHoles = geometry[3];
    mountHoles = geometry[4];
    zTranslate = center ? 0 : -plate_thickness/2;

    if(plate_thickness <= 3) {
        dxf(str("gantry_sq_plate_",
            geom[0],
            "x",
            geom[1],
            "x",
            plate_thickness,
            "_",
            len(mountHoles)));
    } else {
        stl(str("gantry_sq_plate_",
            geom[0],
            "x",
            geom[1],
            "x",
            radius,
            "_",
            len(mountHoles)));
    }
    
    rotate([180,0,0])  translate([0,0,plate_thickness])  children();
    translate([0,0,zTranslate]) difference() {
        translate([0,0,0]) rotate([0,0,-90]) {
            rect_geom = [geom[0], geom[1], plate_thickness];
            rounded_rectangle(rect_geom, r = radius, center = true);

        }
        

        renderGantryHoles = true;

        if(renderGantryHoles) {
            drillHoles(wheelHoles, plate_thickness);
            drillHoles(mountHoles, plate_thickness);
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


module polygon_plate(geometry, center = false) {
    geom = geometry[0];
    radius = geometry[1];
    plate_thickness = geometry[2];

    
    wheelHoles = geometry[3];
    mountHoles = geometry[4];
    zTranslate = center ? 0 : -plate_thickness;

    if(plate_thickness <= 3) {
        dxf(str("gantry_poly_plate_",
//            geom[0][0],
            "x",
//            geom[1][0],
            "x",
            plate_thickness,
            "_",
            len(mountHoles)));
    } else {
        stl(str("gantry_poly_plate_",
//            geom[0][0],
            "x",
//            geom[1][0],
            "x",
            radius,
            "_",
            len(mountHoles)));
    }
    
    rotate([180,0,0])  translate([0,0,plate_thickness])  children();
    translate([0,0,zTranslate]) difference() {
        translate([0,0,0]) rotate([0,0,-90]) {
            if(plate_thickness > 0)
                linear_extrude(plate_thickness) rounded_polygon(geom);
            else 
                rounded_polygon(geom);
        }
        

        renderGantryHoles = true;

        if(renderGantryHoles) {
            drillHoles(wheelHoles, plate_thickness);
            drillHoles(mountHoles, plate_thickness);
        }
    } 
}