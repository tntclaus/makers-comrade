use <toolhead_extruder_orbiter_e3d.scad>
use <toolhead_extruder_orbiter_mosquito.scad>
use <toolhead_extruder_titan_e3d.scad>

translate([-120,0,0])
toolhead_extruder_titan_e3d_assembly(60, 100, 80, 8, 29);

toolhead_extruder_orbiter_e3d_assembly(60, 100, 80, 8, 29);

translate([120,0,0])
toolhead_extruder_orbiter_mosquito_assembly(60, 100, 80, 8, 29);
