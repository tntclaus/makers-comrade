module rotate_about_pt(x = 0, y = 0, z = 0, pt = [0,0,0]) {
    translate(pt)
        rotate([x, y, z]) // CHANGE HERE
            translate(-pt)
                children();   
}