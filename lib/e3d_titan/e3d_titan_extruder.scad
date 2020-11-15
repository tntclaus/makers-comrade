include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/hot_ends.scad>



module titan_extruder() {
    color("#eaeaea", 0.3)
    import("e3d_titan_cover.stl");
    
    color("#414141")
    import("e3d_titan_base.stl");
}

module titan_stepper_position(offset = 3) {
    translate([0,-offset,0])
    rotate([-90,0,0])
    children();
}

module titan_hot_end_position() {
    translate([-10.9,13.6,-11.65])
    children();
}


//titan_stepper_position() NEMA(NEMA17S);
//
//titan_hot_end_position() hot_end(E3Dv6, 1.75, naked = true);
//
//titan_extruder();