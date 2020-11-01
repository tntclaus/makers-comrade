include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>


include <../screw_assemblies.scad>

module caret_bracket_assembly(
    type, 
    part_thickness = 2, 
    screw_type = M5_pan_screw, 
    nut_type = M5_nut, 
    max_screw_depth = 6) { //! Assembly with fasteners in place
    extrusion_corner_bracket(type);

    screw_washer_thickness = washer_thickness(screw_washer(screw_type));
    nut_washer_type = nut_washer(nut_type);
    nut_washer_thickness = nut_washer_type ? washer_thickness(nut_washer_type) : 0;

    nut_offset = extrusion_corner_bracket_base_thickness(type) + part_thickness;
    screw_length = max_screw_depth ? screw_shorter_than(extrusion_corner_bracket_base_thickness(type) + screw_washer_thickness + max_screw_depth)
                                   : screw_longer_than(nut_offset + screw_washer_thickness + nut_washer_thickness + nut_thickness(nut_type));

    extrusion_corner_bracket_hole_positions(type) {
        screw_and_washer(screw_type, screw_length);
        translate_z(-nut_offset)
            vflip()
                if(nut_washer_type)
                    nut_and_washer(nut_type, true);
                else
                    rotate(90)
                        sliding_t_nut(nut_type);
    }
}