
use <NopSCADlib/vitamins/rod.scad>
use <NopSCADlib/vitamins/ball_bearing.scad>

include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/core/polyholes.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/sheets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/kp_pillow_blocks.scad>

include <NopSCADlib/vitamins/scs_bearing_blocks.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <../lib/vslot_rails.scad>
include <../lib/vslot_connectors.scad>
include <../lib/leadscrew_couplers.scad>

use <heatbed.scad>
include <motors.scad>
include <plates.scad>
include <axes/z-axis.scad>
include <axes/x-axis.scad>


V2020 = E2020;
V2040 = E2040;

VSLOT_RAIL_2020_S1 = ["", S_20_TRIANGLE_GANTRY, V2020];
VSLOT_RAIL_2020_D1 = ["", D_20_TRIANGLE_GANTRY, V2020];

//$show_threads = true;
//$renderGantryHoles = true; 

motorModel = NEMA17M;

workingSpaceSize = 600;

workingSpaceSizeMaxZ = workingSpaceSize - 30;
workingSpaceSizeMinZ = 0;

workingSpaceSizeMaxX = workingSpaceSize - 30;
workingSpaceSizeMinX = 0;
workingSpaceSizeMaxY = workingSpaceSize;
workingSpaceSizeMinY = 0;

baseFrontSize = workingSpaceSize+40*2+20;

legElevation = 60;

// Основание
baseLength = baseFrontSize/2+10;
portalWidth = baseFrontSize + 40;

echo(str(
    "Build volume = ",
    workingSpaceSizeMaxX,"x",
   workingSpaceSizeMaxY, "x",
   workingSpaceSizeMaxZ
    ));


frontPlateThickness = 3;

//colors
cubeConnectorColor = "orange";

    
module main_assembly() {
    echo(str(baseFrontSize, " ", portalWidth));
    case(50);
}



if($preview)
    main_assembly();


module extrusion_w_cube(type, size) {
    extrusion(type, size, center = true);
    translate([0, 0, -size/2-10]) color(cubeConnectorColor)
        vslot_connector_cube(VCUBE_20);
}

module extrusion_w_cube_angles(type, size, spacing, sides = [1,0,0,0]) {
    extrusion_w_angle(type, size, sides = sides);
    translate([0, 0, -size/2-10]) color(cubeConnectorColor)
        vslot_connector_cube(VCUBE_20);
}


module case(positionZ = 0) {
    module base() {
        elevation = 10;
        legs = 40 + legElevation;
        sizeWithLegs = baseFrontSize + legs;
        translate([-baseLength,0,elevation]) rotate([0,90,90])
            extrusion(V2020, baseFrontSize);

        translate([baseLength,0,elevation]) rotate([-90,0,180])
            extrusion(V2020, baseFrontSize);
        
        translate([0,-baseLength,elevation])
            rotate([-90,90,90])
                extrusion(V2020, baseFrontSize);
        
        translate([0,baseLength,elevation]) rotate([0,90,0])
                extrusion(V2020, baseFrontSize);
        
        // углы
        co = [[1,1],[-1,1], [-1,-1], [1,-1]];

        for(i= [0:3]) {
            translate([co[i][0]*baseLength,co[i][1]*baseLength,sizeWithLegs/2-legs+elevation*4]) 
                    extrusion_w_angle(V2020, sizeWithLegs, sides = [0,0,0,0]);
        }
        
//        translate([-baseLength+70, 0,0 ]) zAxisMotor();
//        translate([baseLength-70, 0,0 ]) zAxisMotor();
//        mirror([0,1,0])        zAxisMotor();
    }
    
