include <NopSCADlib/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>


include <../../lib/utils.scad>
include <../../lib/spindle/spindles.scad>

use <../../lib/modularHoseLibrary.scad>
use <toolhead_utils.scad>

show_hose = false;


function TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS(x = 30, y = 18) = [
    [ x,  y],
    [ x, -y],
    [-x,  y],
    [-x, -y],
];

coolant_hose_size = 20;
coolant_hose_size_out = coolant_hose_size+4;
coolant_hose_out_wall_dia = coolant_hose_size_out+2;

module motor_collet_44_100_30_RS895_stl() {
    $fn=180;

    motor_collet(
    width = 44,
    length = 100,
    heigth = 30,
    type = RS895);
}

module motor_collet(width, length, heigth, wall_thickness = 30, type) {
    stl(
        str(
        "motor_collet","_",
        "W", width,"x",
        "L", length,"x",
        "H", heigth, "_",
        type[0])
    );


    collet_size = SPINDLE_motor_shield_diameter(type)+wall_thickness;

    color("#1111ff")
    render()
    difference() {
        cylinder(d = collet_size, h = heigth);
        translate_z(-1/2)
        cylinder(d = SPINDLE_motor_shield_diameter(type)+0.5, h = heigth+1);

        // половина
        translate([-collet_size/2+10, 0,collet_size])
        cube([collet_size, collet_size, collet_size*3], center = true);

        // срез сбоку
        translate([0, -collet_size/2-width/2,collet_size])
        cube([collet_size, collet_size, collet_size*3], center = true);

        // срез сбоку
        translate([0, collet_size/2+width/2,collet_size])
        cube([collet_size, collet_size, collet_size*3], center = true);

        // срез в центре
        translate([0, 0,collet_size])
        cube([collet_size, collet_size/3, collet_size*3], center = true);

        plate_corner_position(collet_size, width, 5);

        toolhead_screw_mount_locations(TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS(),-heigth/2)
            cylinder(d = 4.01, h = heigth*2);

    }
}

module D16T_motor_mount_bottom_plate_W60xL100_IL80_ID8_CH8_VH12_RS895_dxf() {
    $fn = 180;
    motor_mount_bottom_plate_sketch(60, 100, 80, 8, 8, 12, RS895);
}

module D16T_motor_mount_top_plate_W60xL100_IL80_CH8_VH12_RS895_dxf() {
    $fn = 180;
    motor_mount_top_plate_sketch(60, 100, 80, 8, 12, RS895);
}
module D16T_motor_mount_bottom_plate_W60xL100_IL80_ID8_CH8_VH11_RS895_dxf() {
    $fn = 180;
    motor_mount_bottom_plate_sketch(60, 100, 80, 8, 8, 11, RS895);
}

module D16T_motor_mount_top_plate_W60xL100_IL80_CH8_VH11_RS895_dxf() {
    $fn = 180;
    motor_mount_top_plate_sketch(60, 100, 80, 8, 11, RS895);
}

module motor_mount_bottom_plate_sketch(
    width,
    length,
    inset_length,
    inset_depth,
    coolant_hose_size,
    vacuum_hose_size,
    type) {
    coolant_hose_position = hose_position(length+1, coolant_hose_size, m=1);
    vacuum_hose_position = hose_position(length+5, vacuum_hose_size);


    difference() {
        toolhead_bottom_plate_sketch(width, length, inset_length, inset_depth);
        SPINDLE_cutouts(type);

        translate(coolant_hose_position)
        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05);

        translate(vacuum_hose_position)
        hose_base_plate_drill_holes(vacuum_hose_size, 25, 3.05);

         toolhead_screw_mount_locations(TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS())
            circle(d = 3.01);
    }
}



module motor_mount_bottom_plate(
    width,
    length,
    inset_length,
    inset_depth,
    coolant_hose_size,
    vacuum_hose_size,
    type,
    thickness = 3) {
    dxf(
        str(
        "D16T_motor_mount_bottom_plate","_",
        "W", width,"x",
        "L", length,"_",
        "IL", inset_length,"_",
        "ID", inset_depth,"_",
        "CH", coolant_hose_size, "_",
        "VH", vacuum_hose_size, "_",
        type[0])
    );

    color("silver")
    translate_z(-3)
    linear_extrude(thickness)
    motor_mount_bottom_plate_sketch(
        width,
        length,
        inset_length,
        inset_depth,
        coolant_hose_size,
        vacuum_hose_size,
        type);
    coolant_hose_position = hose_position(length+1, coolant_hose_size, m=1);
    vacuum_hose_position = hose_position(length+5, vacuum_hose_size);



    plate_corner_position(width, length, 10)
    mount_magnet();


    if(show_hose) {
        translate_z(-thickness) {
            rotate([180,0,0]) translate(coolant_hose_position)
            coolant_hose_chain(coolant_hose_size);

            rotate([180,0,0]) translate(vacuum_hose_position)
            rotate([0,0,180])
            vacuum_cleaner_hose_chain(vacuum_hose_size);
        }
    }
}

