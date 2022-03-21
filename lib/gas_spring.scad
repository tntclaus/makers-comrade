include <NopSCADlib/core.scad>

function gas_spring_function(type) = type[0];
function gas_spring_name(type) = type[1];
function gas_spring_cylinder_dia(type) = type[2];
function gas_spring_piston_dia(type) = type[3];
function gas_spring_cylinder_length(type) = type[4];
function gas_spring_piston_length(type) = type[5];
function gas_spring_mount_door_offset(type) = type[6];
function gas_spring_mount_wall_h_offset(type) = type[7];
function gas_spring_mount_wall_v_offset(type) = type[8];

module gas_spring_cylinder(type) {
    h = gas_spring_cylinder_length(type);
    translate_z(h/2)
    cylinder(d = gas_spring_cylinder_dia(type), h = h, center = true);
}

module gas_spring_piston(type) {
    h = gas_spring_piston_length(type);
    translate_z(h/2)
    cylinder(d = gas_spring_piston_dia(type), h = h, center = true);
}

module gas_spring(type, collapse = 20) {
    rotate([0,90-10,0]) {
        translate_z(gas_spring_piston_length(type))
        gas_spring_cylinder(type);
        gas_spring_piston(type);
    }
}

