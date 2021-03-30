

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/quadrant.scad>

use <../lib/vwheel_gantry.scad>
use <../lib/vwheel_plate.scad>
include <axes/carets.scad>

include <utils.scad>

use <axes/x-axis.scad>

use <fan_duct/fan_duct.scad>


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


internal_face_w = 38;
rad_dia = 23; // Diam of the part with ailettes
rad_nb_ailettes = 11;
rad_len = 26;

nozzle_h = 5;

heater_width  = 5.75*2;
heater_length = 21.2;
heater_height = 20;

heater_x = -15.5 + heater_length;
heater_y = heater_width / 2;

module nozzle_cooler_top_stl(stl = true) {
    difference() {
        nozzle_cooler(E3DVulcano, stl);
        translate([0,0,-55])
        color("black")
        cube([120,120,20], center = true);
    }
}

module nozzle_cooler_bottom_stl(stl = true) {
    l = (heater_length+15)/2-2;
    w = 7-2;
    translate([48.5,0,-44])
    tube_adapter_square2square([w,l,1], [w+2,l+2,10], 2, 2, 0);
    difference() {
        nozzle_cooler(E3DVulcano, stl);
        translate([0,0,-7.5+10])
        color("black")
        cube([120,120,95], center = true);
    }
}

module nozzle_cooler(type, stl = false) {    
    stl("nozzle_cooler_top");
    stl("nozzle_cooler_bottom");
    
    wall_thickness = 2;

    width = heater_length+15;
    length = heater_length+15 + heater_x+4;
    length_inner = heater_length+15;
    heigth = 7;
    
    tube_size = 55;
    tube_rad = 10;
    

    holes_x = [
      for(x = 0, y = 0;x < length-20; x = x+8, y = y+2) 
          [x, width/2-1.5, -15]
    ];
      
    module vent_holes(dia = 2) {
        color("teal") {
            translate([-length/2+10, 0, 5])
            for(coord = holes_x)
                rotate([-45,0,0]) translate(coord) 
                    cylinder(d = dia, h = 20);

            translate([-length/2+10.5, 0, 5])
            rotate([0,-45,0]) 
            translate([-11.25, width/2-9, -18])
                cylinder(d = dia, h = 18);


            translate([length/2-10.5, 0, 5])
            rotate([0,45,0]) 
            translate([11.25, 0, -18])
                cylinder(d = dia, h = 18);
        }
    }
    
    module rectangular_section() {
        difference() {
            rounded_rectangle([length, width, heigth], r = 2, center = true);
            rounded_rectangle([length-10, width-10, heigth+1], r = 2, center = true);
            difference() {
                rounded_rectangle([length-wall_thickness, width-wall_thickness, heigth-wall_thickness], r = 2, center = true);
                rounded_rectangle([length-10+wall_thickness, width-10+wall_thickness, 11], r = 2, center = true);
            }
            
            vent_holes();
            mirror([0,1,0])
            vent_holes();   
        }
    }
    
      
    module vent_hole(dia = 2, angle = 20, offset_x=length_inner/2) {
        translate([offset_x,0,0])
        rotate([0,angle,0])
        translate_z(-3)
        cylinder(d = dia, h = 6);
    }
    
    module cylindrical_section() {
        difference() {
            difference() {
                cylinder(d = length, h = heigth, center = true, $fn = get_fn720(stl));
                cylinder(d = length_inner, h = heigth+1, center = true, $fn = get_fn720(stl));
            }
            difference() {
                cylinder(d = length-wall_thickness, h = heigth-wall_thickness, center = true, $fn = get_fn720(stl));
                cylinder(d = length_inner+wall_thickness, h = heigth+1, center = true, $fn = get_fn720(stl));
            }
            
            // horizontal line
            color("teal")
            translate([length/2, 0,0])
            cube([wall_thickness*2, width/2-wall_thickness, heigth-wall_thickness], center = true);
            
            translate_z(-heigth/2) {
                for(a = [15 : 30 : 360])
                    rotate([0,0,a]) vent_hole();
                
            }
        }
        

    }
    
    module main_section() {
        cylindrical_section();
    }
    
