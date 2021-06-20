include <NopSCADlib/core.scad>
//include <NopSCADlib/vitamins/stepper_motors.scad>


//function titan_extruder_width() = 46.5;
function extruder_orbiter_heigth() =35.9;
function extruder_orbiter_depth() = 28.85;

function extruder_orbiter_translate() = [0,-0,0];
function t_e_t() = extruder_orbiter_translate();


module LDO_stepper() {
    color("silver")
    rotate([-90,0,0])
    translate([6.55,-29,-18])
    import("LDO_stepper.stl");
}

module extruder_orbiter(cover = true) {
    translate(extruder_orbiter_translate()) {        
        color("#414141")
        import("extruder_orbiter_1.5.stl");
    }
}

module extruder_orbiter_stepper_position(offset = 0) {
    translate([-6.55,extruder_orbiter_depth(),extruder_orbiter_heigth()/2])
    rotate([90,0,0])    
    children();
}

module extruder_orbiter_hot_end_position() {
    translate([t_e_t().x,t_e_t().y,t_e_t().z])
    children();
}

module extruder_orbiter_mounts() {
    translate([-16.5,-1,0])
    children();
    translate([ 18, 6,0])
    children();
}
//extruder_orbiter();
//extruder_orbiter_mounts() translate_z(-10) cylinder(d = 3, h = 10);
//extruder_orbiter_stepper_position() LDO_stepper();
//extruder_orbiter_hot_end_position() translate_z(-10) cylinder(d = 10, h = 10);
