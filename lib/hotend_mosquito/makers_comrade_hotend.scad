include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/thread.scad>
use <heatbreak.scad>
use <../nozzles/e3d_nozzles.scad>

module thermistor_pocket(h) {
    cylinder(d = 3.1, h = h, center = true);
}

module place_heaters(d = 6) {
    offs = 6/2 + 0.5 + d/2;
    angle = 28;

    rotate([0,0, angle])
    translate([-offs, 0, 0])
        children();

    rotate([0,0,-angle])
    translate([-offs, 0, 0])
        children();
//    translate([ offs, 0, 0])
//        children();
}

module place_thermistors() {
    offs = 7.5;
    angle = 28;

    rotate([0,0, angle])
    translate([ offs, 0, 0])
        children();

    rotate([0,0,-angle])
    translate([ offs, 0, 0])
        children();

//    translate([ 0,-o, 0])
//    children();
//    translate([ 0, o, 0])
//    children();
}

module place_mounts() {
        translate([ 3.5,-4.3, 0])
        children();
        translate([-3.5, 4.3, 0])
        children();
}

//module place_cutouts() {
//    o = 8;
//    translate([ o,-o, 0])
//    children();
//    translate([ o, o, 0])
//    children();
//    translate([-o, o, 0])
//    children();
//    translate([-o,-o, 0])
//    children();
//}

copper_density = 8.96;
pi = 3.141592;
function cylinder_weight(d_outer, h) = pi * (d_outer/2)^2 * h / 1000 * copper_density;

module hotend(thread = true) {
    h_body = 21;
    h_nozzle_cap = 15;
    h_full = h_body + h_nozzle_cap;

    h_nozzle = 7.5;
    h_throat = 4;

    d_outer = 21;
    d_nozzle_cap = 10;

    h_mount_depth = 3;
    d_mount = 2.5;

    difference() {
        color("#727472")
        union() {
            cylinder(d = d_outer, h = h_body, center = true);
            translate_z(-h_body/2 - h_nozzle_cap/2)
            cylinder(d = d_nozzle_cap, h = h_nozzle_cap, center = true);
        }
        cylinder(d = 2.35, h = h_full+.01, center = true);

        // сопло
        translate_z(-(h_full)/2 - (h_nozzle_cap - h_nozzle)/2)
        cylinder(d = 4.7, h = h_nozzle+.01, center = true);

        // горло
        translate_z(h_body/2 - h_throat/2)
        cylinder(d = 4.7, h = h_throat+.01, center = true);


        place_heaters()
        cylinder(d = 6, h = h_body+.01, center = true);

        place_thermistors()
        thermistor_pocket(h_body+.1);

    //    place_mounts()
    //    cylinder(d = 1.8, h = 30, center = true);

        weight =
            cylinder_weight(d_nozzle_cap, h_nozzle_cap) +
            cylinder_weight(d_outer, h_body) -

            cylinder_weight(2.35, h_full - h_throat - h_nozzle) - // основной канал
            cylinder_weight(5.5, h_throat) - // термобарьер
            cylinder_weight(5.5, h_nozzle) - // сопло
            cylinder_weight(6, h_body) * 2 - // нагреватели
            cylinder_weight(3, h_body) * 2 - // картриджи термисторов
            cylinder_weight(d_mount, h_mount_depth) * 4 - // ноги крепления радиатора
            cylinder_weight(3, h_body) * 2 // винты крепления радиатора
        ;


        rotate([0,0,90])
        mosquito_radiator_hotend_stands_placement()
        translate_z(h_body/2-h_mount_depth/2)
        cylinder(d = d_mount, h = h_mount_depth + .1, center = true);

        rotate([0,0,90])
        mosquito_radiator_hotend_screws_placement() {
//        translate_z(h_body/2)
            cylinder(d = 1.2, h = h_body + .1, center = true);
            translate_z(-1)
            cylinder(d = 3, h = h_body-2 + .1, center = true);
        }

        echo(str("weight = ", weight));

        if(thread == true) {
            // сопло
            translate_z(-(h_full)/2 - (h_nozzle_cap - h_nozzle)/2)
            cylinder(d = 6, h = h_nozzle+.01, center = true);

            // горло
            translate_z(h_body/2 - h_throat/2)
            cylinder(d = 6, h = h_throat+.01, center = true);
        }
    }



    if(thread == true) {
        $show_threads = true;

        translate_z(-h_nozzle_cap/2)
        female_metric_thread(6, 1, h_full);
    }
}





//radiator_hotend_screws_placement()
//cylinder(d = 1.2, h = 100);

//rotate([0,0,90])
//difference() {
//    hotend(false);
////    rotate([0,0,-120])
////    translate([-50, 0, -50])
////    cube([100,100,100]);
//}

//$fn = 360;
module makers_comrade_hotend_assembly() {
    mosquito_heatbreak_assembly();
    translate_z(-16-25)
    rotate([0,0,-28])
    rotate([0,0,90+28])
    hotend(false);
    translate_z(-34-25)
    e3d_nozzle_v6();
}

//makers_comrade_hotend_assembly();
//projection()
//pos = 60;
//difference() {
//    hotend(false);
//    translate_z(-100+pos)
//    cube([100,100,100], center = true);
//
//    translate_z(1+pos)
//    cube([100,100,100], center = true);
//
//}
