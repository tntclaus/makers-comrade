include <NopSCADlib/core.scad>


module clip_u(w, d, h, th) {
    stl(str("clip_u_W", w, "xH", h, "xD", d, "xTh", th));
    difference() {
        cube([w + th * 2, d, h]);
        translate([th, th, -th])
        cube([w, d, h + th * 2]);
    }
}


