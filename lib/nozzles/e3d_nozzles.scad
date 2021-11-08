module e3d_nozzle_v6() {
    color("gold")
    translate([0,0,-1.5])
    rotate([0,0,-90])
    rotate([90,0,0])
        import("v6_nozzle_2.stl");
}


e3d_nozzle_v6();
