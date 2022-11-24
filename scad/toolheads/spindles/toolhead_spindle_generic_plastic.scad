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

    coolant_hose_size = 12;
    vacuum_hose_size = 12;

    linear_extrude(5, convexity = 5)
    motor_mount_bottom_plate_sketch(
    width,
    length,
    inset_length,
    inset_depth,
    coolant_hose_size,
    vacuum_hose_size,
    type);

    module latch_wall() {
        wall_heigth = heigth-8;
        wall_length = inset_length/2;
        offs = width / 2 - inset_depth - 1 / 2;

        color("teal")
        translate([0, offs, 0]) {
            translate_z((wall_heigth) / 2)
            cube([wall_length, 1, wall_heigth], center = true);

            translate_z(wall_heigth-7.5)
            hull() {
                cube([wall_length, 1, 1], center = true);
                translate([0,2.5, 7])
                cube([wall_length, inset_depth, 1], center = true);
            }

            translate([0, - 1, 0])
                translate_z((wall_heigth+10) / 2)
                cube([wall_length, 1, wall_heigth+10], center = true);
        }
    }

    latch_wall();
    mirror([0,1,0])
    latch_wall();
}
