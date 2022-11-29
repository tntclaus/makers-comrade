include <toolhead_spindle_generic.scad>


module toolhead_plastic_spindle_holder(
width,
length,
heigth,
inset_length,
inset_depth,
type
) {
    name = str(
    "ABS_toolhead_plastic_spindle_holder_",
    SPINDLE_motor_name(type)
    );
    stl("ABS_toolhead_plastic_spindle_holder_");

    coolant_hose_size = 0;
    vacuum_hose_size = 16;

    vacuum_hose_position = hose_position(length + 1, vacuum_hose_size);

    i_depth = inset_depth - 2;

    difference() {
        linear_extrude(5, convexity = 5)
            motor_mount_bottom_plate_sketch(
            width,
            length,
            inset_length + 1,
            i_depth,
            coolant_hose_size,
            vacuum_hose_size,
            type);

        translate_z(3)
        cylinder(d = SPINDLE_motor_diameter(type) + 2, h = 10);

        translate(vacuum_hose_position)
            hose_base_plate_drill_children(30){
                cylinder(d = 2.5, h = 10);
            }
    }

    translate(vacuum_hose_position) {
        difference() {
            union() {
                cylinder(d1 = 20.5, d2 = 18.5, h = heigth);
                cylinder(d = 22, h = 5);
            }

            cylinder(d = vacuum_hose_size, h = heigth * 3, center = true);
        }
    }

    module latch_wall() {
        wall_heigth = heigth - 5;
        wall_length = inset_length / 2;
        offs = width / 2 - i_depth - 1 / 2;

        color("teal")
            translate([0, offs, 0]) {
                translate_z((wall_heigth) / 2)
                cube([wall_length, 1, wall_heigth], center = true);

                translate_z(wall_heigth - 7.5)
                hull() {
                    cube([wall_length, 1, 1], center = true);
                    translate([0, 2.5, 7])
                        cube([wall_length, inset_depth, 1], center = true);
                }

                translate([0, - 1, 0])
                    translate_z((wall_heigth + 13) / 2)
                    cube([wall_length, 1, wall_heigth + 13], center = true);
            }
    }

    latch_wall();
    mirror([0, 1, 0])
        latch_wall();
}
