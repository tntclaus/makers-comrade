include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/spools.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>

include <../lib/bearings.scad>

module spool_holder_rod_cap_stl() {
    $fn=180;
    spool_holder_rod_cap();
}

module spool_holder_rod_cap() {
    stl("spool_holder_rod_cap");
    difference() {
        color("red") hull() {

            cylinder(d = 80, h=2);
            translate_z(-6)
            cylinder(d = 45, h=.1);
        }

        translate_z(-6.1) {
            translate([ 10,0,0])
            cylinder(d=5.4, h = 12);
            translate([-10,0,0])
            cylinder(d=5.4, h = 12);
        }
    }
}

module spool_holder_rod_stl() {
    $fn = 180;
    spool_holder_rod();
}

module spool_holder_rod() {
    stl("spool_holder_rod");

    module cap_mount_hole() {
        translate([0,0,97]) hull() {
            translate([0,10,0])
            rotate([0,0,30])
            cylinder(d = 9.5, h = 4.5, $fn = 6);
            rotate([0,0,30])
            cylinder(d = 9.5, h = 4.5, $fn = 6);
        }
        
        translate([0,0,97]) hull() {
            cylinder(d = 5, h = 13);
        }
    }

    difference() {
        union() {
            difference() {
                color("red") hull() {
                    cylinder(d = 80, h=2);
                    translate_z(8)
                    cylinder(d = 45, h=.1);
                }

                for(a = [0 : 90 : 360])
                    rotate([0,0,a])
                    translate([-32,0,-.1]) {
                        cylinder(d = 5.4, h = 5);
                        translate_z(3)
                        hull() {
                            translate_z(5)
                            cylinder(d = 11, h = .1);
                            cylinder(d = 11, h = .1);
                        }
                    }
            }

            translate_z(5)
            cylinder(d = 45, h=100);
        }

        translate([-100,5,-.1])
        cube([200,35,120]);
        
        translate([-100,-50,-.1])
        cube([200,35,120]);
        
        translate([ 10,0,0])
        cap_mount_hole();
        translate([-10,0,0])
        cap_mount_hole();
    }
}

module spool_holder_bearing_block_stl() {
    $fn = 180;
    spool_holder_bearing_block();
}

module spool_holder_bearing_block() {
    stl("spool_holder_bearing_block");
    module bearing_holder() {
        difference() {
            hull() {
                translate([0,-11,0])
                cube([20,0.1,2.8], center = true);
                cylinder(d = 10, h = 2.4, center = true);
            }
            cylinder(d = 5.3, h = 4, center = true);
        }
    }
    
    color("green") {
        translate([0,-12,70/2-2.5])
        hull() {
            translate([0,1,0])
            cube([40,.01,70], center = true);
            translate([0,-1,0])            
            cube([43.82,.01,70], center = true);            
        }
        
        translate([0,0,-1.5])
        bearing_holder();
        translate([0,0,8-1.5])
        bearing_holder();
        
        translate([0,0,30-1.5])
        bearing_holder();
        translate([0,0,38-1.5])
        bearing_holder();
        
        translate([0,0,60-1.5])
        bearing_holder();
        translate([0,0,68-1.5])
        bearing_holder();
    }
}

module spool_holder_bearing_block_assembly() {
    spool_holder_bearing_block();
    
    translate_z(2.5)
    ball_bearing(BB625_2RS);
    
    
    translate_z(32.5)
    ball_bearing(BB625_2RS);
    
    
    translate_z(62.5)
    ball_bearing(BB625_2RS);
}

module spool_holder_assembly(type = spool_300x88) {
    spool_holder_rod();
    translate([0,18,0])
    

    translate_z(20)
    spool_holder_bearing_block_assembly();
    
    translate_z(120)
    spool_holder_rod_cap();
    
//    translate_z(spool_height(type)/2+3)
//    spool(type, filament_d = 1.75);
}


spool_holder_assembly();
//spool_holder_bearing_block_stl();
//spool_holder_rod_stl();
//spool_holder_rod_cap_stl();