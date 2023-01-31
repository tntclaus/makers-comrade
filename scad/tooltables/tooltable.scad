include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/screws.scad>


///////////////////////////////////////////
///// NEW!!!!! 2021.04.13
///////////////////////////////////////////

function TABLE_BASE_BORDER() = 10;
function TABLE_BASE_OFFSET() = 0;

function TABLE_BASE_COMPOUND_WALL_THICKNESS() = 30;

STEEL_COLOR = "#555555";
STAINLESS_COLOR = "#999999";
D16T_COLOR = "#aaaaaa";

POPERECHINA_STEP = 100;

module tooltable_base_extrusions(
    work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
//    echo("extrusion", work_area_width);
    for(x = [0:90:360]) {
        rotate([0,0,x])
        translate([-work_area_width/2, 10,0])
        rotate([90,0,0])
        extrusion(E2020, work_area_width);
    }
}

module place_poperechina(work_area_width) {
    for(i = [-work_area_width/2 : POPERECHINA_STEP : work_area_width/2])
    translate([i,0,0])
    children();
}

module STEEL_3mm_tooltable_base_poperechina_bottom_300_dxf() {
    tooltable_base_poperechina_bottom(300);
}
module STEEL_3mm_tooltable_base_poperechina_top_300_dxf() {
    tooltable_base_poperechina_top(300);
}

module tooltable_base_poperechina_top(work_area_width) {
    dxf_name = str("STEEL_3mm_tooltable_base_poperechina_top_", work_area_width);
    dxf(dxf_name);
    tooltable_base_poperechina_sketch(work_area_width, cut = 1);
}

module tooltable_base_poperechina_bottom(work_area_width) {
    dxf_name = str("STEEL_3mm_tooltable_base_poperechina_bottom_", work_area_width);
    dxf(dxf_name);
    tooltable_base_poperechina_sketch(work_area_width, cut = -1);
}

function poperechina_width(work_area_width) = TABLE_BASE_BORDER() * 2 + work_area_width - 4;

module tooltable_base_poperechina_sketch(work_area_width, cut = 1) {
    width = poperechina_width(work_area_width);
    module ear() {
        square([3, 13], center = true);
        square([4, 7], center = true);
    }

    translate([width/2-4,6.5]) ear();

    difference() {
        rounded_square([width - 4, 10], 1, center = true);
        place_poperechina(work_area_width) {
            translate([0,-2.5 * cut])
            square([3, 5], center = true);
        }
    }

    translate([-width/2+4,6.5]) ear();
}


module tooltable_mount(mount_point_offset, mount_length) {
    difference() {
        hull() {
            translate([0, -10])
                square([mount_point_w(mount_point_offset)-5, 0.0001], center = true);

            translate([0, mount_length-4, 0])
                square([35, 8], center = true);
        }
        translate([ 00, mount_length-6.65, 0])
            circle(d = 5);

        //            translate([-10, mount_length-4, 0])
        //            circle(d = 4);

    }
}

function mount_point_w(mount_point_offset) = mount_point_offset < 45 ? 45 : mount_point_offset;

function fixture_mount_points(x_width, y_width) = [
        [x_width/2-TABLE_BASE_BORDER()/2, -(y_width/2-TABLE_BASE_BORDER()/2-60)]
    ];

function tooltable_width(work_area_width) = work_area_width + TABLE_BASE_BORDER()*2 + TABLE_BASE_OFFSET()*2;

module tooltable_base_sketch(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
    strenghtener_line_width = 33;
//    echo(y_work_area_width);
    assert(x_work_area_width >= 300);
    assert(y_work_area_width >= 300);

    assert(mounts_num >= 3);
    assert(mounts_num <= 4);

    x_width = tooltable_width(x_work_area_width);
    y_width = tooltable_width(y_work_area_width);

//    min_width = width > 700 ? 600 : width;

    difference() {
        slw = strenghtener_line_width/3;

        rounded_square([x_width, y_width], TABLE_BASE_BORDER(), center = true);
//        for(x = [-1, 1])
//            for(y = [-1, 1])
//                translate([x*(work_area_width/4-slw), y*(work_area_width/4-slw)]) {
////                    circle(d = work_area_width/2-20);
//                    rounded_square(
//                    [work_area_width/2-4*slw, work_area_width/2-4*slw],
//                    TABLE_BASE_BORDER()*4, center = true);
//                }

        rounded_square([x_work_area_width, y_work_area_width], 0.5, center = true);




        place_poperechina(x_work_area_width) {
            translate([0,poperechina_width(x_work_area_width)/2-4])
                square([3,3], center = true);
            translate([0,-poperechina_width(x_work_area_width)/2+4])
                square([3,3], center = true);
        }

        rotate([0,0,90])
        place_poperechina(y_work_area_width) {
            translate([0,poperechina_width(y_work_area_width)/2-4])
                square([3,3], center = true);
            translate([0,-poperechina_width(y_work_area_width)/2+4])
                square([3,3], center = true);
        }


        for(point = fixture_mount_points(x_width, y_width))
            translate(point)
                circle(r = M4_tap_radius);
    }


    translate([0, y_width/2, 0])
        tooltable_mount(mount_point_offset, mount_length);

    translate([ x_width/2-mount_point_offset-TABLE_BASE_BORDER(), -y_width/2, 0])
    rotate([0,0,180])
        tooltable_mount(mount_point_offset, mount_length);

    translate([-(x_width/2-mount_point_offset-TABLE_BASE_BORDER()), -y_width/2, 0])
    rotate([0,0,180])
        tooltable_mount(mount_point_offset, mount_length);
}