    module tube_section(center_offset = 20, tube_heigth = 60) {
        quadrant_size = tube_rad * 2;
        difference() {
            translate([center_offset,width/4,quadrant_size-heigth/2])
            union() {
                rotate([90,90,0])
                linear_extrude(width/2) difference() {
                    quadrant(quadrant_size, tube_rad, center = false);
                    quadrant(quadrant_size-heigth, tube_rad, center = false);
                }
                // vertical line
                color("orange")
                translate([quadrant_size-heigth/2, -width/4,-heigth/2+tube_heigth/2])
                    cube([heigth, width/2, tube_heigth], center = true);

                 // horizontal line
                color("teal")
                translate([-(center_offset-quadrant_size)/2, -width/4,-quadrant_size+heigth/2])
                    cube([center_offset-quadrant_size, width/2, heigth], center = true);
            }
            
            translate([center_offset+wall_thickness/2,width/4-wall_thickness/2,quadrant_size-heigth/2-wall_thickness/2])
            rotate([90,90,0])
            linear_extrude(width/2-wall_thickness) difference() {
                quadrant(quadrant_size-wall_thickness, tube_rad, center = false);
                quadrant(quadrant_size-heigth, tube_rad, center = false);
            }
            
            // vertical line
            color("orange")
            translate([center_offset+quadrant_size-heigth/2, 0,-heigth/2+tube_heigth/2+quadrant_size])
            cube([heigth-wall_thickness, width/2-wall_thickness, tube_heigth+4], center = true);
            
            // horizontal line
            color("teal")
            translate([center_offset-(center_offset-quadrant_size)/2, 0,0])
            cube([center_offset-quadrant_size+3, width/2-wall_thickness, heigth-wall_thickness], center = true);

        }
        
        // распорки для крыши
        support_pos = width/8-wall_thickness;
        color("blue")
        translate([center_offset/4+quadrant_size+tube_rad/4, -support_pos,0])
        cube([center_offset/2+tube_rad/2, wall_thickness/2, heigth-wall_thickness], center = true);        
        
        color("blue")
        translate([center_offset/4+quadrant_size+tube_rad/4, support_pos,0])
        cube([center_offset/2+tube_rad/2, wall_thickness/2, heigth-wall_thickness], center = true);        

        // воротник для крепления к экструдеру
        color("green")
        translate([center_offset+quadrant_size-heigth, 0,tube_heigth+(quadrant_size-heigth)-5]) {
            difference() {
                hull() {
                    translate([-5+1,0,0])cube([10,20,1], center = true);
                    translate([-0.5+1,0,-30]) cube([1,1,1], center = true);
                }
                translate([-5,-5,-30])
                cylinder(d = 3.4, h = 200);

                translate([-5,5,-30]) {
                    cylinder(d = 3.4, h = 200);
    //                translate_z(8)
    //                nut_trap(M3_cap_screw, M3_nut, depth = 1.2, h = 1);
                }

            }
            
            translate([3.5,0,3])
            rotate([0,0,90])
            tube_adapter(heigth-wall_thickness*1.2, width/2-wall_thickness*1.2, 20, wall_thickness, 12);
        }
    }
    
    translate_z(-hot_end_length(type)) {

        difference() {
            union() {
                main_section();
                tube_section(32, 62);
            }
//            color("red")
//            translate([length/2, 0,0])
//            cube([heigth-wall_thickness, width/2-wall_thickness, heigth-wall_thickness], center = true);
            
//            // разрез
//            translate([-100,-0,-10])
//            cube([1000, 100, 1000]);
        }
    }
}


module e3d_fan_duct_half() {
    fan_x_offset = rad_dia / 2;
    
    external_face_w = 20;

//    render() 
    difference() {
//        color("DeepSkyBlue")
        hull() {
            translate_z(33.4-3)
            resize([80, 40, 1])
            cylinder(d = 40, h = 1);
                
//            translate_z(1)
            cylinder(d = 27, h = 1);
        }
        translate_z(30-14)
        color("red")
        cylinder(d = 25, h=30, center = true);

        translate_z(0)
        cylinder(d = 16, h=10, center = true);
        
        //разрез
        cube([200,200,200]);
    }
}

module e3d_fan_duct_left_stl() {
//    color("DeepSkyBlue")
    render() difference() {
//        e3d_fan_duct_half();
//        mount_holes();
//        mirror([0,1,0])
//        mount_holes();
    }

