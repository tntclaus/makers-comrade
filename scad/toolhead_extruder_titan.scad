

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../lib/utils.scad>

use <extruder_heatbreak_cooler.scad>
include <toolhead_utils.scad>

use <../lib/modularHoseLibrary.scad>

use <NopSCADlib/utils/tube.scad>

//                                              corner  body    boss    boss          shaft
//                               side, length, radius, radius, radius, depth, shaft, length,      holes

NEMA17HS4023 = ["NEMA17HS4023",  42.3,  23,     53.6/2, 25,     11,     2,     5,     22,          31 ];

NEMA17HS0404 = ["NEMA17HS0404",  42.3,  29,     53.6/2, 25,     11,     2,     5,     22,          31 ];

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


PTFE_TUBE_DIA = 4.18;

coolant_hose_size = 20;
coolant_hose_size_out = coolant_hose_size+4;
coolant_hose_out_wall_dia = coolant_hose_size_out+2;
hose_hole_y_shift = 0;

TOOLHEAD_EXTRUDER_PLASTIC_COLOR = "#3377ff";

TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X = 26;
TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_Y = 18;

TOOLHEAD_EXTRUDER_GROOVE_MOUNT_X = 15/2;
TOOLHEAD_EXTRUDER_HEATBREAK_MOUNT_X = 28/2;

//function coolant_hose_position_mirror(length, y_shift = 0) = [length/2-coolant_hose_size/2-4.5-TOOLHEAD_PLATES_BELT_INSET,y_shift,0];

function TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS(
    x = TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X, 
    y = TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_Y
) = [
    [ x,  y],
    [ x, -y],
    [-x,  y],
    [-x, -y],
];

function TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts) = [
    [-groove_mounts,  groove_mounts],
    [-groove_mounts, -groove_mounts],
    [ groove_mounts, -groove_mounts],
    [ groove_mounts,  groove_mounts],
];

module toolhead_extruder_groove_collet_mounts() {
    for(point = TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts = TOOLHEAD_EXTRUDER_GROOVE_MOUNT_X))
        translate(point) children();
}

module toolhead_extruder_heatbreak_cooler_mounts() {
    for(point = TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts = TOOLHEAD_EXTRUDER_HEATBREAK_MOUNT_X))
        translate(point) children();
}

//module precision_piezzon_pcb_v2_75() {
//    rotate([90,-90,0])
//    translate([-111,0,0])
//    import("../libstl/precision-piezo-uniboard2.75.stl");
//}

module wires_window(width) {
    translate([0,-width/2]) hull() {
        translate([-6,0])
        circle(d = 12);
        translate([6,0])
        circle(d = 12);
    }
}

module toolhead_extruder_top_plate_sketch(
        width, length, inset_length
    ) {
    
        
    difference() {
        toolhead_top_plate_sketch(width, inset_length);
        circle(d = PTFE_TUBE_DIA);
        
        wires_window(width);

        
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            circle(d = 4.01);
        
        translate(hose_position(length, coolant_hose_size, hose_hole_y_shift)) hull() {
            circle(d = coolant_hose_out_wall_dia+.1);
            translate([-coolant_hose_size, 0, 0])
            circle(d = coolant_hose_out_wall_dia+.1);
        }
                
        translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) hull() {   
            circle(d = coolant_hose_out_wall_dia);
            translate([coolant_hose_size, 0, 0])
            circle(d = coolant_hose_out_wall_dia);
        }
        
        colling_tube_position(width-8, inset_length-2, 0)
        circle(d = 4);
    }    
}

module D16T_toolhead_extruder_top_plate_W60xL100_IL80_dxf() {
    $fn = 180;
    toolhead_extruder_top_plate_sketch(width = 60, length = 100, inset_length = 80);
}

module toolhead_extruder_top_plate(
    width, 
    length, 
    inset_length,
    thickness = 3
) {
    dxf_name =         str(
        "D16T_toolhead_extruder_top_plate","_",
        "W", width,"x",
        "L", length,"_",
        "IL", inset_length);
    dxf(dxf_name);

    color("#aaaaaa")
    linear_extrude(thickness)
    toolhead_extruder_top_plate_sketch(
        width, length, inset_length
    );
}