module STEEL_3mm_tooltable_base_300x300_3_dxf() {
    tooltable_base_sketch(
        x_work_area_width = 300,
        y_work_area_width = 300,
        mount_length = 11.2,
        mount_point_offset = 25,
        mounts_num = 3
    );
}


module tooltable_base(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3
) {
    dxf_name = str(
    "STEEL_3mm_tooltable_base", "_",
    x_work_area_width, "x", y_work_area_width, "_",
    mounts_num
    );
//    echo(dxf_name);
    dxf(dxf_name);
    color(STAINLESS_COLOR)
    linear_extrude(3)
    tooltable_base_sketch(
        x_work_area_width = x_work_area_width,
        y_work_area_width = y_work_area_width,
        mount_length = mount_length,
        mount_point_offset = mount_point_offset,
        mounts_num = mounts_num
    );

    module poperechina_top() {
        rotate([90,0,90])
        translate_z(-1.5)
        linear_extrude(3)
            tooltable_base_poperechina_top(work_area_width = y_work_area_width);
    }

    module poperechina_bottom() {
        color("teal")
        rotate([90,0,90])
        translate_z(-1.5)
        linear_extrude(3)
            tooltable_base_poperechina_bottom(work_area_width = x_work_area_width);
    }

    translate_z(-10) {
        place_poperechina(work_area_width = x_work_area_width)
        poperechina_top();
    }

    rotate([0,0,90])
    translate_z(-10) {
        place_poperechina(work_area_width = y_work_area_width)
            poperechina_bottom();
    }

}

module heater_compound_support_sketch(width) {
    translate([0,-TABLE_BASE_COMPOUND_WALL_THICKNESS()/2])
    rotate([0,0,90])
    square([
        width - TABLE_BASE_COMPOUND_WALL_THICKNESS()*3,
        TABLE_BASE_COMPOUND_WALL_THICKNESS()/2
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
        square([wall_width, TABLE_BASE_COMPOUND_WALL_THICKNESS()], center = true);
        square([
            wall_width+TABLE_BASE_COMPOUND_WALL_THICKNESS(),
            TABLE_BASE_COMPOUND_WALL_THICKNESS()/2-0.1
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
    wall_width = width/3-TABLE_BASE_COMPOUND_WALL_THICKNESS()/2;

    difference() {
        union() {
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS());
                translate([wall_width, 0, 0])
                    square([
                        0.0001,
                        TABLE_BASE_COMPOUND_WALL_THICKNESS()
                    ], center = true);
            }
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS());
                translate([0, wall_width, 0])
                    square([
                        TABLE_BASE_COMPOUND_WALL_THICKNESS(),
                        0.0001
                    ], center = true);
            }
        }


        translate([0, wall_width, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS()/2,
                TABLE_BASE_COMPOUND_WALL_THICKNESS()
            ], center = true);


        translate([wall_width, 0, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS(),
                TABLE_BASE_COMPOUND_WALL_THICKNESS()/2
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
    wall_width = width/3-TABLE_BASE_COMPOUND_WALL_THICKNESS()/2;

    difference() {
        union() {
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS());
                translate([wall_width, 0, 0])
                    square([
                        0.0001,
                        TABLE_BASE_COMPOUND_WALL_THICKNESS()
                    ], center = true);
            }
            hull() {
                circle(d = TABLE_BASE_COMPOUND_WALL_THICKNESS());
                translate([0, wall_width, 0])
                    square([
                        TABLE_BASE_COMPOUND_WALL_THICKNESS(),
                        0.0001
                    ], center = true);
            }
        }


        translate([0, wall_width, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS()/2,
                TABLE_BASE_COMPOUND_WALL_THICKNESS()
            ], center = true);


        translate([wall_width, 0, 0])
            square([
                TABLE_BASE_COMPOUND_WALL_THICKNESS(),
                TABLE_BASE_COMPOUND_WALL_THICKNESS()/2
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
    move_xy = (heater_width-TABLE_BASE_COMPOUND_WALL_THICKNESS())/2;
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

module tooltable_glassfiber_coat(
    heater_width,
    name = "unknown_brand",
    thickness = 5
) {
    width = heater_width + TABLE_BASE_COMPOUND_WALL_THICKNESS() * 2;
    vitamin(
        str("tooltable_glassfiber_coat_",
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



module tooltable_assembly(
    x_work_area_width,
    y_work_area_width,
    mount_length,
    mount_point_offset,
    mounts_num = 3)
{
    assembly("heatbed_table"){
        tooltable_base(
        //    tooltable_base_extrusions(
        x_work_area_width = x_work_area_width,
        y_work_area_width = y_work_area_width,
        mount_length = mount_length,
        mount_point_offset = mount_point_offset,
        mounts_num = mounts_num
        );
        translate_z(-5) {
//            tooltable_heater_08_2kW(work_area_width);
//                    translate_z(10)
            children();
        }
    }
}

tooltable_assembly(300, 300, 11.5, 25);
//    ceramic_granite_heatbed_table(300, 300);

//GRANITE_heatbed_table_base_610_10_25_3_dxf();

