include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>
include <../../lib/vwheel_gantries.scad>
include <../../lib/vslot_rails.scad>

//workingSpaceSizeMaxX  = 1000;
//workingSpaceSizeMinX = 0;



MOUNTS = [[5,0,-29.85,30.32],[5,0,-19.85,30.32],[5,20,0,30.32],[7.2,0,19.85,30.32],[7.2,0,29.85,30.32],
    [5,0,-29.85,20.325],[5,0,-19.85,20.325],[5,0,-10,20.325],[5,0,0,20.325],[5,0,10,20.325],[5,0,19.85,20.325],[5,0,29.85,20.325],
    [5,0,-14.825,14.82],[5,0,14.825,14.82],
    [5,0,-29.85,10],[5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],[5,0,29.85,10],
    [5,0,-29.85,0],[5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],[7.2,0,29.85,0],
    [5,0,-29.85,-10],[5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],[5,0,29.85,-10],
    [5,0,-14.825,-14.82],[5,0,14.825,-14.82],
    [5,0,-29.85,-20.325],[5,0,-19.85,-20.325],[5,0,-10,-20.325],[5,0,0,-20.325],[5,0,10,-20.325],[5,0,19.85,-20.325],[5,0,29.85,-20.325],
    [5,0,-29.85,-30.32],[5,0,-19.85,-30.32],[5,20,0,-30.32],[7.2,0,19.85,-30.32],[7.2,0,29.85,-30.32],
];

X_PLATE = [[75,75], 5,      3,        VW_HOLES_40x3,  MOUNTS];

UNIVERSAL_75x75_GANTRY = ["", X_PLATE, [  D_XTREME_VW_SPACER,
                                          D_XTREME_VW_ECCENT,
                                          D_XTREME_VW_SPACER], 40];


X_RAIL = ["", UNIVERSAL_75x75_GANTRY, E2040];

module gantry_sq_plate_75x75x3_45_dxf() {
    projection()     vslot_plate(X_PLATE);
}

//gantry_sq_plate_75x75x3_3_dxf();

module xAxisRails(position = 0, xAxisLength) {
    positionAdj = 
    position > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        position < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        position;
    
    translate([xAxisLength/2,0,0]) rotate([-90,0,90]) {
        vslot_rail(
                X_RAIL, 
                xAxisLength, 
                pos = positionAdj+15, 
                mirror = true
            );
    }
}

//xAxisRails(0, 1000);