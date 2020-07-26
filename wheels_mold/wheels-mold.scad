include <../lib/vwheels.scad>
use <NopSCADlib/utils/core/rounded_rectangle.scad>

// Объём 1 колеса ~ 1,5375 см3


bottomThickness = 2;


wheelDia = 28;
wheelHeigth = 10.2;
cubeH = wheelDia*2;
cubeW = wheelDia*4;



coords1 = [
    for(i=[0:1:3])
        [wheelDia/2, i == 1 ? wheelDia*i - 2 : i == 2? wheelDia*i + 2: wheelDia*i]
];
    
    
coords2 = [
    for(i=[0:1:3])
        [-wheelDia/2, i == 1 ? wheelDia*i - 2 : i == 2? wheelDia*i + 2: wheelDia*i]
];

latchR = 2;


translate([0,0,0]) difference() {
     diffCubeThick = wheelHeigth+1;
        translate([0,-wheelDia*2+wheelDia/2,0]) { 

            color("green") wheelArray();
            $fn =30;
            for (i=[0:1]) {

               translate(coords1[i])    
                    sphere(latchR);

               translate(coords2[i])    
                    sphere(latchR);
            }
    
        }
        translate([0,0,-diffCubeThick/2]) cube([cubeH+59,cubeW,diffCubeThick], center = true);
}
difference() {
    moldBox();
    translate([0,-wheelDia*2+wheelDia/2,0]) { 
                    $fn =30;
            for (i=[2:3]) {

               translate(coords1[i])    
                    sphere(latchR);

               translate(coords2[i])    
                    sphere(latchR);
            }
    }    
}

module moldBox() {
    $fn=60;

    latchX = cubeH-6;
    latchY = cubeW-6;
    wallHeigth = 12;
    
    
    difference() {
        translate([0.5,0,-bottomThickness/2]) 
            cube([cubeH+3,cubeW+3,bottomThickness], center = true);
        
        translate([latchX/2,-latchY/2]) sphere(latchR);
        translate([-latchX/2,latchY/2]) sphere(latchR);
    }
    translate([latchX/2,latchY/2]) sphere(latchR);
    translate([-latchX/2,-latchY/2]) sphere(latchR);
    
    translate([0.5,0,wallHeigth/2-bottomThickness/2]) difference() {
        cube([cubeH+3,cubeW+3,wallHeigth+bottomThickness], center = true);
        translate([-2,-2,0])
            cube([cubeH+4,cubeW+4,wheelHeigth+bottomThickness*2], center = true);
    }

}


module wheelArray() {
    wheelHeigth = 10.2;
    castingViaD = 2;
    

        
    module castingVia(vertical = true, heigth = 6, d = castingViaD) {
        $fn = 30;
        if(vertical) {
        rotate([90,90,90])
            cylinder(d = d, h = heigth, center = true);
        } else {
            translate([-wheelDia/2,wheelDia/2,0]) rotate([90,90,0])  
                cylinder(d = d, h = heigth, center = true);
        }
    }
    
    module pourHole() {
        translate([0,-wheelDia/2 + wheelDia*(len(coords1)/2), 0]) rotate([90,90,90])
            cylinder(d = castingViaD*2, h = wheelDia, center = true, $fn = 30);
        translate([wheelDia/1.5,-wheelDia/2 + wheelDia*(len(coords1)/2), 0]) rotate([90,90,-90]) {
            cylinder(d1 = 9, d2 = castingViaD*2, h = wheelDia/1.5, center = true, $fn = 30);
            translate([0, 0, -wheelDia/1.5/2-1])
            cylinder(d = 9, h = 2, center = true, $fn = 30);
        }
        
    }
    
    for (i=[0:3]) {
       translate(coords1[i])    
            V_wheel("blue");

       translate(coords2[i])    
            V_wheel("blue");
    }

    for (i=[0:3])
       translate([0,coords1[i][1],0])    
            castingVia(heigth = 8);
    
    for (i=[0:3])
       translate([wheelDia,coords1[i][1],0])    
            castingVia(heigth = 4);


    for (i=[0:2]) {
       if(i== 1) { 
           translate([0,coords1[i][1]+2,0]) castingVia(false, heigth = 10, d = castingViaD*1.5);
       } else { 
           translate([0,coords1[i][1],0]) castingVia(false);
       }
   }
    
    
    pourHole();
}