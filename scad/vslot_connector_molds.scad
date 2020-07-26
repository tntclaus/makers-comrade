include <../lib/vslot_connectors.scad>

hipoten = sqrt(20*20*2);
shift = -0;

count = 4;

rowLength = 22*(count);

moldWidth = hipoten+14;
moldLength = rowLength + 8;


spacing = 25;

translate([0,spacing,0]) capCase();
//translate([0,-spacing,0]) containerCase();

module halfSphere(d) {
    $fn = 70;
    difference() {
        sphere(d);
        translate([0,0,-d-1]) cube(d*2, center = true);
    }
}


module capCase() {


    translate([0,11.5, -1])  color("gray") cylinder(d = 5, h = 7, $fn=60);
    for(i=[0:1:count - 1]) {
        translate([22*i,11.5, -1])  color("gray") cylinder(d = 2, h = 7, $fn=60);
        translate([22*i,-11.5, -1])  color("gray") cylinder(d = 2, h = 7, $fn=60);       
    }

    
    x = rowLength;

    difference() {
        translate([x/2-22/2-0.5, -0.5,-7]) cube([moldLength,moldWidth,14], center = true);
        
        translate([22*0,0,0])  cap();
        translate([22*1,0,0])  cap();
        translate([22*2,0,0])  cap();        
        translate([22*3,0,0])  cap(true);
 
       for(i=[0:1:count - 1]) {
            translate([22*i,20-5/2,0]) rotate([180,0,0]) halfSphere(2.5);
            translate([22*i,-20+5/2,0]) rotate([180,0,0]) halfSphere(2.5);
        }
    }
 
    difference() {
        translate([x/2-22/2-0.5, -0.5,-4]) cube([moldLength,moldWidth,20], center = true);
        translate([x/2-22/2+0.5, 0.5,-7]) cube([moldLength,moldWidth,30], center = true);
    }
}

module cap(last = false) {
    rotate([-45,0,0]) {
        vslot_connector_angle(VCUBE_20, true);
        
        if(last == false)
            translate([11,0,0]) difference() {
                cube([2,20,20], center=true);
                translate([0,10,-10]) cube([5,5,5], center=true);
            }
    }
}


module containerCase() {
    x = rowLength;

    
    for(i=[0:1:count - 1])  {
        w = i == count-1 ? 20.675 : 22;
        translate([22*(i-1)+w+1,0,-14])  color("blue") container(w);
        
        translate([22*i,20-5/2,-14]) halfSphere(2.5);
        translate([22*i,-20+5/2,-14]) halfSphere(2.5);
    }
    
    difference() {
        translate([x/2-22/2-0.5, -0.5,-5]) cube([moldLength,moldWidth,20], center = true);
        translate([x/2-22/2+0.5, 0.5,-4]) cube([moldLength,moldWidth,20], center = true);
    }
}

module container(w = 20) {
    color("green") rotate([180,0,0]) difference() {
        translate([shift,-0,-7.5]) cube([w,hipoten+2,15], center=true);
        difference() {
            translate([shift,-0,-8]) cube([23,hipoten+3,16], center=true);
            rotate([45,0,0]) cube([w,20,20], center=true);
        }
    }
}