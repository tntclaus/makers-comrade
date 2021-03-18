include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
//use <NopSCADlib/vitamins/pulley.scad>

include <../screw_assemblies.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>

X_CARET_THICKNESS = 6 + 6*2 + 3*2;

X_CARET_PLATE_GAP = 3 + 1.2; 
X_CARET_PLATE_GAP_RAIL_CENTER = X_CARET_PLATE_GAP + 10;

BELT_H_YS = -10.2; //Belt hole Y shift
BELT_H_X = 41.5;
BELT_H_Y1 = 13;
BELT_H_Y2 = BELT_H_Y1-6;
BELT_H_D = belt_thickness(GT2x6)*2;


X_VW_HOLES = [
    [5.01,  0,-19.85, 35],
    [7.21,  0, 19.85,  0],
    [5.01,  0,-19.85,-35],
];



X_PLATE_LENGTH = 110;
X_PLATE_HEIGTH = 80;


X_PLATE_CONNECTOR_HEIGTH = 8;
X_PLATE_CONNECTOR_LENGTH = 3;
X_PLATE_CONNECTOR_MOUNT_X = X_PLATE_LENGTH/2 - X_PLATE_CONNECTOR_LENGTH;
X_PLATE_CONNECTOR_MOUNT_Y1 = X_VW_HOLES[0][2] - X_PLATE_CONNECTOR_HEIGTH/2 + X_PLATE_CONNECTOR_LENGTH/2;
X_PLATE_CONNECTOR_MOUNT_Y2 = X_VW_HOLES[0][2] + X_PLATE_CONNECTOR_HEIGTH/2 - X_PLATE_CONNECTOR_LENGTH/2; 

X_PLATE_CONNECTOR_MOUNT_Y3 = 0 - X_PLATE_CONNECTOR_HEIGTH/2 + X_PLATE_CONNECTOR_LENGTH/2;
X_PLATE_CONNECTOR_MOUNT_Y4 = 0 + X_PLATE_CONNECTOR_HEIGTH/2 - X_PLATE_CONNECTOR_LENGTH/2; 

X_PLATE_CARET_CONNECTOR_HEIGTH = -X_VW_HOLES[0][2] + X_PLATE_CONNECTOR_HEIGTH;

X_PLATE_SUPPORT_A_LENGTH = 80;
X_PLATE_SUPPORT_A_HEIGTH = 8;


X_PLATE_SUPPORT_B_LENGTH = 20;
X_PLATE_SUPPORT_B_HEIGTH = 7;
X_PLATE_SUPPORT_B_CORNER_RADIUS = 0.5;
X_PLATE_SUPPORT_B_OFFSET_Y = -0.5;

X_PLATE_SUPPORT_B_SCREW_DIA = 3;
X_PLATE_SUPPORT_B_SCREW_OFFSET = X_PLATE_SUPPORT_B_LENGTH/2-X_PLATE_SUPPORT_B_SCREW_DIA;

X_PLATE_SUPPORT_A_B_OFFSET = 28.5;

X_PLATE_SUPPORT_B_SCREW1_X_POS = X_PLATE_SUPPORT_A_LENGTH/2 + X_PLATE_SUPPORT_B_SCREW_OFFSET;
X_PLATE_SUPPORT_B_SCREW2_X_POS = X_PLATE_SUPPORT_A_LENGTH/2 - X_PLATE_SUPPORT_B_SCREW_OFFSET;
X_PLATE_SUPPORT_B_SCREWS_Y_RELATIVE_POS = X_PLATE_SUPPORT_B_HEIGTH/4 - X_PLATE_SUPPORT_B_CORNER_RADIUS/2;
X_PLATE_SUPPORT_B_SCREWS_Y_POS = X_VW_HOLES[0][2] + X_PLATE_SUPPORT_A_B_OFFSET + X_PLATE_SUPPORT_B_SCREWS_Y_RELATIVE_POS;


