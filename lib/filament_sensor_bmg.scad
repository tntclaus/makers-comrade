

module filament_sensor_bmg_back_plate() {
    translate([7.5, 90, 22.85])
        rotate([0, - 90, 0])
            import("../libstl/filament_sensor_cover_bmg.stl");
}

MOUNT_COORDS = [
        [-29.3,9.5],
        [-15.3,9.5],
        [27.5,9.5],
        [-29.3,-10.85],
        [-15.3,-10.85],
        [27.5,-10.85],
    ];

module filament_sensor_bmg_place_mounts() {
    for(c = MOUNT_COORDS)
    translate([c.x, c.y, 0])
    children();
}

module filament_sensor_bmg_case_contour(d_i, h, d_o = 30) {
    module contour(d, h) {
        hull() {
            translate([- 23.5, - 0.7, 0])
                cylinder(d = d, h = h, center = true);
            translate([21.6, - 0.7, 0])
                cylinder(d = d, h = h, center = true);
        }
    }

    difference() {
        contour(d = d_o, h = h);
        contour(d = d_i, h = h+1);
    }
}
