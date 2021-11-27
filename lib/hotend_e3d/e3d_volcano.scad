include <NopSCADlib/core.scad>


// Hot end descriptions
//
//                        s       p                    l    i    d      i l  c           s g    g     d   d              d a   d a
//                        t       a                    e    n    i      n e  o           c r    r     u   u              u t   u t
//                        y       r                    n    s    a      s n  l           r o    o     c   c              c     c
//                        l       t                    g    e           u g  o           e o    o     t   t              t n   t f
//                        e                            t    t           l t  u           w v    v                          o     a
//                                                     h                a h  r             e    e     r   o              h z   h n
//                                                                      t                p            a   f              e z   e
//                                                                      o                i d    w     d   f              i l   i
//                                                                      r                t i    i     i   s              g e   g
//                                                                                       c a    d     u   e              h     h
//                                                                                       h      t     s   t              t     t
//                                                                                              h
//
E3DVulcano= ["E3D Volcano", e3d, "E3D Volcano direct",  62,  3.7, 16,  42.7, "silver",   12,    6,    15, [1, 5,  -4.5], 14,   21];

include <NopSCADlib/vitamins/hot_end.scad>
use <heatbreak.scad>

module e3d_volcano_heater_block(type, naked = false, resistor_wire_rotate = [0,0,0]) {
    nozzle_h = 5;

    heater_width  = 5.75*2;
    heater_length = 21.2;
    heater_height = 20;

    heater_x = -15.5 + heater_length;
    heater_y = heater_width / 2;

    translate_z(-hot_end_length(type))  {
        translate_z(nozzle_h)
        color("lightgrey")
            translate([-heater_x, -heater_y, -heater_height + 11.5])
                cube([heater_length, heater_width, heater_height]);

        translate([4,10.75,5])
            rotate([90,0,0])
                e3d_resistor(type, naked, resistor_wire_rotate);

        translate_z(-heater_height + 11.5)
        e3d_nozzle(type);
    }
}

module e3d_volcano_hotend_assembly() {
    type = E3DVulcano;

    e3d_v6_heatbreak(1.75);
    rotate([0,0,90])
    e3d_volcano_heater_block(type, naked = true);
}

//e3d_volcano_hotend_assembly();
