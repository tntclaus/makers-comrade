

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

//                                              corner  body    boss    boss          shaft
//                               side, length, radius, radius, radius, depth, shaft, length,      holes
NEMA17HS4023 = ["NEMA17HS4023",  42.3,  23,     53.6/2, 25,     11,     2,     5,     22,          31 ];

module bltouch() {
    color("white")
    render()
    translate([-1.3505,-0.013,-42])
    rotate([0,0,90])
    import("/Users/klaus/git/zap/3d-printers-and-cnc/3dprinter-i1/libstl/3dtouch_Probe.stl");
}


module titan_cover() {
    color("orange")
    render()
    translate([-6.5,94.4,12])
    rotate([-90,90,0])
    import("../libstl/titan_vslot_bltouch_noctua_v2/Cover_titan.stl");
}

module titan_cover_e3d() {
    color("teal")
    render()
    translate([4.3,5.3,3])
    rotate([90,0,0])
    import("../libstl/titan_vslot_bltouch_noctua_v2/Cover_e3d.stl");
}

module titan_adapt_carriage() {
    render()
    rotate([90,0,0])
    translate([0,320,-57.9])
    import("../libstl/titan_vslot_bltouch_noctua_v2/Adapt_carriage.stl");
}


module titan_carriage() {    
    titan_adapt_carriage();
    titan_cover();
    titan_cover_e3d();
}

module titan_extruder_assembly() {
//    color("red")
//    render()
    translate([-4, -22.5,-5])
    titan_carriage();
        
    translate([20.8,2.75,-24])
    rotate([0,-90,0])
    fan_assembly(fan40x11, 6);
    
//    translate([-10.6,17,12.1])
//    rotate([90,0,0])
//    NEMA(NEMA17HS4023);
    
    translate([-10.55,13.5,12.15])
    rotate([0,0,180]) {
        titan_extruder();
        titan_hot_end_position() e3d_hot_end(E3Dv6, 1.75, naked = true);
        titan_stepper_position(3.5) NEMA(NEMA17HS4023);
    }


//    translate([-23.3,-0.0,-14.2])
//    bltouch();

}

titan_extruder_assembly();