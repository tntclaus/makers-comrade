include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

include <../utils.scad>



module fanduct_stl() {
    fanduct();
}

module fanduct(blowerType = RB5015)
{
    stl("fanduct");

    exit_depth = blower_depth(blowerType) + blower_wall(blowerType);
    exit_width = blower_exit(blowerType);
//    wall = blower_wall(blowerType);
    wall = 2;

    height = 30;

    tube_adapter(exit_depth, exit_width, height, wall, 12);

}

module blower_centered(blowerType = RB5015) {
    exit_depth = blower_depth(blowerType);
    exit_width = blower_exit(blowerType);
    wall = blower_wall(blowerType);
//    echo(exit_width);
    translate([-exit_width/2,-exit_depth/2,2])
    rotate([-90,0,0])
    blower(blowerType);    
}


module fanduct_assembly(blowerType = RB5015) {
//    render()
    fanduct(blowerType);
//    blower_centered(blowerType);
}

//fanduct_assembly();
