include <toolhead_spindle_generic.scad>
include <toolhead_spindle_generic_plastic.scad>


module toolhead_spindle_rs775_assemby(
    width,
    length,
    inset_length,
    inset_depth,
    heigth
) {

    assembly("toolhead_spindle_rs775") {
        toolhead_spindle_assembly(
        width,
        length,
        inset_length,
        inset_depth,
        heigth,
        type = RS775
        );
    }
}

module toolhead_spindle_RS385_assemby(
    width,
    length,
    inset_length,
    inset_depth,
    heigth
) {

    assembly("toolhead_spindle_RS385") {
        toolhead_plastic_spindle_holder(
        width,
        length,
        heigth,
        inset_length,
        inset_depth,
        type = RS385
        );
    }
}

toolhead_spindle_RS385_assemby(
width = 60,
length = 100,
inset_length = 80,
inset_depth = 8,
heigth = 29
);
