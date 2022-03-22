
//rotate ([0,0,180])
opto_endstop();


module opto_endstop(){
    rotate([90,0,90])
    translate([-32/2,0,-10.5/2])
    difference(){
        union(){
            // base PCB
            color("green") cube([33.0,1.6,10.5]);
            // add the switch module
            translate([8.4,1.6,10.5/2-6.4/2]) optoswitch();
            // connector
            translate([0.2,-7,0]) color("white") cube([5.8,7,10.5]);
            // led
            translate([3.5,1.6,10.5/2-1.5/2]) color("red") cube([2,0.7,1.5]);
        }
        translate([8.4,0,10.5/2-6.4/2]) {
            for ( hole = [2.75,24.5-2.75] ){
            rotate([90,0,0]) translate([hole,6.4/2,-4]) cylinder(r=1.5, h=4.5,$fn=40);
            }
        }
    }
}

// switch module
module optoswitch() {
    difference(){
        union (){
            color("gray") cube([24.5,3.5,6.4]);
            color("gray")translate([6.63,0,0]) cube([4.45,11.3,6.3]);
            color("gray")translate([13.63,0,0]) cube([4.45,11.3,6.3]);
        }
        opto_endstop_place_mounts()
        cylinder(r=1.5, h=4.5,$fn=40);
    }
}

module opto_endstop_place_mounts() {
    for ( hole = [2.75,24.5-2.75] ){
        rotate([90,0,0]) translate([hole,6.4/2,-4]) children();
    }
}