    module top(posX, posY) {
        elevation = baseFrontSize + 30;
        //todo уголки для соединения 
        translate([0,0,elevation]) {
            motorAxialShift = 10;
            translate([0,-baseLength,0]) {
                rotate([0,90,0])
                    extrusion_w_angle(E2020, baseFrontSize, sides = [0,1,1,0]);
                
                translate([-baseLength+motorAxialShift, 10, 45]) xyAxisMotor();
                translate([baseLength-motorAxialShift, 10, 60]) xyAxisMotor();
            }

         
            translate([0,baseLength,0]) {
                rotate([0,90,0])
                    extrusion_w_angle(E2020, baseFrontSize, sides = [1,1,0,0]);
            

            }
            baseWAxialShift = baseLength - motorAxialShift;
            path1 = [ 
                //motor
                [baseWAxialShift, -baseWAxialShift, pulley_pr(GT2x16_toothed_idler)],
                [baseWAxialShift, -baseWAxialShift + posY + 37, pulley_pr(GT2x16_plain_idler)],
                [-baseWAxialShift, -baseWAxialShift + posY + 37, pulley_pr(GT2x16_plain_idler)],            
                [-baseWAxialShift, baseWAxialShift, pulley_pr(GT2x16_plain_idler)],
                [baseWAxialShift, baseWAxialShift, pulley_pr(GT2x16_plain_idler)],
//                [baseLength, posY, pulley_pr(GT2x16_plain_idler)],
                //                [-baseLength, -baseLength, pulley_pr(GT2x16_plain_idler)],

            ];
            path2 = [ 
                //motor
                [-baseWAxialShift, -baseWAxialShift, pulley_pr(GT2x16_toothed_idler)],
                [-baseWAxialShift, -baseWAxialShift + posY + 60, pulley_pr(GT2x16_plain_idler)],
                [baseWAxialShift, -baseWAxialShift + posY + 60, pulley_pr(GT2x16_plain_idler)],            
                [baseWAxialShift, baseWAxialShift, pulley_pr(GT2x16_plain_idler)],
                [-baseWAxialShift, baseWAxialShift, pulley_pr(GT2x16_plain_idler)],
//                [baseLength, posY, pulley_pr(GT2x16_plain_idler)],
                //                [-baseLength, -baseLength, pulley_pr(GT2x16_plain_idler)],

            ];
            translate([0,0,60-15])
                color("red") belt(GT2x6, path1);
                
                
            translate([0,0,60-25])
                color("green") belt(GT2x6, path2);

        }
    }
    
        
    
    
    
    xAxisLength = baseFrontSize-10;
    
    module yAxisRails(position = 0, mirrored = false) {
        positionAdj = 
            position > workingSpaceSizeMaxY 
                ? workingSpaceSizeMaxY : 
                position < workingSpaceSizeMinY ? workingSpaceSizeMinY :
                position;
        
        elevation = baseFrontSize + 20;
        
        translate([baseLength, -baseLength+10, elevation]) rotate([90,180,180]) {
                vslot_rail(
                    VSLOT_RAIL_2040_S, 
                    baseFrontSize, 
                    pos = positionAdj+15, 
                    mirror = true
                ) {
                    if(mirrored) translate([0, 0, xAxisLength/2]) 
                        rotate([90,90,-90]) 
                            xAxisRails(positionAdj, xAxisLength);
                }
            }
        

    }
    
    

    yAxisRails(positionZ);
    mirror([1,0,0]) yAxisRails(positionZ, mirrored = true);
    
    bottom_plate_740x740x3_dxf(
        false
    ) {
        zAxis(0, true);
    }
    zAxis(positionZ);

    base();
    
//    walls();
            
    top(positionZ,positionZ);
}


module printBed() {
    elevation = 85;
    baseLength = workingSpaceSize/2;
    extrusionSize = workingSpaceSize-20;
    // FRAME
    translate([-baseLength,0,elevation]) rotate([0,90,90])
        extrusion_w_cube(V2020, extrusionSize);

    translate([baseLength,0,elevation])  rotate([0,90,-90])
        extrusion_w_cube(V2020, extrusionSize);
    
    translate([0,-baseLength,elevation]) rotate([90,90,-90])
            extrusion_w_cube(V2020, extrusionSize);

    translate([0,0,elevation])          rotate([0,90,0])
            extrusion_w_angle(V2020, extrusionSize, sides = [1,0,1,0]);
    
    translate([0,baseLength,elevation]) rotate([0,90,0])
            extrusion_w_cube(V2020, extrusionSize);
    
    // CONNECTORS
    

    // HEATING PLATE
    translate([0,0,elevation+12])
        heatBed(workingSpaceSize, workingSpaceSize, 20);
}



