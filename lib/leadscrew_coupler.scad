include <NopSCADlib/utils/rounded_polygon.scad>

function LSC_name(type)     = type[0]; //! Part code
function LSC_outer_diameter(type)     = type[1]; // Shell diameter
function LSC_inner_diameter1(type)    = type[2]; // Diatemter of first rod/screw
function LSC_inner_diameter2(type) = type[3]; // Diatemter of second rod/screw
function LSC_height(type)   = type[4]; //! Shell height

module leadscrew_coupler(type) {
    vitamin(str(
    LSC_name(type), ", D=", LSC_outer_diameter(type), ", ",
    "d=", LSC_inner_diameter1(type), "x", LSC_inner_diameter2(type), ", ",
    "L=", LSC_height(type)
    ));
    color("#105a72")
    difference(){
        cylinder(d = LSC_outer_diameter(type), LSC_height(type), center=true);
        translate([0,0,LSC_height(type)/2-1])
            cylinder(d = LSC_inner_diameter1(type), LSC_height(type), center=true);
        translate([0,0,-LSC_height(type)/2+1])
            cylinder(d = LSC_inner_diameter2(type), LSC_height(type), center=true);

        translate_z(-LSC_height(type))
        cube([LSC_outer_diameter(type),LSC_outer_diameter(type),LSC_height(type)*2]);
    }
}
