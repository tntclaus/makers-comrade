
use <NopSCADlib/vitamins/rod.scad>
use <NopSCADlib/vitamins/ball_bearing.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/kp_pillow_blocks.scad>

include <NopSCADlib/vitamins/scs_bearing_blocks.scad>

use <../lib/v-wheels/v-wheels.scad>
use <../lib/v-wheels/gantry.scad>


Steel3   = [ "Steel6","Sheet mild steel", 3,"silver", false];

// Extrusion
//                   W   H    d1   d2   s  cw   cwi    t  st  f
T2020  = [ "T2020", 20, 20,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];
IGNORE2020  = [ "ignoreMe", 20, 20,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];

V20404022 = [ "V20.40x40.22", 20, 40,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];

V2020 = [ "V2020", 20, 20,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];
V2040 = [ "V2040", 20, 40,  4.2,   3,  8,  6, 12.0,   2,  2, 1 ];



workingSpaceSize = 500;
baseFrontSize = workingSpaceSize+40*2+10;

yAxisCaseSize = workingSpaceSize*1.6;


yAxisLeadScrewLength = workingSpaceSize * 1.4;

//$show_threads = true;

G_PLATE_20_PRINTED = ["VSlot_Gantry_Plate_20mm", 20.1, 3, "plastic", "green"];
//G_PLATE_20_PRINTED = ["VSlot_Gantry_Plate_20mm", 20, 6, "metal", "green"];

module VSlot_Gantry_Plate_20mm_stl() gantry_plate(G_PLATE_20_PRINTED);
    
module main_assembly() {
    base();

//    translate([-workingSpaceSize/2,0,0])
//        printing_bed();


    portal();
}


if($preview)
    main_assembly();


module printing_bed(showVolume = false) {
    module cart() {
        gantry_cart_20_3(G_PLATE_20_PRINTED);
    }
    
    module cart_left() {
        translate([0,workingSpaceSize/2+3,10])        
            rotate([-90,90,0])
                cart();
    }
    
    
    module cart_rigth() {
        translate([0,-workingSpaceSize/2-3,10])        
            rotate([90,90,0])
                cart();
    }

    elevation = 32;
    translate([-workingSpaceSize/2+10,0,elevation])
    rotate([0,90,90])
        extrusion(T2020, workingSpaceSize-40, center = true);

    translate([workingSpaceSize/2-10,0,elevation])    
    rotate([0,90,90])
        extrusion(T2020, workingSpaceSize-40, center = true);
    
    translate([0,-workingSpaceSize/2+10,elevation])
        rotate([0,90,0])
            extrusion(T2020, workingSpaceSize, center = true);

    translate([0,0,elevation])
        rotate([0,90,0])
            extrusion(T2020, workingSpaceSize-40, center = true);
    
    translate([0,workingSpaceSize/2-10,elevation])
        rotate([0,90,0])
            extrusion(T2020, workingSpaceSize, center = true);
    
    if(showVolume) {
        translate([-workingSpaceSize/2,-workingSpaceSize/2,elevation+10]) 
            cube(workingSpaceSize);
    }

    wheelPlacementFactor = 5;
    translate([workingSpaceSize/wheelPlacementFactor,0,0]) {
        cart_rigth();
        cart_left();
    }
    

    translate([-workingSpaceSize/wheelPlacementFactor,0,0]) {
        cart_rigth();
        cart_left();
    }
    
    
    translate([0,0,0]) {
        translate([0,0,18]) 
            sheet(AL6, 71, 100, 2);
        
        rotate([90,180,90])
            scs_bearing_block(SCS12LUU);
    }
}

module portal() {
    translate([0,-baseFrontSize/2,baseFrontSize/2+20])
        extrusion(V2040, baseFrontSize, center = true);
    translate([0,baseFrontSize/2,baseFrontSize/2+20])
        extrusion(V2040, baseFrontSize, center = true);

    // todo может здесь можно обойтись полосой алюминия
    translate([0,0,baseFrontSize+30])
        rotate([0,90,90])
            extrusion(T2020, baseFrontSize+40, center = true);
}


module base() {
    module screwmM3x15(rotation = [0,90,0]) {
        rotate(rotation) {
            screw(M3_hex_screw, 15);
            translate([0,0,-2]) spring_washer(M3_washer);
            translate([0,0,-0.65])  washer(M3_washer);
        }
    }
    
    module screwM3x15(rotation = [0,90,0]) {
        rotate(rotation) {
            screw(M3_pan_screw, 15);
            translate([0,0,-2]) spring_washer(M3_washer);
        }
    }
    
