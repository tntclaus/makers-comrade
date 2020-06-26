//EXEMPLE use wheel("shape(mini,V,double","bearing(y,n)",shim lenght);
// //mini V wheel without bearing
//wheel("mini","y",5); //mini V wheel with bearing and 5mm shim
//wheel("V","n",0); //V wheel without bearing
//wheel("V","y",10); //V wheel with bearing and 10mm shim
//wheel("double","n",0); //double V wheel without bearing
//wheel("double","y",15); //double V wheel with bearing and 15mm shim

include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>

use <v-wheels.scad>


//https://openbuildspartstore.com/openrail-gantry-plate/
//Version - V1
//Size: 20mm, 40mm, 60mm and 80mm sizes to accommodate OpenRail mounted to corresponding sized extrusions.
//20 - 80x80mm - 3.2mm Thick
//40 - 100x120mm - 3.2mm Thick
//60 - 120x140mm - 3.2mm Thick
//80 - 140x160mm - 3.2mm Thick
//Material: 6061 - T6 Aluminum
//Finish: Anodized Aluminum
//Color: Black

function bb_name(type)     = type[0]; //! Part code without shield type suffix
function bb_size(type)     = type[1]; //! Size: 20, 40, 60, 80
function bb_thickness(type)    = type[2]; //! Thick
function bb_material(type) = type[3]; //! Material: "aluminium", "plastic"
function bb_color(type)   = type[4]; //! Shield colour, "silver" for metal

function defined(a) = a != undef; 


function plateBySize(size) = 
      size == 20
    ? 1 
    : size == 20.1
    ? 7 
    : size == 40
    ? 4
    : size == 60
    ? 5
    : size == 80
    ? 6 
    : 2;
        

delta=0.01;
tolerance = 0.2;

G_PLATE_20_PRINTED = ["VSlot Gantry Plate - 20mm 65x65", 20, 6, "plastic", "green"];
G_PLATE_20_METAL = ["VSlot Gantry Plate - 20mm 65x65", 20, 3, "aluminium", "silver"];

gantry_cart_20_3(G_PLATE_20_PRINTED);

module gantry_cart_20_4(plate) {
    gantry_plate(plate,center = false);
    
    translate([20,20,0]) {
        wheel_and_spacer(6.35);
    }
    
    translate([20,-20,0]) {
        wheel_and_spacer(6.35);
    }
    
    translate([-20,20,0]) {
        wheel_and_spacer(6.35, eccentric= false);
    }
    
    translate([-20,-20,0]) {
        wheel_and_spacer(6.35, eccentric= false);
    }
}

module gantry_cart_20_3(plate) {
    gantry_plate(plate,center = false);
    
    translate([20,0,0]) {
        wheel_and_spacer(6.35);
    }
    
    translate([-20,20,0]) {
        wheel_and_spacer(6.35, eccentric= false);
    }
    
    translate([-20,-20,0]) {
        wheel_and_spacer(6.35, eccentric= false);
    }
}

module gantry_plate(type, center=true) {
    if(bb_material(type) == "plastic") {
        stl(bb_name(type));
        
        color(bb_color(type))
            plate(plateBySize(bb_size(type)), bb_thickness(type), center=center);
    } else {
        vitamin(str(
            bb_name(type)
        ));
        color("silver")
            plate(plateBySize(bb_size(type)), center=center);
    }
    
}

module wheel_and_spacer(h = 6.35, eccentric = true) {
    if(eccentric) {
        eccentric_spacer(h);
    } else {
        spacer(h);
    }

    shift = eccentric ? [0.5,1,h + 10.2/2] : [0,0,h + 10.2/2];
           
    translate(shift){
        wheel();
        rotate([0,180,0])
        translate([0,0,17.6])
        screw(M5_hex_screw, 30);
        translate([0,0,h-1])
            nut(M5_nut);
    }
}

module gantry_cart_spacer_6_35_stl() spacer();

module spacer(h = 6.35) {
    hstr = h == 6.35 ? "6_35" : str(h);
    stl(str("gantry_cart_spacer_", hstr));
    translate([0,0,h])
    rotate([0,180,0])
    difference() {
            cylinder(h, d = 10);
            translate([0,0,-0.1])
            cylinder(h+0.2, d = 5);
    }    
}


module eccentric_spacer(h = 6.35) {
    vitamin(str(
        "Openbuilds Eccentric Spacer (h=", h, "mm)"
    ));
    translate([0,0,h])
    rotate([0,180,0])
    difference() {
            union() {
                color("red")
                cylinder(h, d = 10, $fn=6);
                cylinder(h+2.5, d = 7.12);
            }
            translate([0,1,-0.1])
            cylinder(h+3, d = 5);
    }
}


module oval_hole(length,diameter, height){
    translate([-length/2,-diameter/2,0])
    cube([length,diameter,height]);
    
