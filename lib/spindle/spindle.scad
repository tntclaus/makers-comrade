include <NopSCADlib/utils/core/core.scad>
include <../utils.scad>

function SPINDLE_motor_name(type) = type[0];
function SPINDLE_mount_center_offset(type) = type[1];

function SPINDLE_mount_coordinates(type) = [
    [-SPINDLE_mount_center_offset(type),  0, 0],
    [ SPINDLE_mount_center_offset(type),  0, 0],
//    [ 0, -SPINDLE_mount_center_offset(type), 0],
//    [ 0,  SPINDLE_mount_center_offset(type), 0],
];

function SPINDLE_motor_shield_diameter(type) = type[2];
function SPINDLE_motor_diameter(type) = type[3];
function SPINDLE_motor_heigth(type) = type[4];

function SPINDLE_motor_vent_holes_offset(type) = type[5];

function SPINDLE_motor_vent_holes_top_z(type) = type[6];
function SPINDLE_motor_vent_holes_top_heigth(type) = type[7];

function SPINDLE_shaft_diameter(type) = type[8];
function SPINDLE_shaft_heigth(type) = type[9];
function SPINDLE_shaft_z_offset(type) = type[10];
function SPINDLE_shaft_collar_diameter(type) = type[11];
function SPINDLE_shaft_collar_heigth(type) = type[12];

function SPINDLE_motor_mount_dia(type) = type[13];

function SPINDLE_assembly_z_offset() = 19.5;


module SPINDLE_cutouts(type, h = 10, d = 4, d_collar_off = 0) {
    d_collar = SPINDLE_shaft_collar_diameter(type) + d_collar_off;
    SPINDLE_vent_cutouts(type, d);
    SPINDLE_mount_cutouts(type);
    SPINDLE_shaft_collar_cutout(type, d_collar);
}

module SPINDLE_vent_cutout(type, d = 4) {
    rotate([180,0,90])
    arc(radius = SPINDLE_motor_vent_holes_offset(type)-d/2, angles = [23, 68], width = d);

}

module SPINDLE_shaft_collar_cutout(type, d = 4) {
    rotate([0,180,0])
    circle(d = d);
}

module SPINDLE_vent_cutouts(type, d = 4) {
    SPINDLE_vent_cutout(type, d);
    rotate([0,0,90])
    SPINDLE_vent_cutout(type, d);
    rotate([0,0,180])
    SPINDLE_vent_cutout(type, d);
    rotate([0,0,270])
    SPINDLE_vent_cutout(type, d);

}

module SPINDLE_mount_cutouts(type) {
    SPINDLE_mount_positions(type) circle(d = SPINDLE_motor_mount_dia(type));
}

module SPINDLE_mount_positions(type) {
    for(t = SPINDLE_mount_coordinates(type))
        translate(t)
        rotate([0,180,0])
        children();
}


module SPINDLE_motor(type) {
    vitamin(str(SPINDLE_motor_name(type), " DC Motor"));

    color("#a6a6a6")
    if(SPINDLE_motor_name(type) == "RS775") {
        rotate([90,0,0])
        import("Motor - RS-775.stl");
    } else if(SPINDLE_motor_name(type) == "RS895") {
        // https://grabcad.com/library/895-dc-motor-12-24v-1
        translate_z(-64.5)
        import("895DcMotor.stl");
    }
}

module SPINDLE_ER11_drill_bit() {
    color("silver")
    rotate([90,0,0])
    import("C16-ER11-35L 5mm Bit.stl");
}

module SPINDLE_ER11_chuck() {
    vitamin("ER11 chuck");
    vitamin("ER11 collet");    
    color("silver")
    rotate([90,0,0])
    import("C16-ER11-35L 5mm Shank Chuck Collet.stl");
}

module SPINDLE_ER11_nut() {
    vitamin("ER11 Nut");    
    color("#333333")
    rotate([90,0,0])
    import("C16-ER11-35L 5mm Nut.stl");
}

module SPINDLE_ER11_assembly(type) {
    translate_z(SPINDLE_shaft_z_offset(type)) {
        SPINDLE_motor(type);
        SPINDLE_ER11_chuck();
        SPINDLE_ER11_drill_bit();
        SPINDLE_ER11_nut();
    }
}

//SPINDLE_ER11_assembly(RS895);
//translate_z(-SPINDLE_shaft_collar_heigth(RS895))
//cylinder(d = SPINDLE_shaft_collar_diameter(RS895), h = SPINDLE_shaft_collar_heigth(RS895));
//SPINDLE_cutouts(RS895, 20);