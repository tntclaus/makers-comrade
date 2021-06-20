include <toolhead_extruder_generic.scad>
use <../lib/extruder_orbiter/extruder_orbiter.scad>
use <toolhead_extruder_heatbreak_e3d_cooler.scad>

module toolhead_extruder_orbiter_mount_60x100x80_NEMA17S_5_stl() {
    toolhead_extruder_orbiter_mount(
        width = 60,
        length = 100,
        inset_length = 80,
        motor_type = NEMA17S,
        padding = 5
    );
}

module toolhead_extruder_orbiter_mount(
    width,
    length,
    inset_length,
    motor_type,
    padding = 10
) {

    stl_name = str(
        "toolhead_extruder_orbiter_mount", "_",
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
        difference() {
            linear_extrude(3) difference() {
                square([inset_length - padding, width - padding], center = true);
                circle(d = PTFE_TUBE_DIA);

                translate(hose_position(length, coolant_hose_size, hose_hole_y_shift)) hull() {
                    circle(d = coolant_hose_size+6);
                    translate([-coolant_hose_size, 0, 0])
                    circle(d = coolant_hose_size+6);
                }

                translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) {
                    for(x = [-4 : 2 : 5])
                        for(y = [-5.5 : 2 : 6.5])
                            translate([x*2, y*2, 0])
                                circle(d = 2.5);
                }

                wires_window(width);

                toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                    circle(d = 4.1);

//                plate_corner_position(width,inset_length, 10)
//                    circle(d = 15);
            }

            translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) {
                translate_z(2)
                for(x = [-4 : 2 : 5]) {
                    hull() {
                        translate([x*2, -5.5*2, 0])
                            cylinder(d = 2.5, h = 2);
                        translate([x*2, 16.5*2, 0])
                            cylinder(d = 2.5, h = 2);
                    }
                }
            }

            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                cylinder(d1 = 4.1, d2 = 8.1, h = 3.01);

            translate_z(-.1)
            cooling_tube_position(width-8, inset_length-2, 0)
                cylinder(d = 4.1, h = 3.2);

            rotate([0,0,-90])
            translate_z(-40)
            extruder_orbiter_mounts()
            cylinder(d = 3.8, h = 113.2);


            cooling_tube_position(width, inset_length+4, 5, m = true) {
                hull() {
//                    translate([0, 10, 0])
//                        cylinder(d = FAN_DUCT_OUTER_D+2, h = 100, center = true);
                    translate([10, 0, 0])
                        cylinder(d = FAN_DUCT_OUTER_D+2, h = 100, center = true);
                    cylinder(d = FAN_DUCT_OUTER_D+2, h = 100, center = true);
                }
            }
            cooling_tube_position(width, inset_length, 4) {

            }
        }


    }

}

module toolhead_extruder_orbiter_vitamins_assembly(length, heigth, motor_type) {
    translate_z(heigth+15+3) {
        rotate([0,0,-90]) {
            translate_z(-11.95) {
                extruder_orbiter();
                extruder_orbiter_stepper_position(2) LDO_stepper();
                //                NEMA(motor_type);
            }
        }
        translate_z(-16.5)
            children();
    }
    translate_z(5.9)
    extruder_orbiter_hot_end_position() {
        translate_z(-40) {
            toolhead_extruder_heatbreak_e3d_cooler(length, cut_half = true);
            toolhead_extruder_heatbreak_e3d_fan_duct_nozzle();
        }
    }
}

module toolhead_extruder_orbiter_assembly(
        width,
        length,
        inset_length,
        inset_depth,
        heigth,
        motor_type = NEMA17S) {
    toolhead_extruder_orbiter_vitamins_assembly(
            length = length,
            heigth = heigth,
            motor_type = motor_type)
        toolhead_extruder_orbiter_mount(
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

module fan_duct_splitter_stl() {
    $fn = 90;
    rotate([90,0,0])
    fan_duct_splitter();
}

module fan_duct_splitter() {
    stl("fan_duct_splitter");

    module triple() {
        rotate([0,45,0])
        children();

        rotate([0,-45,0])
        children();


    }


    h = 15;
    ir = 3/2;
    difference() {
        union() {
            triple()
            translate_z(.5)
            tube(or = 4.5/2, ir = ir, h = h, center = false);

            translate_z(-h)
            tube(or = 7/2, ir = 2, h = h, center = false);
            sphere(d = 7);
        }
        triple()
        cylinder(r = ir, h = h+2);

        translate_z(-h-2)
        cylinder(r = 2.5, h = h+3);
    }
}

//fan_duct_splitter_stl();
//toolhead_extruder_orbiter_mount_60x100x80_NEMA17S_5_stl();
toolhead_extruder_orbiter_assembly(60, 100, 80, 8, 29);
//toolhead_extruder_bottom_plate(60, 100, 80, 8, 29);
//cooler_stl();

//toolhead_titan_extruder_groove_collet_top_part1_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part2_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part3_44x29_stl();

//toolhead_titan_extruder_groove_collet_top_44x29_stl();

//toolhead_extruder_orbiter_mount_60x100x80_NEMA17S_5_stl();
//toolhead_titan_extruder_groove_collet_44x29_100_stl();


//D16T_toolhead_extruder_top_plate_W60xL100_IL80_dxf();
//D16T_toolhead_extruder_bottom_plate_W60xL100_IL80_ID8_dxf();
