include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>
include <x-axis.scad>
include <brackets.scad>


//include <NopSCADlib/vitamins/pulleys.scad>
//use <NopSCADlib/vitamins/pulley.scad>
include <carets.scad>


module D16T_y_caret_60_dxf() {
    $fn = 180;
    projection() vslot_plate(GET_Y_PLATE(w = 60));
}

module y_pulley_block(length, plate_thickness) {
    translate([0,0,-plate_thickness]) mirror([0,0,1]) screw(M4_cs_cap_cross_screw, length);
    translate_z(1) nut(M4_nut);
    spring_washer(M4_washer);
    translate_z(length-14) pulley(Y_PULLEY);
}

module yAxisRails(position = 0, size, baseLength, xAxisLength, railSpacing = 60, mirrored = false) {
        dxf(str("D16T_y_caret_", railSpacing));
    
        positionAdj = 
            position > workingSpaceSizeMaxY 
                ? workingSpaceSizeMaxY : 
                position < workingSpaceSizeMinY ? workingSpaceSizeMinY :
                position;
        
        elevation = size + 30;
        
    
        translate([baseLength, baseLength-10, elevation]) rotate([-90,90,180]) {
                vslot_rail(
                    GET_Y_RAIL(railSpacing), 
                    size, 
                    pos = positionAdj, 
                    mirror = true
                ) {
                    if(!mirrored) { 
                        translate([-xAxisLength/2-15, 0, 10])  
                                xAxisRails(position, xAxisLength, railSpacing/2);
                    }
                 
                    if(!mirrored) {
                        translate([0,PULLEY_Y_COORDINATE2,0]) y_pulley_block(37.5, 3);
                        translate([-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE,0]) y_pulley_block(20.5, 3);
                    } else {
                        translate([0,PULLEY_Y_COORDINATE2,0]) y_pulley_block(20.5, 3);
                        translate([-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE,0]) y_pulley_block(37.5, 3);                        
                    }
                    
                    if(mirrored) {
                        
                    }
                    
                }                
            }
    }

//y_caret_stl();
//y_caret_60_dwg();

//workingSpaceSizeMaxX  = 1000;
//workingSpaceSizeMinX = 0;
//workingSpaceSizeMaxY  = 1000;
//workingSpaceSizeMinY = 0;
//baseFrontSize = 50;
//xAxisLength = 50;
//baseLength = 500;
//yAxisRails(65, 200, 10, 300);
    
//gantry_poly_plate_xx3_15_dxf();