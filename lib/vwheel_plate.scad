include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/polyholes.scad>
include <geometries.scad>

module triangle_plate(geometry, center = false) {
    tri_geom = geometry[0];
    radius = geometry[1];
    plate_thickness = geometry[2];
    
    holes = geometry[3];
    zTranslate = center ? 0 : -plate_thickness/2;
    
    rotate([180,0,0])  translate([0,0,plate_thickness])  children();
    translate([0,0,zTranslate]) difference() {
        translate([5,0,0]) rotate([0,0,-90]) {
            triangle(tri_geom, r = radius, h = plate_thickness, center = true);

        }
        

        renderGantryHoles = true;

        if(renderGantryHoles) {
            for (i=[0:len(holes)-1]){
                translate([holes[i][2],holes[i][3],0])
                color("red")
                if(holes[i][1]==0) {
                    drill(
                        holes[i][0]/2,
                        plate_thickness*2
                    );
                    if(plate_thickness > 3) {
                        translate([0,0,-3])
                        drill(
                            holes[i][0]/2+3,
                            (plate_thickness)
                        );
                    }
                } else {
                    echo("can't drill");
                }
            }
        }
    }
}

