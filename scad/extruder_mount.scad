

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <axes/carets.scad>

include <../lib/utils.scad>

use <axes/x-axis.scad>

use <extruder_heatbreak_cooler.scad>

//                                              corner  body    boss    boss          shaft
//                               side, length, radius, radius, radius, depth, shaft, length,      holes

NEMA17HS4023 = ["NEMA17HS4023",  42.3,  23,     53.6/2, 25,     11,     2,     5,     22,          31 ];

// Hot end descriptions
//
//                        s       p                    l    i    d      i l  c           s g    g     d   d              d a   d a
//                        t       a                    e    n    i      n e  o           c r    r     u   u              u t   u t
//                        y       r                    n    s    a      s n  l           r o    o     c   c              c     c
//                        l       t                    g    e           u g  o           e o    o     t   t              t n   t f
//                        e                            t    t           l t  u           w v    v                          o     a
//                                                     h                a h  r             e    e     r   o              h z   h n
//                                                                      t                p            a   f              e z   e
//                                                                      o                i d    w     d   f              i l   i
//                                                                      r                t i    i     i   s              g e   g
//                                                                                       c a    d     u   e              h     h
//                                                                                       h      t     s   t              t     t
//                                                                                              h
//
E3DVulcano= ["E3D Volcano", e3d, "E3D Volcano direct",  62,  3.7, 16,  42.7, "silver",   12,    6,    15, [1, 5,  -4.5], 14,   21];


module precision_piezzon_pcb_v2_75() {
    rotate([90,-90,0])
    translate([-111,0,0])
    import("../libstl/precision-piezo-uniboard2.75.stl");
}


module precision_piezzo_mount() {
    rotate([0,0,90])
    translate([0,0,0])
    color("#00aaff"){
        import("../libstl/preicision_piezo_throat_bottom.stl");
        import("../libstl/preicision_piezo_holder.stl");
        import("../libstl/preicision_piezo_holder_inlet.stl");
    }
}

module precision_piezon_mount_holes(rotation = [0,0,0]) {
    mounts = [
//        [0, 0, 0],    
        [-13.68, 11.54, 0],
        [14.18, 11.54, 0],
        [-13.68, -10.47, 0],
        [14.18, -10.47, 0],
    ];
    rotate(rotation) {
        for(e = mounts) {
            translate(e)
                children();
        }
    }
}

module cable_chain_holder() {
    module wall() {
        rotate([90,0,0])
        linear_extrude(6)
        rounded_polygon([
            [0,0,1],[0,60,1],[33,60,1],[18,0,1],
        ]);
        
        rotate([90,0,0])
        linear_extrude(33.35)
        rounded_polygon([
            [1,0,1],[15,60,1],[16,60,1],[2,0,1]
        ]);
    }
    
    difference() {
        translate([-30,-10,12]) 
        color("blue")
        union() {
//            translate_z(-10) 
//            cube([19,10,40]);
            translate([0,10,-10]) 
            wall();
//            translate_z(3) 
//            cube([19,4,47]);
        }
        
//        color("red")
//        translate([-40,5.5,31.2]) {
//            rotate([0,90,0]) {
//                cylinder(d = 4.2, h = 58);
//                translate([0,0,52])
//                nut_trap(M4_cap_screw, M4_nut, depth = 6, h = 6);
//            }
//        }
    }
}

module titan_adapt_carriage_stl(railsDistance = 30) {
    width = railsDistance * 2 + 3.7;
    depth = 90;

    mount_ear_w = 12;

