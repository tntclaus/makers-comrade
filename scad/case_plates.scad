include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <hinge_pn5-40.scad>
include <utils.scad>

use <parametric_butt_hinge_3.7.scad>

sidePlateColor = "green";
sidePlateOpacity = 1;
module bottom_plate(
        width,
        heigth,
        thickness = 3,
        elevation = 0) {
    dxf(str("bottom_plate_",width,"x", heigth, "x", thickness));

    module cut_angles() {
       t = thickness + 1;
        union() {
        translate([0,0,-t/2]) square(20);
        }
    }

    module diff_plate() {
        render(convexity = 2) difference() {
            t = 1;
            translate([0,0,elevation]) {
                difference() {
                    square([width, heigth], center=true);
                    translate([width/2, heigth/2,0])
                        mirror([1,1,0]) cut_angles();
                    translate([-width/2, -heigth/2,0])
                        mirror([0,0,0]) cut_angles();
                    translate([width/2, -heigth/2,0])
                        mirror([1,0,0]) cut_angles();
                    translate([-width/2, heigth/2,0])
                        mirror([0,1,0]) cut_angles();

                        stepZ = (heigth-60) / 6;
                        listZ = [ for (i = [30 : stepZ : heigth]) i ];
                    //    echo(listZ);
                        stepX = (width-60) / 6;
                        listX = [ for (i = [30 : stepX : width]) i ];
                    //    echo(listX);


                    for(i = listX) {
                        translate([-heigth/2 + i, -width/2+ 10, 0]) m5_hole(d = 5);
                        translate([-heigth/2 + i, width/2 - 10, 0]) m5_hole(d = 5);
                    }

                    for(i = listZ) {
                        translate([-heigth/2 + 10, -width/2 + i, 0]) m5_hole(d = 5);
                        translate([heigth/2 - 10, -width/2 + i, 0]) m5_hole(d = 5);
                    }
                }
            }

            children();
        }
    }

    diff_plate() {projection() children();};
}

//bottom_plate(700,700);

module m5_hole(d) {
    vitamin(str("M",d," Screw"));
    vitamin(str("M",d," V-Slot Nut"));
    circle(d = d);
}

module side_plate(
    case_width,
    case_heigth,
    side,
    thickness,
    topElevation,
    topMountHolesAdj = 0
) {
    width = case_width + thickness*2;
    heigth = case_heigth + topElevation;
    offs = 20 + side;
    stepZ = (heigth-20) / 8;
    listZ = [ for (i = [10 : stepZ : heigth]) i ];
//    echo(listZ);
    stepX = (width-60) / 6;
    listX = [ for (i = [30 : stepX : width]) i ];
//    echo(listX);

    translate([-width/2,0,0]) difference() {
        square([width, heigth]);
        polygon([
            [20,0],
            [offs,side],
            [width-offs,side],
            [width-20, 0]
        ]);
        // left
        for(i = listZ)
            translate([thickness+10, i, 0]) m5_hole(d = 5);

//        translate([10, heigth-10, 0]) m5_hole(d = 5);

        // right
        for(i = listZ)
            translate([width-(thickness+10), i, 0]) m5_hole(d = 5);

//        translate([width-10, heigth-10, 0]) m5_hole(d = 5);

        // top
        for(i = listX)
            translate([i, case_heigth-10-topMountHolesAdj, 0]) m5_hole(d = 5);

//        translate([width-25, heigth-10, 0]) m5_hole(d = 5);

        // bottom
        for(i = listX)
            translate([i, side+10, 0]) m5_hole(d = 5);

//        translate([width-25, side+10, 0]) m5_hole(d = 5);

    }
}

module back_plate(
        width,
        heigth,
        side,
        thickness = 3,
        topElevation = 0
) {
    dxf(str("back_plate_",width,"x", heigth, "x", thickness));
    difference() {
        side_plate(width,  heigth, side, thickness, topElevation, 20);
        translate([0,heigth-5, 0])
            window_for_Y_rail(width, side);
    }
}

module front_plate(
        width,
        heigth,
        side,
        thickness = 3,
        topElevation = 0
) {
    dxf(str("front_plate_",width,"x", heigth, "x", thickness));

    portal_window_w = width-80;
    portal_window_h = heigth-side-100;

    echo("front plate window w: ", portal_window_w, "; h: ", portal_window_h);

    difference() {
        side_plate(width,  heigth, side, thickness, topElevation, 20);
        translate([0, (heigth-60)/2+side,0])
            rounded_square([portal_window_w, portal_window_h], 20);


        translate([0,heigth-5, 0])
            window_for_Y_rail(width, side);
    }
}