FIXTURE_EAR_SHIFT = 6;
FIXTURE_EAR1_X = X_VW_HOLES[0][3] - FIXTURE_EAR_SHIFT;
FIXTURE_EAR2_X = X_VW_HOLES[2][3] + FIXTURE_EAR_SHIFT;


X_MOUNTS = [
//    [5,0,-29.85,30.32],

    // отверстия в ушках
//    [5,  0,-35.75, 39],  
//    [5,  0,-35.75,-39],
    

    // отверстия для монтажа стальных суппортов
    [X_PLATE_SUPPORT_B_SCREW_DIA+0.05, 0,X_PLATE_SUPPORT_B_SCREWS_Y_POS, X_PLATE_SUPPORT_B_SCREW1_X_POS],
    [X_PLATE_SUPPORT_B_SCREW_DIA+0.05, 0,X_PLATE_SUPPORT_B_SCREWS_Y_POS, X_PLATE_SUPPORT_B_SCREW2_X_POS],

    [X_PLATE_SUPPORT_B_SCREW_DIA+0.05, 0,X_PLATE_SUPPORT_B_SCREWS_Y_POS,-X_PLATE_SUPPORT_B_SCREW1_X_POS],
    [X_PLATE_SUPPORT_B_SCREW_DIA+0.05, 0,X_PLATE_SUPPORT_B_SCREWS_Y_POS,-X_PLATE_SUPPORT_B_SCREW2_X_POS],
    
    // отверстия для альтернативных 4-колёсного варианта
    [7.21,  0, 19.85, 30],
    [7.21,  0, 19.85,-30],
    
    
//    [5,0,-29.85,30.32],[5,0,-19.85,30.32],[5,20,0,30.32],[7.2,0,19.85,30.32],[7.2,0,29.85,30.32],
//    [5,0,-29.85,20.325],[5,0,-19.85,20.325],[5,0,-10,20.325],[5,0,0,20.325],[5,0,10,20.325],[5,0,19.85,20.325],[5,0,29.85,20.325],
//    [5,0,-14.825,14.82],[5,0,14.825,14.82],
    
    
    
//    [5,0,-29.85,10],[5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],[5,0,29.85,10],
//    [5,0,-29.85,0],[5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],[7.2,0,29.85,0],
//    [5,0,-29.85,-10],[5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],[5,0,29.85,-10],
//    [5,0,-14.825,-14.82],[5,0,14.825,-14.82],
//    [5,0,-29.85,-20.325],[5,0,-19.85,-20.325],[5,0,-10,-20.325],[5,0,0,-20.325],[5,0,10,-20.325],[5,0,19.85,-20.325],[5,0,29.85,-20.325],


//    [5,0,-29.85,-30.32], //mount    
//    [5,0,-19.85,-30.32], // mount   
    
//    // отверстия для ремней из устаревшей версии
//    [BELT_H_D, 0, ["circle", [[BELT_H_YS-BELT_H_Y1,-BELT_H_X], [BELT_H_YS-BELT_H_Y2,-BELT_H_X]]]],
//    [BELT_H_D, 0, ["circle", [[BELT_H_YS+BELT_H_Y1,-BELT_H_X], [BELT_H_YS+BELT_H_Y2,-BELT_H_X]]]],
//
//    [BELT_H_D, 0, ["circle", [[BELT_H_YS-BELT_H_Y1,BELT_H_X], [BELT_H_YS-BELT_H_Y2,BELT_H_X]]]],
//    [BELT_H_D, 0, ["circle", [[BELT_H_YS+BELT_H_Y1,BELT_H_X], [BELT_H_YS+BELT_H_Y2,BELT_H_X]]]],    
    
    // отверстие под резьбу М3 в ушке фиксатора
    [2.5, 0,-21.85-6.475,FIXTURE_EAR1_X],
    [2.5, 0,-21.85-6.475,FIXTURE_EAR2_X],
    
    
    // отверстие под провод датчика автоуровня
    [5, 0, -10, 0],

    // отверстия для вставки поперечных пластин
    [3, 0,["square",[[X_PLATE_CONNECTOR_MOUNT_Y1, X_PLATE_CONNECTOR_MOUNT_X], [X_PLATE_CONNECTOR_MOUNT_Y2, X_PLATE_CONNECTOR_MOUNT_X]]]],
    [3, 0,["square",[[X_PLATE_CONNECTOR_MOUNT_Y1,-X_PLATE_CONNECTOR_MOUNT_X], [X_PLATE_CONNECTOR_MOUNT_Y2,-X_PLATE_CONNECTOR_MOUNT_X]]]],

    [3, 0,["square",[[X_PLATE_CONNECTOR_MOUNT_Y3, X_PLATE_CONNECTOR_MOUNT_X], [X_PLATE_CONNECTOR_MOUNT_Y4, X_PLATE_CONNECTOR_MOUNT_X]]]],
    [3, 0,["square",[[X_PLATE_CONNECTOR_MOUNT_Y3,-X_PLATE_CONNECTOR_MOUNT_X], [X_PLATE_CONNECTOR_MOUNT_Y4,-X_PLATE_CONNECTOR_MOUNT_X]]]],


    // отверстия под дополнительный винтовой крепеж шпилькой/винтом м3
    [2.5, 0, X_PLATE_CONNECTOR_MOUNT_Y4+5, X_PLATE_CONNECTOR_MOUNT_X ],
    [2.5, 0, X_PLATE_CONNECTOR_MOUNT_Y4+5,-X_PLATE_CONNECTOR_MOUNT_X ]    

//    [7.2,0,19.85,-30.32],    
//    [7.2,0,29.85,-30.32], //mount
];


