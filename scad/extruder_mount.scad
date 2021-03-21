

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
    
    toolhead_titan_extruder_groove_collet(groove_collet_width);
    rotate([0,0,180]) 
    toolhead_titan_extruder_groove_collet(groove_collet_width);
    
}

//module titan_adapt_carriage() {
//    titan_adapt_carriage_stl();
//
//    translate_z(-11)
//    titan_hot_end_position()
//    precision_piezon_mount_holes([0,0,90]) {
//        translate_z(-1)
//        nut(M3_nut);
//    }
//
//    titan_extruder_cover_hole(0)
//        screw(M3_cap_screw, 35);
//    
//    titan_extruder_cover_hole(1)
//        screw(M3_cap_screw, 35);
//
//    titan_extruder_cover_hole(2)
//        translate_z(2) screw(M3_cap_screw, 35);
//
//    titan_extruder_cover_hole(3)
//        translate_z(2) screw(M3_cap_screw, 20);
//
//    rotate([0,-14,0])
//    translate([-47,7.3,14])
//    color("green")
//    rotate([0,180,0])
//    precision_piezzon_pcb_v2_75();
//}


module toolhead_titan_extruder_groove_collet_44_stl() {
    toolhead_titan_extruder_groove_collet(
        44
    );
}

module toolhead_titan_extruder_groove_collet(
    width
) {
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X + 3.5) * 2;
    
    stl_name = str(
    "toolhead_titan_extruder_groove_collet", "_",
    width
    );
//    echo(stl_name);
    stl(stl_name);
    
    heigth = hot_end_groove(E3DVulcano);
    screw_mount_column_h = (29-heigth)/2;
    
    translate_z(heigth/2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        union() {
            rounded_rectangle([length, width, heigth], r=3, center = true);
            translate([-length/2+4,0,screw_mount_column_h+heigth/2])
                rounded_rectangle([8, width, 29-heigth], r=3, center = true);

        }
        cylinder(d = hot_end_groove_dia(E3DVulcano), h = heigth+1, center = true);

        toolhead_xtruder_groove_collet_mounts()
            translate_z(-heigth) cylinder(d = 4.01, h = heigth*4);
        
        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(-heigth) cylinder(d = 4.01, h = 1000);
        
        translate([length, 0, 0])
            cube([length*2, width*2, heigth*4], center = true);
    }
    
    
    
}

module toolhead_titan_extruder_mount_60x80x42_NEMA17S_5_stl() {
    toolhead_titan_extruder_mount(
        width, 
        inset_length,
        heigth,
        motor_type,
        padding = 10
    );
}

module toolhead_titan_extruder_mount(
    width, 
    length,
    inset_length,
    heigth,
    motor_type,
    padding = 10
) {
    stl_name = str(
        "toolhead_titan_extruder_mount", "_",
        width, "x",
        inset_length,"x",
        heigth,"_",
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
        translate([13.6,10.87,NEMA_width(motor_type)/2])
        rotate([0,90,0])
        linear_extrude(2) difference() {
            NEMA_outline(motor_type);
            circle(NEMA_boss_radius(motor_type));
            NEMA_screw_positions(motor_type) circle(d = 3.1);
        }

    }
    
}


module titan_extruder_vitamins_assembly(heigth, motor_type) {
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
    }
}

module titan_extruder_assembly(        
        width, 
        length, 
        inset_length, 
        inset_depth, 
        heigth,
        motor_type = NEMA17S) {
    titan_extruder_vitamins_assembly(heigth, motor_type)
        toolhead_titan_extruder_mount(
            width = width, 
            length = length,
            inset_length = inset_length,
            heigth = 42,
            padding = 5,
            motor_type = motor_type
        );
    
    translate_z(heigth)
    toolhead_extruder_top_plate(
        width = width, length = length, inset_length = inset_length
   );
            
    toolhead_extruder_bottom_plate(        
        width = width, 
        length = length, 
        inset_length = inset_length,
        inset_depth = inset_depth
    );    
}

titan_extruder_assembly(60, 100, 80, 8, 29);

//titan_adapt_carriage_stl();
