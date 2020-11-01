
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

include <pulley_and_motor_plates.scad>

use <heatbed.scad>
include <motors.scad>
include <case_plates.scad>
include <axes/z-axis.scad>
include <axes/x-axis.scad>
include <axes/y-axis.scad>


V2020 = E2020;
V2040 = E2040;

VSLOT_RAIL_2020_S1 = ["", S_20_TRIANGLE_GANTRY, V2020];
VSLOT_RAIL_2020_D1 = ["", D_20_TRIANGLE_GANTRY, V2020];

//$show_threads = true;
//$renderGantryHoles = true; 

motorModel = NEMA17M;

workingSpaceSize = 600;

workingSpaceSizeMaxZ = workingSpaceSize - 10;
workingSpaceSizeMinZ = 20;

workingSpaceSizeMaxX = workingSpaceSize - 18;
workingSpaceSizeMinX = 12;
workingSpaceSizeMaxY = workingSpaceSize + 20;
workingSpaceSizeMinY = 70;

baseFrontSize = workingSpaceSize+40*2+20;

legElevation = 60;

// Основание
baseLength = baseFrontSize/2+10;
portalWidth = baseFrontSize + 40;

// Стенки
wallThickness = 4;
topElevation = 160;

echo(str(
    "Build volume = ",
    workingSpaceSizeMaxX,"x",
   workingSpaceSizeMaxY, "x",
   workingSpaceSizeMaxZ
    ));


frontPlateThickness = 3;

//colors
cubeConnectorColor = "orange";
//wallColor = "#33aaee99";
wallColor = "#6633ff";
    
module main_assembly() {
    echo(str(baseFrontSize, " ", portalWidth));
    case(75);
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
        
    }
    
    module top(posXinc, posY) {
        posX = 
    posXinc > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        posXinc < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        posXinc;
        
        
        elevation = baseFrontSize + 30;
        
        module corner_elevation_assembly(baseWAxialShift) {
            corner3 = [baseWAxialShift+10, -baseWAxialShift+30,10];
            translate(corner3) rotate([0,0,180]) 
                 color("silver") linear_extrude(3)
                    pulley_corner_plate();
        }
        //todo уголки для соединения 
        translate([0,0,elevation]) {
            motorAxialShiftY = 31+wallThickness;
            motorAxialShiftX = baseLength;
            beltsSpacing = 18;
            translate([0,-baseLength,0]) {
                rotate([0,90,0])
                    extrusion_w_angle(E2020, baseFrontSize, sides = [0,1,1,0]);
                
                translate([-baseLength, -motorAxialShiftY, 10]) xyAxisMotor(left = true);
                translate([baseLength, -motorAxialShiftY, 10+beltsSpacing]) xyAxisMotor(left = false);
            }

         
            translate([0,baseLength,0]) {
                rotate([0,90,0])
                    extrusion_w_angle(E2020, baseFrontSize, sides = [1,1,0,0]);
            }

            baseWAxialShift = baseLength;
            idler = GT2x20_plain_idler;
            
            
            corner1 = [-baseWAxialShift-10, baseWAxialShift-30,10];
            corner2 = [baseWAxialShift-30, baseWAxialShift+10,10];

            
            translate(corner1) corner_pulley_block(6, 26);
            translate(corner2) {
                rotate([0,0,-90]) corner_pulley_block(6, 26);
                translate([-10,-31,-5])
                rotate([0,-90,180]) endstop_y();
            }
    
            corner_elevation_assembly(baseWAxialShift);
            translate_z(3) corner_elevation_assembly(baseWAxialShift);
            translate_z(6) corner_elevation_assembly(baseWAxialShift);
            translate_z(9) corner_elevation_assembly(baseWAxialShift);
            translate_z(12) corner_elevation_assembly(baseWAxialShift);
            translate_z(15) corner_elevation_assembly(baseWAxialShift);

            adjAdjY = 5;
            caretThick = 3 * 2 + 6*2 + 11;
            beltThick = belt_thickness(GT2x6);
            pulleyPR = pulley_pr(idler);
            adjPosY = baseLength - (posY - pulleyPR) - 0.5 + adjAdjY;
            adjPosY1 = baseLength - (posY + caretThick + beltThick) + adjAdjY;
            adjPosY2 = baseLength - (posY + pulleyPR + beltThick + caretThick) + adjAdjY;
            
            adjPosX = posX+75;
            
            path1 = [ 
                //motor
                [motorAxialShiftX, -baseWAxialShift-motorAxialShiftY, pulley_pr(GT2x16_toothed_idler)],
                [baseWAxialShift-12, adjPosY2, -pulley_pr(idler)],
                [-baseWAxialShift+adjPosX, adjPosY1, 1],
                [-baseWAxialShift+adjPosX-75/2, adjPosY - pulleyPR + beltThick, 1],
                [-baseWAxialShift-1, adjPosY, pulley_pr(idler)],
                [-baseWAxialShift-1, baseWAxialShift+1, pulley_pr(GT2x20_plain_idler)],
                [baseWAxialShift+1, baseWAxialShift+1, pulley_pr(GT2x20_plain_idler)],
            ];
            

            echo(caretThick, belt_thickness(GT2x6));
            
            path2 = [ 
                //motor
                [-motorAxialShiftX, -baseWAxialShift-motorAxialShiftY, pulley_pr(GT2x16_toothed_idler)],
                [-baseWAxialShift-1, baseWAxialShift+1, pulley_pr(idler)],
                [baseWAxialShift+1, baseWAxialShift+1, pulley_pr(idler)],
                [baseWAxialShift+1, adjPosY, pulley_pr(idler)],
                [-baseWAxialShift+adjPosX, adjPosY - pulleyPR + beltThick, 1],
                [-baseWAxialShift+adjPosX-75/2, adjPosY1, 1],                
                [-baseWAxialShift+12, adjPosY2 , -pulley_pr(idler)],
            ];
            translate([0,0,24.1+beltsSpacing])
                color("#ff000099") belt(GT2x6, path1);
                
                
            translate([0,0,24.1])
                color("#00ff0099") belt(GT2x6, path2);

        }
    }
    

    // Y/X AXIS
    xAxisLength = baseFrontSize-10;
    yAxisRails(positionZ, baseFrontSize, baseLength);
    mirror([1,0,0]) 
        yAxisRails(positionZ, baseFrontSize, baseLength, xAxisLength, mirrored = true);
    
    bottom_plate_740x740x3_dxf(
        false
    ) {
        zAxis(0, true);
    }
    zAxis(positionZ);

    base();
    
