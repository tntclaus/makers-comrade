include <NopSCADlib/core.scad>

/**
* STL helper
*/
module cable_chain_section_body_and_cap(l, w, h) {
    $fn = 90;
    translate([0,0,h/2]) {
            translate([0, - l, -h+1.5])
            rotate([0, 0, 0])
                cable_chain_section_cap(l, w, h);

        cable_chain_section_body(l, w, h);
    }
}

module cable_chain_section(l, w, h, color = "yellow") {
    name = str("ABS_cable_chain_section_body_and_cap_",
    "l", l, "w", w, "h", h
    );
    stl(name);

    color("blue")
    render()
    cable_chain_section_cap(l, w, h);

    color(color)
    render()
    cable_chain_section_body(l, w, h);
}

module cable_chain_section_cap(l, w, h, expansion = 0) {
    translate([0,l/12,h/2-1/2-.25]) {
            cube([w-6, l / 3, 1.5+expansion], center = true);
            cube([w-3+expansion*10, l / 3 / 2, 1.5+expansion], center = true);
    }
}

module cable_chain_section_body(l, w, h) {
    module ear_mount() {
        translate_z(h/2)
        cube([3.2, h/2, h/2], center = true);
        translate_z(-h/2)
        cube([3.2, h/2, h/2], center = true);
        rotate([0, 90, 0])
            difference() {
                cylinder(d = h+.2, h = 3.2, center = true);
                cylinder(d = 3, h = 4, center = true);
            }
    }
    difference() {
        union() {
            hull() {
                cube([w, l, h], center = true);

                translate([0, l / 2, 0])
                    rotate([0, 90, 0])
                        cylinder(d = h, h = w, center = true);

                translate([0, - l / 2 + h / 4, 0])
                    rotate([0, 90, 0])
                        cylinder(d = h, h = w, center = true);
            }
            translate([0, -l / 2, 0])
            rotate([0, 90, 0])
            cylinder(d = 3, h = w+1, center = true);
        }

        translate([0, l / 2, 0])
            rotate([0, 90, 0])
                cylinder(d = 3.5, h = w*2, center = true);

//        translate([0, l / 3, 1])
//            cube([w - 4, l, h], center = true);


        translate([0, l * 0.8, 0])
            cube([w - 3.1, l, h*2], center = true);

        translate([0, 0, 2])
            cube([w - 6, l*2, h], center = true);

        translate([-w/2, -l / 2, 0])
            ear_mount();
        translate([w/2, -l / 2, 0])
            ear_mount();

        translate_z(-1.5)
        cable_chain_section_cap(l, w, h, expansion = 1);
    }


}
//XS2Qgv9h6NbKTq
//
//tls_ca_file: /etc/pki/cyrus-imapd/server.pem
//tls_cert_file: /etc/pki/cyrus-imapd/server.pem
//tls_key_file: /etc/pki/cyrus-imapd/server.pem
//
//# TLS parameters
//smtpd_tls_key_file = /etc/pki/cyrus-imapd/server.pem
//smtpd_tls_cert_file = /etc/pki/cyrus-imapd/server.pem
//smtpd_tls_CAfile = /etc/pki/cyrus-imapd/server.pem
//smtpd_use_tls=yes
//smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
//smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
//
//
//myhostname = mx.cityscreen.cloud
//alias_maps = hash:/etc/aliases
//alias_database = hash:/etc/aliases
//myorigin = /etc/mailname
//mydestination = cityscreen.cloud
//mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
//mailbox_size_limit = 0
//recipient_delimiter = +
//
//# These are the "no relay" restrictions
//smtpd_recipient_restrictions = permit_mynetworks permit_inet_interfaces permit_sasl_authenticated reject_unauth_destination
//


module cable_chain(type) {
    l = 20;
    w = 30;
    h = 14;

    module rotated_section(angle = 0, color = "yellow") {
        rotate([angle,0,0])
            translate([0, l/2,0])
            cable_chain_section(l = l, w = w, h = h, color = color);

        rotate([angle,0,0])
        translate([0,l,l*sin(angle)])
                children();
    }

        rotated_section(color = "green")
        rotated_section(angle=0)
        rotated_section(angle=0, color = "blue");
}

//cable_chain([]);

//color("blue")
//render()
cable_chain_section_body_and_cap(l = 20, w = 30, h = 14);


//cube([10,10,10]);
