use <../lib/hotend_mosquito/heatbreak.scad>

mosquito_heatbreak_assembly();


//mosquito_radiator_radiator_mount_screws_placement()
//translate([0,0,-40])
//cylinder(d = 2, h = 10);

mosquito_radiator_hotend_screws_placement()
translate([0,0,-40])
cylinder(d = 2, h = 10);
