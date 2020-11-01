include <NopSCADlib/utils/core/core.scad>

include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <screw_assemblies.scad>
include <../lib/leadscrew_couplers.scad>

module motor_mount_plate_dxf() {
    motorMountPlate(NEMA17M, 4);
}

//motor_mount_plate_dxf();

module motorMountPlate(model,distance) {
    dxf("motor_mount_plate");
    
    hd = 4;
    mw = NEMA_width(model)/2;
    
    cl = mw;
    echo(cl);
    coords = [
    [3,3,3],
    [-3,41,-3],
    [-cl+13,47,3],        
    [-cl+13,40+mw*2-3+distance,3],    
    [cl+7,40+mw*2-3+distance,3],        
    [cl+13,40,-3],
    [37,   34,3],    
    [37,   23,3],    
//    [23,17,-3],        
    [17,    3,3],            
    ];
    shift =  40+mw+distance;
    
    module mountHull(d = 5) {
        hull() {
            circle(d = d);
            translate([0,-3,0]) circle(d = d);
        }
    }
    
    difference() {
        translate([-10,-shift,0]) rounded_polygon(coords);
        translate([0,-shift,0]) {
            translate([0,10,0]) mountHull();
            translate([20,30,0]) mountHull();        
            translate([0,30,0]) mountHull();
        }
    
        circle(d = NEMA_boss_radius(model)*2);
        NEMA_screw_positions(model, 4) circle(d=hd);
//        translate([0,1,0]) { 
//            circle(d = NEMA_boss_radius(model)*2);
//            NEMA_screw_positions(model, 4) circle(d=hd);
//        }
//        translate([0,2,0]) {
//            circle(d = NEMA_boss_radius(model)*2);
//            NEMA_screw_positions(model, 4) circle(d=hd);
//        }
        
    }
}

module motor(motorScrewY, model, diff=false) {
    tr = NEMA_hole_pitch(model)/2;
        
    module scr() {
        cylinder(d = 4, h = 30);
    }
        
    rotate([0,90,0]) if(!diff) {
        NEMA(model);
        translate([0,0,30])
            leadscrew_coupler(FLEXIBLE_COUPLER_8_5);



    } else {
        cylinder(d = NEMA_boss_radius(model)*2, h = 30);
    }

    if(!diff) {
        translate([motorScrewY,tr,tr]) screwmM3x15();  
        translate([motorScrewY,tr,-tr]) screwmM3x15(); 
        translate([motorScrewY,-tr,tr]) screwmM3x15(); 
        translate([motorScrewY,-tr,-tr]) screwmM3x15();    
    } else {
        translate([0,tr,tr]) rotate([0,90,0]) scr();  
        translate([0,tr,-tr]) rotate([0,90,0]) scr(); 
        translate([0,-tr,tr]) rotate([0,90,0]) scr(); 
        translate([0,-tr,-tr]) rotate([0,90,0]) scr();        
    }
}

module motorPulley(motorScrewY, model, pulley, pulleyElevation) {
    rotate([0,90,0]) {
        NEMA(model);
        translate([0,0,pulleyElevation])
            pulley(pulley);
    }

    tr = NEMA_hole_pitch(model)/2;

    translate([motorScrewY,tr,tr]) screwmM3x15();  
    translate([motorScrewY,tr,-tr]) screwmM3x15(); 
    translate([motorScrewY,-tr,tr]) screwmM3x15(); 
    translate([motorScrewY,-tr,-tr]) screwmM3x15();
}

