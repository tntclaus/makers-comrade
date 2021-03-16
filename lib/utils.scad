include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/utils/core/polyholes.scad>


function get_fn_for_stl(stl, fn) = stl ? fn : 45;     
function get_fn720(stl) = stl ? 720 : 45;
function get_fn360(stl) = stl ? 720 : 45;
function get_fn180(stl) = stl ? 720 : 45;    

module rotate_about_pt(x = 0, y = 0, z = 0, pt = [0,0,0]) {
    translate(pt)
        rotate([x, y, z]) // CHANGE HERE
            translate(-pt)
                children();   
}

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
                translate([vertex.x,vertex.y,plate_thickness/2]) {
                if(hullType == "circle")
                    drill(hole[0]/2 + extra_size, plate_thickness*2);
                else if(hullType == "square")
                    cube([hole[0], hole[0], plate_thickness*2], center = true);
                }
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



module tube_adapter(exit_depth, exit_width, height, wall, in_dia = 6, throat = false) {
    difference() {
        hull() {
            translate_z(wall)
            cube([exit_width+wall+0.5, exit_depth+wall+0.5, 1], center=true);
            translate_z(height)
            cylinder(d = in_dia+wall, h = 1, center = true);
        }
        hull() {
            translate_z(wall)
            cube([exit_width, exit_depth, 1], center=true);
            translate_z(height)
            cylinder(d = in_dia, h = 1, center = true);
        }
        translate_z(wall)
        cube([exit_width, exit_depth, 1.1], center=true);
        translate_z(height)
        cylinder(d = in_dia, h = 1, center = true);
    }

    if(throat) {
        translate_z(height + wall)
        difference() {
            cylinder(d = in_dia+wall, h = in_dia, center = true, $fn=get_fn_for_stl(stl,360));
            cylinder(d = in_dia, h = in_dia+1, center = true, $fn=get_fn_for_stl(stl,360));
        }
    }
}


module tube_adapter_square2square(in, out, height, wall, r = 1, stl = false) {
    difference() {
        hull() {            
            rounded_rectangle([in.x+wall, in.y+wall, 1], r, center=true);
            translate_z(height)
            rounded_rectangle([out.x+wall, out.y+wall, 1], r, center=true);
        }
        hull() {
            rounded_rectangle([in.x, in.y, 1], r, center=true);
            translate_z(height)
            rounded_rectangle([out.x, out.y, 1], r, center=true);
        }
    translate_z(height+out.z/2)
    rounded_rectangle(out, r, center=true);
//        translate_z(height)
//        cylinder(d = in_dia, h = 4, center = true);
    }
    difference() {
        translate_z(height+out.z/2)
        rounded_rectangle([out.x+wall, out.y+wall, out.z], r, center=true);

        translate_z(height+out.z/2)
        rounded_rectangle(out, r, center=true);
    }
    
    difference() {
        translate_z(-in.z/2)
        rounded_rectangle([in.x+wall, in.y+wall, in.z], r, center=true);

        translate_z(-in.z/2)
        rounded_rectangle(in, r, center=true);
    }
//    translate_z(height + in_dia/2+wall)
//    difference() {
//        cylinder(d = in_dia+wall, h = in_dia, center = true, $fn=get_fn_for_stl(stl,360));
//        cylinder(d = in_dia, h = in_dia+1, center = true, $fn=get_fn_for_stl(stl,360));
//    }
}