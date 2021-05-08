include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/vitamins/extrusions.scad>

use <heat_bed_heater.scad>


///////////////////////////////////////////
///// NEW!!!!! 2021.04.13
///////////////////////////////////////////

TABLE_BASE_BORDER = 3;
TABLE_BASE_OFFSET = 3;

TABLE_BASE_COMPOUND_WALL_THICKNESS = 30;

STEEL_COLOR = "#555555";
STAINLESS_COLOR = "#999999";
D16T_COLOR = "#aaaaaa";

function HEATER_WIDTH(table_width) = 540;


module heatbed_table_base_extrusions(
    work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
    color("#aaaaaa11")
    for(x = [0:90:360]) {
        rotate([0,0,x])
        translate([-work_area_width/2, 10,0])
        rotate([90,0,0])
        extrusion(E2020, work_area_width);

//        translate([10, x,0])
//        rotate([0,90,0])
//        extrusion(E2020, work_area_width);
    }

//    rotate([90,0,0])
//    extrusion(E2020, work_area_width);
}

module heatbed_table_base_sketch(
    work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
    strenghtener_line_width = 33;
    
    assert(work_area_width >= 300);
    assert(mounts_num >= 3);
    assert(mounts_num <= 4);    
    
    width = work_area_width + TABLE_BASE_BORDER*2 + TABLE_BASE_OFFSET*2;
    
    min_width = width > 600 ? 600 : width;
    
    difference() {
        slw = strenghtener_line_width/3;
        
        rounded_square([min_width, width], TABLE_BASE_BORDER, center = true);
        for(x = [-1, 1])
            for(y = [-1, 1])
                translate([x*(work_area_width/4-slw), y*(work_area_width/4-slw)]) {
//                    circle(d = work_area_width/2-20);
                    rounded_square(
                    [work_area_width/2-4*slw, work_area_width/2-4*slw], 
                    TABLE_BASE_BORDER*4, center = true);
                }
                
//        rounded_square(work_area_width-46, TABLE_BASE_BORDER, center = true);
    }
    
    module v_strenghtener() {    
        line_width = strenghtener_line_width;
        
        hull() {
            translate([-min_width/2+2,0]) 
                square([1, line_width], center = true);
            translate([ min_width/2-2,min_width/3])
                square([1, line_width], center = true);
        }
        
        hull() {
            translate([-min_width/2+2,0]) 
                square([1, line_width], center = true);
            translate([ min_width/2-2,-min_width/3]) 
                square([1, line_width], center = true);
        }
    }
    
    v_strenghtener();
    
    rotate([0,0,90])
    v_strenghtener();

    rotate([0,0,180])
    v_strenghtener();

    rotate([0,0,270])
    v_strenghtener();
    
    mount_point_w = mount_point_offset < 45 ? 45 : mount_point_offset;
    
    module mount() {
        difference() {
            
            hull() {
                translate([0, -10])
                square([mount_point_w-5, 0.0001], center = true);
                
                translate([0, mount_length-4, 0])
                square([35, 8], center = true);
            }
            translate([ 00, mount_length-6.65, 0])
            circle(d = 5);

//            translate([-10, mount_length-4, 0])
//            circle(d = 4);

        }
    }
    
    translate([0, width/2, 0])
    mount();
    
    translate([ width/2-mount_point_offset-TABLE_BASE_BORDER*2, -width/2, 0])
    rotate([0,0,180])
    mount();

    translate([-(width/2-mount_point_offset-TABLE_BASE_BORDER*2), -width/2, 0])
    rotate([0,0,180])
    mount();
    
}
module GRANITE_heatbed_table_base_610_10_25_3_dxf() {
    heatbed_table_base_sketch(
        work_area_width = 610, 
        mount_length = 10,
        mount_point_offset = 25,
        mounts_num = 3
    );
}

module heatbed_table_base(
    work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
    dxf_name = str(
    "GRANITE_heatbed_table_base", "_",
    work_area_width, "_",
    mount_length, "_",
    mount_point_offset, "_",
    mounts_num
    );
    echo(dxf_name);
    dxf(dxf_name);
    color(STAINLESS_COLOR)
    linear_extrude(3)
    heatbed_table_base_sketch(
        work_area_width = work_area_width, 
        mount_length = mount_length,
        mount_point_offset = mount_point_offset,
        mounts_num = mounts_num
    );
}

module heater_compound_support_sketch(width) {
    translate([0,-TABLE_BASE_COMPOUND_WALL_THICKNESS/2])
    rotate([0,0,90])
    square([
        width - TABLE_BASE_COMPOUND_WALL_THICKNESS*3,         
        TABLE_BASE_COMPOUND_WALL_THICKNESS/2
    ], center = true);
}

module heater_compound_support(width) {
    dxf(str("heater_compound_support", width));
        color(D16T_COLOR)
    linear_extrude(3)
    heater_compound_support_sketch(width);
}

module heater_compound_wall_top_center_sketch(width) {
    wall_width = width/3;
    
    union() {
        square([wall_width, TABLE_BASE_COMPOUND_WALL_THICKNESS], center = true);
        square([
            wall_width+TABLE_BASE_COMPOUND_WALL_THICKNESS,      
            TABLE_BASE_COMPOUND_WALL_THICKNESS/2-0.1
        ], center = true);
    }
}

module heater_compound_wall_top_center(width) {
    dxf(str("heater_compound_wall_top_center_", width));
        color(D16T_COLOR)
    linear_extrude(3)
    heater_compound_wall_top_center_sketch(width);
}

