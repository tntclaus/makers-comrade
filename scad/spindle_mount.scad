include <NopSCADlib/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/vitamins/screws.scad>


include <../lib/utils.scad>
include <../lib/spindle/spindles.scad>

use <../lib/modularHoseLibrary.scad>

show_hose = true;
show_magnets = true;

function VERTICAL_SCREW_MOUNTS(x = 26, y = 20) = [
    [ x,  y],
    [ x, -y],
    [-x,  y],
    [-x, -y],
];


function BOTTOM_PLATE(width, length, inset_length, inset_depth, r = 1) = [
    [-(length-r*2)/2, (width-r*2)/2, r],

    // карман
    [-(length+2)/2+(length-inset_length)/2, (width-2)/2, 1],    
    [-(length-2)/2+(length-inset_length)/2, (width-2)/2-(inset_depth-2), -1],
    [ (length-2)/2-(length-inset_length)/2, (width-2)/2-(inset_depth-2), -1],    
    [ (length+2)/2-(length-inset_length)/2, (width-2)/2, 1],    

    [ (length-r*2)/2, (width-r*2)/2, r],
    [ (length-r*2)/2,-(width-r*2)/2, r],

    // карман
    [ (length+2)/2-(length-inset_length)/2, -(width-2)/2, 1],    
    [ (length-2)/2-(length-inset_length)/2, -(width-2)/2+(inset_depth-2), -1],
    [-(length-2)/2+(length-inset_length)/2, -(width-2)/2+(inset_depth-2), -1],    
    [-(length+2)/2+(length-inset_length)/2, -(width-2)/2, 1],    

    [-(length-r*2)/2,-(width-r*2)/2, r],    
];

function TOP_PLATE(width, length, r = 1) = [
    [-(length-r*2)/2, (width-r*2)/2, r],
    [ (length-r*2)/2, (width-r*2)/2, r],
    [ (length-r*2)/2,-(width-r*2)/2, r],
    [-(length-r*2)/2,-(width-r*2)/2, r], 
];


function PLATE_SCREW_CONNECTORS(width, length, padding) = [
    [-(length-padding)/2, (width-padding)/2, 0],
    [ (length-padding)/2, (width-padding)/2, 0],
    [ (length-padding)/2,-(width-padding)/2, 0],
    [-(length-padding)/2,-(width-padding)/2, 0],
];

module plate_corner_position(width, length, padding) {
    for(position = PLATE_SCREW_CONNECTORS(width, length, padding))
        translate(position)
        children();
}


module motor_collet_60_100_84_3_RS895_stl() {
    $fn=180;
    motor_collet(60, 100, 84, 3, RS895);
}

