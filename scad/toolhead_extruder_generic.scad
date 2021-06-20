include <NopSCADlib/vitamins/hot_end.scad>
include <NopSCADlib/vitamins/hot_ends.scad>


include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <../lib/utils.scad>

include <toolhead_utils.scad>

use <../lib/modularHoseLibrary.scad>
use <NopSCADlib/utils/tube.scad>


//                                              corner  body    boss    boss          shaft
//                               side, length, radius, radius, radius, depth, shaft, length,      holes
NEMA17HS4023 = ["NEMA17HS4023", 42.3, 23, 53.6 / 2, 25, 11, 2, 5, 22, 31];
NEMA17HS0404 = ["NEMA17HS0404", 42.3, 29, 53.6 / 2, 25, 11, 2, 5, 22, 31];

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
E3DVulcano = ["E3D Volcano", e3d, "E3D Volcano direct", 62, 3.7, 16, 42.7, "silver", 12, 6, 15, [1, 5, - 4.5], 14, 21];


PTFE_TUBE_DIA = 4.18;

coolant_hose_size = 20;
coolant_hose_size_out = coolant_hose_size + 4;
coolant_hose_out_wall_dia = coolant_hose_size_out + 2;
hose_hole_y_shift = 0;

TOOLHEAD_EXTRUDER_PLASTIC_COLOR = "#3377ff";

TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X = 26;
TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_Y = 18;

TOOLHEAD_EXTRUDER_GROOVE_MOUNT_X = 15 / 2;
TOOLHEAD_EXTRUDER_HEATBREAK_MOUNT_X = 28 / 2;


FAN_DUCT_OUTER_D = 8;
FAN_DUCT_INNER_D = 6;

function TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS(
x = TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X,
y = TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_Y
) = [
        [x, y],
        [x, - y],
        [- x, y],
        [- x, - y],
    ];

function TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts) = [
        [- groove_mounts, groove_mounts],
        [- groove_mounts, - groove_mounts],
        [groove_mounts, - groove_mounts],
        [groove_mounts, groove_mounts],
    ];

module toolhead_extruder_groove_collet_mounts() {
    for (point = TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts = TOOLHEAD_EXTRUDER_GROOVE_MOUNT_X))
    translate(point) children();
}

module toolhead_extruder_heatbreak_cooler_mounts() {
    for (point = TOOLHEAD_EXTRUDER_SQUARE_MOUNTS(groove_mounts = TOOLHEAD_EXTRUDER_HEATBREAK_MOUNT_X))
    translate(point) children();
}

//module precision_piezzon_pcb_v2_75() {
//    rotate([90,-90,0])
//    translate([-111,0,0])
//    import("../libstl/precision-piezo-uniboard2.75.stl");
//}

module wires_window(width) {
    translate([0, - width / 2]) hull() {
        translate([- 6, 0])
            circle(d = 12);
        translate([6, 0])
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
            circle(d = coolant_hose_out_wall_dia + .1);
            translate([- coolant_hose_size, 0, 0])
                circle(d = coolant_hose_out_wall_dia + .1);
        }

        translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) hull() {
            circle(d = coolant_hose_out_wall_dia);
            translate([coolant_hose_size, 0, 0])
                circle(d = coolant_hose_out_wall_dia);
        }

        cooling_tube_position(width, inset_length + 4, 5, m = true) {
            hull() {
                translate([0, 10, 0])
                    circle(d = FAN_DUCT_OUTER_D + 2);
                translate([10, 0, 0])
                    circle(d = FAN_DUCT_OUTER_D + 2);
                circle(d = FAN_DUCT_OUTER_D + 2);
            }
        }

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
    dxf_name = str(
    "D16T_toolhead_extruder_top_plate", "_",
    "W", width, "x",
    "L", length, "_",
    "IL", inset_length);
    dxf(dxf_name);

    color("#aaaaaa")
        linear_extrude(thickness)
            toolhead_extruder_top_plate_sketch(
            width, length, inset_length
            );
}

module cooling_tube_position(width, inset_length, inset_depth, part = "both", m = false) {
    x = inset_length / 2 - 7;
    y = - (width / 2 - inset_depth - 7);

