include <toolhead_extruder_generic.scad>
use <../../lib/extruder_e3d_titan/e3d_titan_extruder.scad>
use <toolhead_extruder_heatbreak_e3d_cooler.scad>
use <../../lib/hotend_e3d/e3d_volcano.scad>

module toolhead_titan_extruder_mount_60x100x80_NEMA17S_5_stl() {
    toolhead_titan_extruder_mount(
        width = 60,
        length = 100,
        inset_length = 80,
        motor_type = NEMA17S,
        padding = 5
    );
}

module toolhead_titan_extruder_mount(
    width,
    length,
    inset_length,
    motor_type,
    padding = 10
) {

    stl_name = str(
        "toolhead_titan_extruder_mount", "_",
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
        }

        translate_z(2.95)
        translate([13.6,10.87,NEMA_width(motor_type)/2]) {
            rotate([0,90,0])
            linear_extrude(2) difference() {
                union() {
                    NEMA_outline(motor_type);
                    square_corner_w = NEMA_width(motor_type)/2;
                    translate([-square_corner_w+5,-square_corner_w-2])
                    square([NEMA_width(motor_type)-5,square_corner_w+2]);
                }
                circle(NEMA_boss_radius(motor_type));
                NEMA_screw_positions(motor_type) circle(d = 3.1);
            }

            translate([11.5,-NEMA_width(motor_type)/2-2.5,-NEMA_width(motor_type)/2])
            hull() {
                translate([-10.5,0,NEMA_width(motor_type)-1-5])
                cube([2,2,2], center = true);
                cube([23,2,0.1], center = true);
            }
        }

    }

}

module titan_extruder_vitamins_assembly(length, heigth, motor_type) {
//    translate([10,0,0])
    translate_z(heigth+15+3) {
        rotate([0,0,90]) {
            translate_z(0.75) {
                titan_extruder();
                titan_stepper_position(2) NEMA(motor_type);
            }
        }
        translate_z(-16.5)
            children();
    }
    translate_z(9.7)
    titan_hot_end_position() {
        e3d_volcano_hotend_assembly();
        translate_z(-40){
            toolhead_extruder_heatbreak_e3d_cooler(length, cut_half = true);
            toolhead_extruder_heatbreak_e3d_fan_duct_nozzle();
        }
    }
}

module toolhead_extruder_titan_e3d_assembly(
        width,
        length,
        inset_length,
        inset_depth,
        heigth,
        motor_type = NEMA17S) {
    titan_extruder_vitamins_assembly(
            length = length,
            heigth = heigth,
            motor_type = motor_type)
        toolhead_titan_extruder_mount(
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

    toolhead_extruder_e3d_bottom_plate(
        width = width,
        length = length,
        inset_length = inset_length,
        inset_depth = inset_depth,
        heigth = heigth
    );
}


//toolhead_extruder_titan_e3d_assembly(60, 100, 80, 8, 29);
//cooler_stl();

//toolhead_titan_extruder_groove_collet_top_part1_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part2_44x29_stl();
//toolhead_titan_extruder_groove_collet_top_part3_44x29_stl();
//render()
//toolhead_extruder_heatbreak_cooler_100_stl();

//toolhead_titan_extruder_groove_collet_top_44x29_stl();

//toolhead_titan_extruder_mount_60x100x80_NEMA17S_5_stl();
//toolhead_titan_extruder_groove_collet_44x29_100_stl();


//D16T_toolhead_extruder_top_plate_W60xL100_IL80_dxf();
//D16T_toolhead_extruder_bottom_plate_W60xL100_IL80_ID8_dxf();
