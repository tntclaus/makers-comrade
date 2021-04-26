include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/screws.scad>

include <gears/gears.scad>

NEMA14_ROUND  = ["NEMA14",   35.2, 19,     19, 19,     11,     2,     2.5,     6,          43.85/2 ];

MR95ZZ = ["MR95ZZ", 5, 9, 3, "blue",     0.5, 0.5];

//M4_cs_cap_screw  =  ["M4_cs_cap","M4 cs cap",    hs_cs_cap,4, 8.0, 0,    1.49,2.5, 20,  M4_washer, M4_nut,   M4_tap_radius,    M4_clearance_radius];

M5_cs_pan_screw     = ["M5_cs_cap","M5 cs cap",    hs_cs_cap,   5, 10,  3.95,   0,   0, 0,   M5_washer, M5_nut,   M5_tap_radius,    M5_clearance_radius];

//translate([0,28/2,0])
planetary_gear(
    modul=0.42, 
    sun_teeth=10, 
    planet_teeth=26, 
    number_planets=3, 
    width=3, 
    rim_width=0.5, 
    bore=2.5, 
    planet_bore  = 9,
//    pressure_angle=20, 
//    helix_angle=30, 
//    together_built=false, 
    optimized=false
    ) {
   translate_z(1.5) {
        ball_bearing(MR95ZZ);
//        translate_z(13.5-6.9)
//        screw(M5_cs_pan_screw, 10);
    } 
}

difference() {
hull()
planetary_gear_planets_position(
    modul=0.42, 
    sun_teeth=10, 
    planet_teeth=26, 
    number_planets=3, 
    width=3, 
    rim_width=0.5, 
    bore=2.5, 
    planet_bore  = 9
) {
   translate_z(6) {
       cylinder(d = 10, h =4, center = true);
       cylinder(d = 11, h =3, center = true);
    } 
}
planetary_gear_planets_position(
    modul=0.42, 
    sun_teeth=10, 
    planet_teeth=26, 
    number_planets=3, 
    width=3, 
    rim_width=0.5, 
    bore=2.5, 
    planet_bore  = 9
) {
   translate_z(1.5) {
//        ball_bearing(MR95ZZ);
        translate_z(13.5-6.9)
        screw(M5_cs_pan_screw, 10);
    } 
}

}
//planetary_gear_planets_position(
//    modul=0.42, 
//    sun_teeth=10, 
//    planet_teeth=26, 
//    number_planets=3, 
//    width=3, 
//    rim_width=0.5, 
//    bore=2.5, 
//    planet_bore  = 9
//) {
//   translate_z(4.5) {
//        cylinder(d = 12, h =4, center = true);
//    } 
//}

//translate_z(5)
//rotate([180,0,0])
//screw(M5_cs_pan_screw, 15);
//
////rotate([0,0,45])    
//translate_z(-5)
//NEMA(NEMA14_ROUND);


