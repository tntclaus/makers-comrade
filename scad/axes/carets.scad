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

BELT_H_YS = -10.2; //Belt hole Y shift
BELT_H_X = 41.5;
BELT_H_Y1 = 13;
BELT_H_Y2 = BELT_H_Y1-6;
BELT_H_D = belt_thickness(GT2x6)*2;

X_MOUNTS = [
//    [5,0,-29.85,30.32],
    [5,  0,-35.75,39],    
    [5,  0,-35.75,-39],        
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
    
    [BELT_H_D, 0, ["circle", [[BELT_H_YS-BELT_H_Y1,-BELT_H_X], [BELT_H_YS-BELT_H_Y2,-BELT_H_X]]]],
    [BELT_H_D, 0, ["circle", [[BELT_H_YS+BELT_H_Y1,-BELT_H_X], [BELT_H_YS+BELT_H_Y2,-BELT_H_X]]]],

    [BELT_H_D, 0, ["circle", [[BELT_H_YS-BELT_H_Y1,BELT_H_X], [BELT_H_YS-BELT_H_Y2,BELT_H_X]]]],
    [BELT_H_D, 0, ["circle", [[BELT_H_YS+BELT_H_Y1,BELT_H_X], [BELT_H_YS+BELT_H_Y2,BELT_H_X]]]],    
    


//    [7.2,0,19.85,-30.32],    
//    [7.2,0,29.85,-30.32], //mount
];


//X_PLATE = [[75,75], 5,      5,        VW_HOLES_20x3_BOTTOM,  X_MOUNTS];

X_VW_HOLES = [
    [5,  0,-19.85,35],
    [7.2,0,19.85,0],
    [5,  0,-19.85,-35]
];

X_PLATE_POLY = [
    [-38,-42,5],      
    [-40,-42,5],
    [-45,-22,10],
    [-45, 5,10],    
    [-30, 25,5],    
    [  0,20,10],
    [30,  25,5],
    [45, 5,10],    
    [45,-22,10],    
    [40,-42,5],
    [38,-42,5],          

    [28,-35,-5],      
    [-28,-35,-5],    
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
PULLEY2_X_COORDINATE = pulley_od(Y_PULLEY) - belt_thickness(GT2x6);

//Y_MOUNTS = [
//    [5.05,0,-38,-36],  
//    [5.05,0,-38, 36],        
//    [4.05,0,-PULLEY2_X_COORDINATE, PULLEY_Y_COORDINATE],  [4,0,0, PULLEY_Y_COORDINATE],
//    [4.05,0,-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE],  [4,0,0,-PULLEY_Y_COORDINATE],
//];

function GET_Y_MOUNTS(w) = [
    [5.05,0,-38,-16-w/2],  
    [5.05,0,-38, 16+w/2],        
    [4.05,0,-PULLEY2_X_COORDINATE, PULLEY_Y_COORDINATE],  [4,0,0, PULLEY_Y_COORDINATE],
    [4.05,0,-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE],  [4,0,0,-PULLEY_Y_COORDINATE],
];

function GET_Y_VW_HOLES(w) = [
    [5.05,  0,-19.85, 16+w/2],
    [7.25,  0, 19.85,  0],
    [5.05,  0,-19.85,-16-w/2]
];

function GET_Y_PLATE_POLY(w) = [
    [-16-w/2,-20,10],
    [0,20,10],
    [16+w/2,-20,10],

    [20+w/2,-43,3],
    [10+w/2,-43,3],
    [4+w/2,-25,-3],
    
    [-4-w/2,-25,-3],
    [-10-w/2,-43,3], 
    [-20-w/2,-43,3],
//    [-40,-40,3], 
//    [  7,-22,3], 
//    [ -7,-22,3], 
];


//Y_PLATE = [GET_Y_PLATE_POLY(60), 5, 5, GET_Y_VW_HOLES(60),  GET_Y_MOUNTS(60)];
//Y_GANTRY = ["", Y_PLATE, [  S_XTREME_VW_SPACER,
//                            S_XTREME_VW_ECCENT,
//                            S_XTREME_VW_SPACER], 20];

function GET_Y_PLATE(w) = [GET_Y_PLATE_POLY(w), 5, 5, GET_Y_VW_HOLES(w), GET_Y_MOUNTS(w)];
function GET_Y_GANTRY(w, profile = 20) = ["", GET_Y_PLATE(w), [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], profile];



function GET_Y_RAIL(width, profile = 20) = ["", GET_Y_GANTRY(width, profile), E2040];