//X_PLATE = [[75,75], 5,      5,        VW_HOLES_20x3_BOTTOM,  X_MOUNTS];


X_PLATE_POLY = [
//  бывш ушки
//    [-38,-21.85,5],      
//    [-40,-42,5],


    // ушко фиксатора

    [ FIXTURE_EAR1_X+5,-21.85-6,-1],
    [ FIXTURE_EAR1_X+0,-21.85-6,3.5],
    [ FIXTURE_EAR1_X-5,-21.85-6,-1],

    [ FIXTURE_EAR2_X+5,-21.85-6,-1],
    [ FIXTURE_EAR2_X+0,-21.85-6,3.5],
    [ FIXTURE_EAR2_X-5,-21.85-6,-1],

    [-X_PLATE_LENGTH/2+ 1, -21.85 - 4, 1],
    [-X_PLATE_LENGTH/2+10, 5,10],
    
    [-30, 25,5],
    [  0,20,10],
    [ 30,  25,5],

    [ X_PLATE_LENGTH/2-10,  5,10],
    [ X_PLATE_LENGTH/2- 1, -21.85 - 4, 1],

//  бывш ушки
//    [45,-22,10],
//    [40,-42,5],
//    [38,-42,5],          

//    [28,-35,-5],      
//    [-28,-35,-5],    
];

X_PLATE = [X_PLATE_POLY, 5,      3,        X_VW_HOLES,  X_MOUNTS];

UNIVERSAL_75x75_GANTRY = ["", X_PLATE, [  S_XTREME_VW_SPACER,
                                          S_XTREME_VW_ECCENT,
                                          S_XTREME_VW_SPACER], 20];

SPECIAL_75x75_GANTRY = ["", X_PLATE, [  S_XTREME_VW_SPACER,
                                          S_XTREME_VW_ECCENT,
                                          S_XTREME_VW_SPACER], 20];

X_RAIL = ["", SPECIAL_75x75_GANTRY, E2020];












Y_VW_HOLES = [
    [5.05,  0,-19.85, 36],
    [7.25,  0, 19.85,  0],
    [5.05,  0,-19.85,-36]
];