    if (part == "left" || part == "both")
        translate([x, y])
            children();

    if (part == "right" || part == "both")
        translate([- x, y]) {
            if (m)
                mirror([1, 0, 0])
                    children();
            else
                children();
        }
}

module toolhead_titan_extruder_groove_collet_44x29_100_stl() {
    toolhead_titan_extruder_groove_collet(
    44,
    29,
    100
    );
}

module toolhead_titan_extruder_groove_collet_44x29_100_mirrored_stl() {
    mirror([1, 0, 0])
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
//    echo(width, heigth, plate_length);
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X + 3.5) * 2;

    m4_grover_uncompressed_heigth = 1.75;
    m4_grover_half_compressed_heigth = 1.6;
    m4_grover_compressed_heigth = 1.1;

    m4_washer_heigth = 0.9;

    m4_washer_grover_assembly_h = m4_washer_heigth + m4_grover_half_compressed_heigth;

    stl_name = str(
    "toolhead_titan_extruder_groove_collet", "_",
    width, "x",
    heigth, "_",
    plate_length
    );

    stl_name_mirrored = str(
    "toolhead_titan_extruder_groove_collet", "_",
    width, "x",
    heigth, "_",
    plate_length,
    "_mirrored"
    );

    stl(stl_name_mirrored);

    groove_collet_heigth = hot_end_groove(E3DVulcano);
    screw_mount_column_h = (heigth - groove_collet_heigth) / 2;

    groove_dia = hot_end_groove_dia(E3DVulcano);

    translate_z(groove_collet_heigth / 2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
        difference() {
            union() {
                rounded_rectangle([length, width, groove_collet_heigth], r = 3, center = true);
                translate([- length / 2 + 4, 0, screw_mount_column_h + groove_collet_heigth / 2 -
                        m4_washer_grover_assembly_h / 2])
                    rounded_rectangle([8, width, heigth - groove_collet_heigth - m4_washer_grover_assembly_h], r = 3,
                    center = true);

                translate_z(- groove_collet_heigth / 2)
                translate(hose_position(plate_length, coolant_hose_size))
                    cylinder(d = coolant_hose_out_wall_dia, h = heigth + groove_collet_heigth / 2);

                translate_z(- groove_collet_heigth / 2)
                difference() {
                    fan_duct_tube(FAN_DUCT_OUTER_D);
                    fan_duct_tube(FAN_DUCT_INNER_D, true);
                }
            }
            cylinder(d = groove_dia, h = groove_collet_heigth + 1, center = true);

            //        toolhead_extruder_groove_collet_mounts()
            //            translate_z(-groove_collet_heigth) cylinder(d = 4.01, h = groove_collet_heigth*4);

            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(- groove_collet_heigth) cylinder(d = 4.01, h = 1000);

            translate([length, 0, 0])
                cube([length * 2, width * 2, groove_collet_heigth * 3], center = true);

            toolhead_extruder_groove_collet_mounts()
            cylinder(d = 3.01, h = 1000, center = true);

            toolhead_extruder_heatbreak_cooler_mounts() cylinder(d = 3.01, h = 1000, center = true);

            translate_z(- groove_collet_heigth)
            translate(hose_position(plate_length, coolant_hose_size))
                cylinder(d = coolant_hose_size, h = 1000);


            translate_z(heigth - groove_collet_heigth - 10)
            translate(hose_position(plate_length, coolant_hose_size))
                cylinder(d = coolant_hose_size_out, h = 1000);


        }
    module fan_duct_tube(d, cut = false) {
        hull() {
            if (cut == false) {
                cooling_tube_position(width, plate_length - 20, 0, part = "right") {
                    translate([d, d / 2, 0])
                        cylinder(d = .1, h = 10);
                }
            }
            cooling_tube_position(width, plate_length - 20, 0, part = "right") {
                cylinder(d = d, h = .1);
            }
            translate_z(heigth)
            cooling_tube_position(width, plate_length - 16, - 3, part = "right") {
                cylinder(d = d, h = .1);
            }
        }
        translate_z(heigth)
        cooling_tube_position(width, plate_length - 16, - 3, part = "right") {
            cylinder(d = d, h = 10);
        }
    }
}