module heater_compound_wall_top_corner_sketch(width) {
    wall_width = width/3-TABLE_BASE_COMPOUND_WALL_THICKNESS/2;
    
    difference() {
        union() {
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS);
                translate([wall_width, 0, 0])
                    square([
                        0.0001, 
                        TABLE_BASE_COMPOUND_WALL_THICKNESS
                    ], center = true);
            }
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS);
                translate([0, wall_width, 0])
                    square([
                        TABLE_BASE_COMPOUND_WALL_THICKNESS, 
                        0.0001
                    ], center = true);
            }
        }
        
            
        translate([0, wall_width, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS/2,      
                TABLE_BASE_COMPOUND_WALL_THICKNESS
            ], center = true);
        
            
        translate([wall_width, 0, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS,      
                TABLE_BASE_COMPOUND_WALL_THICKNESS/2
            ], center = true);
    }
}

module heater_compound_wall_top_corner(width) {
    dxf(str("heater_compound_wall_top_center_", width));
    color(STEEL_COLOR)
    linear_extrude(3)
    heater_compound_wall_top_corner_sketch(width);
}

module heater_compound_wall_bottom_corner_sketch(width) {
    wall_width = width/3-TABLE_BASE_COMPOUND_WALL_THICKNESS/2;
    
    difference() {
        union() {
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS);
                translate([wall_width, 0, 0])
                    square([
                        0.0001, 
                        TABLE_BASE_COMPOUND_WALL_THICKNESS
                    ], center = true);
            }
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS);
                translate([0, wall_width, 0])
                    square([
                        TABLE_BASE_COMPOUND_WALL_THICKNESS, 
                        0.0001
                    ], center = true);
            }
        }
        
            
        translate([0, wall_width, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS/2,      
                TABLE_BASE_COMPOUND_WALL_THICKNESS
            ], center = true);
        
            
        translate([wall_width, 0, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS,      
                TABLE_BASE_COMPOUND_WALL_THICKNESS/2
            ], center = true);
    }
}

module heater_compound_wall_bottom_corner(width) {
    dxf(str("heater_compound_wall_top_center_", width));
    color(STEEL_COLOR)
    linear_extrude(1)
    heater_compound_wall_bottom_corner_sketch(width);
}

module heater_table_compound_walls(
    heater_width
) {
    move_xy = (heater_width-TABLE_BASE_COMPOUND_WALL_THICKNESS)/2;
    translate([0, move_xy,0])
        heater_compound_wall_top_center(heater_width);

    translate([0,-move_xy,0])
        heater_compound_wall_top_center(heater_width);
    
    translate([ move_xy,0,0])
        rotate([0,0,90])
        heater_compound_wall_top_center(heater_width);
    
    translate([-move_xy,0,0])
        rotate([0,0,90])
        heater_compound_wall_top_center(heater_width);

    translate([-move_xy,-move_xy,0])
        heater_compound_wall_top_corner(heater_width);

    translate([move_xy,-move_xy,0])
        rotate([0,0,90])
        heater_compound_wall_top_corner(heater_width);

    translate([move_xy, move_xy,0])
        rotate([0,0,180])
        heater_compound_wall_top_corner(heater_width);

    translate([-move_xy, move_xy,0])
        rotate([0,0,270])
        heater_compound_wall_top_corner(heater_width);

    heater_compound_support(heater_width);
    
    translate([ heater_width/4, 0,0])
    rotate([0,0,180])
    heater_compound_support(heater_width);

    translate([-heater_width/4, 0,0])
    rotate([0,0,180])
    heater_compound_support(heater_width);
}

module heatbed_table_glassfiber_coat(
    heater_width,
    name = "unknown_brand",
    thickness = 5
) {
    width = heater_width + TABLE_BASE_COMPOUND_WALL_THICKNESS * 2;
    vitamin(
        str("heatbed_table_glassfiber_coat_",
            width, "x", width, "_",
            name, "_", 
            thickness, "mm"
        )
    );
    translate_z(thickness/2)
//    color("white")
//    cube([width,width, thickness], center = true);

    translate_z(thickness)
    heater_table_compound_walls(
        width
    );
}

module heatbed_table_thermal_compound(width, heigth) {
    
}

module heatbed_table_heater_08_2kW(work_area_width) {
    nichrome_wire_dia = 0.8;
    nichrome_wire_total_l = 10000;
    nichrome_wire_span_x  = 30;
    nichrome_wire_span_y = 490;
    
    width = 540;
    assert(
        work_area_width >= width, 
        "This is 2kW heater for tables bigger than 0.25 sq. meters"
    );

    heatbed_table_glassfiber_coat(width);
    translate_z(5)
//    heat_bed_heater(width, width);
    heatbed_table_thermal_compound();
}

module heatbed_table_ceramic_granite(
    work_area_width,
    thickness = 8
) {
    width = work_area_width;
    vitamin(
        str("heatbed_table_ceramic_granite_",
            width, "x", width, "x",
            thickness, "mm"
        )
    );
    translate_z(thickness/2)
    color("#333333")
    cube([width,width, thickness], center = true);
}

module heatbed_table_assembly(
    work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3) 
{
//    heatbed_table_base(
    heatbed_table_base_extrusions(
        work_area_width = work_area_width, 
        mount_length = mount_length,
        mount_point_offset = mount_point_offset,
        mounts_num = mounts_num
    );
//    translate_z(3) {
//        heatbed_table_heater_08_2kW(work_area_width);
//        translate_z(10)
//        heatbed_table_ceramic_granite(work_area_width);
//    }
}

heatbed_table_assembly(610, 60, 100);

//GRANITE_heatbed_table_base_610_10_25_3_dxf();

