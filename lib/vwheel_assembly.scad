include <vwheels.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>

module spacer(h = 6) {
    hstr = h == 6.35 ? "6_35" : str(h);
    vitamin(str("gantry_cart_spacer_", hstr));
    color("silver")
    translate([0,0,h])
    rotate([0,180,0])
    difference() {
            cylinder(h, d = 10);
            translate([0,0,-0.1])
            cylinder(h+0.2, d = 5);
    }    
}


module eccentric_spacer(h = 6) {
    vitamin(str(
        "Openbuilds Eccentric Spacer (h=", h, "mm)"
    ));
    translate([0,0,h])
    rotate([0,180,0])
    difference() {
            union() {
                color("red")
                cylinder(h, d = 10, $fn=6);
                cylinder(h+2.5, d = 7.12);
            }
            translate([0,1,-0.1])
            cylinder(h+3, d = 5);
    }
}


module vwheel_assembly(type) {
    h = type[1]; 
    eccentric = type[2];
    wheelType = type[3];
    screwType = type[4];
    double = type[5];

    if(eccentric) {
        eccentric_spacer(h);
    } else {
        spacer(h);
    }

    shift = eccentric ? [0.25,1,h + 11/2] : [0,0,h + 11/2];
    
    screwLength = double ? 35 : 25;
        
   
    translate(shift){
        vwheel(wheelType);
        rotate([0,180,0])
        translate([0,0,14.5])
            screw(screwType, screwLength);

        translate([0,0,h-1+screwLength-25])
            spring_washer(screw_washer(screwType));
        translate([0,0,h+screwLength-25])
            nut(screw_nut(screwType));

    }
    
    if(double) {
        if(eccentric) {
            translate([0,0,21.8]) rotate([0,180,0]) eccentric_spacer(h);
        } else {
            translate([0,0,21.8]) rotate([0,180,0]) spacer(h);
        }
    }
}