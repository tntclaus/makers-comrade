include <NopSCADlib/utils/core/core.scad>

function mosquito_radiator_heigth() = 25;
function mosquito_radiator_width() = 25;
function mosquito_radiator_depth() = 13;


module mosquito_radiator_hotend_stands_placement() {
    y = 7.5;
    x = 3.75;
    for(xi = [-1, 1])
    for(yi = [-1, 1])
    translate([x*xi,y*yi,0])
        children();
}

module mosquito_radiator_hotend_screws_placement() {
    x = 7;
    for(xi = [-1, 1])
    translate([x*xi,0,0])
        children();
}

module mosquito_radiator_block_volume() {
    color("blue")
    translate([0,0,-mosquito_radiator_heigth()/2])
    cube([mosquito_radiator_depth(),mosquito_radiator_width(),mosquito_radiator_heigth()], center = true);
}


module mosquito_heatbreak_assembly() {
    translate_z(-27.5)
    mosquito_radiator_hotend_stands_placement() {
        color("silver")
            cylinder(d = 2.45, h = 12, center = true);
    }

    mosquito_radiator();
    mosquito_heatbreak();
}

module mosquito_radiator() {
    vitamin("NF Crazy / Mosquito Radiator");

    translate_z(-25)
    color("#a43434")
    rotate([90,0,90])
    import("Mellow_NF_Crazy_radiator.stl");
}

module mosquito_heatbreak() {
    vitamin("NF Crazy / Mosquito Heatbreak");

    translate_z(-25)
    color("silver")
    rotate([90,0,90])
    import("Mellow_NF_Crazy_heatbreak.stl");
}

mosquito_heatbreak_assembly();
//mosquito_radiator_block_volume();
