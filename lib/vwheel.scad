include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/vitamins/ball_bearing.scad>



$fn=60;

module mini_V_wheel(colour = "black") {
    vitamin(str("V Wheel Mini"));    
    color(colour)
    difference() {
        hull() {
            cylinder(d=12.21,h=8.8,center=true);
            cylinder(d=15.23,h=5.78,center=true);
        }
        cylinder(d=8.63,h=9,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=10,h=5);
    }
}

module V_wheel(colour = "black") {
    vitamin(str("V Wheel"));
    color(colour)
    difference() {
        hull() {
            cylinder(d=19.6,h=10.2,center=true);
            cylinder(d=23.9,h=5.9,center=true);
        }
        cylinder(d=14,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=16,h=5);
    }
}

module double_V_wheel(colour = "black") {
    vitamin(str("V Wheel Double"));

    color(colour)
    difference() {
        union() {
            for(i=[-1,1]) translate([0,0,i*2.695]) hull() {
                cylinder(d=19.61,h=4.84,center=true);
                cylinder(d=23.9,h=0.55,center=true);
            }
            cylinder(d=18.75,h=4.84,center=true);
        }
        cylinder(d=14,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=16,h=5);
    }  
} 



module vwheel(model) {
    
    name = model[0];
    shape = model[1];
    bearing = model[2];
    type = model[3];    
    colour = type=="xtreme" ? "white" : ( type == "metal" ? "silver" : "black");
    
    if (shape=="mini") {mini_V_wheel(colour);}
    else if (shape=="double") {double_V_wheel(colour);}
    else {V_wheel(colour);}
    
    if (shape=="mini" && bearing) {
            //todo
    } else if (bearing) {
            translate([0,0,-bearing[3]/2-0.5])    
                ball_bearing(bearing);
            translate([0,0,bearing[3]/2+0.5])
                ball_bearing(bearing);
    }
}
