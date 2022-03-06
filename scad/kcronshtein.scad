include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/rounded_polygon.scad>

//формулы для гибки
//https://www.dreambird.ru/articles/2018/calculating-unfolded-part-radbend/

function K(r, s) = log(r / s) * 0.5 + 0.65;

function BA_lte90(a, r, s) = PI * (180 - a) / 180 * (r + s * K(r, s) / 2) - 2 * (r + s);
function BA_gt90_lte165(a, r, s) = PI * (180 - a) / 180 * (r + s * K(r, s) / 2) - 2 * (r + s) * tan((180 - a) / 2);

function BA(a, r, s) = a <= 90 ? BA_lte90(a, r, s) : BA_gt90_lte165(a, r, s);

//echo("K=", K(1, 3));
//echo("BA=", BA(60, 6, 4));
//echo("BA=", BA(90, 3, 3));

//расчёт гибки
//http://www.cb-online.ru/spravochniky-online/stampovka-spravochnik/holodnayia-shtampovka/гибка/расчет-заготовок/

MATERIAL_THICKNESS = 1.5;

L1 = 300; //mm
L2 = 300; //mm
R = 3; //mm
BENDING_ANGLE = 90; //º
L_r = BA(BENDING_ANGLE, R, MATERIAL_THICKNESS);

L = L1 + L2 + L_r;

KRONST_W = 40;
UKOSINA_W = 40;
UKOSINA_Wi = UKOSINA_W - 4;
UKOSINA_OFFSET = 20;

echo(L_r);
echo(L);
echo(L / 2);
echo(L_r / 2 + L1);

module kronstein_latch_sketch() {
    translate([L1/3/2, 0])
    rounded_square([L1/3, KRONST_W], r = 3, center = true);
    rounded_square([KRONST_W, KRONST_W/2], r = 3, center = true);
}

module kronstein_base_sketch() {
    module triangle_mark() {
        translate([0, - KRONST_W / 2 + 1])
            rounded_polygon([[0, 0, 0.5], [1, - 3, 1], [- 1, - 3, 1]]);
    }

    difference() {
        translate([L1/2-L2/2,0])
        rounded_square([L, KRONST_W], r = 3, center = true);
        translate([- (L_r / 2 + L2 - UKOSINA_OFFSET - UKOSINA_W / 2), 0])
            square([UKOSINA_Wi, 3], center = true);
        translate([L_r / 2 + L1 - UKOSINA_OFFSET - UKOSINA_W / 2, 0])
            square([UKOSINA_Wi, 3], center = true);

        mirror([0, 1, 0])
            triangle_mark();

        triangle_mark();

        translate([L1/4,0,0]) circle(d = 6.1);
        translate([L1/2,0,0]) circle(d = 6.1);

        translate([-L2/2,0,0]) circle(d = 4.1);

        translate([-(L2 - MATERIAL_THICKNESS*2.5),0,0]) square([MATERIAL_THICKNESS, KRONST_W/2], center = true);
    }
}

module ukos_sketch() {
    u_wi = UKOSINA_W;
    u_w = u_wi * cos(45);

    L_b = sqrt(pow(L1 - UKOSINA_OFFSET - MATERIAL_THICKNESS, 2) + pow(L2 - UKOSINA_OFFSET - MATERIAL_THICKNESS, 2));
    L_s = sqrt(pow(L1 - u_wi - UKOSINA_OFFSET - MATERIAL_THICKNESS, 2) + pow(L2 - u_wi - UKOSINA_OFFSET -
        MATERIAL_THICKNESS, 2));

    //    L_u = sqrt(pow(L1-UKOSINA_Wi/2-UKOSINA_OFFSET,2) + pow(L2-UKOSINA_Wi/2-UKOSINA_OFFSET,2));
    th = MATERIAL_THICKNESS / 2 * cos(45);
    off = 2.25 * cos(45);

    difference() {
        polygon([
                [L_b / 2, u_w / 2],
                [L_b / 2 - off, u_w / 2 - off],
                [L_b / 2 - off + th, u_w / 2 - off - th],

                [L_s / 2 + off + th, - u_w / 2 - th + off],
                [L_s / 2 + off, - u_w / 2 + off],
                [L_s / 2, - u_w / 2],

                [- L_s / 2, - u_w / 2],
                [- (L_s / 2 + off), - u_w / 2 + off],
                [- (L_s / 2 + off + th), - u_w / 2 - th + off],

                [- (L_b / 2 - off + th), u_w / 2 - off - th],
                [- (L_b / 2 - off), u_w / 2 - off],
                [- L_b / 2, u_w / 2],
            ]);
    }
}


module kron_base() {
    //    translate_z(- MATERIAL_THICKNESS)
    linear_extrude(MATERIAL_THICKNESS, convexity = 4) {
        translate([- L_r / 2, 0])
            difference() {
                kronstein_base_sketch();
                translate([- (L2 / 2 - L_r / 2), 0])
                    square([L2, KRONST_W * 2], center = true);
            }
    }

    rotate([0, 90]) {
        //        translate_z(- MATERIAL_THICKNESS)
        linear_extrude(MATERIAL_THICKNESS, convexity = 4) {
            translate([L_r / 2, 0])
                difference() {
                    kronstein_base_sketch();

                    translate([L1 / 2 - L_r / 2, 0])
                        square([L1, KRONST_W * 2], center = true);

                }

        }
    }
}


module cronshtein() {
    kron_base();

    color("red", 0.5)
        translate([(L1 - UKOSINA_OFFSET - UKOSINA_W / 2) / 2 + MATERIAL_THICKNESS / 2, 0, (L2 - UKOSINA_OFFSET - UKOSINA_W /
            2) / 2 + MATERIAL_THICKNESS / 2])
            rotate([90, 45, 0])
                translate_z(- MATERIAL_THICKNESS / 2)
                linear_extrude(MATERIAL_THICKNESS, convexity = 4) {
                    ukos_sketch();
                }

    translate([0,0,L2-MATERIAL_THICKNESS*1.5])
    rotate([0,180,0])
    translate_z(-MATERIAL_THICKNESS/2)
    linear_extrude(MATERIAL_THICKNESS)
        kronstein_latch_sketch();
}

//cronshtein();


//ukos_sketch();
//kronstein_base_sketch();
//kronstein_latch_sketch();
