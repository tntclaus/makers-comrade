//EXEMPLE use wheel("shape(mini,V,double","bearing(y,n)",shim lenght);
// //mini V wheel without bearing
//wheel("mini","y",5); //mini V wheel with bearing and 5mm shim
//wheel("V","n",0); //V wheel without bearing
//wheel("V","y",10); //V wheel with bearing and 10mm shim
//wheel("double","n",0); //double V wheel without bearing
//wheel("double","y",15); //double V wheel with bearing and 15mm shim


$fn=60;

module mini_V_wheel() {
    difference() {
        hull() {
            cylinder(d=12.21,h=8.8,center=true);
            cylinder(d=15.23,h=5.78,center=true);
        }
        cylinder(d=8.63,h=9,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=10,h=5);
    }
}

module V_wheel() {
    difference() {
        hull() {
            cylinder(d=19.6,h=10.2,center=true);
            cylinder(d=23.9,h=5.9,center=true);
        }
        cylinder(d=14,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=16,h=5);
    }
}

module double_V_wheel() {
    difference() {
        union() {
            for(i=[-1,1]) translate([0,0,i*2.695]) hull() {
                cylinder(d=19.61,h=4.84,center=true);
                cylinder(d=23.9,h=0.55,center=true);
            }
            cylinder(d=18.75,h=4.84,center=true);
        }
        cylinder(d=14,h=11,center=true);
        for(i=[0.5,-5.5]) translate([0,0,i]) cylinder(d=16,h=5);
    }  
} 

module wheel(shape,bearing,c) {
    if (shape=="mini") {mini_V_wheel();}
    else if (shape=="double") {double_V_wheel();}
    else {V_wheel();}
    
    if (shape=="mini" && bearing=="y") {
        for(i=[0,180]) rotate([i,0,0]) difference() {
            union() {
                translate([0,0,0.35]) cylinder(d=10,h=4);
                translate([0,0,0.35+4+0.1]) cylinder(d=8,h=c);
            }
            cylinder(d=5,h=10+2*c,center=true);
        }
        
    }
    else if (bearing=="y") {
        color("gray")
        for(i=[0,180]) rotate([i,0,0]) difference() {
            union() {
                translate([0,0,0.35]) cylinder(d=16,h=5);
                translate([0,0,0.35+5+0.1]) cylinder(d=8,h=c);
            }
            cylinder(d=5,h=11+2*c,center=true);
        }
    }
    else {}
}

wheel(bearing = "y");