module toolhead_titan_extruder_groove_collet_top_part1_44x29_stl() {
    $fn = 180;
    toolhead_titan_extruder_groove_collet_top_part1(44, 29);
}

module toolhead_titan_extruder_groove_collet_top_part2_44x29_stl() {
    $fn = 180;
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

    translate_z(18 + piezo_disc_thick) {
        translate_z(2)
        piezo_disc();
        color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
            translate_z(3.05 + piezo_disc_thick)
            toolhead_piezo_groove();
    }


    translate_z(groove_collet_top_heigth / 2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR) {
        toolhead_titan_extruder_groove_collet_top_part1(
        width,
        top_plate_distance
        );

        translate([0, 0, (groove_collet_top_heigth + ptfe_cylinder_heigth) / 2 - 3])
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



    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X - 5) * 2 - coolant_hose_out_wall_dia / 2 - 5;

    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;


    stl_name = str(
    "toolhead_titan_extruder_groove_collet_top_part1", "_",
    width, "x",
    heigth
    );
    stl(stl_name);

    difference() {
        rounded_rectangle([length, length, groove_collet_top_heigth], r = 3, center = true);

        cylinder(d = 16.2, h = heigth + 1, center = true);

        toolhead_extruder_groove_collet_mounts()
        translate_z(- heigth) cylinder(d = 3.01, h = heigth * 4);

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

    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X - 5) * 2 - coolant_hose_out_wall_dia / 2 - 5;

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
            translate_z(- 5) rounded_rectangle([length, length, 3], r = 3, center = true);
            translate_z(2.45)
            cylinder(d1 = 6, d2 = 6, h = ptfe_cylinder_heigth - 4, center = true);
        }
        translate_z(- 6.51)
        cylinder(d1 = 2, d2 = 4, h = ptfe_cylinder_heigth / 2);
        translate_z(- 6.51 + ptfe_cylinder_heigth / 2 - 0.01)
        cylinder(d = 4, h = ptfe_cylinder_heigth);

        toolhead_extruder_groove_collet_mounts()
        translate_z(- heigth) cylinder(d = 3.01, h = heigth * 4);
    }
}


module toolhead_extruder_bottom_plate_sketch(
width,
length,
inset_length,
inset_depth
) {
    difference() {
        toolhead_bottom_plate_sketch(width, length, inset_length, inset_depth);
        circle(d = 16.01);
        translate([0, 8])
            circle(d = 3.01);

        toolhead_extruder_groove_collet_mounts() circle(d = 2.3);

        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
        circle(d = 3.01);

        toolhead_extruder_heatbreak_cooler_mounts() circle(d = 3.01);

        translate(hose_position(length, coolant_hose_size))
            circle(d = coolant_hose_size);

        translate(hose_position(length, coolant_hose_size, 0, 1))
            circle(d = coolant_hose_size);

        cooling_tube_position(width, inset_length, inset_depth) {
            circle(d = FAN_DUCT_INNER_D);
        }

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
heigth,
thickness = 3
) {
    dxf_name = str(
    "D16T_toolhead_extruder_bottom_plate", "_",
    "W", width, "x",
    "L", length, "_",
    "IL", inset_length, "_",
    "ID", inset_depth);
    dxf(dxf_name);

    color("silver")
        translate_z(- thickness)
        linear_extrude(thickness)
            toolhead_extruder_bottom_plate_sketch(
            width,
            length,
            inset_length,
            inset_depth);

    groove_collet_width = width - inset_depth * 2;

    toolhead_titan_extruder_groove_collet(groove_collet_width, heigth, length);

    translate([0,0,0])
    mirror([1, 0, 0])
        toolhead_titan_extruder_groove_collet(groove_collet_width, heigth, length);

    translate_z(hot_end_groove(E3DVulcano))
    toolhead_titan_extruder_groove_collet_top(groove_collet_width, heigth);

}
//toolhead_titan_extruder_groove_collet(44, 29, 100);

