/*	To improve fit of belt to pulley, set the following constant. Decrease or increase by 0.1mm at a time. We are modelling the *BELT* tooth here, not the tooth on the pulley. Increasing the number will *decrease* the pulley tooth size. Increasing the tooth width will also scale proportionately the tooth depth, to maintain the shape of the tooth, and increase how far into the pulley the tooth is indented. Can be negative */
additional_tooth_width = 0.2; //mm

//	If you need more tooth depth than this provides, adjust the following constant. However, this will cause the shape of the tooth to change.
additional_tooth_depth = 0; //mm

function tooth_spaceing_curvefit (b,c,d, teeth)
    = ((c * pow(teeth,d)) / (b + pow(teeth,d))) * teeth ;

function tooth_spacing(tooth_pitch,pitch_line_offset, teeth)
    = (2*((teeth*tooth_pitch)/(3.14159265*2)-pitch_line_offset)) ;


function belt_pulley_dia(type) = type[1];
function belt_tooth_profile(type) = type[2];
function belt_tooth_depth(type) = type[3];
function belt_tooth_width(type) = type[4];
function belt_tooth_count(type) = type[5];


module tooth_profile_sketch(profile) {
    polygon(profile);
}

module pulley_sketch(type) {
    pulley_od = belt_pulley_dia(type);
    tooth_distance_from_centre = sqrt( pow(pulley_od/2,2) - pow((belt_tooth_width(type)+additional_tooth_width)/2,2));
    tooth_width_scale = (belt_tooth_width(type) + additional_tooth_width ) / belt_tooth_width(type);
    tooth_depth_scale = ((belt_tooth_depth(type) + additional_tooth_depth ) / belt_tooth_depth(type)) ;
    teeth = belt_tooth_count(type);

    difference() {
        circle(r=pulley_od/2, $fn=teeth*4);

        for (i = [1:teeth])
        rotate([0, 0, i * (360 / teeth)])
            translate([0, - tooth_distance_from_centre, 0])
                scale([tooth_width_scale, tooth_depth_scale, 1])
                    tooth_profile_sketch(belt_tooth_profile(type));
    }

}


