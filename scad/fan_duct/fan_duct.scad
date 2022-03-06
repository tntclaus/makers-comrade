include <NopSCADlib/core.scad>

use <NopSCADlib/utils/core/rounded_rectangle.scad>
use <NopSCADlib/utils/tube.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../../lib/utils.scad>



//module fanduct_stl() {
//    fanduct();
//}

module fanduct_circles(d, circles, offcenter) {
    if(circles == 2)
        fanduct_two_circles(d, offcenter);
    else
        circle(d = d);
}
module fanduct_two_circles(d, offcenter = 5.2) {
    translate([- offcenter, 0])
        circle(d = d);
    translate([offcenter, 0])
        circle(d = d);
}

module fanduct(
    type = RB5015,
    make_hull = false,
    circles = 2,
    hole_odia = 10,
    hole_idia = 6,
    height = 11.051,
    throat_height = 10,
    throat_top_thickness = 3,
    throat_side_thickness = 3,
    offcenter = 5.2
) {
    function thick() = make_hull ? -.2 : .2;

    exit_depth = blower_depth(type) + thick();
    exit_width = blower_exit(type) + thick();

    //    translate_z(2.4)
    //    tube_adapter(exit_depth, exit_width, height, wall, 6, 10);
    //    translate_z(2)
    //
    //    color("green")
    //    rectangular_tube([exit_width+2.5, exit_depth+2.5, 4], thickness = 1.2, fillet = 0.1);


    tube_from_shapes(height, heigth_0 = 1, heigth_1 = 6) {
        hull() fanduct_circles(hole_odia, circles, offcenter);
        union() fanduct_circles(hole_idia, circles, offcenter);
        square([exit_width + throat_side_thickness, exit_depth + throat_top_thickness], center = true);
        square([exit_width, exit_depth], center = true);
    }

    if(!make_hull)
    translate_z(height+6) difference() {
        linear_extrude(throat_height, convexity = 3) fanduct_circles(hole_odia + 3, circles, offcenter);
        translate_z(-.01)
        linear_extrude(throat_height + .1) fanduct_circles(hole_odia, circles, offcenter);
    }
}

module blower_centered(blowerType = RB5015) {
    exit_depth = blower_depth(blowerType);
    exit_width = blower_exit(blowerType);
    wall = blower_wall(blowerType);
    //    echo(exit_width);
    translate([- exit_width / 2, - exit_depth / 2, 2])
        rotate([- 90, 0, 0])
            blower(blowerType);
}


module fanduct_assembly(blowerType = RB5015) {
    //    render()
    fanduct(blowerType);
    //    blower_centered(blowerType);
}

//fanduct_assembly();

//blower_centered(RB5015);
