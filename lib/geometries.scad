include <NopSCADlib/utils/rounded_polygon.scad>


module triangle(size, h = 1, r = 0, center = false) {
    a = size[0];
    b = size[1];
    c = size[2];
    
    cosB = (pow(c, 2) + pow(a, 2) - pow(b, 2)) / (2*c*a);
    
    assert(cosB > -1, "angle can't be 0 or 180");
    assert(cosB < 1, "angle can't be 0 or 180");
    
    B = acos(cosB);
    
    Xa = 0;
    Ya = 0;

    Xb = c;
    Yb = 0;
    
    
    Yc = sin(B) * a;
    Xc = cos(B) * a;
    
    S = (a + b + c) / 2;
    A = sqrt(S*(S-a)*(S-b)*(S-c));
    H = 2 * A / c; 
        
    points = [
        [Xc, Yc, r],
        [Xb, Yb, r], 
        [Xa, Ya, r], 
    ];

    tangents = rounded_polygon_tangents(points);

    if(center) {
        translate([-c/2, -H/2, -h/2]) 
        if(h > 0) {
            linear_extrude(h) rounded_polygon(points,tangents);
        } else {
            rounded_polygon(points,tangents);
        }
    } else {
        if(h > 0) {
            linear_extrude(h) rounded_polygon(points,tangents);
        } else {
            rounded_polygon(points,tangents);
        }
    }
}