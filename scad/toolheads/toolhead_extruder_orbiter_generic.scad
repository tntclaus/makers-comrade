include <toolhead_extruder_generic.scad>
include <toolhead_extruder_heatbreak_e3d_cooler.scad>
use <../../lib/extruder_orbiter/extruder_orbiter.scad>
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

                translate(hose_position(length, coolant_hose_size, hose_hole_y_shift, 1)) hull() {
                    circle(d = coolant_hose_size+6);
                    translate([coolant_hose_size, 0, 0])
                        circle(d = coolant_hose_size+6);
                }

                wires_window(width);

                toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
                    circle(d = 4.1);
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
                    translate([10, 0, 0])
                        cylinder(d = FAN_DUCT_OUTER_D+2, h = 100, center = true);
                    cylinder(d = FAN_DUCT_OUTER_D+2, h = 100, center = true);
                }
            }
        }
    }
}