module colling_tube_position(width, inset_length, inset_depth) {
    translate([inset_length/2-5, -(width/2-inset_depth-5)])
    children();

    translate([-(inset_length/2-5), -(width/2-inset_depth-5)])
    children();

}

module toolhead_extruder_bottom_plate_sketch(
    width, 
    length, 
    inset_length, 
    inset_depth,
    type
) {
    difference() {
        toolhead_bottom_plate_sketch(width, length, inset_length, inset_depth);
        circle(d = 16.01);
        translate([0,8])
        circle(d = 3.01);

        toolhead_extruder_groove_collet_mounts() circle(d = 2.3);

        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            circle(d = 3.01);
        
        toolhead_extruder_heatbreak_cooler_mounts() circle(d = 3.01);
            
        translate(hose_position(length, coolant_hose_size))
        circle(d = coolant_hose_size); 
                    
        translate(hose_position(length, coolant_hose_size, 0, 1))    
        circle(d = coolant_hose_size); 
        
        colling_tube_position(width, inset_length, inset_depth)
        circle(d = 4);
    }
}

module D16T_toolhead_extruder_bottom_plate_W60xL100_IL80_ID8_dxf() {
    $fn = 180;    
    toolhead_extruder_bottom_plate_sketch(
        width = 60, 
        length = 100, 
        inset_length = 80, 
        inset_depth = 8
    );
}

module toolhead_extruder_bottom_plate(
    width, 
    length, 
    inset_length, 
    inset_depth, 
    type,
    heigth,
    thickness = 3
) {
    dxf_name = str(
        "D16T_toolhead_extruder_bottom_plate","_",
        "W", width,"x",
        "L", length,"_",
        "IL", inset_length,"_",
        "ID", inset_depth);
    dxf(dxf_name);

    color("silver")
    translate_z(-thickness)
    linear_extrude(thickness)
    toolhead_extruder_bottom_plate_sketch(
        width, 
        length, 
        inset_length, 
        inset_depth,
        type);
        
//    plate_corner_position(width, length, 10)
//    mount_magnet();
    
    groove_collet_width = width-inset_depth*2;
    
    toolhead_titan_extruder_groove_collet(groove_collet_width, heigth, length);

    rotate([0,0,180]) 
    toolhead_titan_extruder_groove_collet(groove_collet_width, heigth, length);

    translate_z(hot_end_groove(E3DVulcano))
    toolhead_titan_extruder_groove_collet_top(groove_collet_width, heigth);    
    
}


module toolhead_titan_extruder_groove_collet_44x29_100_stl() {
    toolhead_titan_extruder_groove_collet(
        44,
        29,
        100
    );
}



module toolhead_titan_extruder_groove_collet_44_dxf() {
    toolhead_titan_extruder_groove_collet(
        44,
        29
    );
}

