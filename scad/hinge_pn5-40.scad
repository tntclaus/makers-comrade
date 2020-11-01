include <NopSCADlib/utils/core/core.scad>
include <utils.scad>


module hinge_shape(middleCut = true) {
    difference() {
        hull() {
            translate([-15, 15,0]) circle(r = 5);
            translate([-15,-15,0]) circle(r = 5);
            translate([-1,-15,0]) square(10, center = true);
            translate([-1,15,0]) square(10, center = true);    
        }            
        if(middleCut) {
            translate([0,15,0]) square([10,10.5], center = true);
            translate([5,5,0]) square([10,10.5], center = true);
            translate([0,-5,0]) square([10,10.5], center = true);
            translate([5,-15,0]) square([10,10.5], center = true);
        }
    }        
}    

module hinge_shapes() {
    hinge_shape(false);
    rotate([180,180,0]) hinge_shape(false);            
}

module hinge_pn5_40_render(angle = 0) {
    vitamin("Петля ПН5-40");
    
    mount_holes = [
        [-12.5, -12.5, 0],
        [-12.5, 12.5, 0]
    ];


    
    module hinge_half() {
        module cyl() {
            translate_z(0.5) cylinder(d1 = 5, d2 = 10, h = 5);
            translate_z(-0.5) cylinder(d = 5, h=10);
        }
        difference() { 
            linear_extrude(1.5) hinge_shape();
            translate([-12.5, -12.5, 0]) cyl();
            translate([-12.5, 12.5, 0]) cyl();
        }
    }
    
    

    module hinges() {
        translate([0,20,3.5]) rotate([90,0,0])cylinder(d=7, h=40);
        hinge_half();
        rotate_about_pt(y = -angle, pt = [0,0,3.5])
            rotate([180,180,0]) hinge_half();            
    }

//hinge_shapes();
    render() hinges();
}

module hinge_pn5_40(angle = 0) {
    
    color("silver") hinge_pn5_40_render(angle);
}
//hinge_shapes();
//hinge_pn5_40(0);