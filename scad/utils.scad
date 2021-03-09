function get_fn_for_stl(stl, fn) = stl ? fn : 45;     
function get_fn720(stl) = stl ? 720 : 45;
function get_fn360(stl) = stl ? 720 : 45;
function get_fn180(stl) = stl ? 720 : 45;    

module rotate_about_pt(x = 0, y = 0, z = 0, pt = [0,0,0]) {
    translate(pt)
        rotate([x, y, z]) // CHANGE HERE
            translate(-pt)
                children();   
}