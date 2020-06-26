//EXEMPLE use wheel("shape(mini,V,double","bearing(y,n)",shim lenght);
// //mini V wheel without bearing
//wheel("mini","y",5); //mini V wheel with bearing and 5mm shim
//wheel("V","n",0); //V wheel without bearing
//wheel("V","y",10); //V wheel with bearing and 10mm shim
//wheel("double","n",0); //double V wheel without bearing
//wheel("double","y",15); //double V wheel with bearing and 15mm shim

include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/vitamins/ball_bearing.scad>

BB625_2RS =  ["625",  5,  16, 5, "orange", 1, 1];

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

/**

*/
module wheel(shape, bearing = true, type = "black") {
    colour = type=="xtreme" ? "white" : ( type == "metal" ? "silver" : "black");
    
    if (shape=="mini") {mini_V_wheel(colour);}
    else if (shape=="double") {double_V_wheel(colour);}
    else {V_wheel(colour);}
    
    if (shape=="mini" && bearing) {
            //todo
    } else if (bearing) {
            translate([0,0,-BB625_2RS[3]/2-0.5])    
                ball_bearing(BB625_2RS);
            translate([0,0,BB625_2RS[3]/2+0.5])
                ball_bearing(BB625_2RS);
    }
}

wheel();