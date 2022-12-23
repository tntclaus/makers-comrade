include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/vitamins/ball_bearing.scad>


function v_wheel_dia(type) = type[1];
function v_wheel_rad(type) = type[1]/2;
function v_wheel_dia2(type) = type[2];
function v_wheel_dia_inner(type) = type[3];
function v_wheel_thick(type) = type[4];
function v_wheel_thick_edge(type) = type[5];
function v_wheel_color(type) = type[6];


$fn=60;
//
//module mini_V_wheel(type) {
//    vitamin(str("V Wheel Mini"));
//    color(v_wheel_color(type))
//    difference() {
//        hull() {
//            cylinder(d=12.21,h=8.8,center=true);
//            cylinder(d=15.23,h=5.78,center=true);
//        }
//        cylinder(d=8.63,h=9,center=true);
//        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=10,h=5);
//    }
//}

module v_wheel(type) {
    vitamin(type[0]);

    color(v_wheel_color(type))
    render()
    difference() {
        fn = 180;
        hull() {
            cylinder(d=v_wheel_dia2(type),h=v_wheel_thick(type),center=true);
            cylinder(d=v_wheel_dia(type),h=5.9,center=true);
        }
        cylinder(d=v_wheel_dia_inner(type)-2,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=v_wheel_dia_inner(type),h=5);
    }
}

module double_v_wheel(type) {
    vitamin(type[0]);
    color(v_wheel_color(type))
    render()
    difference() {
        union() {
            for(i=[-1,1]) translate([0,0,i*v_wheel_thick(type)/4]) hull() {
                cylinder(d=v_wheel_dia2(type),h=v_wheel_thick(type)/2,center=true);
                cylinder(d=v_wheel_dia(type),h=0.2,center=true);
            }
            cylinder(d=18.75,h=4.84,center=true);
        }
        cylinder(d=v_wheel_dia_inner(type)-2,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=v_wheel_dia_inner(type),h=5);
    }
}



module vwheel(model) {

    name = model[0];
    shape = model[1];
    bearing = model[2];
    type = model[3];


    if (shape=="double") {double_v_wheel(type);}
    else {v_wheel(type);}

    if (bearing) {
            translate([0,0,-bearing[3]/2-0.5])
                ball_bearing(bearing);
            translate([0,0,bearing[3]/2+0.5])
                ball_bearing(bearing);
    }
}