    ear_mounts_coords = [
        [depth/2-mount_ear_w/2,width/2-2,7.5],
        [-depth/2+mount_ear_w/2,width/2-2,7.5],
        [depth/2-mount_ear_w/2,-width/2+2,7.5],
        [-depth/2+mount_ear_w/2,-width/2+2,7.5]
    ];
    
//    color("#00ffaa")
    difference() {
        translate_z(-11)
        titan_hot_end_position()
        difference() {
            union() {
                translate_z(-0.08) {
                    cube([depth, width, 4], center = true);
                    // titan mount ear
                    translate([8,13,7.5])
                    cube([depth-37,5,15], center = true);

                    translate([-depth/2, -width/2,0])
                    rotate([0,0,180])
                    cable_chain_holder();

                    //carriage mount ears
                    for(ear_mount = ear_mounts_coords) 
                        translate(ear_mount) 
                        difference() 
                            cube([mount_ear_w,4,15], center = true);

                    difference() {
                        rotate([0,0,90])
                        translate([0,0,-22.10])
                        import("../libstl/preicision_piezo_throat.stl");
                        translate_z(-1)
                        cube([100,100,4],center=true);
                    }
                }
            }
            cable_hole_width = 17.5;
            translate([-26,0,-10])
            linear_extrude(12)
            rounded_polygon([
                [-5, cable_hole_width/2, 3],
                [ 5, cable_hole_width/2, 3],        
                [ 5,-cable_hole_width/2, 3],
                [-5,-cable_hole_width/2, 3],    
            ]);        
            
            precision_piezon_mount_holes([0,0,90]) {
                translate_z(-3)
                cylinder(d = 4, h = 5);
                translate_z(-1)            
                cylinder(d = 7, h = 5, $fn = 6);
            }
            translate_z(-3)
                cylinder(d = 5, h = 20);

            for(ear_mount = ear_mounts_coords) 
                translate(ear_mount) 
                    if(ear_mount[1] < 0) {
                        color("red")
                        rotate([-90,0,0]) {
                            translate_z(-3)
                            cylinder(d = 5, h = 15);
                            translate_z(10)
                            rotate([0,0,90])
                            nut_trap(M5_cap_screw, M5_nut, depth = 10, h = 10);
                        }
                    } else {
                        rotate([90,0,0]) {
                            translate_z(-3)
                            cylinder(d = 5, h = 15);
                            translate_z(1)
                            rotate([0,0,90])
                            nut_trap(M5_cap_screw, M5_nut, depth = 1, h = 1);
//                            translate_z(0)
//                            cylinder(d = 8, h = 15, $fn = 6);
                        }
                    }
        }
        
        titan_stepper_position(0) NEMA(NEMA17HS4023);
        titan_stepper_position(3) NEMA(NEMA17HS4023);
        hull()
        difference() {
            titan_extruder_cover();
            translate([0,17,0])
                cube([100,10,100], center=true);
        }
        titan_extruder_cover_holes() {
            color("red")
            translate_z(-1)
            cylinder(d = 3.2, h = 20);
            translate_z(2)
            cylinder(d = 6, h = 20);
        }

        rotate([0,-14,0])
        translate([-47,7.3,14])
        color("green")
        rotate([0,180,0]) {
            hull()
            precision_piezzon_pcb_v2_75();
        }
        


        // pcb mount hole
        color("red")
        translate([-38.2,31,-14.1])
        rotate([90,0,0]) {
            cylinder(d = 3.5, h = 200);
            translate_z(38.4)
            rotate([0,0,90])
            nut_trap(M3_cap_screw, M3_nut, depth = 2, h = 2);
        }

        translate([-10.9,18.45 + railsDistance,-51.03])
        rotate([-90,90,0])
        color("green")
        x_caret_1_stl();

    }

 }
 
//precision_piezzon_pcb_v2_75();
//translate([-6,-8.5,20])
//cube([16,5,5], center = true);


COVER_MOUNT_1 = [-29,8,3.2];
COVER_MOUNT_2 = [22,8,3.2];
COVER_MOUNT_3 = [22,8,57];


module titan_adapt_carriage() {
    titan_adapt_carriage_stl();

    translate_z(-11)
    titan_hot_end_position()
    precision_piezon_mount_holes([0,0,90]) {
        translate_z(-1)
        nut(M3_nut);
    }

    titan_extruder_cover_hole(0)
        screw(M3_cap_screw, 35);
    
    titan_extruder_cover_hole(1)
        screw(M3_cap_screw, 35);

    titan_extruder_cover_hole(2)
        translate_z(2) screw(M3_cap_screw, 35);

    titan_extruder_cover_hole(3)
        translate_z(2) screw(M3_cap_screw, 20);

    rotate([0,-14,0])
    translate([-47,7.3,14])
    color("green")
    rotate([0,180,0])
    precision_piezzon_pcb_v2_75();
}




module titan_carriage() {    

    titan_adapt_carriage();

//    translate([0,0,23])
//    titan_cover();

//    titan_cover_e3d();
}

module e3d_fan_duct_stl() {
    import("../libstl/E3D_V6_40mm_Fan_v2.stl");
}

module e3d_fan_duct() {
    stl("e3d_fan_duct");
    translate([26.35,0,-49])
    rotate([-90,0,90])
    color("#00aaff")
    e3d_fan_duct_stl();
}

module titan_extruder_vitamins_assembly() {
//        rotate([0,0,-107]) 
    {
            titan_extruder();
            titan_stepper_position(0) NEMA(NEMA17M);
        }
        titan_hot_end_position() { 
            translate([0,0,-23]) // precision piezzo offset
                e3d_hot_end_cooler_assembly();
            translate([0,0,-33.2])
            precision_piezzo_mount();
//            e3d_fan_duct();
        }
}

module titan_extruder_assembly(width = 30) {
    titan_adapt_carriage_stl(width);
//    translate([-20,0,0])
    titan_extruder_vitamins_assembly();    

//    translate([26.45,13.7,-60.6])
//    rotate([0,90,0])
//    fan_assembly(fan40x11, 0);
}

titan_extruder_assembly();

//titan_adapt_carriage_stl();
