include <toolhead_extruder_generic.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
use <../../lib/hotend_mosquito/heatbreak.scad>
use <../../lib/hotend_mosquito/mosquito_magnum_hotend.scad>



module toolhead_extruder_heatbreak_mosquito_cooler_100_stl() {
    $fn = 180;
    toolhead_extruder_heatbreak_mosquito_cooler(plate_length = 100);
}

module toolhead_extruder_heatbreak_mosquito_top_sketch(length) {
    resize([length, 40])
        circle(d = 40);


    cooling_tube_position(
    width = 60,
    inset_length = length,
    inset_depth = 8
    ) {
        circle(d = FAN_DUCT_OUTER_D + 1);
    }
}
FAN_DUCT_CENTER_OFFSET = 4;

module toolhead_extruder_heatbreak_mosquito_fan_duct_exits(sy = 0, sz = 0, m = false) {
    x = 40 / 2 + FAN_DUCT_CENTER_OFFSET;
    y = 0 + sy;
    z = 0 + sz;

    translate([x, y, z])
        children();
    translate([- x, y, z])
        if (m == true)
            mirror([1, 0, 0])
                children();
        else
            children();
}

module toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes() {
    max_heigth = 5;
    module fan_duct_mount_hole() {
        cylinder(d = 3.5, h = max_heigth);
        translate_z(2.1)
        cylinder(d = 7, h = 3, $fn = 6);

        hull() {
            translate_z(1)
            cylinder(d = 7, h = .1, $fn = 6);
            translate_z(max_heigth)
            cylinder(d = 3.5, h = .1);
        }
    }

    translate([0, - FAN_DUCT_OUTER_D - 2, 0])
        fan_duct_mount_hole();
    translate([0, FAN_DUCT_OUTER_D + 2, 0])
        fan_duct_mount_hole();
}

module toolhead_extruder_heatbreak_mosquito_cooler(
plate_length,
cut_half = false
) {
    stl(str("toolhead_extruder_heatbreak_mosquito_cooler", "_", plate_length));
    length = plate_length - TOOLHEAD_PLATES_BELT_INSET * 2 - 2;

    external_face_w = 20;

    zero_level = 21;

    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
        difference() {
            union() {
                hull() {
                    translate_z(zero_level)
                    linear_extrude(0.5)
                        toolhead_extruder_heatbreak_mosquito_top_sketch(length = length);

                    // низ
                    cylinder(d = 27, h = 1);
                    toolhead_extruder_heatbreak_mosquito_fan_duct_exits()
                    cylinder(d = FAN_DUCT_OUTER_D + 1, h = 0.5);
                }

                toolhead_extruder_heatbreak_mosquito_fan_duct_exits()
                rounded_rectangle([FAN_DUCT_OUTER_D, FAN_DUCT_OUTER_D * 3 + 4, 2], r = 1);
            }

            translate_z(- .1)
            toolhead_extruder_heatbreak_mosquito_fan_duct_exits() {
                toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes();
            }

            translate_z(zero_level + 1)
            mosquito_radiator_block_volume();

            z_level = 3.5;
            hull() {
                translate_z(zero_level)
                translate(hose_position(plate_length, coolant_hose_size))
                    cylinder(d = coolant_hose_size, h = 1);
                translate_z(z_level)
                cylinder(d = 23, h = 1);
            }

            hull() {
                translate_z(zero_level)
                translate(hose_position(plate_length, coolant_hose_size, 0, 1))
                    cylinder(d = coolant_hose_size, h = 1);
                translate_z(z_level)
                cylinder(d = 23, h = 1);
            }

            hull() {
                translate_z(zero_level)
                cooling_tube_position(
                width = 60,
                inset_length = length,
                inset_depth = 8,
                part = "left"
                )
                cylinder(d = FAN_DUCT_INNER_D, h = 1);

                translate_z(- 0.1) {
                    translate([40 / 2 + FAN_DUCT_CENTER_OFFSET, 0, 0])
                        cylinder(d = FAN_DUCT_INNER_D, h = 1);
                }
            }

            hull() {
                translate_z(zero_level)
                cooling_tube_position(
                width = 60,
                inset_length = length,
                inset_depth = 8,
                part = "right"
                )
                cylinder(d = FAN_DUCT_INNER_D, h = 1);

                translate_z(- 0.1) {
                    translate([- 40 / 2 - FAN_DUCT_CENTER_OFFSET, 0, 0])
                        cylinder(d = FAN_DUCT_INNER_D, h = 1);
                }
            }

            toolhead_extruder_heatbreak_cooler_mounts()
            translate_z(- 1) cylinder(d = 3.6, h = 1000);

            toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
            translate_z(- 1) cylinder(d = 4.01, h = 1000);


            //        translate(vacuum_hose_position(length))
            //        linear_extrude(100)
            //        hose_base_plate_drill_holes(coolant_hose_size, 25, 3.05);

            //разрез
            if (cut_half) {
                translate([- 100, 0, - 1])
                    cube([200, 200, 200]);
            }
        }
}

module toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle_stl() {
    rotate([0, 180, 0])
        toolhead_extruder_heatbreak_mosquito_fan_duct_nozzle();
}
module toolhead_extruder_heatbreak_mosquito_fan_duct_nozzle() {
    stl("ABS_toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle");

    // magnum
    heigth = 20;
    // magnum+
//    heigth = 20 + 19;

    module object(d, cutout = false) {
        hull() {
            cylinder(d = d, h = .1);
            translate([0, 0, - heigth])
                rotate([0, 76, 0])
                    resize([d / 2, d * 4])
                        if (cutout)
                        translate_z(1)
                        cylinder(d = d, h = 1.2);
                        else
                            cylinder(d = d, h = 3);
        }
        if (cutout)
            translate([0, 0, - heigth])
                rotate([0, 76, 0])
                    resize([d / 2, d * 4])
                        rotate([0, 180, 0])
                            translate_z(- 1)
                            cylinder(d = d, h = 10);

//              направление воздушного потока
//                translate([0, 0, - heigth])
//                rotate([0, 76-180, 0])
//                cylinder(d=1, h = 100);
    }

    toolhead_extruder_heatbreak_mosquito_fan_duct_exits(m = true) difference() {
        union() {
            object(FAN_DUCT_OUTER_D);
            translate_z(- 1.9)
            rounded_rectangle([FAN_DUCT_OUTER_D, FAN_DUCT_OUTER_D * 3 + 4, 2], r = 1);
        }
        object(FAN_DUCT_INNER_D, cutout = true);
        translate_z(- 1.9)
        toolhead_extruder_heatbreak_mosquito_fan_duct_mount_holes();
    }
}

module toolhead_extruder_mosquito_bottom_plate_sketch(
    width,
    length,
    inset_length,
    inset_depth
) {
    difference() {
        toolhead_extruder_generic_bottom_plate_sketch(width, length, inset_length, inset_depth);
        mosquito_radiator_radiator_mount_screws_placement()
        circle(d=2.5);
    }
}

module D16T_toolhead_extruder_mosquito_bottom_plate_W60xL100_IL80_ID8_dxf() {
    toolhead_extruder_mosquito_bottom_plate_sketch(
        width = 60,
        length = 100,
        inset_length = 80,
        inset_depth = 8
    );
}

module toolhead_extruder_mosquito_bottom_plate(
    width,
    length,
    inset_length,
    inset_depth,
    heigth,
    thickness = 3
) {
    dxf_name = str(
    "D16T_toolhead_extruder_mosquito_bottom_plate", "_",
    "W", width, "x",
    "L", length, "_",
    "IL", inset_length, "_",
    "ID", inset_depth);
    dxf(dxf_name);

    color("silver")
    translate_z(- thickness)
    linear_extrude(thickness)
    toolhead_extruder_mosquito_bottom_plate_sketch(
        width,
        length,
        inset_length,
        inset_depth
    );

    groove_collet_width = width - inset_depth * 2;


    toolhead_mosquito_extruder_collets(
        width = width,
        length = length,
        inset_length = inset_length,
        inset_depth = inset_depth,
        heigth = heigth,
        thickness = thickness
    );
}


module toolhead_mosquito_extruder_groove_collets(width, heigth, length) {
    stl_name = str(
    "ABS_toolhead_mosquito_extruder_groove_collets", "_",
    "W", width, "x",
    "H", heigth, "x",
    "L", length
    );
    stl(stl_name);

    toolhead_mosquito_extruder_groove_collet(width, heigth, length);

    translate([0,0,0])
        mirror([1, 0, 0])
            toolhead_mosquito_extruder_groove_collet(width, heigth, length);
}

module toolhead_mosquito_extruder_collets(
    width,
    length,
    inset_length,
    inset_depth,
    heigth,
    thickness = 3
) {
    groove_collet_width = width - inset_depth * 2;

    toolhead_mosquito_extruder_groove_collets(groove_collet_width, heigth, length);

    groove_collet_top_heigth = 4;


    ptfe_cylinder_heigth = heigth - groove_collet_top_heigth;

    translate_z(5.05 + piezo_disc_thick)
    rotate([180,0,0]){
        translate_z(2)
        piezo_disc();
        color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
            translate_z(3.05 + piezo_disc_thick)
            toolhead_piezo_groove();
    }

}