module toolhead_titan_extruder_groove_collet(
    width,
    heigth,
    plate_length
) {
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X + 3.5) * 2;

    m4_grover_uncompressed_heigth=1.75;
    m4_grover_half_compressed_heigth=1.6;    
    m4_grover_compressed_heigth=1.1;
    
    m4_washer_heigth = 0.9;
    
    m4_washer_grover_assembly_h = m4_washer_heigth + m4_grover_half_compressed_heigth;
    
    stl_name = str(
    "toolhead_titan_extruder_groove_collet", "_",
    width, "x",
    heigth, "_",
    plate_length
    );
    
    stl(stl_name);
    
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    screw_mount_column_h = (heigth-groove_collet_heigth)/2;
    
    groove_dia = hot_end_groove_dia(E3DVulcano);
    
    translate_z(groove_collet_heigth/2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        union() {
            rounded_rectangle([length, width, groove_collet_heigth], r=3, center = true);
            translate([-length/2+4,0,screw_mount_column_h+groove_collet_heigth/2-m4_washer_grover_assembly_h/2])
                rounded_rectangle([8, width, heigth-groove_collet_heigth-m4_washer_grover_assembly_h], r=3, center = true);

            translate_z(-groove_collet_heigth/2)
            translate(hose_position(plate_length, coolant_hose_size)) 
                cylinder(d = coolant_hose_out_wall_dia, h = heigth+groove_collet_heigth/2);

        }
        cylinder(d = groove_dia, h = groove_collet_heigth+1, center = true);

//        toolhead_extruder_groove_collet_mounts()
//            translate_z(-groove_collet_heigth) cylinder(d = 4.01, h = groove_collet_heigth*4);
        
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(-groove_collet_heigth) cylinder(d = 4.01, h = 1000);
        
        translate([length, 0, 0])
            cube([length*2, width*2, groove_collet_heigth*4], center = true);
        
        toolhead_extruder_groove_collet_mounts()
            cylinder(d = 3.01, h = 1000, center = true);
        
        toolhead_extruder_heatbreak_cooler_mounts() cylinder(d = 3.01, h = 1000, center = true);
        
        translate_z(-groove_collet_heigth)
        translate(hose_position(plate_length, coolant_hose_size)) 
            cylinder(d = coolant_hose_size, h = 1000);
        

        translate_z(heigth-groove_collet_heigth-10)
        translate(hose_position(plate_length, coolant_hose_size)) 
            cylinder(d = coolant_hose_size_out, h = 1000);
        

    }


//    dxf_name = str(
//    "toolhead_titan_extruder_groove_collet", "_",
//    width
//    );
//    dxf(dxf_name);
//    echo(stl_name);

//    linear_extrude(3)
//    toolhead_titan_extruder_groove_collet_sketch(width);
}

module toolhead_titan_extruder_groove_collet_top_part1_44x29_stl() {
    $fn=180;
    toolhead_titan_extruder_groove_collet_top_part1(44, 29);
}

module toolhead_titan_extruder_groove_collet_top_part2_44x29_stl() {
    $fn=180;
    toolhead_titan_extruder_groove_collet_top_part2(44, 29);
}


module toolhead_titan_extruder_groove_collet_top(
    width,
    top_plate_distance
) {
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    groove_collet_top_heigth = 4;
    heigth = top_plate_distance - groove_collet_heigth;
    
    
    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;

    translate_z(18+piezo_disc_thick) {
        translate_z(2)
        piezo_disc();
        color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
        translate_z(3.05+piezo_disc_thick)
        toolhead_piezo_groove();
    }
        
    
    translate_z(groove_collet_top_heigth/2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR) {
        toolhead_titan_extruder_groove_collet_top_part1(
            width,
            top_plate_distance
        );
        
        translate([0,0,(groove_collet_top_heigth+ptfe_cylinder_heigth)/2-3]) 
        toolhead_titan_extruder_groove_collet_top_part2(
            width,
            top_plate_distance
        );
    }
}


module toolhead_titan_extruder_groove_collet_top_part1(
    width,
    top_plate_distance
) {
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    groove_collet_top_heigth = 4;
    heigth = top_plate_distance - groove_collet_heigth;
    


    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X - 5) * 2 - coolant_hose_out_wall_dia/2-5;
    
    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;

    
    stl_name = str(
        "toolhead_titan_extruder_groove_collet_top_part1", "_",
        width, "x",
        heigth
    );
    stl(stl_name);
    
    difference() {
        rounded_rectangle([length, length, groove_collet_top_heigth], r=3, center = true);

        cylinder(d = 16.2, h = heigth+1, center = true);

        toolhead_extruder_groove_collet_mounts()
            translate_z(-heigth) cylinder(d = 3.01, h = heigth*4);
        
    }
}

module toolhead_titan_extruder_groove_collet_top_part2(
    width,
    top_plate_distance
) {
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    groove_collet_top_heigth = 4;
    heigth = top_plate_distance - groove_collet_heigth;
    
    piezo_disc_thick = 0.45;

    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X - 5) * 2 - coolant_hose_out_wall_dia/2-5;
    
    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;


    stl_name = str(
    "toolhead_titan_extruder_groove_collet_top_part2", "_",
    width, "x",
    heigth
    );