//    color(wallColor) 
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
                linear_extrude(wallThickness) 
                    bottom_plate(
                        portalWidth, 
                        portalWidth
                    ) {
                            zAxis(0, true);
                    }
    }
}

module back_plate_740x800x4_dxf(dxf = true) {
    module side() {
        back_plate(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation,
            wallThickness,
            topElevation);
    }
    
    if(dxf)
        side();
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
                linear_extrude(wallThickness) 
                    side();
    }
}

module front_plate_740x800x4_dxf(dxf = true) {
    module side() {
        front_plate(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation,
            wallThickness,
            topElevation);
    }
    if(dxf)
        side();
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
            linear_extrude(wallThickness) 
                side();
        
        translate([0,0,-1.5]) 
        plastic_doors(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation, 4, angle = 90);
    }
}

module side_plate_l_740x800x4_dxf(dxf = true) {
    module side() {
        side_plate_l(
            portalWidth, 
            portalWidth + legElevation, 
            legElevation,
            wallThickness,
            topElevation);
    }
    if(dxf)
        side();
    else {
        color(sidePlateColor, sidePlateOpacity)   
        render(convexity = 2)  
            rotate([90,0,0]) 
                linear_extrude(wallThickness) 
                    side();
        
        rotate([90,0,0]) 
        translate([0, 0, 4]) 
            plastic_window(portalWidth + legElevation, legElevation, 3);
    }
}

module plastic_window_800x60x3_stl() {
    $fn = 90;
    plastic_window(800, 60, 3);
}

module side_plate_r_740x800x4_dxf(dxf = true) {
    module side() {
        difference() {
            side_plate_r(
                portalWidth, 
                portalWidth + legElevation, 
                legElevation,
                workingSpaceSize/2-20,
                wallThickness,
                topElevation
            );
            translate([-5,portalWidth + legElevation+10,0]) {
                hull() {
                circle(d = 10);
                translate([10,0,0]) circle(d = 10);
                }
            }
            
            
            translate([30,portalWidth + legElevation+25,0]) {
                hull() {
                circle(d = 10);
                translate([0,10,0]) circle(d = 10);
                }
            }
            
        }
    }
    if(dxf)
        side();
    else {
        color(sidePlateColor, sidePlateOpacity)    
        render(convexity = 2)  
            rotate([90,0,0]) 
                linear_extrude(wallThickness) 
                    side();
        rotate([90,0,0]) {
            translate([workingSpaceSize/2-20, 0, -4]) 
                    plastic_window(portalWidth + legElevation, legElevation, 3);
            translate([-workingSpaceSize/2+20, 0, -4]) 
                plastic_window(portalWidth + legElevation, legElevation, 3);
        }
    }
}


module walls() {
    //back
    translate([portalWidth/2,0,-legElevation]) 
        rotate([90,0,90])
            back_plate_740x800x4_dxf(false);

    //front
    translate([-portalWidth/2-wallThickness,0,-legElevation]) 
        rotate([90,0,90]) {
            front_plate_740x800x4_dxf(false);
        }
    
    //left
    translate([0,-portalWidth/2,-legElevation])  {
            side_plate_l_740x800x4_dxf(false);
    }
    
//    translate([portalWidth/2,-portalWidth/2,portalWidth+topElevation+10])
//    mirror([1,0,0])
//    extrusion_corner_bracket(
//        E20_corner_bracket
//    , 
//        screw_type = M5_cs_cap_cross_screw, 
//        nut_type = M5_nut
//    );
    
    //right
    translate([0,portalWidth/2+wallThickness,-legElevation]) 
        side_plate_r_740x800x4_dxf(false);   
}



module xyAxisMotor(left = false) {
    color("silver") if(left) {
        linear_extrude(3) mirror([0,1,0]) 
            motorMountPlate(NEMA17M, wallThickness); 
    } else {
        linear_extrude(3) mirror([1,0,0]) mirror([0,1,0]) 
            motorMountPlate(NEMA17M, wallThickness);
    }
    
    rotate([0,-90,0]) motorPulley(6, NEMA17M, GT2x16_toothed_idler, 11);
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