module bottom_plate_740x740x3_dxf(dxf = true) {
    if(dxf)
        bottom_plate(
            portalWidth, 
            portalWidth) {
                zAxis(0, true);
            }
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
            translate([0,0,-3])
                linear_extrude(3) 
                    bottom_plate(
                        portalWidth, 
                        portalWidth
                    ) {
                            zAxis(0, true);
                    }
    }
}

module back_plate_740x800x3_dxf(dxf = true) {
    if(dxf)
        back_plate(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation);
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
                linear_extrude(3) 
                    back_plate(
                        portalWidth, 
                        portalWidth + legElevation, 
                        legElevation);
    }
}

module front_plate_740x800x3_dxf(dxf = true) {
    if(dxf)
        front_plate(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation);
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
            linear_extrude(3) 
                front_plate(
                    portalWidth, 
                    portalWidth + legElevation, 
                    legElevation);
    }
}

module side_plate_l_740x800x3_dxf(dxf = true) {
    if(dxf)
        side_plate_l(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation);
    else {
        color(sidePlateColor, sidePlateOpacity)   
        render(convexity = 2)  
            rotate([90,0,0]) 
                linear_extrude(3) 
                    side_plate_l(
                        portalWidth, 
                        portalWidth + legElevation, 
                        legElevation);
    }
}

module side_plate_r_740x800x3_dxf(dxf = true) {
    if(dxf)
        side_plate_r(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation,
            workingSpaceSize/2-20
        );
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
            rotate([90,0,0]) 
                linear_extrude(3) 
                    side_plate_r(
                        portalWidth, 
                        portalWidth + legElevation, 
                        legElevation,
                        workingSpaceSize/2-20
                    );  
    }
}


module walls() {
    //back
    translate([portalWidth/2,0,-legElevation]) 
        rotate([90,0,90])
            back_plate_740x800x3_dxf(false);

    //front
    translate([-portalWidth/2-3,0,-legElevation]) 
        rotate([90,0,90])
            front_plate_740x800x3_dxf(false);
    
    //left
    translate([0,-portalWidth/2,-legElevation]) 
            side_plate_l_740x800x3_dxf(false);
    
    
    //right
    translate([0,portalWidth/2+3,-legElevation]) 
        side_plate_r_740x800x3_dxf(false);   
}



//
//module screwM5x15(rotation = [0,90,0]) {
//    rotate(rotation) {
//        screw(M5_pan_screw, 15);
//        translate([0,0,-2]) spring_washer(M5_washer);
//    }
//}
//
//
//
//
//
//
module xyAxisMotor() {
    rotate([0,90,0]) motorPulley(6, NEMA17M, GT2x16_toothed_idler, 11);
//    motorPulley(6, NEMA17M, GT2x16_toothed_idler, 4);
}

module zAxisMotor(motorTranslation = 0, diff = false) {
    motorScrewY = frontPlateThickness+3;
    
    differ = motorTranslation < 0 ? 4 : 1;
    
    translate([
        0, 
        -baseLength+NEMA_width(motorModel)/2+10, 
        NEMA_length(motorModel)/2
    ]) {
        rotate([0,-90,0])
            motor(motorScrewY, motorModel, diff);
        
//        if(motorTranslation < 0) {    
//            xAxisMotorHolder(motorModel);    
//        } else {
//            rotate([180,0]) translate([0,0,-3])
//            xAxisMotorHolder(motorModel);    
//        }
        
        translate([0,0,workingSpaceSize/2+40]) leadscrew(
            8, 
            workingSpaceSize, 
            8, 
            2, 
            center = true
        );
    }
}
//
//
//module xAxisMotorHolder(motor) {
//
//    thickness = 3;
//    offsetW = 0;
//    offsetD = 0;
//    
//    width = NEMA_width(motor) + offsetW;
//    depth = NEMA_width(motor) + offsetD;
//    color("blue") translate([-offsetD/2,offsetW/2,thickness/2]) difference() {
//        rounded_rectangle([depth,width,thickness], thickness, center = true);
//
//        translate([offsetD/2,-offsetW/2,0])
//        drill(NEMA_boss_radius(motor), thickness+2);
//        
////        translate([0,22,0])
////        slot(3, depth/2, h = thickness+2);
//    }
//}