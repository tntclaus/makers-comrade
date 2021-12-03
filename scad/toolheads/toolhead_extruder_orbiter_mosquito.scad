include <toolhead_extruder_generic.scad>
include <toolhead_extruder_heatbreak_e3d_cooler.scad>
use <../../lib/extruder_orbiter/extruder_orbiter.scad>
use <toolhead_extruder_heatbreak_mosquito_cooler.scad>
use <toolhead_extruder_orbiter_generic.scad>

use <../../lib/hotend_mosquito/heatbreak.scad>
use <../../lib/hotend_mosquito/mosquito_magnum_hotend.scad>


module toolhead_extruder_orbiter_vitamins_assembly(
width, length, heigth, inset_length, inset_depth, motor_type) {
    translate_z(heigth + 15 + 3) {
        rotate([0, 0, - 90]) {
            translate_z(- 11.95) {
                extruder_orbiter();
                extruder_orbiter_stepper_position(2) LDO_stepper();
            }
        }
        translate_z(- 16.5)
        children();
    }

    toolhead_extruder_mosquito_bottom_plate(
    width = width,
    length = length,
    inset_length = inset_length,
    inset_depth = inset_depth,
    heigth = heigth
    );

    extruder_orbiter_hot_end_position() {
        translate_z(- 3)
        mosquito_magnum_hotend_assembly();
        translate_z(- 21.5 - 3) {
            toolhead_extruder_heatbreak_mosquito_cooler(length, cut_half = true);
            toolhead_extruder_heatbreak_mosquito_fan_duct_nozzle();
        }
    }
}

module toolhead_extruder_orbiter_mosquito_assembly(
    width,
    length,
    inset_length,
    inset_depth,
    heigth,
    motor_type = NEMA17S) {
    assembly("toolhead_extruder_orbiter_mosquito"){
        toolhead_extruder_orbiter_vitamins_assembly(
        width = width,
        length = length,
        heigth = heigth,
        inset_length = inset_length,
        inset_depth = inset_depth,
        motor_type = motor_type
        ){
            toolhead_extruder_orbiter_mount(
            width = width,
            length = length,
            inset_length = inset_length,
            padding = 5,
            motor_type = motor_type
            );
        }

        translate_z(heigth)
        toolhead_extruder_top_plate(
        width = width,
        length = length,
        inset_length = inset_length
        );
    }
}

//toolhead_extruder_orbiter_mosquito_assembly(
//    width = 60,
//    length = 100,
//    inset_length = 80,
//    inset_depth = 8,
//    heigth = 29
//);
//toolhead_extruder_orbiter_mount_60x100x80_NEMA17S_5_stl();
