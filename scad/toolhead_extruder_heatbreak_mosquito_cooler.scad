include <toolhead_extruder_generic.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
use <../lib/hotend_mosquito/heatbreak.scad>
use <../lib/hotend_mosquito/mosquito_magnum_hotend.scad>



module toolhead_extruder_heatbreak_mosquito_cooler_100_stl() {
    $fn = 180;
    toolhead_extruder_heatbreak_mosquito_cooler(plate_length = 100);
}

module toolhead_extruder_heatbreak_mosquito_top_sketch(length) {
    resize([length, 40])
        circle(d = 40);


    cooling_tube_position(
    width = 60,
    inset_length = length,
    inset_depth = 8
    ) {
        circle(d = FAN_DUCT_OUTER_D + 1);
    }
}

module toolhead_extruder_heatbreak_mosquito_fan_duct_exits(sx = 0, sy = 0, sz = 0, m = false) {
    x = 40 / 2 + sx;
    y = 0 + sy;
    z = 0 + sz;

    translate([x, y, z])
        children();
    translate([- x, y, z])
        if (m == true)
            mirror([1, 0, 0])
                children();
        else
            children();
}

module toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes() {
    max_heigth = 10;
    module fan_duct_mount_hole() {
        cylinder(d = 3.5, h = max_heigth);
        translate_z(2.1)
        cylinder(d = 6.5, h = 3, $fn = 6);

        hull() {
            translate_z(5)
            cylinder(d = 6.5, h = .1, $fn = 6);
            translate_z(max_heigth)
            cylinder(d = 3.5, h = .1);
        }
    }

    translate([0, - FAN_DUCT_OUTER_D - 2, 0])
        fan_duct_mount_hole();
    translate([0, FAN_DUCT_OUTER_D + 2, 0])
        fan_duct_mount_hole();
}

module toolhead_extruder_heatbreak_mosquito_cooler(
    plate_length,
    cut_half = false
) {
    stl(str("toolhead_extruder_heatbreak_mosquito_cooler", "_", plate_length));
    length = plate_length - TOOLHEAD_PLATES_BELT_INSET * 2 - 2;

    external_face_w = 20;

    zero_level = 21;

    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
        difference() {
            union() {
                hull() {
                    translate_z(zero_level)
                    linear_extrude(0.5)
                        toolhead_extruder_heatbreak_mosquito_top_sketch(length = length);

                    // низ
                    cylinder(d = 27, h = 1);
                    toolhead_extruder_heatbreak_mosquito_fan_duct_exits()
                    cylinder(d = FAN_DUCT_OUTER_D + 1, h = 0.5);
                }

                toolhead_extruder_heatbreak_mosquito_fan_duct_exits()
                rounded_rectangle([FAN_DUCT_OUTER_D, FAN_DUCT_OUTER_D * 3 + 4, 2], r = 1);
            }

            translate_z(- .1)
            toolhead_extruder_heatbreak_mosquito_fan_duct_exits() {
                toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes();
            }

            translate_z(zero_level+1)
            mosquito_radiator_block_volume();


            hull() {
                translate_z(zero_level)
                translate(hose_position(plate_length, coolant_hose_size))
                    cylinder(d = coolant_hose_size, h = 1);
                translate_z(1)
                cylinder(d = 23, h = 1);
            }

            hull() {
                translate_z(zero_level)
                translate(hose_position(plate_length, coolant_hose_size, 0, 1))
                    cylinder(d = coolant_hose_size, h = 1);
                translate_z(1)
                cylinder(d = 23, h = 1);
            }

            hull() {
                translate_z(zero_level)
                cooling_tube_position(
                width = 60,
                inset_length = length,
                inset_depth = 8,
                part = "left"
                )
                cylinder(d = FAN_DUCT_INNER_D, h = 1);

                translate_z(- 0.1) {
                    translate([40 / 2, 0, 0])
                        cylinder(d = FAN_DUCT_INNER_D, h = 1);
                }
            }

            hull() {
                translate_z(zero_level)
                cooling_tube_position(
                width = 60,
                inset_length = length,
                inset_depth = 8,
                part = "right"
                )
                cylinder(d = FAN_DUCT_INNER_D, h = 1);

                translate_z(- 0.1) {
                    translate([- 40 / 2, 0, 0])
                        cylinder(d = FAN_DUCT_INNER_D, h = 1);
                }
            }

            toolhead_extruder_heatbreak_cooler_mounts()
            translate_z(- 1) cylinder(d = 3.6, h = 1000);

            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(- 1) cylinder(d = 4.01, h = 1000);


            //        translate(vacuum_hose_position(length))
            //        linear_extrude(100)
            //        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05);

            //разрез
            if (cut_half) {
                translate([- 100, 0, - 1])
                    cube([200, 200, 200]);
            }
        }
}

module toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle_stl() {
    rotate([0,180,0])
    toolhead_extruder_heatbreak_mosquito_fan_duct_nozzle();
}
module toolhead_extruder_heatbreak_mosquito_fan_duct_nozzle() {
    stl("toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle");

    module object(d) {
        hull() {
            cylinder(d = d, h = .1);
            translate([- 7, 0, - 22])
                rotate([0, 60, 0])
                    resize([d / 2, d * 4, 3])
                        cylinder(d = d, h = 3);
        }
    }

    toolhead_extruder_heatbreak_mosquito_fan_duct_exits(m = true) difference() {
        union() {
            object(FAN_DUCT_OUTER_D);
            translate_z(-1.9)
            rounded_rectangle([FAN_DUCT_OUTER_D, FAN_DUCT_OUTER_D * 3 + 4, 2], r = 1);
        }
        object(FAN_DUCT_INNER_D);
        translate_z(-1.9)
        toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes();
    }
}

//translate_z(3)
//toolhead_extruder_bottom_plate(
//    width = 60,
//    length = 100,
//    inset_length = 80,
//    inset_depth = 8,
//    heigth = 29
//);

//rotate([0,0,90])
//mosquito_magnum_hotend_assembly();

translate_z(-21.5)
toolhead_extruder_heatbreak_mosquito_cooler(plate_length = 100, cut_half = true);
//toolhead_extruder_heatbreak_mosquito_cooler_100_stl();
translate_z(-21.5)
rotate([0,180,0])
toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle_stl();


//toolhead_extruder_heatbreak_mosquito_top_sketch(100);
