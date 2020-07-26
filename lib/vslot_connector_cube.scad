include <NopSCADlib/utils/core/core.scad>

function vcc_profile_width(type) = type[0];
function vcc_profile_size(type) = (type[1] / vcc_profile_width(type));

module vslot_connector_cube(type) {
    stl(str("vslot_cube",vcc_profile_width(type)));
    
    width = vcc_profile_width(type);    
    
    d1 = 5.5;
    d2 = 11;
    
    module hole() {
        $fn=60;
        cylinder(d=d1, h=width+2, center=true);
        translate([0,0,-(width-d2)/2]) cylinder(d=d2, h=width, center=true);
    }
    
    difference() {
        cube([width,width,width], center=true);
        hole();
        mirror([1,0,1]) hole();
        mirror([0,1,1]) hole();
    }
}

//vslot_connector_cube([20,40]);