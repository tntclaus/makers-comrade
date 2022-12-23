use <vwheel_plate.scad>
use <vwheel_assembly.scad>

/**
 * First object should be 2D, will be subtracted from plate sketch. Pass `let()`
 * if there is nothing to subtract. Don't pass 3D objects as first child.
 */
module vwheel_gantry(type, center = false, mirror = false, mirror_plate = [0,0,0]) {
    plate = type[1];
    wheels = type[2];

    holes = plate[3];

//    double = wheels[0][5];
    plate_thickness = plate[2];

    zTranslation = center ? 29/2 : 0;
    mirror(mirror_plate) {
        rotate([90,0,90])
        translate([0,0,zTranslation]) {
            vslot_plate(plate) {
                children(0);
                if($children > 1)
                    children([1:$children-1]);
            }

            for (i=[0:len(holes)-1]){
                translate([holes[i][2],holes[i][3],-plate_thickness])
                if(holes[i][1]==0) {
                    mirror([0,0,1])
                    vwheel_assembly(wheels[i]);
                }
            }

//            if(double) {
//                translate([0,0,21.8]) rotate([180,0,0])
//                if(mirror) {
//                    vslot_plate(plate) {
//                        children(0);
//                        if($children > 1)
//                            children([1:$children-1]);
//                    }
//                } else {
//                    vslot_plate(plate);
//                }
//            }
        }
    }
}