module window(heigth, side, with_holes = true) {
        tongueOffset =  (heigth-side-80)/2;
    translate([0, (heigth-60)/2+side,0]) difference() {
        rounded_square([100,  heigth-side-80], 20);

        translate([0,tongueOffset,0]) rounded_square([20,  60], 5);
        translate([0,-tongueOffset,0]) rounded_square([20,  60], 5);
    }
    if(with_holes) {
        translate([0, heigth-60,0]) m5_hole(5);
        translate([0, side+35,0]) m5_hole(5);
        translate([0, side+60,0]) m5_hole(5);
    }
}

module window_for_Y_rail(width, side) {
    rounded_square([width-60,  30], 10);
}

//window_for_Y_rail(500,20);

module side_plate_r(
        width,
        heigth,
        side,
        off,
        thickness = 3,
        topElevation = 0
) {
    dxf(str("side_plate_r_",width,"x", heigth, "x", thickness));

    difference() {
        side_plate(width,  heigth, side, thickness, topElevation);
        translate([off,0,0])
            window(heigth, side);
        translate([-off,0,0])
            window(heigth, side);

        translate([-width/2,heigth,0]) motorWindow();
        translate([width/2,heigth+18,0]) mirror([1,0,0]) motorWindow();
    }
}

//front_plate(700,700,80,200,3,80);
module motorWindow() {
    motorWindowCoordinates = [
        [-3,0,0],
        [-3,23,0],
        [14,20,3],
        [17,3,0],
        [34,3,0],
        [34,0,0],


    ];
        rounded_polygon(motorWindowCoordinates);
}

module plastic_doors(width, heigth, side, thickness, angle) {
//    plastic_door(width, heigth, side, thickness,left = true);
    plastic_door_assembly(width, heigth, side, thickness, angle, left = false);
    mirror([1,0,0]) plastic_door_assembly(width, heigth, side, thickness, angle, left = false);
}

    C_CONSTANT = 0 + 0;

    C_FEMALE   = C_CONSTANT + 0;
    C_MALE     = C_CONSTANT + 1;


module hinge()
{
    // Initialize model resolution.

//    $fn = m_resolution;

    // Generate hinge assembly.

    rotate ( [ 0.0, 0.0, 0.0 ] )
    {
        rotate ( [ 0.0, -0, 0.0 ] ) leaf ( C_FEMALE );
        leaf ( C_MALE );
    }
}

module platic_door_hinge_spacer_sketch() {
    projection()
    difference() {
        rotate ( [ 0.0, 180.0, 0.0 ] ) leaf ( C_FEMALE );

        translate([35/2-5,0,1])
        cube([35,100,20], center = true);
    }
}

module plastic_door_sketch(width, heigth, side, left = true) {
    overlap = 10;

    door_width = width-80+overlap;
    door_heigth = heigth-side-100+overlap;

    echo(str("plastic_door_", door_width/2, "x", door_heigth));

    hinge_y_pos = door_heigth/2-80;

    module hinge_holes() {
        projection()
        tool_cutter_fastener_set ( 6, 1, 0 );
    }

    difference() {
        color("orange")
        union() {
            rounded_square([door_width,  door_heigth], 20);
        }
        if(left) {
            translate([(width-80+overlap+1)/2, 0, 0])
                square([width-80+overlap+1, heigth-side-100+overlap+1], center = true);
        } else {
            translate([-(width-80+overlap+1)/2, 0, 0])
                square([width-80+overlap+1, heigth-side-100+overlap+1], center = true);
        }

        translate([-door_width/2, hinge_y_pos,0])
        hinge_holes();

        translate([-door_width/2,-hinge_y_pos,0])
        hinge_holes();

        // магнит
        translate([-10, door_heigth/2-10-overlap/2, 0])
        circle(d = 3);

        translate([-10,-door_heigth/2+10+overlap/2, 0])
        circle(d = 3);
    }

//    translate([-door_width/2, hinge_y_pos,-6])
//    tool_cutter_fastener_set ( 6, 1, 0 );

//    translate([-door_width/2, hinge_y_pos,-6])
//    color("red")
//    platic_door_hinge_spacer_sketch();
//    hinge();

//    translate([-door_width/2,-hinge_y_pos,-6])
//    color("red")
//    hinge();

}



module plastic_door(width, heigth, side, thickness, left = true) {
    overlap = 25;

    module hinge_projection() {
        translate_z(0) linear_extrude(10) hinge_shapes();
        translate([-12.5,12.5,-5]) cylinder(d=5,h=10);
        translate([-12.5,-12.5,-5]) cylinder(d=5,h=10);
    }



