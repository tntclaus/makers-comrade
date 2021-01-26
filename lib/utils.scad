include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/utils/core/polyholes.scad>


module drillHoles(holes, plate_thickness) {    
    module drillHole(hole) {
                translate([hole[2],hole[3],0])
        color("red")
        if(hole[1]==0) {
            drill(
                hole[0]/2,
                plate_thickness*2
            );
            if(plate_thickness > 3) {
                translate([0,0,-3])
                drill(
                    hole[0]/2+3,
                    (plate_thickness)
                );
            }
        } else {
            echo("can't drill");
        }
    }
    
    module drillHull(hole) {
        hullType = hole[2][0];
        hullGeom = hole[2][1];
        color("green") hull() {
            for(vertex = hullGeom) {
                translate([vertex.x,vertex.y,0])
                    drill(hole[0]/2, plate_thickness*2);
            }
        }
    }
    
    
    
    for (hole = holes){
        if(Len(hole) == 4) {
            drillHole(hole);
        } else if(Len(hole) == 3) {
            drillHull(hole);
        }
        
    }
}