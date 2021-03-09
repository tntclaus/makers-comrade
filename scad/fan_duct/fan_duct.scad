include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

include <../utils.scad>

module tube_adapter(exit_depth, exit_width, height, wall, in_dia = 6, stl = false) {
    difference() {
        hull() {
            translate_z(2)
            cube([exit_width+wall+0.5, exit_depth+wall+0.5, 4], center=true);
            translate_z(height)
            cylinder(d = in_dia+wall, h = 4, center = true, $fn=get_fn_for_stl(stl,360));
        }
        hull() {
            translate_z(2)
            cube([exit_width, exit_depth, 4], center=true);
            translate_z(height)
            cylinder(d = in_dia, h = 4, center = true, $fn=get_fn_for_stl(stl,360));
        }
        translate_z(2)
        cube([exit_width, exit_depth, 4], center=true);
        translate_z(height)
        cylinder(d = in_dia, h = 4, center = true);
    }

    translate_z(height + in_dia/2+wall)
    difference() {
        cylinder(d = in_dia+wall, h = in_dia, center = true, $fn=get_fn_for_stl(stl,360));
        cylinder(d = in_dia, h = in_dia+1, center = true, $fn=get_fn_for_stl(stl,360));
    }
}


module tube_adapter_square2square(in, out, height, wall, r = 1, stl = false) {
    difference() {
        hull() {            
            rounded_rectangle([in.x+wall, in.y+wall, 1], r, center=true);
            translate_z(height)
            rounded_rectangle([out.x+wall, out.y+wall, 1], r, center=true);
        }
        hull() {
            rounded_rectangle([in.x, in.y, 1], r, center=true);
            translate_z(height)
            rounded_rectangle([out.x, out.y, 1], r, center=true);
        }
    translate_z(height+out.z/2)
    rounded_rectangle(out, r, center=true);
//        translate_z(height)
//        cylinder(d = in_dia, h = 4, center = true);
    }
    difference() {
        translate_z(height+out.z/2)
        rounded_rectangle([out.x+wall, out.y+wall, out.z], r, center=true);

        translate_z(height+out.z/2)
        rounded_rectangle(out, r, center=true);
    }
    
    difference() {
        translate_z(-in.z/2)
        rounded_rectangle([in.x+wall, in.y+wall, in.z], r, center=true);

        translate_z(-in.z/2)
        rounded_rectangle(in, r, center=true);
    }
//    translate_z(height + in_dia/2+wall)
//    difference() {
//        cylinder(d = in_dia+wall, h = in_dia, center = true, $fn=get_fn_for_stl(stl,360));
//        cylinder(d = in_dia, h = in_dia+1, center = true, $fn=get_fn_for_stl(stl,360));
//    }
}

module fanduct_stl() {
    fanduct();
}

module fanduct(blowerType = RB5015)
{
    stl("fanduct");

    exit_depth = blower_depth(blowerType) + blower_wall(blowerType);
    exit_width = blower_exit(blowerType);
//    wall = blower_wall(blowerType);
    wall = 2;

    height = 30;

    tube_adapter(exit_depth, exit_width, height, wall, 12);

}

module blower_centered(blowerType = RB5015) {
    exit_depth = blower_depth(blowerType);
    exit_width = blower_exit(blowerType);
    wall = blower_wall(blowerType);
//    echo(exit_width);
    translate([-exit_width/2,-exit_depth/2,2])
    rotate([-90,0,0])
    blower(blowerType);    
}


module fanduct_assembly(blowerType = RB5015) {
//    render()
    fanduct(blowerType);
//    blower_centered(blowerType);
}

//fanduct_assembly();
