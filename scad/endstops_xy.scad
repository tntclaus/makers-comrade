include <NopSCADlib/utils/core/core.scad>
//include <NopSCADlib/vitamins/hot_ends.scad>
//include <NopSCADlib/vitamins/tubings.scad>
//include <NopSCADlib/vitamins/zipties.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
//include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/pcbs.scad>

//include <NopSCADlib/utils/rounded_rectangle.scad>

include <pulley_and_motor_plates.scad>

include <axes/carets.scad>
use <../lib/vwheel_plate.scad>
//pcb_assembly(RAMPSEndstop, 5);


module endstop_pitch_plate() {
    difference() {
    translate([-18,31,0])
    rounded_rectangle([20,35,3], r=1, center = true);
    translate([-19.85,35,-5])
    cylinder(d = 12, h = 20);
    vslot_plate(Y_PLATE);
    }
}

//endstop_pitch_plate();

module endstop_x_mount_stl() {
    difference() {
        union() {
            translate([4.5,-1,1.5])
            rounded_rectangle([30,20,3], r=3.5, center = true);
//            translate([13,-15,1.5])
//            rounded_rectangle([34,14,3], r=3.5, center = true);
            pcb_screw_positions(RAMPSEndstop){
                cylinder(d = 7, h = 6);
            }
            translate([6,-7,0])
            cylinder(d = 4, h = 6);
        }
        pcb_screw_positions(RAMPSEndstop){
            translate_z(-1) cylinder(d = 3, h = 11);
            nut_trap(M3_cap_screw, M3_nut, depth = 4);
        }
//        hull() {
//            translate([3,-15,0])
//                cylinder(d1 = 6.2, d2 = 12, h = 3);
//            translate([23,-15,0])
//                cylinder(d1 = 6.2, d2 = 12, h = 3);        
//        }
    }
}


module endstop_x() {
    translate_z(6) pcb(RAMPSEndstop);
    stl("endstop_x_mount");
    color("green")
    render()
    endstop_x_mount_stl();
}


module endstop_y_mount_stl() {
    difference() {
        union() {
            difference() {
                translate([-1,-11,0])
                cube([33,40,7], center = true);

                translate([18,-30,-5]) {
                    rounded_rectangle([20,40,20], r = 8);
                }
                translate([-10,-21,-5]) {
                    rounded_rectangle([30,20,40], r = 1.5);
                }
                translate([0,-21,0]) {
                    rotate([0,90,0])
                    cylinder(d = 5.2, h = 30, center = true);
                }

//                translate([-20,-10,-10]) 
//                rotate([0,0,45])
//                cube([50,20,10]);
            }



            pcb_screw_positions(RAMPSEndstop){
                translate_z(-3.5) cylinder(d = 7, h = 9.5);
            }
            translate([6,-7,0])
            cylinder(d = 4, h = 6);
        }
        pcb_screw_positions(RAMPSEndstop){
            translate_z(-10) cylinder(d = 3, h = 21);
            translate_z(-1.5) nut_trap(M3_cap_screw, M3_nut, depth = 3);
        }
//        hull() {
//            translate([-10,-15,-2])
//                cylinder(d = 5.2, h = 11);
//            translate([-5,-15,-2])
//                cylinder(d = 5.2, h = 11);        
//        }
        

    }    
}

module endstop_y() {
    translate_z(6) pcb(RAMPSEndstop);
    
    stl("endstop_y_mount");

    color("green")
    render()    
    endstop_y_mount_stl();
}

//translate([20,5,0])
//endstop_x();        
//endstop_y();
//rotate([0,-180,180])
//pulley_corner_plate();