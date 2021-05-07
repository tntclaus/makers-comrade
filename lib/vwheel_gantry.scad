use <vwheel_plate.scad>
use <vwheel_assembly.scad>


module vwheel_gantry(type, center = false, mirror = false, mirror_plate = [0,0,0]) {
    plate = type[1];
    wheels = type[2];

    holes = plate[3];
    
    double = wheels[0][5];
    
    
    zTranslation = center ? -23/2 : 0;
    mirror(mirror_plate) {
        rotate([90,0,90])
        translate([0,0,zTranslation]) {
            vslot_plate(plate) { children(); }
            
            for (i=[0:len(holes)-1]){
                translate([holes[i][2],holes[i][3],0])
                if(holes[i][1]==0) {
                    vwheel_assembly(wheels[i]);
                } 
            }
            
            if(double) {
                translate([0,0,21.8]) rotate([180,0,0])
                if(mirror) {
                    vslot_plate(plate) {children();}
                } else {
                    vslot_plate(plate);
                }
            }
        }
    }
}