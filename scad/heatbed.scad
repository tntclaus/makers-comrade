include <NopSCADlib/utils/core/core.scad>


module heatBedHeater(width, depth, padding=14) {
    x=width;
    y=depth;

    st=15;				// step for wires

    wireMinSpacing = 1; 

    volt=48;
    power=volt * 30;

    iamp=power/volt;
    rohm=volt/iamp;



    p=0.017/1000;	//Copper resistance om*mm^2/mm
    h=0.035;			//Copper foil height

    l=(x/st)*(y/st)*st;


    //r=(p*l)/s;
    //s=(p*l)/r;

    s=(p*l)/rohm;

    w=s/h;

    $fn=16;

    //st=w + wireMinSpacing;

    assert(st > w, "Adjust step");
    assert(st - w > wireMinSpacing, "");

    seconds = 120;
    weight = 1000;
    heatCapacityAl = 0.900;
    heatCapacityH2O = 4.186;
    energy = power * seconds;

    temp = energy / weight / heatCapacityH2O;

//  todo: dxf, fix path
//
//    echo("Power ", power, "VA");
//    echo("Voltage ", volt, "V");
//    echo("Current ", iamp, "A");
//    echo("Resistance ", rohm, "ohm");
//    echo("Wire length ", l, "mm");
//    echo("Wire width ", w, "mm");
//    echo("Wire height ", h, "mm");
//    echo("Wire spacing ", st - w, "mm");
//    echo("Temp in ", seconds, "s = ", temp, "ºC");

    module line(le) {
        hull() {
            translate([-le/2,0,0]) circle(w/2);
            translate([le/2,0,0]) circle(w/2);
        } // hl
    }

    module hb() {
        translate([-x/2+st/2,0])
            for (i=[0:st:(x-st)])
                translate([i,0]) rotate([0,0,90]) line(y-st);

        translate([-x/2+st,0])
            for (i=[0:st*2:(x-st*2)])
                translate([i,y/2-st/2]) line(st);

        translate([-x/2+st,0])
            for (i=[0:st*2:(x-st*3)])
                translate([i+st,-y/2+st/2]) line(st);
    } 


    if($preview) {
        color("ForestGreen") translate([0,0,-1.5/2])
            cube([x + padding, y + padding, 1.5], center=true);
        
        color("orange")  linear_extrude(h)
            hb();
    } else {
            hb();
    }
}

module heatBedGlass(width, depth, thickness = 5) {
    vitamin(str("Glass/Mirror w=",width,", h=", depth));
    cube([width, depth, thickness], center=true);
}

module heatBed(width, depth, padding) {
    difference() {
        union() {
            heatBedHeater(width, depth, padding);
            translate([0,0,5/2]) color("SteelBlue", 0.5)
                heatBedGlass(width+padding, depth+padding);
            heatBedBottomPlate(width, depth, padding);
        }
        co = [[1,1],[-1,1], [-1,-1], [1,-1]];
        for(i= [0:3]) {
            holeX = width/2 + padding/4;
            holeY = depth/2 + padding/4;
            translate([co[i][0]*holeX, co[i][1]*holeY,0]) color("red")
                cylinder(d=5, h = padding, center=true);
        }

    }

}

module heatbed_bottom_plate_620x620_dxf() {
    width = 620;
    heigth = 620;
    offs = 20;
    stepY = (heigth-20) / 8;
    listY = [ for (i = [10 : stepY : heigth]) i ];
//    echo(listZ);
    stepX = (width-20) / 8;
    listX = [ for (i = [10 : stepX : width]) i ];
        
    function firstOrLast(cX, cY) = 
            cX == 10 ? true : 
            cX == width - 10 ? true :
            cY == 10 ? true :
            cY == heigth - 10 ? true :
            false;
    
    difference() {
        rounded_square([620, 620], r = 3, center=true);
        for(y = listY)
            for(x = listX)
                translate([x-width/2, y-heigth/2, 0]) 
                    if(firstOrLast(x, y))
                        circle(d = 5);        
                    else 
                        circle(d = 3);        
    }
}

module heatBedBottomPlate(width, depth, padding) {
    dxf(str("heatbed_bottom_plate_", width + padding,"x", depth + padding));
    translate_z(-4) render() linear_extrude(4) heatbed_bottom_plate_620x620_dxf();
}

//heatBedBottomPlate(500,500,10);
