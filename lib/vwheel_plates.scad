
VW_HOLES_20x3 = [
    [5,  0,-19.85,20],
    [7.2,0,19.85,0],
    [5,  0,-19.85,-20]
];

VW_HOLES_20x3_BOTTOM = [
    [5,  0,-9.85,20],
    [7.2,0,29.85,0],
    [5,  0,-9.85,-20]
];

VW_HOLES_40x3 = [
    [5,  0,-29.85,30.32],
    [7.2,0,29.85,0],
    [5,  0,-29.85,-30.32]
];



VW_HOLES_20x2 = [
    [5,  0,-19.85,0],
    [7.2,0, 19.85,0]
];

//              SIZE,     RADIUS, THICKNESS, WHEEL HOLES,    MOUNT HOLES
GEOM_TR_20 = [[65,65,65], 5,      3,        VW_HOLES_20x3,  []];

GEOM_TR_40 = [[90,90,80], 5,      3,        VW_HOLES_40x3,  []];

GEOM_SQ_20 = [[40,65],    5,      3,        VW_HOLES_20x2,  []];


use <vwheel_plate.scad>

//vslot_plate(GEOM_TR_40);