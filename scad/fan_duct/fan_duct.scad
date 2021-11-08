include <NopSCADlib/core.scad>

use <NopSCADlib/utils/core/rounded_rectangle.scad>
use <NopSCADlib/utils/tube.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/blowers.scad>

include <../../lib/utils.scad>



module fanduct_stl() {
    fanduct();
}

module fanduct(blowerType = RB5015)
{
    stl("fanduct");

    exit_depth = blower_depth(blowerType) + .2;
    exit_width = blower_exit(blowerType) + .2;

    height = 20;

    //    translate_z(2.4)
    //    tube_adapter(exit_depth, exit_width, height, wall, 6, 10);
    //    translate_z(2)
    //
    //    color("green")
    //    rectangular_tube([exit_width+2.5, exit_depth+2.5, 4], thickness = 1.2, fillet = 0.1);

    module two_circles(d) {
        translate([- 6.5, 0])
            circle(d = d);
        translate([6.5, 0])
            circle(d = d);
    }

    tube_from_shapes(height, heigth_0 = 1, heigth_1 = 4) {
        hull() two_circles(8);
        union() two_circles(6);
        square([exit_width + 1, exit_depth + 1], center = true);
        square([exit_width, exit_depth], center = true);
    }
    translate_z(height+5) difference() {
        linear_extrude(7) two_circles(8);
        translate_z(-.01)
        linear_extrude(7.1) two_circles(6);
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

fanduct_assembly();

//blower_centered(RB5015);