    module screwM5x15(rotation = [0,90,0]) {
        rotate(rotation) {
            screw(M5_pan_screw, 15);
            translate([0,0,-2]) spring_washer(M5_washer);
        }
    }
    
    motorModel = NEMA17;
    frontPlateThickness = 3;
    
    module steel_plate(width, height, showScrews = false) {
//        dxf("Front Plate");
        module plateScrews() {
            scrW = width/2-10;
            scrH = height/2-10;
            translate([5, scrW, scrH]) screwM5x15();  
            translate([5, scrW-20, scrH]) screwM5x15();  
            translate([5, scrW, -scrH]) screwM5x15();    
            translate([5, -scrW, scrH]) screwM5x15();    
            translate([5, -scrW+20, scrH]) screwM5x15();            
            translate([5, -scrW, -scrH]) screwM5x15();  

            translate([5, 0, -scrH]) screwM5x15();  
            
            cHole = extrusion_center_square(T2020);
            
            translate([5, cHole, -scrH-cHole]) screwM3x15();
            translate([5, -cHole, -scrH-cHole]) screwM3x15();              
//            translate([5, cHole, -scrH+cHole]) screwM3x15();  
//            translate([5, -cHole, -scrH+cHole]) screwM3x15();              

        }
        
        difference() {
            rotate([90,90,90]) sheet(Steel3, height, width, 2);
            plateScrews();
        }
        if(showScrews) plateScrews();
    }
    
    module V20404022(length) {
        translate([20,10,0])
            extrusion(V20404022, length, center = true);
        extrusion(IGNORE2020, length, center = true);

        translate([-20,0,0])
            extrusion(T2020, length, center = true);
    }
    
    module yAxisMotor() {
        motorScrewY = frontPlateThickness+3;

        translate([-yAxisCaseSize/2-3,0,0]) {
            rotate([0,90,0]) {
                NEMA(motorModel);
                translate([0,0,40])
                leadscrew_coupler(30,8,5,50);
            }
            tr = NEMA_hole_pitch(motorModel)/2;

            translate([motorScrewY,tr,tr]) screwmM3x15();  
            translate([motorScrewY,tr,-tr]) screwmM3x15(); 
            translate([motorScrewY,-tr,tr]) screwmM3x15(); 
            translate([motorScrewY,-tr,-tr]) screwmM3x15();
        }
    }

    translate([0,-baseFrontSize/2+10,-V20404022[1]/2])
    rotate([0,-90,0])
        V20404022(yAxisCaseSize);

    translate([0,baseFrontSize/2-10,-V20404022[1]/2])
        rotate([0,-90,180])
            V20404022(yAxisCaseSize);

    difference() {
        translate([-yAxisCaseSize/2-1.5,0,-10]) rotate([180,180,0])
            steel_plate(baseFrontSize,20*3, showScrews = true);
        translate([0,0,-2]) yAxisMotor();
    }

    translate([yAxisCaseSize/2+1.5,0,-10])
        steel_plate(baseFrontSize,20*3, showScrews = true);

    translate([0,0,-30]) rotate([0,90,0])
        extrusion(T2020, yAxisCaseSize, center = true);

    yAxisFreeSpace = (yAxisCaseSize - yAxisLeadScrewLength);
    yAxiscouplingLength = 50/2;
    yAxisMotorShaft = NEMA_shaft_length(motorModel);
    leadScrewOffset = yAxisFreeSpace/2 - yAxiscouplingLength - yAxisMotorShaft;

    // Y-axis lead screw, motor, pillow block  
    translate([0,0,-2]) {
        yAxisMotor();
        

        translate([yAxisLeadScrewLength/2-10,0,0]) rotate([90,0,90])
            //todo: кастомная деталь для подшипника и оси
            kp_pillow_block(KP08_18);
    
        translate([-leadScrewOffset, 0, 0]) rotate([0,-90,0])
            leadscrew(
                8, 
                yAxisLeadScrewLength, 
                8, 
                2, 
                center = true
            );
        
    }

}




//todo в отдельный модуль
module leadscrew_coupler(do, di1, di2, h) {
    vitamin(str(
    "Lead Screw Coupler, D=", do, ", ",
    "d1=", di1, ", ",
    "d2=", di2, ", ",
    "L=", h
    ));
    difference(){
        cylinder(d = do, h, center=true);
        translate([0,0,h/2-1])
            cylinder(d = di1, h, center=true);
        translate([0,0,-h/2+1])
            cylinder(d = di2, h, center=true);
    }
}

