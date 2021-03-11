include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/utils/core/polyholes.scad>


module drillHoles(holes, plate_thickness, extra_size = 0) {    
    module drillHole(hole) {
                translate([hole[2],hole[3],0])
        color("red")
        if(hole[1]==0) {
            drill(
                hole[0]/2 + extra_size,
                plate_thickness*2
            );
            if(plate_thickness > 3) {
                translate([0,0,-3])
                drill(
                    hole[0]/2+3 + extra_size,
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
                    drill(hole[0]/2 + extra_size, plate_thickness*2);
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

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 