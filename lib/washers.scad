module high_precision_washer_8x5_dxf() {
    $fn = 180;
    high_precision_washer_sketch(8,5.01);
}

module high_precision_washer_sketch(d_outer, d_inner) {
    difference() {
        circle(d = d_outer);
        circle(d = d_inner);
    }
}

//high_precision_washer_8x5_dxf();