module motor_mount_top_plate_sketch(
        width, length, inset_length,
        coolant_hose_size,
        vacuum_hose_size,
        type,
        thickness = 3
    ) {
    coolant_hose_position = hose_position(length+3, coolant_hose_size, m=1);
    vacuum_hose_position = hose_position(length+10, vacuum_hose_size);


    difference() {
        toolhead_top_plate_sketch(width, inset_length);
        circle(d = SPINDLE_motor_shield_diameter(type));


        translate(coolant_hose_position) hull() {
            circle(d = coolant_hose_size+4);
            translate([coolant_hose_size, 0, 0])
            circle(d = coolant_hose_size+4);
        }

        translate(vacuum_hose_position) hull() {
            circle(d = vacuum_hose_size+4);
            translate([-vacuum_hose_size, 0, 0])
            circle(d = vacuum_hose_size+4);
        }

        toolhead_screw_mount_locations(TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS())
            circle(d = 4.01);
    }
}

module motor_mount_top_plate(
        width, length, inset_length,
        coolant_hose_size,
        vacuum_hose_size,
        type,
        thickness = 3
    ) {
    dxf(
        str(
        "D16T_motor_mount_top_plate","_",
        "W", width,"x",
        "L", length,"_",
        "IL", inset_length,"_",
        "CH", coolant_hose_size, "_",
        "VH", vacuum_hose_size, "_",
        type[0])
    );

    color("#aaaaaa")
    linear_extrude(thickness)
    motor_mount_top_plate_sketch(
        width, length, inset_length,
        coolant_hose_size,
        vacuum_hose_size,
        type,
        thickness
    );

//    plate_corner_position(width, inset_length, 10)
//    translate_z(3)
//    mount_magnet();
//    translate([length/2-20, width/2-10, -2])
    toolhead_screw_mount_locations(TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS())
    translate_z(-0.45)
    piezo_disc();
}

module coolant_hose_chain(size) {
    angle = 15;
    $fn = 20;
    color("blue") {
        translate_z(-3)
        rotate([180,0,0])
        hose_base_plate(size, 22, 3.05, 4.5);

        hose_base_plate(size, 22, 3.05, 4.5)
        rotate([0,angle,-angle])
        hose_segment(size)
        rotate([0,angle,-angle])
        hose_segment(size)
        rotate([0,-2*angle,-angle])
        hose_segment(size)
        rotate([0,-2*angle,angle])
        hose_segment(size)
        rotate([0,-2*angle,angle])
        hose_segment(size)
        rotate([0,-2*angle,2*angle])
        hose_round_nozzle(size, 3);
    }
}

module vacuum_cleaner_hose_chain(size) {
    angle = 15;
    $fn = 20;
    color("green") {
        translate_z(-3)
        rotate([180,0,0])
        hose_base_plate(size, 24, 3.05, 5.5);

        hose_base_plate(size, 24, 3.05, 5.5)
        rotate([0,angle,-angle])
        hose_segment(size)
        rotate([0,angle,-angle])
        hose_segment(size)
        rotate([0,-2*angle,-angle])
        hose_segment(size)
        rotate([0,-2*angle,angle])
        hose_segment(size)
        rotate([0,-2*angle,angle])
        hose_segment(size)
        rotate([0,-2*angle,2*angle])
        hose_flat_nozzle(size, size*2, size/2);
    }
}

module toolhead_spindle_assembly(
        width,
        length,
        inset_length,
        inset_depth,
        heigth,
        type = RS895
    ) {
    assembly("toolhead_spindle"){
        coolant_hose_size = 8;
        vacuum_hose_size = 12;

        toolhead_screw_mount_locations(TOOLHEAD_SPINDLE_RS895_VERTICAL_SCREW_MOUNTS(), 33)
        screw(M4_cap_screw, 35);


        SPINDLE_ER11_assembly(type);
        motor_mount_bottom_plate(
        width = width, length = length, inset_length = inset_length, type = type,
        coolant_hose_size = coolant_hose_size,
        vacuum_hose_size = vacuum_hose_size,
        inset_depth = inset_depth
        );


        motor_collet(width - inset_depth * 2, length, heigth, type = type);
        mirror([1, 0, 0])
            motor_collet(width - inset_depth * 2, length, heigth, type = type);

        translate_z(heigth)
        motor_mount_top_plate(
        width = width, length = length, inset_length = inset_length, type = type,
        coolant_hose_size = coolant_hose_size,
        vacuum_hose_size = vacuum_hose_size
        );
    }
}

//spindle_assembly(
//    width = 60,
//    length = 100,
//    inset_length = 80,
//    inset_depth = 8,
//    heigth = 30);

//D16T_motor_mount_bottom_plate_W60xL100_IL80_ID8_CH8_VH11_RS895_dxf();
//D16T_motor_mount_top_plate_W60xL100_IL80_CH8_VH11_RS895_dxf();
motor_collet_44_100_30_RS895_stl();
