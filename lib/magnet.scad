include <NopSCADlib/core.scad>

module magnet_round_with_cone_hole(
    d,
    h,
    dia_inner1,
    dia_inner2
) {
    // https://mirmagnitov.ru/product/nyeodimovyy-magnit-disk-10kh3-mm-s-zyenkovkoy-3-5-7-mm-n35uh/
    vitamin(str(
    "Magnet N35UH", "_",
    "D", d, "xH", h, "_",
    "Di1_",dia_inner1,"xDi2_",dia_inner2
    ));

    color("#3c4422")
    render()
    difference() {
        cylinder(d = d, h = h);
        translate_z(-.005)
        cylinder(d1 = dia_inner2, d2 = dia_inner1, h = h+.01);
    }
}

module magnet_square(
    width,
    length,
    heigth
) {
    vitamin(str(
    "Magnet", "_",
    width, "x",
    length, "x",
    heigth
    ));

    translate_z(heigth/2)
    cube([width, length, heigth], center = true);
}
