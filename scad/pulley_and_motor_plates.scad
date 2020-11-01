include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

include <screw_assemblies.scad>

CORNER_PLATE_COORDS = [
    [3,3,3],
    [3,37,3],
    [37,37,3],
    [37,23,3],    
//    [23,17,-3],        
    [17,3,3],            
    ];
    

module pulley_corner_plate() { 
    dxf("pulley_corner_plate");
    
    difference() {
        rounded_polygon(CORNER_PLATE_COORDS);
        translate([10,10,0]) circle(d = 5);
        translate([30,30,0]) circle(d = 5);        
        translate([10,30,0]) circle(d = 4);                
    }
}

module pulley_corner_plate_dxf() {
    pulley_corner_plate();
}

module corner_pulley_assembly(pos1, pos2, length, plate_thickness) {
    mirror([0,0,1]) screw(M4_cs_cap_cross_screw, length);
    translate_z(plate_thickness) spring_washer(M4_washer);
    translate_z(plate_thickness+1) washer(M4_washer);
    translate_z(plate_thickness+1.5) washer(M4_washer);
    translate_z(plate_thickness+2) washer(M4_washer);    
    translate_z(plate_thickness+2.5) washer(M4_washer);        
    translate_z(plate_thickness+3) nut(M4_nut);
    translate_z(plate_thickness+14.5) nut(M4_nut);    
    translate_z(plate_thickness+17.5) washer(M4_washer);        
    translate_z(plate_thickness+18) washer(M4_washer);
    translate_z(plate_thickness+18.5) washer(M4_washer);    
    translate_z(plate_thickness+19) washer(M4_washer);        
    translate_z(plate_thickness+19.5) washer(M4_washer);        
    translate_z(plate_thickness+20) nut(M4_nut);            
    translate_z(plate_thickness+23) nut(M4_nut);
    translate_z(plate_thickness+34) nut(M4_nut);    

    translate_z(plate_thickness+pos1) pulley(GT2x20_plain_idler);
    translate_z(plate_thickness+pos2) pulley(GT2x20_plain_idler);    
}

module corner_pulley_block(pos1, pos2, length = 40, plate_thickness=3) { 
    color("#e1e1e1") linear_extrude(plate_thickness) pulley_corner_plate();
    translate([10,30,0]) corner_pulley_assembly(pos1,pos2,length,plate_thickness);

}

