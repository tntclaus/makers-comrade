
VCUBE_2020_A168 = [20,20];
VCUBE_20 = VCUBE_2020_A168;

use <vslot_connector_cube.scad>
use <vslot_connector_angle.scad>


// при печати из abs вес будет 5,5 грамм у одного кубика
module vslot_cube20_stl() vslot_connector_cube(VCUBE_20);

// при печати из abs вес будет 3,5 грамма у одного угла
module vslot_angle20_stl() vslot_connector_angle(VCUBE_20);

//vslot_connector_cube(VCUBE_20);
//vslot_connector_angle(VCUBE_20);