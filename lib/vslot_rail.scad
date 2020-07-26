include <vwheel_gantries.scad>
include <NopSCADlib/vitamins/extrusions.scad>

include <vslot_connectors.scad>

cubeConnectorColor = "orange";

module extrusion_w_angle(type, size, sides = [1,0,0,0], spacing = 0, center = true) {
    
    trans = center ? [0,0,0] : [0,0,size/2];
    module angleMounts() {
        translate([0, -20, -size/2+10+spacing]) color(cubeConnectorColor)
            vslot_connector_angle(VCUBE_20);
        translate([0, -20, size/2-10-spacing]) color(cubeConnectorColor) rotate([90,0,0])
            vslot_connector_angle(VCUBE_20);
    }
    
    translate(trans) {    
        extrusion(type, size, center = true);
        if(sides[0]) angleMounts();
        if(sides[1]) rotate([0,0,90]) angleMounts();
        if(sides[2]) mirror([0,1,0]) angleMounts();
        if(sides[3]) rotate([0,0,270]) angleMounts();
    }
}

module vslot_rail(type, l, pos = 10, mirror = false, angles = false) {

    
    
    gantry = type[1];
    extrusion = type[2];
    length = l;
    position = pos;
    
    plate = gantry[1][0];

    translate([0,0,plate[0]/2 + position]) vwheel_gantry(gantry, center=true, mirror = mirror) children();
    
    exHeigth = extrusion_height(extrusion);
    
    
    if(exHeigth == gantry[3]) {
         if(angles) {
            extrusion_w_angle(extrusion, length, sides = [1,0,1,0], center = false);
        } else {
            extrusion(extrusion, length, center = false);
        }

    } else {
        translate([exHeigth/2-10,0,0]) 
            rotate([0,0,90])    {  if(angles) {
                                    extrusion_w_angle(extrusion, length, true);
                                } else {
                                    extrusion(extrusion, length, center = false);
                                }
                            }

    }
    
}