//    echo(stl_name);
    stl(stl_name);
    
    difference() {
        union() {
            translate_z(-5) rounded_rectangle([length, length, 3], r=3, center = true);
            translate_z(2.45)
            cylinder(d1 = 6, d2 = 6, h = ptfe_cylinder_heigth-4, center = true);
        }
        translate_z(-6.51)
        cylinder(d1 = 2, d2 = 4, h = ptfe_cylinder_heigth/2);
        translate_z(-6.51+ptfe_cylinder_heigth/2-0.01)
        cylinder(d = 4, h = ptfe_cylinder_heigth);

        toolhead_extruder_groove_collet_mounts()
            translate_z(-heigth) cylinder(d = 3.01, h = heigth*4);
    }
}

module toolhead_titan_extruder_mount_60x100x80_NEMA17S_5_stl() {
    toolhead_titan_extruder_mount(
        width = 60, 
        length = 100,
        inset_length = 80,
        motor_type = NEMA17S,
        padding = 5
    );
}

module toolhead_titan_extruder_mount(
    width, 
    length,
    inset_length,
    motor_type,
    padding = 10
) {
    
    stl_name = str(
        "toolhead_titan_extruder_mount", "_",
        width, "x",
        length,"x",
        inset_length,"_",
        motor_type[0],"_",
        padding
    );
//    echo(stl_name);
    stl(stl_name); 
    
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    translate_z(3-1.5) { 
        difference() {
            linear_extrude(3) difference() {
                square([inset_length - padding, width - padding], center = true); 
                circle(d = PTFE_TUBE_DIA);
                
                translate(hose_position(length, coolant_hose_size, hose_hole_y_shift)) hull() {
                    circle(d = coolant_hose_size+6);
                    translate([-coolant_hose_size, 0, 0])
                    circle(d = coolant_hose_size+6);
                }
                        
                translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) {
                    for(x = [-4 : 2 : 5])
                        for(y = [-5.5 : 2 : 6.5])
                            translate([x*2, y*2, 0])
                                circle(d = 2.5);
                }
                
                wires_window(width);
                
                toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                    circle(d = 4.1);
                
//                plate_corner_position(width,inset_length, 10)
//                    circle(d = 15);
            }
            
            translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) {
                translate_z(2)
                for(x = [-4 : 2 : 5]) {
                    hull() {
                        translate([x*2, -5.5*2, 0])
                            cylinder(d = 2.5, h = 2);
                        translate([x*2, 16.5*2, 0])
                            cylinder(d = 2.5, h = 2);
                    }
                }
            }
            
            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                cylinder(d1 = 4.1, d2 = 8.1, h = 3.01);
            
            translate_z(-.1)
            colling_tube_position(width-8, inset_length-2, 0)
                cylinder(d = 4.1, h = 3.2);
        }
        
        translate_z(2.95)
        translate([13.6,10.87,NEMA_width(motor_type)/2]) {
            rotate([0,90,0])
            linear_extrude(2) difference() {
                union() {
                    NEMA_outline(motor_type);
                    square_corner_w = NEMA_width(motor_type)/2;
                    translate([-square_corner_w+5,-square_corner_w-2])
                    square([NEMA_width(motor_type)-5,square_corner_w+2]);
                }
                circle(NEMA_boss_radius(motor_type));
                NEMA_screw_positions(motor_type) circle(d = 3.1);
            }
            
            translate([11.5,-NEMA_width(motor_type)/2-2.5,-NEMA_width(motor_type)/2])
            hull() {
                translate([-10.5,0,NEMA_width(motor_type)-1-5])
                cube([2,2,2], center = true);
                cube([23,2,0.1], center = true);
            }
        }

    }
    
}

module titan_extruder_heatbreak_cooler_100_stl() {
    $fn = 180;
    titan_extruder_heatbreak_cooler(plate_length = 100);
}

