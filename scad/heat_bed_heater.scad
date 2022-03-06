include <NopSCADlib/utils/core/core.scad>

function heater_material_function_name(type) = type[0];
function heater_material_name(type) = type[1];

// g * cm^3
function heater_material_density(type) = type[2];

// micro ohm * mm^2 / meter
function heater_material_resistance(type, temperature = 100) = type[3][search(temperature, type[3])[0]][1];


COPPER =                   ["copper",           "Copper",           8.96, [[20, 0.017], [100, 0.018], [200, 0.020]]];
ALUMINIUM =                ["aluminium",        "Aluminium",        2.7 , [[20, 0.028], [100, 0.029], [200, 0.030]]];

// http://thermalinfo.ru/svojstva-materialov/metally-i-splavy/udelnoe-elektricheskoe-soprotivlenie-stali-pri-razlichnyh-temperaturah
STEEL_03X18H10 =           ["steel_08Х18Н10",   "Steel 08Х18Н10",   7.85, [[20, 0.800], [100, 0.846], [200, 0.910]]];
STEEL_AISI304 =            ["steel_aisi304",    "Steel AISI304",    7.85, [[20, 0.800], [100, 0.846], [200, 0.910]]];

// http://thermalinfo.ru/svojstva-materialov/metally-i-splavy/udelnoe-soprotivlenie-nihroma-plotnost-teploprovodnost-teploemkost
NICHROME_X20H80 =          ["nichrome_X20H80",  "Nichrome X20H80",  8.4 , [[20, 1.130], [100, 1.135], [200, 1.152]]];


module heat_bed_heater(type, dimensions, spacing = 1.7, power = 500, volt=220) {
    x=dimensions.x;
    y=dimensions.y;

    st=spacing;				// step for wires

    wireMinSpacing = .1;

    iamp=power/volt;
    rohm=volt/iamp;



    p=heater_material_resistance(type)/1000; // Stainless ohm*mm^2/mm
//    h=0.572727;			//Copper foil height
    h=dimensions.z;

    l=(x/st)*(y/st)*st;


    //r=(p*l)/s;
    //s=(p*l)/r;

    s=(p*l)/rohm;

    w=s/h;

    $fn=16;

    //st=w + wireMinSpacing;
    echo("P ", p, "micro ohm / mm");
    echo("Power ", power, "VA");
    echo("Voltage ", volt, "V");
    echo("Current ", iamp, "A");
    echo("Resistance ", rohm, "ohm");
    echo("Wire S ", s, "mm2");
    echo("Wire length ", l, "mm");
    echo("Wire width ", w, "mm");
    echo("Wire height ", h, "mm");
    echo("Wire spacing ", st - w, "mm");


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
    echo(str("Temp in ", seconds, "s = ", temp, "ºC"));

    module line(le) {
        hull() {
//            translate([-le/2,0,0])  circle(w/2, $fn = 6);
//            translate([le/2,0,0]) circle(w/2, $fn = 6);
            translate([-le/2,0,0]) rotate([0,0,45]) square(w*cos(45), center = true);
            translate([ le/2,0,0]) rotate([0,0,45]) square(w*cos(45), center = true);
//            translate([le/2,0,0]) circle(w/2, $fn = 20);

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


//    color("orange")  linear_extrude(h)
    hb();

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
//heatBed(620,620,20);
//heatBedBottomPlate(500,500,10);



//heat_bed_heater(295, 295, spacing = 1.7, power = 500);
//heat_bed_heater(STEEL_03X18H10, [595, 595, 0.5], spacing = 10, power = 2000);


module heat_bed_heater_etching_template(thickness = 2) {

    linear_extrude(thickness)
        union() {
            difference() {
                rounded_square([298, 298], 5, center = true);
                square([286.3, 291], center = true);
            }
            heat_bed_heater(ALUMINIUM, [290, 290, 0.009], spacing = 2.65, power = 600);
        }

    module column() {
        translate_z(thickness + 1.5)
        cube([295, 3, 3], center = true);
    }

    module columns() {
        for (y = [- 285.6 / 2 : 47.59/2 : 287.4 / 2])
        translate([0, y, 0])
            column();
    }

    color("red")
        columns();
}

//heat_bed_heater_etching_template(1.2);
