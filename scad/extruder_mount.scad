

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <axes/carets.scad>

include <../lib/utils.scad>

//                                              corner  body    boss    boss          shaft
//                               side, length, radius, radius, radius, depth, shaft, length,      holes

NEMA17HS4023 = ["NEMA17HS4023",  42.3,  23,     53.6/2, 25,     11,     2,     5,     22,          31 ];


module titan_cover() {
    color("orange")
    difference() {
        width = titan_extruder_width()+8;
        heigth = titan_extruder_heigth()-4;    
        depth = titan_extruder_depth()/2-4;
        translate([-width/2-2.5,-2,-heigth/2+6]) {
//            rounded_rectangle([width,depth,heigth], r = 1, center = false, xy_center =  false);
            hull() {
                translate([15,0,35])
                rotate([-90,0,0])
                cylinder(d = 30, h = depth);
                difference() {
                    cube([width,depth,heigth], center = false);
                    translate([-1,-1,30])
                    cube([31,50,30], center = false);
                }
            }
        }

        titan_extruder_hull(wheel_dia = 50);
    }
}

module titan_cover_e3d() {

}

module belt_clamp() {
    render()
    difference() {
        union() {
            translate([-100,-300,-1146])
                import("/Users/klaus/Downloads/ECBC.stl");
        }
        
        translate([0,0,8.5])
        cube([200,200,20],center = true);
    }
}

module titan_adapt_carriage_stl() {
//    render()
    titan_adapt_carriage();
}

COVER_MOUNT_1 = [-29,8,3.2];
COVER_MOUNT_2 = [22,8,3.2];
COVER_MOUNT_3 = [22,8,57];

module titan_adapt_carriage() {
    stl("titan_adapt_carriage");
    
    plate_position = [-2.5,34,0];
    
    
    difference() {
        width = titan_extruder_width()+8;
        heigth = titan_extruder_heigth()-4;    
        depth = titan_extruder_depth()/2+7;
        translate([0,0,23])
        translate([-width/2-2.5,8,-heigth/2+6])
            cube([width,depth,heigth]);

        translate([0,0,23])
        translate([0,4,0])
            titan_extruder_hull(
                wheel_dia = 0,
                spring_wheel_dia = 0,
                throat_dia = 24.5
        );

        translate([0,0,23])
        titan_extruder_hull(wheel_dia = 50);
        
        translate(plate_position)
        rotate([-90,90,0])
                drillHoles(VW_HOLES_20x3_BOTTOM,50);

        translate([-39,0,23])        
        cube([60,100,100]);
        
        cover_mounts(false);
    }
    
    module cover_mounts(diff = true) {    
        translate(COVER_MOUNT_1)
        rotate([-90,0,0]) difference() {
            if(diff)
                cylinder(d = 5, h = 22);

            translate_z(-0.1)
            cylinder(d = 3.3, h = 31);    
        }

        translate(COVER_MOUNT_2)
        rotate([-90,0,0]) difference() {
            if(diff)
                 cylinder(d = 5, h = 22);
            translate_z(-0.1)
            cylinder(d = 3.3, h = 31);    
        }
     
     
        translate(COVER_MOUNT_3)
        rotate([-90,0,0]) difference() {
            if(diff)
                 cylinder(d = 6, h = 22);
            translate_z(-0.1)
            cylinder(d = 3.3, h = 31);    
        }
    }
    
    cover_mounts();
    
    module belt_clamps() {
        translate([32.1,-13.2,0])
        color("red")
        rotate([0,180,0])
        belt_clamp();

        color("orange")
        translate([33.605, -11.5,0])
            cube([15.2,23,12], center = true);            
        
        translate([32.1,-13.2,0])
        color("red")
        mirror([0,0,1])
        rotate([0,180,0])
        belt_clamp();        
    }
    
    module plate() {
        difference() 
        {
            translate(plate_position) union() {
                rotate([-90,90,0])
                color("green")
                difference() {
                    union() {
                        vslot_plate(X_PLATE);
                        
                        translate([-50,0,-2.5])
                        cube([30,60,5],center = true);

                    }
                    translate([0,-35,0])
                        cube([77.5,10,15], center = true);
                    
                    translate([0,35,0])
                        cube([77.5,10,15], center = true);

                }
                belt_clamps();
                
                mirror([1,0,0])
                belt_clamps();
            }

            translate([0,23.6,0]) {
                translate(COVER_MOUNT_1) rotate([-90,0,0]) {
                         cylinder(d = 6.2, h = 2.5, $fn = 6);
                }
                translate(COVER_MOUNT_2) rotate([-90,0,0]) {
                         cylinder(d = 6.2, h = 2.5, $fn = 6);
                }
                translate(COVER_MOUNT_3) rotate([-90,0,0]) {
                         cylinder(d = 6.2, h = 2.5, $fn = 6);
                }
            }
        }
    }
    
    difference() {
        plate();
        cover_mounts(false);
    }
}


module titan_carriage() {    
    titan_adapt_carriage();

    translate([0,0,23])
    titan_cover();

    titan_cover_e3d();
}

module titan_extruder_assembly() {
//    color("red")
//    render()
//    translate([-4, -22.5,-5])
    titan_carriage();
        
//    translate([20.8,2.75,-24])
//    rotate([0,-90,0])
//    fan_assembly(fan40x11, 6);
    
//    translate([-10.6,17,12.1])
//    rotate([90,0,0])
//    NEMA(NEMA17HS4023);
    

    translate([0,0,23])
    titan_extruder();

    translate([0,0,23])    
    titan_stepper_position(2) NEMA(NEMA17HS4023);
    titan_hot_end_position() { 
//        translate([0,0,-23]) // precision piezzo offset
        e3d_hot_end(E3Dv6, 1.75, naked = true);
    }



//    translate([-23.3,-0.0,-14.2])
//    bltouch();

}

//titan_extruder_assembly();

//titan_adapt_carriage_stl();