module titan_extruder_heatbreak_cooler(
    plate_length,
    cut_half = false
) {
    stl(str("titan_extruder_heatbreak_cooler", "_", plate_length));
    length = plate_length - TOOLHEAD_PLATES_BELT_INSET*2 - 2;
    
    external_face_w = 20;
    
    zero_level = 33.4-3;

//    render() 
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        hull() {
            translate_z(zero_level)
            resize([length, 40, 0.7])
            cylinder(d = 40, h = 0.5);


            cylinder(d = 27, h = 1);
        }
        translate_z(30-6)
        color("red")
        cylinder(d = 25, h=44, center = true);

        translate_z(0)
        cylinder(d = 16, h=10, center = true);
        
        hull() {
            translate_z(zero_level)
            translate(hose_position(plate_length, coolant_hose_size))
            cylinder(d = coolant_hose_size, h = 1);
            translate_z(1)
            cylinder(d = 25, h = 1);
        }
        
        hull() {
            translate_z(zero_level)
            translate(hose_position(plate_length, coolant_hose_size, 0, 1))
            cylinder(d = coolant_hose_size, h = 1);
            translate_z(1)
            cylinder(d = 25, h = 1);
        }
        
        
        toolhead_extruder_heatbreak_cooler_mounts()
            translate_z(-1) cylinder(d = 3.6, h = 1000);
            
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(-1) cylinder(d = 4.01, h = 1000);
    
        
//        translate(vacuum_hose_position(length))   
//        linear_extrude(100) 
//        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05); 
        
        //разрез
        if(cut_half) {
            translate([-100,0,0])
            cube([200,200,200]);
        }
    }
}

module titan_extruder_vitamins_assembly(length, heigth, motor_type) {
//    translate([10,0,0])
    translate_z(heigth+15+3) {
        rotate([0,0,90]) {
            translate_z(0.75) {
                titan_extruder();
                titan_stepper_position(2) NEMA(motor_type);
            }
        }
        translate_z(-16.5) 
            children();
    }
    translate_z(9.7)
    titan_hot_end_position() { 
        e3d_hot_end_cooler_assembly();
        translate_z(-40)
        titan_extruder_heatbreak_cooler(length, cut_half = true);
    }
}

module titan_extruder_assembly(        
        width, 
        length, 
        inset_length, 
        inset_depth, 
        heigth,
        motor_type = NEMA17S) {
    titan_extruder_vitamins_assembly(
            length = length, 
            heigth = heigth, 
            motor_type = motor_type)
        toolhead_titan_extruder_mount(
            width = width, 
            length = length,
            inset_length = inset_length,
            padding = 5,
            motor_type = motor_type
        );
    
    translate_z(heigth)
    toolhead_extruder_top_plate(
        width = width, 
        length = length, 
        inset_length = inset_length
    );
            
    toolhead_extruder_bottom_plate(        
        width = width, 
        length = length, 
        inset_length = inset_length,
        inset_depth = inset_depth,
        heigth = heigth
    );    
}

module fan_duct_splitter_stl() {
    $fn = 90;
    rotate([90,0,0])
    fan_duct_splitter();
}

module fan_duct_splitter() {
    stl("fan_duct_splitter");
    
    module triple() {
        rotate([0,45,0])
        children();

        rotate([0,-45,0])
        children();


    }
    
    
    h = 15;
    ir = 3/2;
    difference() {
        union() {
            triple()
            translate_z(.5)
            tube(or = 4.5/2, ir = ir, h = h, center = false);
            
            translate_z(-h)
            tube(or = 7/2, ir = 2, h = h, center = false);
            sphere(d = 7);
        }
        triple()
        cylinder(r = ir, h = h+2);

        translate_z(-h-2)
        cylinder(r = 2.5, h = h+3);
    }
}

//fan_duct_splitter_stl();

//titan_extruder_assembly(60, 100, 80, 8, 29);
//cooler_stl();

//toolhead_titan_extruder_groove_collet_top_part1_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part2_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part3_44x29_stl();
//render()
//titan_extruder_heatbreak_cooler_100_stl();

//toolhead_titan_extruder_groove_collet_top_44x29_stl();

//toolhead_titan_extruder_mount_60x100x80_NEMA17S_5_stl();
//toolhead_titan_extruder_groove_collet_44x29_100_stl();


//D16T_toolhead_extruder_top_plate_W60xL100_IL80_dxf();
//D16T_toolhead_extruder_bottom_plate_W60xL100_IL80_ID8_dxf();