    translate([length/2,0,0])
    cylinder(h=height, d=diameter);
    
    translate([-length/2,0,0])
    cylinder(h=height, d=diameter);    
}

module plate (plate_type, thickness, center = true){
    plate = plate_spec[plate_type];
    echo(plate[2]);
//    plate[2] = 20;
    plate_thickness = defined(thickness) ? thickness : plate[2]; 
    
    shift = center ? -plate_thickness/2 : -plate_thickness;
    
    translate([0,0,shift])
        difference(){
            //The plate
            translate([-(plate[0]-plate[3])/2,-(plate[1]-plate[3])/2,0])
            minkowski(){
                cube([plate[0]-plate[3],plate[1]-plate[3],plate_thickness/2]);
                cylinder(h=plate_thickness/2, d=plate[3]);
            }
            
            //The holes
            for (i=[4:len(plate)-1]){
                translate([plate[i][2],plate[i][3],-delta])
                oval_hole(
                    height=plate_thickness+2*delta,
                    diameter=plate[i][0],
                    length=plate[i][1]
                );
            }
        }
}
plate_spec = [
["width","Depth","Thickness","Corner Radius",
    ["Hole Diameter","Hole Length (0 for circle)","X translation","Y translation"]
],

//20mm Gantry Plate
[65.5,65.5,3,3.36,
    [3,6.5,-20.146,27.7],[3,6.5,0,27.7],[3,6.5,20.146,27.7],
    [5,0,-19.85,20],[5,20.64,0,20],[7.2,0,19.85,20],
    [5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],
    [5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],
    [5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],
    [5,0,-19.85,-20],[5,20.64,0,-20],[7.2,0,19.85,-20],
    [3,6.5,-20.146,-27.7],[3,6.5,0,-27.7],[3,6.5,20.146,-27.7]
],

//Universal Gantry Plate
[127,88,3,3.36,
    [3,6.5,-20,38.02],[3,6.5,0,38.02],[3,6.5,20,38.02],
    [5,0,-49.85,30.32],[5,0,-39.85,30.32],[5,0,-29.85,30.32],[5,0,-19.85,30.32],[5,20,0,30.32],[7.2,0,19.85,30.32],[7.2,0,29.85,30.32],[7.2,0,39.85,30.32],[7.2,0,49.85,30.32],
    [5,0,-49.85,20.325],[5,0,-39.85,20.325],[5,0,-29.85,20.325],[5,0,-19.85,20.325],[5,0,-10,20.325],[5,0,0,20.325],[5,0,10,20.325],[5,0,19.85,20.325],[5,0,29.85,20.325],[5,0,39.85,20.325],[5,0,49.85,20.325],
    [5,0,-14.825,14.82],[5,0,14.825,14.82],
    [5,0,-29.85,10],[5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],[5,0,29.85,10],
    [5,0,-49.85,0],[5,0,-39.85,0],[5,0,-29.85,0],[5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],[7.2,0,29.85,0],[7.2,0,39.85,0],[7.2,0,49.85,0],
    [5,0,-29.85,-10],[5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],[5,0,29.85,-10],
    [5,0,-14.825,-14.82],[5,0,14.825,-14.82],
    [5,0,-49.85,-20.325],[5,0,-39.85,-20.325],[5,0,-29.85,-20.325],[5,0,-19.85,-20.325],[5,0,-10,-20.325],[5,0,0,-20.325],[5,0,10,-20.325],[5,0,19.85,-20.325],[5,0,29.85,-20.325],[5,0,39.85,-20.325],[5,0,49.85,-20.325],
    [5,0,-49.85,-30.32],[5,0,-39.85,-30.32],[5,0,-29.85,-30.32],[5,0,-19.85,-30.32],[5,20,0,-30.32],[7.2,0,19.85,-30.32],[7.2,0,29.85,-30.32],[7.2,0,39.85,-30.32],[7.2,0,49.85,-30.32],
    [3,6.5,-20,-38.02],[3,6.5,0,-38.02],[3,6.5,20,-38.02]
],

//OpenRail 20mm Gantry Plate
[80,80,3.175,10,
    [5,0,-22.3,22.3],[5,0,0,22.3],[7.137,0,22.3,22.3],
    [5,0,0,22.30],
    [5,0,0,10],
    [5,0,-22.3,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.137,0,22.3,0],
    [5,0,0,-10],
    [5,0,-22.3,-22.3],[5,0,0,-22.3],[7.137,0,22.3,-22.3]
],

//OpenRail 40mm Gantry Plate
[100,120,3.175,10,
    [5,0,-32.3,42.3],[5,0,-22.3,42.3],[5,0,-10,42.3],[5,0,0,42.3],[5,0,10,42.3],[7.137,0,22.3,42.3],[7.137,0,32.3,42.3],
    [5,0,-10,30],[5,0,10,30],
    [5,0,-10,20],[5,0,10,20],
    [5,0,-40,10],[5,0,-20,10],[5,0,0,10],[5,0,20,10],[5,0,40,10],
    [5,0,-32.3,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.137,0,32.3,0],
    [5,0,-40,-10],[5,0,-20,-10],[5,0,0,-10],[5,0,20,-10],[5,0,40,-10],
    [5,0,-10,-20],[5,0,10,-20],
    [5,0,-10,-30],[5,0,10,-30],
    [5,0,-32.3,-42.3],[5,0,-22.3,-42.3],[5,0,-10,-42.3],[5,0,0,-42.3],[5,0,10,-42.3],[7.137,0,22.3,-42.3],[7.137,0,32.3,-42.3]
],

//OpenRail 60mm Gantry Plate
[120,140,3.175,10,
    [5,0,-42.3,52.3],[5,0,-32.3,52.3],[5,0,-22.3,52.3],[5,0,-10,52.3],[5,0,0,52.3],[5,0,10,52.3],[7.137,0,22.3,52.3],[7.137,0,32.3,52.3],[7.137,0,42.3,52.3],
    [5,0,-20,30],[5,0,0,30],[5,0,20,30],
    [5,0,-42.3,26.3],[7.137,0,42.3,26.3],
    [5,0,-30,20],[5,0,0,20],[5,0,30,20],
    [5,0,-45,10],[5,0,0,10],[5,0,45,10],
    [5,0,-42.30,0],[5,0,-30,0],[5,0,-20,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[5,0,20,0],[5,0,30,0],[7.137,0,42.30,0],
    [5,0,-45,-10],[5,0,0,-10],[5,0,45,-10],
    [5,0,-30,-20],[5,0,0,-20],[5,0,30,-20],
    [5,0,-42.3,-26.3],[7.137,0,42.3,-26.3],
    [5,0,-20,-30],[5,0,0,-30],[5,0,20,-30],
    [5,0,-42.3,-52.3],[5,0,-32.3,-52.3],[5,0,-22.3,-52.3],[5,0,-10,-52.3],[5,0,0,-52.3],[5,0,10,-52.3],[7.137,0,22.3,-52.3],[7.137,0,32.3,-52.3],[7.137,0,42.3,-52.3]
],

//OpenRail 80mm Gantry Plate
[140,160,3.175,10,
    [5,0,-52.3,62.3],[5,0,-42.3,62.3],[5,0,-32.3,62.3],[5,0,-22.3,62.3],[5,0,-10,62.3],[5,0,0,62.3],[5,0,10,62.3],[7.137,0,22.3,62.3],[7.137,0,32.3,62.3],[7.137,0,42.3,62.3],[7.137,0,52.3,62.3],
    [5,0,-30,40],[5,0,-20,40],[5,0,20,40],[5,0,30,40],
    [5,0,-52.3,35],[7.137,0,52.3,35],
    [5,0,-40,30],[5,0,0,30],[5,0,40,30],
    [5,0,-55,10],[5,0,-40,10],[5,0,0,10],[5,0,40,10],[5,0,55,10],
    [5,0,-52.3,0],[5,0,-30,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[5,0,30,0],[5,0,52.3,0],
    [5,0,-55,-10],[5,0,-40,-10],[5,0,0,-10],[5,0,40,-10],[5,0,55,-10],
    [5,0,-40,-30],[5,0,0,-30],[5,0,40,-30],
    [5,0,-52.3,-35],[7.137,0,52.3,-35],
    [5,0,-30,-40],[5,0,-20,-40],[5,0,20,-40],[5,0,30,-40],
    [5,0,-52.3,-62.3],[5,0,-42.3,-62.3],[5,0,-32.3,-62.3],[5,0,-22.3,-62.3],[5,0,-10,-62.3],[5,0,0,-62.3],[5,0,10,-62.3],[7.137,0,22.3,-62.3],[7.137,0,32.3,-62.3],[7.137,0,42.3,-62.3],[7.137,0,52.3,-62.3]
],


//20mm Gantry Plate
[65.5,65.5,3,3.36,
    [3,6.5,-20.146,27.7],[3,6.5,0,27.7],[3,6.5,20.146,27.7],
    [5,0,-19.85,20],[5,20.64,0,20],[7.2,0,19.85,20],
    [5,0,-19.85,10],[5,0,0,10],[5,0,19.85,10],
    [5,0,-19.85,0],[5,0,-10,0],[5,0,0,0],[5,0,10,0],[7.2,0,19.85,0],
    [5,0,-19.85,-10],[5,0,0,-10],[5,0,19.85,-10],
    [5,0,-19.85,-20],[5,20.64,0,-20],[7.2,0,19.85,-20],
    [3,6.5,-20.146,-27.7],[3,6.5,0,-27.7],[3,6.5,20.146,-27.7]
],
];

