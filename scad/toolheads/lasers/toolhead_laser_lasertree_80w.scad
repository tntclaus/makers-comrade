include <NopSCADlib/utils/core/core.scad>
include <../toolhead_utils.scad>

tool_h = 40;
tool_w = 40;
tool_l = 60;

laser_offset = 15-tool_w/2;

mounts_h = 4;
mounts_offset = 6/2;


module toolhead_laser_lasertree_80w_place_laser_window() {
    translate([0, laser_offset, 0])
        children();
}

module toolhead_laser_lasertree_80w_place_mounts() {
    translate([mounts_offset, 0, mounts_h])
        children();

    translate([-mounts_offset, 0, mounts_h])
        children();
}



module toolhead_laser_lasertree_80w() {
    color("green") {
        difference() {
            cube([tool_l, tool_w, tool_h], center = true);
            translate([0, tool_w/2, -tool_h/2])
                toolhead_laser_lasertree_80w_place_mounts()
            rotate([90,0,0])
            cylinder(d = 3, h = 10, center = true);
        }
    }
    translate([0,0,-tool_h/2])
    toolhead_laser_lasertree_80w_place_laser_window() {
//        cylinder(d = 15, h = 5, center = true);
        cylinder(d = 2, h = 20, center = true);
    }
}


module toolhead_laser_lasertree_80w_place_tool() {
    translate([0,10/2-2,0])
        children();
}

module toolhead_laser_lasertree_80w_piezo_probe() {
    stl("ABS_toolhead_laser_lasertree_80w_piezo_probe");
    difference() {
        union() {
            cube([10, 60, 2], center = true);
            cube([3, 63, 2], center = true);
        }
        translate([0,-20+10+3,0])
            cylinder(r = M3_clearance_radius, h = 5, center = true);
        translate([0,20+10-5,0])
            cylinder(r = M3_clearance_radius, h = 5, center = true);
    }
}
module ABS_toolhead_laser_lasertree_80w_piezo_probe_stl() {
    translate_z(1)
    toolhead_laser_lasertree_80w_piezo_probe();
}

module ABS_toolhead_laser_lasertree_80w_case_stl() {
    $fn = 90;
    translate_z(40+5)
    rotate([180,0,0])
    toolhead_laser_lasertree_80w_case();
}
module toolhead_laser_lasertree_80w_case() {
    stl("ABS_toolhead_laser_lasertree_80w_case");

    translate_z(40)
    difference() {
        linear_extrude(5, convexity = 3)
            toolhead_bottom_plate_sketch(width = 60, length = 100, inset_length = 80, inset_depth = 5);

        cube([58,30,30], center = true);

        for(x = [-1,1])
        for(y = [-1,1])
        translate([x*20,y*20,0]) {
            cylinder(r = M3_clearance_radius, h = 20, center = true);
            cylinder(r = 3, h = 3.5);
        }

        translate([0,-15,0])
        cylinder(d = 16, h = 2, center = true);

//        toolhead_laser_lasertree_80w_place_tool()
//        toolhead_laser_lasertree_80w_place_laser_window()
//        cylinder(d = 15, h = 10, center = true);
    }
    difference() {
        translate([0, 24, 19.5])
            cube([66, 2, 41], center = true);

        translate([0, 24, -1])
            toolhead_laser_lasertree_80w_place_mounts()
            rotate([90,0,0])
            cylinder(r = M3_clearance_radius, h = 10, center = true);
    }

    module support() {
        color("red")
            hull() {
                translate([- 32, 0, 40])
                    cube([2, 12, 2], center = true);
                translate([- 32, 24, 10])
                    cube([2, 2, 20], center = true);
            }
    }

    support();
    mirror([1,0,0])
    support();

}

module toolhead_laser_lasertree_80w_assembly() {
    translate_z(-tool_h-3)
    assembly("toolhead_laser_lasertree_80w"){
        translate_z(tool_h/2-1)
        toolhead_laser_lasertree_80w_place_tool()
        toolhead_laser_lasertree_80w();

        toolhead_laser_lasertree_80w_case();

        translate_z(tool_h/2-1)
        translate([0,-30,-10])
        rotate([90,0,0])
        toolhead_laser_lasertree_80w_piezo_probe();
    }
}


//toolhead_laser_lasertree_80w_assembly();
ABS_toolhead_laser_lasertree_80w_case_stl();

translate([0,35,0])
rotate([0,0,90])
ABS_toolhead_laser_lasertree_80w_piezo_probe_stl();
