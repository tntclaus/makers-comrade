include <vwheel_gantries.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <vslot_connectors.scad>

cubeConnectorColor = "orange";

module extrusion_w_angle(type, size, sides = [1,0,0,0], spacing = 0, center = true) {

    trans = center ? [0,0,0] : [0,0,size/2];
    module angleMounts() {
        translate([0, -10, -size/2+spacing])
            rotate([90,0,-90])
                extrusion_corner_bracket_assembly(E20_corner_bracket);
//            color(cubeConnectorColor)
//            vslot_connector_angle(VCUBE_20);
        translate([0, -10, size/2-spacing])
//        color(cubeConnectorColor)
            rotate([90,90,-90])
                extrusion_corner_bracket_assembly(E20_corner_bracket);
//            vslot_connector_angle(VCUBE_20);
    }

    translate(trans) {
        extrusion(type, size, center = true);
        if(sides[0]) angleMounts();
        if(sides[1]) rotate([0,0,90]) angleMounts();
        if(sides[2]) mirror([0,1,0]) angleMounts();
        if(sides[3]) rotate([0,0,270]) angleMounts();
    }
}

function max_position(length, safe_margin, safe_margin_top, position) = position >= 0 && position <= length - safe_margin - safe_margin_top ? position : length - safe_margin * 2;

module vslot_rail(
    type,
    l,
    pos = 0,
    mirror = false,
    mirror_plate = [0,0,0],
    safe_margin = 0,
    safe_margin_top = 0
) {

    gantry = type[1];
    extrusion = type[2];
    length = l;
    position = pos;

    plate = gantry[1][0];

    exHeigth = extrusion_height(extrusion);

    translate([0,0,length - safe_margin - max_position(length, safe_margin, safe_margin_top, position)])
        vwheel_gantry(gantry, center=true, mirror = mirror, mirror_plate = mirror_plate){
            children(0);
            if($children > 1)
                children([1:$children-1]);
        }




    if(exHeigth == gantry[3]) {
        extrusion(extrusion, length, center = false);
    } else {
        translate([-10,0,0])
            rotate([0,0,90])    {
                extrusion(extrusion, length, center = false);
            }
    }
}