module toolhead_mosquito_extruder_groove_collet(
    width,
    heigth,
    plate_length
) {
    length = (TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNT_X + 3.5) * 2;

    m4_grover_uncompressed_heigth = 1.75;
    m4_grover_half_compressed_heigth = 1.6;
    m4_grover_compressed_heigth = 1.1;

    m4_washer_heigth = 0.9;

    m4_washer_grover_assembly_h = m4_washer_heigth + m4_grover_half_compressed_heigth;


    groove_collet_heigth = 6;
    screw_mount_column_h = (heigth - groove_collet_heigth) / 2;

    groove_dia = hot_end_groove_dia(E3DVulcano);

    translate_z(groove_collet_heigth / 2)
    color(TOOLHEAD_EXTRUDER_PLASTIC_COLOR)
    difference() {
        union() {
            base_length = length/2-1;
            translate([-base_length/2-1,0,0])
            rounded_rectangle([base_length, width, groove_collet_heigth], r = 3, center = true);

            translate([- length / 2 + 4, 0, screw_mount_column_h + groove_collet_heigth / 2])
                rounded_rectangle([8, width, heigth - groove_collet_heigth], r = 3,
                center = true);

            translate_z(- groove_collet_heigth / 2)
            translate(hose_position(plate_length, coolant_hose_size))
                cylinder(d = coolant_hose_out_wall_dia-.5, h = heigth + groove_collet_heigth / 2 - 1);

            translate_z(- groove_collet_heigth / 2)
            difference() {
                fan_duct_tube(FAN_DUCT_OUTER_D);
                fan_duct_tube(FAN_DUCT_INNER_D, true);
            }

            // wire ear
            translate([-6,width/2+2,0])
            difference() {
                cube([10, 10, groove_collet_heigth], center = true);
                translate([3,-2,0])
                cube([10, 10, groove_collet_heigth*2], center = true);
            }
        }
//        resize([PIEZO_DISC_DIA_MAX, PIEZO_DISC_DIA, 50])
        cylinder(d = PIEZO_DISC_DIA_MAX, h = 50, center = true);

        toolhead_screw_mount_locations(TOOLHEAD_EXTRUDER_VERTICAL_SCREW_MOUNTS())
        translate_z(- groove_collet_heigth) cylinder(r = M4_clearance_radius, h = 1000);

        translate([length, 0, 0])
            cube([length * 2, width * 2, heigth * 3], center = true);

        toolhead_extruder_heatbreak_cooler_mounts() cylinder(r = M3_clearance_radius, h = 1000, center = true);

        translate_z(- groove_collet_heigth)
        translate(hose_position(plate_length, coolant_hose_size))
            cylinder(d = coolant_hose_size, h = 1000);


        translate_z(heigth - groove_collet_heigth - 10)
        translate(hose_position(plate_length, coolant_hose_size))
            cylinder(d = coolant_hose_size_out, h = 1000);


    }


    module fan_duct_tube(d, cut = false) {
        hull() {
            if (cut == false) {
                cooling_tube_position(width, plate_length - 20, 0, part = "right") {
                    translate([d, d / 2, 0])
                        cylinder(d = .1, h = 10);
                }
            }
            cooling_tube_position(width, plate_length - 20, 0, part = "right") {
                cylinder(d = d, h = .1);
            }
            translate_z(heigth)
            cooling_tube_position(width, plate_length - 16, - 3, part = "right") {
                cylinder(d = d, h = .1);
            }
        }
        translate_z(heigth)
        cooling_tube_position(width, plate_length - 16, - 3, part = "right") {
            cylinder(d = d, h = 10);
        }
    }
}

module ABS_toolhead_mosquito_extruder_groove_collets_W44xH29xL100_stl(){
    $fn = 90;
    toolhead_mosquito_extruder_groove_collets(width = 44, heigth = 29, length = 100);
}


//toolhead_extruder_mosquito_bottom_plate_sketch(
//    width = 60,
//    length = 100,
//    inset_length = 80,
//    inset_depth = 8
//);

//rotate([0,0,90])
//mosquito_magnum_hotend_assembly();
//mosquito_radiator_radiator_mount_screws_placement()
//cylinder(d=2, h=10);

//translate_z(- 21.5)
toolhead_extruder_heatbreak_mosquito_cooler_100_stl();

//translate_z(- 21.5)
//    translate([0,50,0])

//D16T_toolhead_extruder_mosquito_bottom_plate_W60xL100_IL80_ID8_dxf();


//translate_z(3+21.5)
//toolhead_extruder_mosquito_bottom_plate(
//width = 60,
//length = 100,
//inset_length = 80,
//inset_depth = 8,
//heigth = 29
//);

//toolhead_extruder_heatbreak_mosquito_cooler(plate_length = 100, cut_half=true);
//rotate([0, 180, 0])
//    toolhead_extruder_mosquito_heatbreak_fan_duct_nozzle_stl();



//toolhead_extruder_heatbreak_mosquito_top_sketch()

//ABS_toolhead_mosquito_extruder_groove_collets_W44xH29xL100_stl();
//toolhead_mosquito_extruder_groove_collets(width = 44, heigth = 29, length = 100);
//toolhead_mosquito_extruder_collets();
