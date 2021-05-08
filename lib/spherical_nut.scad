include <NopSCADlib/utils/core/core.scad>

function DIN_1587_D(type) = type[0];
function DIN_1587_Dk(type) = type[1];
function DIN_1587_M(type) = type[2];
function DIN_1587_E(type) = type[3];
function DIN_1587_T(type) = type[4];
function DIN_1587_W(type) = type[5];
function DIN_1587_H(type) = type[6];
function DIN_1587_R(type) = type[7];

module spherical_nut_DIN_1587(type) {
    color("silver") difference() {
        union() {
            cylinder(d=DIN_1587_E(type), DIN_1587_M(type), $fn = 6);
            
            cylinder(d=DIN_1587_Dk(type), DIN_1587_T(type));

            difference() {
                translate_z(DIN_1587_T(type))
                sphere(r = DIN_1587_R(type));
                cylinder(r=DIN_1587_R(type), DIN_1587_T(type));
            }
        }
        translate_z(-.1)
        cylinder(d = DIN_1587_D(type), h = DIN_1587_T(type));
    }
    
}