    translate([0, (heigth-60)/2+side,0]) {
        difference() {
            union() {
                rounded_rectangle([width-80+overlap,  heigth-side-100+overlap, thickness-1], 20);
                translate_z(2)
                    rounded_rectangle([width-80,  heigth-side-100, 1], 20);
            }
            if(left) {
                translate([(width-80+overlap+1)/2, 0, 0])
                    cube([width-80+overlap+1, heigth-side-100+overlap+1, thickness*2], center = true);
            } else {
                translate([-(width-80+overlap+1)/2, 0, 0])
                    cube([width-80+overlap+1, heigth-side-100+overlap+1, thickness*2], center = true);

            }

            translate([width/2-31+8.5, ((heigth-60)/2+side)/2-60,0])
            hinge_projection();

            translate([width/2-31+8.5, (-(heigth-60)/2+side)/2,0])
            hinge_projection();

        }
    }
}

module plastic_door_assembly(width, heigth, side, thickness, angle = 0, left = true) {
    color("blue", 0.25)
        render()
        rotate_about_pt(y = -angle, pt = [width/2-31, 0, 0])
            plastic_door(width, heigth, side, thickness, left);

    module hinge(angle = 0) {
        translate_z(1.5)
        mirror([1,0,0]) mirror([0,0,1]) hinge_pn5_40(angle);
    }

    translate([0, (heigth-60)/2+side,0]) {
    translate([width/2-31+8.5, ((heigth-60)/2+side)/2-60,0])
        hinge(angle);

    translate([width/2-31+8.5, (-(heigth-60)/2+side)/2,0])
        hinge(angle);
    }
}

module plastic_window_l0_800x60_dxf() {
    overlap = 4;
    heigth = 800;
    side = 60;
    difference() {
        translate([0, (heigth-60)/2+side,0])
            rounded_square([100+overlap,  heigth-side-80+overlap], 20);
        translate([0, heigth-60,0]) circle(d = 5);
        translate([0, side+35,0]) circle(d = 5);
        translate([0, side+60,0]) circle(d = 5);
    }
}

module plastic_window_l1_800x60_dxf() {
    overlap = 4;
    heigth = 800;
    side = 60;
    window(heigth, side, false);
}

//plastic_window_l0_800x60_dxf();
//translate([0, 0, 1.5]) plastic_window_l1_800x60_dxf();

module plastic_window_sketch(heigth, side) {
        translate([0, (heigth-60)/2+side,0])
        difference() {
            rounded_square([100+overlap,  heigth-side-80+overlap], 20);
        }
}

module plastic_window(heigth, side, thickness) {
    stl(str("plastic_window_",heigth,"x",side, "x", thickness));

    dxf(str("plastic_window_l0_",heigth,"x",side));
    dxf(str("plastic_window_l1_",heigth,"x",side));

    overlap = 4;

    tongueOffset =  (heigth-side-80)/2 + overlap;
    color("#3333ff", 0.4)
    render()

    difference() {
        union() {
            linear_extrude(thickness/2)
            translate([0, (heigth-60)/2+side,0]) difference() {
                rounded_square([100+overlap,  heigth-side-80+overlap], 20);

//                translate([0,tongueOffset,0]) rounded_square([16,  60], 5);
//                translate([0,-tongueOffset,0]) rounded_square([16,  60], 5);
            }

            translate_z(thickness/2) linear_extrude(thickness/2) window(heigth, side, false);
        }


        translate([0, heigth-60,-1]) cylinder(d = 5, h = thickness+2);
        translate([0, side+35,-1]) cylinder(d = 5, h = thickness+2);
        translate([0, side+60,-1]) cylinder(d = 5, h = thickness+2);
    }
}

module side_plate_l(
        width,
        heigth,
        side,
        thickness = 3,
        topElevation = 0
) {
    dxf(str("side_plate_l_",width,"x", heigth, "x", thickness));

    difference() {
        side_plate(width,  heigth, side, thickness, topElevation);
        window(heigth, side);
//        translate([width/2,heigth+10,0]) rounded_square([60,20], 3);
    }
}
//plastic_window(700, 80, 4);
//side_plate_r(700,700,80,200, 4,180);
//translate([0,-860/2])
front_plate(740, 800, 60, 4, 160);
//
//translate_z(-2)
//color("silver")
plastic_door_sketch(740, 800, 60, 4);

hinge();

//cube([10,10,10]);
platic_door_hinge_spacer_sketch();
