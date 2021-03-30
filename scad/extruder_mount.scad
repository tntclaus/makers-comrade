

include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>

use <../lib/e3d_titan/e3d_titan_extruder.scad>

include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../lib/utils.scad>

use <extruder_heatbreak_cooler.scad>
use <toolhead_utils.scad>

use <../lib/modularHoseLibrary.scad>

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

coolant_hose_size = 11;
hose_hole_y_shift = -12;

TOOLHEAD_EXTRUDER_PLASTIC_COLOR = "#3377ff";

TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X = 26;
TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_Y = 18;

function coolant_hose_position(length, y_shift = 0) = [length/2-coolant_hose_size/2-4.5,y_shift,0];
function vacuum_hose_position(length, y_shift = 0) = [-length/2+coolant_hose_size/2+4.5,y_shift,0];

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

module toolhead_xtruder_groove_collet_mounts() {
    for(point = TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts = 28/2))
        translate(point) children();
}

module precision_piezzon_pcb_v2_75() {
    rotate([90,-90,0])
    translate([-111,0,0])
    import("../libstl/precision-piezo-uniboard2.75.stl");
}



//COVER_MOUNT_1 = [-29,8,3.2];
//COVER_MOUNT_2 = [22,8,3.2];
//COVER_MOUNT_3 = [22,8,57];

module toolhead_extruder_top_plate_sketch(
        width, length, inset_length
    ) {
    
        
    difference() {
        toolhead_top_plate_sketch(width, inset_length);
        circle(d = PTFE_TUBE_DIA);
        
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            circle(d = 4.01);
        
        translate(coolant_hose_position(length, hose_hole_y_shift)) hull() {
            circle(d = coolant_hose_size+6);
            translate([coolant_hose_size, 0, 0])
            circle(d = coolant_hose_size+6);
        }
                
        translate(vacuum_hose_position(length, hose_hole_y_shift)) hull() {   
            circle(d = coolant_hose_size+6);
            translate([-coolant_hose_size, 0, 0])
            circle(d = coolant_hose_size+6);
        }
    }    
}

module D16T_toolhead_extruder_top_plate_W60xL100_IL80_dxf() {
    $fn = 180;
    toolhead_extruder_top_plate_sketch(width = 60, length = 100, inset_length = 80);
}

module toolhead_extruder_top_plate(
        width, length, inset_length,
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
        
    plate_corner_position(width, inset_length, 10)
    translate_z(thickness)
    mount_magnet();
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
        circle(d = 16.05);
        toolhead_xtruder_groove_collet_mounts() circle(d = 3.05);

        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            circle(d = 3.01);
            
        translate(coolant_hose_position(length))
        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05);
                    
        translate(vacuum_hose_position(length))    
        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05); 
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
        
    plate_corner_position(width, length, 10)
    mount_magnet();
    
    groove_collet_width = width-inset_depth*2;
    
    toolhead_titan_extruder_groove_collet(groove_collet_width, heigth);
    rotate([0,0,180]) 
    toolhead_titan_extruder_groove_collet(groove_collet_width, heigth);

    translate_z(hot_end_groove(E3DVulcano))
    toolhead_titan_extruder_groove_collet_top(groove_collet_width, heigth);    
    
    translate(vacuum_hose_position(length))
    hose_base_plate(10, 20, 4, 3.45, false);
}


module cooler_stl() {
    $fn = 180;
    hose_base_plate(10, 20, 4, 3.45, false);
}

module toolhead_titan_extruder_groove_collet_44x29_stl() {
    toolhead_titan_extruder_groove_collet(
        44,
        29
    );
}

module toolhead_titan_extruder_groove_collet(
    width,
    heigth
) {
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X + 3.5) * 2;
    
    stl_name = str(
    "toolhead_titan_extruder_groove_collet", "_",
    width, "x",
    heigth
    );
//    echo(stl_name);
    stl(stl_name);
    
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    screw_mount_column_h = (heigth-groove_collet_heigth)/2;
    
    groove_dia = hot_end_groove_dia(E3DVulcano);
    
    translate_z(groove_collet_heigth/2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        union() {
            rounded_rectangle([length, width, groove_collet_heigth], r=3, center = true);
            translate([-length/2+4,0,screw_mount_column_h+groove_collet_heigth/2])
                rounded_rectangle([8, width, heigth-groove_collet_heigth], r=3, center = true);

        }
        cylinder(d = groove_dia, h = groove_collet_heigth+1, center = true);

        toolhead_xtruder_groove_collet_mounts()
            translate_z(-groove_collet_heigth) cylinder(d = 4.01, h = groove_collet_heigth*4);
        
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(-groove_collet_heigth) cylinder(d = 4.01, h = 1000);
        
        translate([length, 0, 0])
            cube([length*2, width*2, groove_collet_heigth*4], center = true);
    }
}

module toolhead_titan_extruder_groove_collet_top_44x29_stl() {
    $fn=180;
    toolhead_titan_extruder_groove_collet_top(44,29);
}

