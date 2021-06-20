include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/hot_ends.scad>


function titan_extruder_width() = 46.5;
function titan_extruder_heigth() =60.5;
function titan_extruder_depth() = 24.9;

function titan_extruder_translate() = [10.9,-13.6,8];
function t_e_t() = titan_extruder_translate();

function titan_extruder_cover_hole1() = [t_e_t().x-15.525,t_e_t().y-15.48,0];
function titan_extruder_cover_hole2() = [t_e_t().x+15.525,t_e_t().y-15.48,0];
function titan_extruder_cover_hole3() = [t_e_t().x+15.525,t_e_t().y+15.48,0];
function titan_extruder_cover_hole4() = [t_e_t().x-21.7,  t_e_t().y+14.7,0];

function titan_extruder_cover_holes_coords() = [
        titan_extruder_cover_hole1(),
        titan_extruder_cover_hole2(),
        titan_extruder_cover_hole3(),
        titan_extruder_cover_hole4()
    ];


module titan_extruder(cover = true) {
    if(cover) {
        color("#eaeaea", 0.3)
        titan_extruder_cover();
    }

    translate(titan_extruder_translate()) {        
        color("#414141")
        import("e3d_titan_base.stl");
    }
}

module titan_extruder_cover() {
    color("white")
    translate(titan_extruder_translate())
    import("e3d_titan_cover.stl");
}



module titan_stepper_position(offset = 3) {
    translate([0,-offset,0.5])
    translate(titan_extruder_translate())
    rotate([-90,0,0])    
    children();
}

module titan_hot_end_position() {
    translate([t_e_t().x-10.9,t_e_t().y+13.6,t_e_t().z-11.65])
    children();
}

module titan_extruder_cube() {
    width = titan_extruder_width();
    heigth = titan_extruder_heigth();    
    depth = titan_extruder_depth();
    union() {
        translate([-width/2-2.5,0,-heigth/2+9.5])
        cube([width,depth,heigth]);

        translate([-16,3.6,15.6])
        rotate([-90,0,0])
        cylinder(d = 34, h = 6);
        
        color("red")
        rotate([90,0,0])
        cylinder(d = 16, h = 6);
    }
    

}


module titan_extruder_hull(
    wheel_dia = 35,
    shaft_dia = NEMA_body_radius(NEMA17S),
    shaft_depth = 6,
    spring_wheel_dia = 16,
    spring_wheel_depth = 30,
    throat_dia = 23,
    throat_depth = 20
) {
//    render()
    union() {
        scale([1.01,1.01,1.01])
        hull() {
            import("e3d_titan_cover.stl");
            import("e3d_titan_base.stl");
        }
        color("#00bb00")
        translate([-16,3.6,15.6])
        rotate([-90,0,0])
        cylinder(d = wheel_dia, h = 6);
        
        color("red")
        rotate([90,0,0])
        cylinder(d = shaft_dia, h = shaft_depth);

        color("orange")
        translate([18,13.6,23])
        rotate([0,90,0])
        cylinder(d = spring_wheel_dia, h = spring_wheel_depth);

        color("orange")
        translate([18,13.6,23])
        rotate([0,90,0])
        cylinder(d = spring_wheel_dia, h = spring_wheel_depth);


        color("silver")
        translate([-10.95,13.6,-20])
        rotate([0,180,0])
        cylinder(d = throat_dia, h = throat_depth);
        
        titan_stepper_position() {
            NEMA_screw_positions(NEMA17S) {
                translate([0,0,-10])
                cylinder(d = 4, h = 20);
            }
        }
    }
}

module titan_extruder_cover_hole(index) {
        translate([0,titan_extruder_depth(),0])
        rotate([-90,0,0])
        translate(titan_extruder_cover_holes_coords()[index]) children();    
}

module titan_extruder_cover_holes() {
    for(hole = titan_extruder_cover_holes_coords())
        translate([0,titan_extruder_depth(),0])
        rotate([-90,0,0])
        translate(hole) children();
}
//titan_extruder();
//titan_stepper_position() NEMA(NEMA17S);
//titan_hot_end_position() hot_end(E3Dv6, 1.75, naked = true);
//
//include <NopSCADlib/utils/core/rounded_rectangle.scad>
//
//
//
//
//titan_extruder_hull();
//titan_extruder_cube();
//titan_extruder_cover();
//titan_extruder_cover_holes() 
//    color("red")
//    cylinder(d = 3, h = 20);