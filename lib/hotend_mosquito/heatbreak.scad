include <NopSCADlib/utils/core/core.scad>

module mosquito_radiator_hotend_stands_placement() {
    x = 7.5;
    y = 3.75;
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
        rotate([90,0,0])
            import("Mellow_NF_Crazy_radiator.stl");
}

module mosquito_heatbreak() {
    vitamin("NF Crazy / Mosquito Heatbreak");

    translate_z(-25)
    color("silver")
        rotate([90,0,0])
            import("Mellow_NF_Crazy_heatbreak.stl");
}

mosquito_heatbreak_assembly();