module toolhead_titan_extruder_groove_collet_top(
    width,
    top_plate_distance
) {
    groove_collet_heigth = hot_end_groove(E3DVulcano);
    groove_collet_top_heigth = 4;
    heigth = top_plate_distance - groove_collet_heigth;
    
    stl_name = str(
    "toolhead_titan_extruder_groove_collet_top", "_",
    width, "x",
    heigth
    );
//    echo(stl_name);
    stl(stl_name);
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X - 5) * 2;
    
    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;

        
    translate_z(groove_collet_top_heigth/2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR) {
        difference() {

            rounded_rectangle([length, width, groove_collet_top_heigth], r=3, center = true);

            cylinder(d = 16.2, h = heigth+1, center = true);

            toolhead_xtruder_groove_collet_mounts()
                translate_z(-heigth) cylinder(d = 4.01, h = heigth*4);
            
            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                translate_z(-heigth) cylinder(d = 4.01, h = 1000);
            
        }

        translate([0,0,(groove_collet_top_heigth+ptfe_cylinder_heigth)/2]) 
        difference() {
            cylinder(d1 = 18, d2 = 8, h = ptfe_cylinder_heigth, center = true);
            cylinder(d1 = 16, d2 = 4, h = ptfe_cylinder_heigth+.1, center = true);
        }
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
        linear_extrude(3) difference() {
            square([inset_length - padding, width - padding], center = true); 
            circle(d = PTFE_TUBE_DIA);
            
            translate(coolant_hose_position(length, hose_hole_y_shift)) hull() {
                circle(d = coolant_hose_size+6);
                translate([coolant_hose_size, 0, 0])
                circle(d = coolant_hose_size+6);
            }
                    
            translate(vacuum_hose_position(length, hose_hole_y_shift)) hull() {   
                circle(d = coolant_hose_size+6);
                translate([-coolant_hose_size, 0, 0])
                circle(d = coolant_hose_size+6);
            }
            
            
            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                circle(d = 4.1);
            
            plate_corner_position(width,inset_length, 10)
                circle(d = 15);
        }
        
        translate_z(2.95)
        translate([13.6,10.87,NEMA_width(motor_type)/2]) {
            rotate([0,90,0])
            linear_extrude(2) difference() {
                NEMA_outline(motor_type);
                circle(NEMA_boss_radius(motor_type));
                NEMA_screw_positions(motor_type) circle(d = 3.1);
            }
            
            translate([8.5,-NEMA_width(motor_type)/2-1,-NEMA_width(motor_type)/2])
            hull() {
                translate([-7.5,0,NEMA_width(motor_type)-1-5])
                cube([2,2,2], center = true);
                cube([17,2,0.1], center = true);
            }
        }

    }
    
}

module titan_extruder_heatbreak_cooler_100_stl() {
    $fn = 180;
    titan_extruder_heatbreak_cooler(length = 100);
}

module titan_extruder_heatbreak_cooler(
    length
) {
    stl(str("titan_extruder_heatbreak_cooler", "_", length));
    
    external_face_w = 20;
    
    zero_level = 33.4-3;

//    render() 
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        hull() {
            translate_z(zero_level)
            resize([94, 40, 0.7])
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
            translate(coolant_hose_position(length))
            cylinder(d = 11, h = 1);
            translate_z(1)
            cylinder(d = 25, h = 1);
        }
        
        hull() {
            translate_z(zero_level)
            translate(vacuum_hose_position(length))
            cylinder(d = 11, h = 1);
            translate_z(1)
            cylinder(d = 25, h = 1);
        }
        
        
        toolhead_xtruder_groove_collet_mounts()
                translate_z(-1) cylinder(d = 3.6, h = 1000);
            
            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                translate_z(-1) cylinder(d = 4.01, h = 1000);
        
        
//        translate(vacuum_hose_position(length))   
//        linear_extrude(100) 
//        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05); 
        
        //разрез
        translate([-100,0,0])
        cube([200,200,200]);
    }
}

module titan_extruder_vitamins_assembly(length, heigth, motor_type) {
//    translate([10,0,0])
    translate_z(heigth+15+3) {
        rotate([0,0,90]) {
            translate_z(0.75) {
                titan_extruder();
//                titan_stepper_position(2) NEMA(motor_type);
            }
        }
        translate_z(-16.5) 
            children();
    }
    translate_z(9.7)
    titan_hot_end_position() { 
        e3d_hot_end_cooler_assembly();
        translate_z(-40)
        titan_extruder_heatbreak_cooler(length);
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

//titan_extruder_assembly(60, 100, 80, 8, 29);
cooler_stl();

//render()
//titan_extruder_heatbreak_cooler_100_stl();

//toolhead_titan_extruder_groove_collet_top_44x29_stl();

//toolhead_titan_extruder_mount_60x100x80_NEMA17S_5_stl();
//toolhead_titan_extruder_groove_collet_44_stl();