include <NopSCADlib/utils/core/core.scad>



sidePlateColor = "green";
sidePlateOpacity = 0.5;
module bottom_plate(
        width, 
        heigth, 
        thickness = 3,
        elevation = 0) {
    dxf(str("bottom_plate_",width,"x", heigth, "x", thickness));
    
    module cut_angles() {
       t = thickness + 1; 
        union() {
        translate([0,0,-t/2]) square(21);
        translate([20,0,-t/2]) square(20);
        translate([0,20, -t/2]) square(20)        ;
        }
    }
    
    module diff_plate() {
        render(convexity = 2) difference() {
            t = 1;
            translate([0,0,elevation]) {
                    difference() {
                square([width, heigth], center=true);
                translate([width/2, heigth/2,0]) 
                    mirror([1,1,0]) cut_angles();
                translate([-width/2, -heigth/2,0]) 
                    mirror([0,0,0]) cut_angles();        
                translate([width/2, -heigth/2,0]) 
                    mirror([1,0,0]) cut_angles();        
                translate([-width/2, heigth/2,0]) 
                    mirror([0,1,0]) cut_angles();        
                    }
            }

            children();
        }
    }

    diff_plate() {projection() children();};
}

module m5_hole(d) {
    vitamin(str("M",d," Screw")); 
    vitamin(str("M",d," V-Slot Nut"));     
    circle(d = d);
}

module side_plate(
    width, 
    heigth,
    side
) {
    offs = 20+side;
    stepZ = (heigth-15) / 6;
    listZ = [ for (i = [5 : stepZ : heigth]) i ];
//    echo(listZ);
    stepX = (width-60) / 6;
    listX = [ for (i = [30 : stepX : width]) i ];
//    echo(listX);

    translate([-width/2,0,0]) difference() {
        square([width, heigth]);
        polygon([
            [20,0],
            [offs,side],
            [width-offs,side],
            [width-20, 0]
        ]);
        // left
        for(i = listZ)
            translate([10, i, 0]) m5_hole(d = 5);
        
//        translate([10, heigth-10, 0]) m5_hole(d = 5);
        
        // right
        for(i = listZ)
            translate([width-10, i, 0]) m5_hole(d = 5);
        
//        translate([width-10, heigth-10, 0]) m5_hole(d = 5);
        
        // top
        for(i = listX)
            translate([i, heigth-10, 0]) m5_hole(d = 5);
        
//        translate([width-25, heigth-10, 0]) m5_hole(d = 5);

        // bottom
        for(i = listX)
            translate([i, side+10, 0]) m5_hole(d = 5);
        
//        translate([width-25, side+10, 0]) m5_hole(d = 5);

    }    
}

module back_plate(
        width, 
        heigth,
        side,
        thickness = 3
) {
    dxf(str("back_plate_",width,"x", heigth, "x", thickness));
    side_plate(width,  heigth, side);
}

module front_plate(
        width, 
        heigth,
        side,
        thickness = 3
) {
    dxf(str("front_plate_",width,"x", heigth, "x", thickness));

    difference() {
                side_plate(width,  heigth, side);
                
                translate([0, (heigth-60)/2+side,0]) rounded_square([width-80,  heigth-side-80], 20);
            }
}


    
module window(heigth, side) {
        tongueOffset =  (heigth-side-80)/2;
    translate([0, (heigth-60)/2+side,0]) difference() {
        rounded_square([100,  heigth-side-80], 20);
        
        translate([0,tongueOffset,0]) rounded_square([20,  60], 5);
        translate([0,-tongueOffset,0]) rounded_square([20,  60], 5);
    }
    translate([0,heigth-60,0]) m5_hole(5);
    translate([0,side+35,0]) m5_hole(5);
    translate([0,side+60,0]) m5_hole(5);
}

module side_plate_r(
        width, 
        heigth,
        side,
        off,
        thickness = 3
) {
    dxf(str("side_plate_r_",width,"x", heigth, "x", thickness));
    
    difference() {
        side_plate(width,  heigth, side);
        translate([off,0,0])
            window(heigth, side);
        translate([-off,0,0])
            window(heigth, side);
    }

}
module side_plate_l(
        width, 
        heigth,
        side,
        thickness = 3
) {
    dxf(str("side_plate_l_",width,"x", heigth, "x", thickness));

     difference() {
                side_plate(width,  heigth, side);
                window(heigth, side);
            }
}