include <NopSCADlib/utils/core/core.scad>

include <../screw_assemblies.scad>
include <../../lib/leadscrew_couplers.scad>

include <../motors.scad>

module zAxisRails(
            position = 0, 
            mirrored = false, 
            diff = false) {
    
    if(!diff) {
        positionAdj = 
                position > workingSpaceSizeMaxZ 
                    ? workingSpaceSizeMaxZ : 
                    position < workingSpaceSizeMinZ ? workingSpaceSizeMinZ :
                    position;
        
        translate([0, -baseLength, 20]) rotate([0,0,-90])
            vslot_rail(
                VSLOT_RAIL_2020_S, 
                baseFrontSize, 
                pos = positionAdj, 
                mirror = true,
                angles = true
            )   {
                depth = 55;
                rotate([0,90,0]) translate([-depth/2,0,0]) {
                    difference() {
                        cube([depth,6,40], center=true);
                         translate([-15.5,0,0]) rotate([90,0,0]) 
                            cylinder(d = 5, h = 15, center = true, $fn=30); 
                    }
                }
            }
        if(mirrored)
            translate([0, 0, positionAdj-20]) printBed();
    }
    
    translate([0,0,-23]) zAxisMotor(diff = diff);
}

module zAxis(positionZ, diff = false) {
        zAxisRails(positionZ, mirrored = true, diff = diff);
        translate([-workingSpaceSize/2+20,0,0]) {
            mirror([0,1,0]) zAxisRails(positionZ, diff = diff);
            
        }
        translate([workingSpaceSize/2-20,0,0]) {
            mirror([0,1,0]) zAxisRails(positionZ, diff = diff);
        }

}