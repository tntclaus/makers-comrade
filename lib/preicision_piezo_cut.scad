module precision_piezon_mount_holes() {
    mounts = [
        [-13.68, 11.54, 0],
        [14.18, 11.54, 0],
        [-13.68, -10.47, 0],
        [14.18, -10.47, 0],
    ];
    for(e = mounts) {
        translate(e)
            children();
    }
}

color("red")
translate([0,0,20])
precision_piezon_mount_holes() 
    cylinder(d = 3.7, h = 20, $fn=20);


translate([-40,14.5,20])
render()
difference() {
    translate([-39,135,0])
    import("/Users/klaus/Downloads/Piezo_20_V1.12_Groovemount_.stl");

color("blue")
cube([40,100,40], center = true);

translate([0,-50,0])
color("blue")
cube([120,40,40], center = true);
}


//color("green")
//translate([0,0,20])
//rotate([0,180,0])
//render()
//translate([-40.05,89.2,0])
//difference() {
//    translate([-39,95,0])
//    import("/Users/klaus/Downloads/Piezo_20_V1.12_Groovemount_.stl");
//color("blue")
//translate([0,-80,0])
//cube([40,100,40], center = true);
//
//translate([0,-50,0])
//color("blue")
//cube([120,40,40], center = true);
//
//}

//color("red")
//translate([40.5,8.5,6.5])
//render()
//difference() {
//    translate([-79,150,0])
//    import("/Users/klaus/Downloads/Piezo_20_V1.12_Groovemount_.stl");
//color("blue")
//cube([40,100,40], center = true);
//
//translate([0,-50,0])
//color("blue")
//cube([120,40,40], center = true);
//}
//
//
//
//color("teal")
//translate([39,33.5,6.5]) 
//render()
//difference() {
//    translate([-79,150,0])
//    import("/Users/klaus/Downloads/Piezo_20_V1.12_Groovemount_.stl");
//color("blue")
//cube([40,100,40], center = true);
//
//translate([0,-6,0])
//color("blue")
//cube([120,40,40], center = true);
//
//
//}