include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/pulleys.scad>
//use <NopSCADlib/vitamins/pulley.scad>

include <../screw_assemblies.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>

X_CARET_THICKNESS = 11 + 6*2 + 3*2;

BELT_H_X = 30.32;
BELT_H_Y1 = 13;
BELT_H_Y2 = 13-6;
BELT_H_D = 1.8;

X_MOUNTS = [[5,0,-29.85,30.32],[5,0,-19.85,30.32],[5,20,0,30.32],[7.2,0,19.85,30.32],[7.2,0,29.85,30.32],
    [5,0,-29.85,20.325],[5,0,-19.85,20.325],[5,0,-10,20.325],[5,0,0,20.325],[5,0,10,20.325],[5,0,19.85,20.325],[5,0,29.85,20.325],
    [5,0,-14.825,14.82],[5,0,14.825,14.82],
    
    
    
    [5,0,-29.85,10],[5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],[5,0,29.85,10],
    [5,0,-29.85,0],[5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],[7.2,0,29.85,0],
    [5,0,-29.85,-10],[5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],[5,0,29.85,-10],
    [5,0,-14.825,-14.82],[5,0,14.825,-14.82],
    [5,0,-29.85,-20.325],[5,0,-19.85,-20.325],[5,0,-10,-20.325],[5,0,0,-20.325],[5,0,10,-20.325],[5,0,19.85,-20.325],[5,0,29.85,-20.325],


    [5,0,-29.85,-30.32], //mount    
    [5,0,-19.85,-30.32], // mount   
    
    [BELT_H_D, 0, ["circle", [[-BELT_H_Y1,-BELT_H_X], [-BELT_H_Y2,-BELT_H_X]]]],
    [BELT_H_D, 0, ["circle", [[BELT_H_Y1,-BELT_H_X], [BELT_H_Y2,-BELT_H_X]]]],

    [BELT_H_D, 0, ["circle", [[-BELT_H_Y1,BELT_H_X], [-BELT_H_Y2,BELT_H_X]]]],
    [BELT_H_D, 0, ["circle", [[BELT_H_Y1,BELT_H_X], [BELT_H_Y2,BELT_H_X]]]],    
    


    [7.2,0,19.85,-30.32],    
    [7.2,0,29.85,-30.32], //mount
];

X_PLATE = [[75,75], 5,      3,        VW_HOLES_40x3,  X_MOUNTS];

UNIVERSAL_75x75_GANTRY = ["", X_PLATE, [  D_XTREME_VW_SPACER,
                                          D_XTREME_VW_ECCENT,
                                          D_XTREME_VW_SPACER], 40];


X_RAIL = ["", UNIVERSAL_75x75_GANTRY, E2040];












Y_VW_HOLES = [
    [5,  0,-19.85,35],
    [7.2,0,19.85,0],
    [5,  0,-19.85,-35]
];

Y_PLATE_POLY = [
    [-35,-20,10],
    [0,20,10],
    [35,-20,10],
    [15,-30,-5],
    [7,-40,3],    
    [-7,-40,3],        
    [-15,-30,-5],    
];

Y_PULLEY = GT2x20_plain_idler;

PULLEY_Y_COORDINATE = X_CARET_THICKNESS/2 + belt_thickness(GT2x6) + pulley_pr(Y_PULLEY);
PULLEY2_X_COORDINATE = pulley_od(Y_PULLEY) + belt_thickness(GT2x6);

Y_MOUNTS = [
    [4,0,-PULLEY2_X_COORDINATE,PULLEY_Y_COORDINATE],                     [4,0,0,PULLEY_Y_COORDINATE],
                                                                [5,0,0,10],
    [5,0,-35,0],     [5,0,-20,0],         [5,0,-10,0],    [5,0,0,0],
                                                                [5,0,0,-10],  
    [4,0,-PULLEY2_X_COORDINATE,-PULLEY_Y_COORDINATE],                  [4,0,0,-PULLEY_Y_COORDINATE],
];


Y_PLATE = [Y_PLATE_POLY, 5,      3,        Y_VW_HOLES,  Y_MOUNTS];

Y_GANTRY = ["", Y_PLATE, [  S_XTREME_VW_SPACER,
                            S_XTREME_VW_ECCENT,
                            S_XTREME_VW_SPACER], 20];


Y_RAIL = ["", Y_GANTRY, E2040];