//Y_PLATE_POLY = [
//    [-36,-20,10],
//    [0,20,10],
//    [36,-20,10],
//
//    [40,-43,3],
//    [30,-43,3],
//    [24,-25,-3],
//    
//    [-24,-25,-3],
//    [-30,-43,3], 
//    [-40,-43,3],
////    [-40,-40,3],        
////    [7,-22,3],    
////    [-7,-22,3],        
//];
Y_PULLEY = GT2x20_plain_idler;

PULLEY_Y_COORDINATE = X_CARET_THICKNESS/2  - belt_thickness(GT2x6) + pulley_pr(Y_PULLEY);
PULLEY_Y_COORDINATE2 = PULLEY_Y_COORDINATE - GT2x6[5];
PULLEY2_X_COORDINATE = pulley_od(Y_PULLEY) - belt_thickness(GT2x6);

//Y_MOUNTS = [
//    [5.05,0,-38,-36],  
//    [5.05,0,-38, 36],        
//    [4.05,0,-PULLEY2_X_COORDINATE, PULLEY_Y_COORDINATE],  [4,0,0, PULLEY_Y_COORDINATE],
//    [4.05,0,-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE],  [4,0,0,-PULLEY_Y_COORDINATE],
//];

function GET_Y_MOUNTS(w) = [
    [5.05,0,["circle", [[-45,-X_CARET_PLATE_GAP_RAIL_CENTER-w/2], [-40,-X_CARET_PLATE_GAP_RAIL_CENTER-w/2]]]],  
    [5.05,0,["circle", [[-45, X_CARET_PLATE_GAP_RAIL_CENTER+w/2], [-40, X_CARET_PLATE_GAP_RAIL_CENTER+w/2]]]],  
    [4.05,0,-PULLEY2_X_COORDINATE, PULLEY_Y_COORDINATE],  [4,0,0, PULLEY_Y_COORDINATE2],
    [4.05,0,-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE],  [4,0,0,-PULLEY_Y_COORDINATE2],
];

function GET_Y_VW_HOLES(w) = [
    [5.05,  0,-19.85, X_CARET_PLATE_GAP_RAIL_CENTER+w/2],
    [7.25,  0, 19.85,  0],
    [5.05,  0,-19.85,-X_CARET_PLATE_GAP_RAIL_CENTER-w/2]
];

function GET_Y_PLATE_POLY(w) = [
    [-X_CARET_PLATE_GAP-w/2-10,-20,10],
    [                            0, 20,10],
    [ X_CARET_PLATE_GAP+w/2+10,-20,10],

    [ X_CARET_PLATE_GAP+w/2+17,-50,3],
    [ X_CARET_PLATE_GAP+w/2+3,-50,3],
    [ X_CARET_PLATE_GAP+w/2-3,-25,-3],
    
    [-X_CARET_PLATE_GAP-w/2+3,-25,-3],
    [-X_CARET_PLATE_GAP-w/2-3,-50,3], 
    [-X_CARET_PLATE_GAP-w/2-17,-50,3],
//    [-40,-40,3], 
//    [  7,-22,3], 
//    [ -7,-22,3], 
];


//Y_PLATE = [GET_Y_PLATE_POLY(60), 5, 5, GET_Y_VW_HOLES(60),  GET_Y_MOUNTS(60)];
//Y_GANTRY = ["", Y_PLATE, [  S_XTREME_VW_SPACER,
//                            S_XTREME_VW_ECCENT,
//                            S_XTREME_VW_SPACER], 20];

function GET_Y_PLATE(w) = [GET_Y_PLATE_POLY(w), 5, 3, GET_Y_VW_HOLES(w), GET_Y_MOUNTS(w)];
function GET_Y_GANTRY(w, profile = 20) = ["", GET_Y_PLATE(w), [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], profile];



function GET_Y_RAIL(width, profile = 20) = ["", GET_Y_GANTRY(width, profile), E2040];