include <NopSCADlib/utils/core/core.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>

module xAxisRails(position = 0, xAxisLength) {
    positionAdj = 
    position > workingSpaceSizeMaxX 
        ? workingSpaceSizeMaxX : 
        position < workingSpaceSizeMinX ? workingSpaceSizeMinX :
        position;
    
    translate([xAxisLength/2,0,0]) rotate([-90,0,90]) {
        vslot_rail(
                VSLOT_RAIL_2040_D, 
                xAxisLength, 
                pos = positionAdj+15, 
                mirror = true
            );
    }
}
