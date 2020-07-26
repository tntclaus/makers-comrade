include <NopSCADlib/utils/core/core.scad>

function vcc_profile_width(type) = type[0];
function vcc_profile_size(type) = (type[1] / vcc_profile_width(type));

module vslot_connector_angle(type, negative = false) {
    stl(str("vslot_angle",vcc_profile_width(type)));
    
    width = vcc_profile_width(type);    
    
    d1 = 5.5;
    d2 = 12;
    
    module hole() {
//        $fn=30;
        cylinder(d=d1, h=width+2, center=true);
        translate([0,0,(width-d2)/2]) cube([d2,d2,width], center=true);
    }
    
    if(negative) {
        intersection() {
            cube([width,width,width], center=true);
            hole();
        }
        intersection() {
            cube([width,width,width], center=true);
            mirror([0,1,1]) hole();
        }
//        intersection() {
//            cube([width,width,width], center=true);
//            translate([0,-width*2+3.4,width]) rotate([45,0]) cube(width*4, center=true);
//        }
    } else {
        difference() {
            cube([width,width,width], center=true);
            hole();
            mirror([0,1,1]) hole();
            translate([0,-width*2+3.4,width]) rotate([45,0]) cube(width*4, center=true);
        }
    }
}

//vslot_connector_angle([20,40]);


vslot_connector_angle([20,40], true);