module motor_collet(width, length, heigth, wall_thickness = 30, type) {
    stl(
        str(
        "motor_collet","_",
        width,"_",
        length,"_",
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
        
        plate_mount_locations(-heigth/2)
            cylinder(d = 4.01, h = heigth*2);

    }
}

module motor_mount_bottom_plate_60_100_84_3_RS895_dxf() {
    projection() mount_bottom_plate(60, 100, 84, 3, RS895);
}

module motor_mount_bottom_plate(
    width, 
    length, 
    inset_length, 
    inset_depth, 
    type, 
    coolant_hose_size,
    vacuum_hose_size,
    thickness = 3) {
    dxf(
        str(
        "motor_mount_bottom_plate","_",
        width,"_",
        length,"_",
        inset_length,"_",
        inset_depth,"_",
        type[0])
    );

    coolant_hose_position = [length/2-coolant_hose_size-4.5,0,0];        
    vacuum_hose_position = [-length/2+vacuum_hose_size+4,0,0];

    color("silver")
    difference() {
        translate_z(-3)
        linear_extrude(thickness)
        rounded_polygon(BOTTOM_PLATE(width, length, inset_length, inset_depth));
        translate_z(1)
        SPINDLE_cutouts(type);
        
        translate_z(-thickness) {
            translate(coolant_hose_position)
            hose_base_plate_drill_holes(coolant_hose_size, thickness, 25, 3.05);
                    
            translate(vacuum_hose_position)    
            hose_base_plate_drill_holes(vacuum_hose_size, thickness, 25, 3.05);
        }
        
        plate_corner_position(width, length, 10)
        translate_z(-1-thickness)
        mount_magnet_mount_hole(thickness);
        
        plate_mount_locations(-4)
            cylinder(d = 3.01, h = 10);

    }
    
    
    
//    translate([length/2-4, width/2-4, 0])
//    translate_z(-30)
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

module motor_mount_top_plate(
        width, length, type, inset_length,
        coolant_hose_size,
        vacuum_hose_size,
        thickness = 3
    ) {
    dxf(
        str(
        "motor_mount_top_plate","_",
        width,"x",
        inset_length,"_",
        type[0])
    );

    coolant_hose_position = [length/2-coolant_hose_size-4.5,0,0];        
    vacuum_hose_position = [-length/2+vacuum_hose_size+4,0,0];


    color("#aaaaaa")
    difference() {
        linear_extrude(3)
        rounded_polygon(TOP_PLATE(width, inset_length));
        translate_z(-1)
        cylinder(d = SPINDLE_motor_shield_diameter(type)+0.5, h = 5);
        
        translate_z(-thickness/2) {
            translate(coolant_hose_position) hull() {
                cylinder(d = coolant_hose_size+4, h = thickness*2);
                translate([coolant_hose_size, 0, 0])
                cylinder(d = coolant_hose_size+4, h = thickness*2);
            }
                    
            translate(vacuum_hose_position) hull() {   
                cylinder(d = vacuum_hose_size+4, h = thickness*2);
                translate([-vacuum_hose_size, 0, 0])
                cylinder(d = vacuum_hose_size+4, h = thickness*2);
            }
        }
        plate_corner_position(width, inset_length, 10)
        translate_z(-1)
        mount_magnet_mount_hole(thickness);
        
        plate_mount_locations(-1)
            cylinder(d = 4.01, h = 10);
    }    
    
    plate_corner_position(width, inset_length, 10)
    translate_z(3)
    mount_magnet();
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

module mount_magnet() {
    if(show_magnets) {
        translate_z(2.5)
        screw(M3_cs_cap_screw, 5);
        magnet_round_hole(10,3,3,7);
    }
}



module mount_magnet_mount_hole(thickness) {
    cylinder(d = 2, h=thickness*2);
}

module magnet_round_hole(d, h, dia_inner1, dia_inner2) {
    // https://mirmagnitov.ru/product/nyeodimovyy-magnit-disk-10kh3-mm-s-zyenkovkoy-3-5-7-mm-n35uh/
    vitamin(str(
        "Magnet N35UH", "_",
        d, "x", h, "_",
        dia_inner1,"x",dia_inner2
    ));
    
    difference() {
        cylinder(d = d, h = h);

        translate_z(-0.01)
            cylinder(r1 = dia_inner1/2, r2 = dia_inner2/2, h = h+0.02);
    }

}

module magnet_square(
        width, 
        length,
        heigth
) {
    vitamin(str(
        "Magnet", "_",
        width, "x",
        length, "x",
        heigth
    ));
    
    translate_z(heigth/2)
    cube([width, length, heigth], center = true);
}


module plate_mount_locations(z = 0) {
    for(location = VERTICAL_SCREW_MOUNTS())
        translate([location.x, location.y, z])
        children();
}

module spindle_assembly(
        width, 
        length, 
        inset_length, 
        inset_depth, 
        heigth, 
        type = RS895
    ) {
    i4 = 25.4/4;
    i3 = 25.4/3;
    
    coolant_hose_size = i4;
    vacuum_hose_size = 8;


    plate_mount_locations(33)
        screw(M4_cap_screw, 35);

    
    SPINDLE_ER11_assembly(type);
    motor_mount_bottom_plate(
        width, length, inset_length, inset_depth, type,
        coolant_hose_size = coolant_hose_size,
        vacuum_hose_size = vacuum_hose_size
    );    
    
    
    motor_collet(width-inset_depth*2, length, heigth, type = type);
    mirror([1,0,0])
    motor_collet(width-inset_depth*2, length, heigth, type = type);

    translate_z(heigth)
    motor_mount_top_plate(
        width = width, length = length, inset_length = inset_length, type = type,
        coolant_hose_size = coolant_hose_size,
        vacuum_hose_size = vacuum_hose_size
   );
}

spindle_assembly(
    width = 60, 
    length = 100, 
    inset_length = 80, 
    inset_depth = 6, 
    heigth = 30);

//motor_mount_bottom_plate_60_100_84_3_RS895_dxf();