    module mount_holes() {
        color("red")
        translate([0, internal_face_w/2 - 3.5, 4])
        rotate([0,90,0])
        translate_z(-1) {
            cylinder(d = 3.4, h=20);
            translate_z(13)
            nut_trap(M3_cap_screw, M3_nut, depth = 7, h = 1);
        }        
        color("red")
        translate([0, internal_face_w/2 - 3.5, 4+15])
        rotate([0,90,0])
        translate_z(-1) {
            cylinder(d = 3.4, h=20);
            translate_z(13)
            nut_trap(M3_cap_screw, M3_nut, depth = 7, h = 1);
        }        
    }
}

module e3d_fan_duct_right_stl() {
    color("DeepSkyBlue")
    
    render() mirror([1,0,0]) difference() {
//        e3d_fan_duct_half();
//        mount_holes();
//        mirror([0,1,0])
//        mount_holes();
    }

    module mount_holes() {
        color("red")
        translate([0, internal_face_w/2 - 3.5, 4])
        rotate([0,90,0])
        translate_z(-1) {
            cylinder(d = 3.2, h=20);
            translate_z(10)
            cylinder(d = 6.4, h=20);
        }        
        color("red")
        translate([0, internal_face_w/2 - 3.5, 4+15])
        rotate([0,90,0])
        translate_z(-1) {
            cylinder(d = 3.2, h=20);
            translate_z(10)
            cylinder(d = 6.4, h=20);
        }        
    }
}


module e3d_fan_duct() {
//    stl("e3d_fan_duct_left");
//    stl("e3d_fan_duct_right");    
//    translate([26.35,0,-49])
//    rotate([-90,0,90])
//    color("#00aaff")
//    e3d_fan_duct_right_stl();
//    e3d_fan_duct_left_stl();
}

module e3d_hot_end_cooler_assembly() {
    volcano_hot_end(E3DVulcano, 1.75, naked = true);
//    volcano_heater_block(E3DVulcano, naked = true);
    translate([0,0,-40])
        e3d_fan_duct();
    
//    nozzle_cooler(E3DVulcano);
}


module volcano_hot_end(type, filament, naked = false, resistor_wire_rotate = [0,0,0], bowden = false) {
    insulator_length = hot_end_insulator_length(type);
    inset = hot_end_inset(type);
    h_ailettes = rad_len / (2 * rad_nb_ailettes - 1);

    vitamin(str("e3d_hot_end(", type[0], ", ", filament, "): Hot end ", hot_end_part(type), " ", filament, "mm"));

    translate_z(inset - insulator_length)
        color(hot_end_insulator_colour(type))
            rotate_extrude()
                difference() {
                    union() {
                        for (i = [0 : rad_nb_ailettes - 1])
                            translate([0, (2 * i) * h_ailettes])
                                square([rad_dia / 2, h_ailettes]);

                        square([hot_end_insulator_diameter(type) / 2,  insulator_length]);

                        translate([0, -10])
                            square([2, 10]);
                    }
                    square([3.2 / 2, insulator_length]);  // Filament hole

                    translate([hot_end_groove_dia(type) / 2, insulator_length - inset - hot_end_groove(type)])
                        square([100, hot_end_groove(type)]);
            }

    if(bowden)
        translate_z(inset)
            bowden_connector();

    volcano_heater_block(type, naked, resistor_wire_rotate);

    if(!naked)
        translate_z(inset - insulator_length)
            e3d_fan();
}

module volcano_heater_block(type, naked = false, resistor_wire_rotate = [0,0,0]) {
    
    translate_z(-hot_end_length(type))  {
        translate_z(nozzle_h)
            color("lightgrey")
                translate([-heater_x, -heater_y, -heater_height + 11.5])
                    cube([heater_length, heater_width, heater_height]);

        translate([4,10.75,5])
        rotate([90,0,0])
        e3d_resistor(type, naked, resistor_wire_rotate);
        translate_z(-heater_height + 11.5)
        e3d_nozzle(type);
    }
}

e3d_hot_end_cooler_assembly();
//nozzle_cooler_top_stl(true);
//nozzle_cooler_bottom_stl(true);

//nozzle_cooler_stl(false);
