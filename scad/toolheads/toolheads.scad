use <toolhead_extruder_orbiter_e3d.scad>
use <toolhead_extruder_orbiter_mosquito.scad>
use <toolhead_extruder_titan_e3d.scad>
use <lasers/toolhead_laser_lasertree_80w.scad>

translate([-120,0,0])
toolhead_extruder_titan_e3d_assembly(60, 100, 80, 8, 29);

toolhead_extruder_orbiter_e3d_assembly(60, 100, 80, 8, 29);

translate([120,0,0])
toolhead_extruder_orbiter_mosquito_assembly(60, 100, 80, 8, 29);

translate([240,0,0])
toolhead_laser_lasertree_80w_assembly();
