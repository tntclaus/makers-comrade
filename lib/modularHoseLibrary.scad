include <NopSCADlib/core.scad>
include <utils.scad>

// ==========================================
//
//	Title:			Modular Hose Library
//	Version:		0.2
//	Last Updated:	21 June 2011
//	Author: 		Damian Axford
//	License: 		Attribution - Share Alike - Creative Commons
//	License URL: 	http://creativecommons.org/licenses/by-sa/3.0/
//	Thingiverse URL:	http://www.thingiverse.com/thing:9457
//
// ==========================================


// -----------------------------------------------------------------------------------
// Includes
// -----------------------------------------------------------------------------------

// boxes.scad required for roundedBox module
//include <boxes.scad>

// -----------------------------------------------------------------------------------
// global variables
// -----------------------------------------------------------------------------------

tolerance = 0.2;  // distance between ball and socket surfaces

// fractions of an inch
i1 = 25.4;
i4 = 25.4/4;
i8 = 25.4/8;
i16 = 25.4/16;

// -----------------------------------------------------------------------------------
// Discrete elements, non-chainable
// -----------------------------------------------------------------------------------

module modularHoseBall(mhBore) {
	mhBallOD = mhBore*2;
	mhOffsetToBallCenter=0.61 * mhBore;
	mhOffsetToTopOfBall=1.07 * mhBore;
	mhWideBore=mhBore * 1.6;  // started at 1.32
	mhBallID = mhBore * 1.6;
	mhOffsetToInnerBallCenter = 0.75 * mhBore;

	difference() {
		union() {
			translate([0,0,mhOffsetToBallCenter]) sphere(r = mhBallOD/2);
		}

		// Remove top of ball
		translate([0,0,mhOffsetToTopOfBall + mhBallOD/2]) cube(size = [mhBallOD,mhBallOD,mhBallOD], center=true);
	
		// Remove bottom of ball
		translate([0,0,-mhBallOD/2]) cube(size = [mhBallOD,mhBallOD,mhBallOD], center=true);

		// hollow out the ball
		translate([0,0,-0.01]) cylinder(h=mhOffsetToTopOfBall+0.02, r1=mhBore/2 ,r2=mhWideBore/2);

		// hollow out some more with a stretched sphere
		translate([0,0,mhOffsetToInnerBallCenter]) scale([1,1,1.2]) sphere(r = mhBallID/2);
	}
}

// -----------------------------------------------------------------------------------
// Discrete elements, chainable
// -----------------------------------------------------------------------------------

mhSocketHeightScaleFactor = 1.26 + 0.39;

module modularHoseSocket(mhBore) {
	mhOffsetToSocketCenter=0.31 * mhBore;
	mhOffsetToBaseOfSkirt = 0.39 * mhBore;
	mhSocketID = tolerance + mhBore * 2;
	mhSkirtOD = 2.40 * mhBore;    // started at 2.52
	mhSkirtHeight = 1.26*mhBore;   
	mhWaistOD = 1.58 * mhBore;
	mhRimRadius = 0.18 * mhBore;
	mhSocketChamferOffset = 0.79 * mhBore;
	mhSocketChamferHeight = 0.86 * mhBore;
	mhSocketChamferID = mhBore*1.77;

	union() {
		translate([0,0,mhSkirtHeight + mhOffsetToBaseOfSkirt]) children(0);
		difference() {
			union() {		
	
				// Skirt
				translate([0,0,mhOffsetToBaseOfSkirt]) cylinder(h=mhSkirtHeight, r1=mhSkirtOD/2, r2=mhWaistOD/2);
		
				// Rim
				// Rim - collar
				translate([0,0,mhRimRadius]) cylinder(h = mhOffsetToBaseOfSkirt-mhRimRadius, r = mhSkirtOD/2);
		
				// Rim - radius
				rotate_extrude(convexity = 10) translate([(mhSkirtOD/2) - mhRimRadius, mhRimRadius, 0]) circle(r = mhRimRadius);
			
				// Rim - cap
				cylinder(h= mhRimRadius, r=(mhSkirtOD/2) - mhRimRadius);
			}
		
			// removeBore
			translate([0,0,-1]) cylinder(h=mhSkirtHeight + mhOffsetToBaseOfSkirt + 2,r=mhBore/2);
		
			// straighten socket sides
			translate([0,0,mhSocketChamferOffset]) cylinder(h=mhSocketChamferHeight,r1=mhSocketChamferID/2,r2=mhBore/2);
		
			// remove socket		
			translate([0,0,mhOffsetToSocketCenter]) sphere(r = mhSocketID/2);
		}
	}
}

module modularHoseWaist(mhBore, mhWaistHeight) {

	mhWaistOD = 1.58 * mhBore;

	union() {
		translate([0,0,mhWaistHeight]) children(0);
		difference() {
			translate([0,0,-0.01]) cylinder(h= mhWaistHeight + 0.02, r=mhWaistOD/2);
				
			// removeBore
			translate([0,0,-1]) cylinder(h=mhWaistHeight+2,r=mhBore/2);
		}
	}
}

module hose_round_nozzleTip(mhBore, mhNozzleID) {

	mhWaistOD = 1.58 * mhBore;
	mhNozzleHeight = 2 * mhBore;
	mhNozzleOD = mhNozzleID + 1.2;

	difference() {
		union() {
			translate([0,0,mhNozzleHeight]) children(0);

			cylinder(h= mhNozzleHeight, r1=mhWaistOD/2, r2=mhNozzleOD/2);
		}
	
		// removeBore
		translate([0,0,-0.01]) cylinder(h=mhNozzleHeight+0.02,r1=mhBore/2, r2=mhNozzleID/2);
	}

}

module modular_hose_flat_nozzle_tip(mhBore, mhNozzleWidth, mhNozzleThickness) {

	mhWaistOD = 1.58 * mhBore;
	mhNozzleHeight = 3 * mhBore;

	difference() {
		union() {
			translate([0,0,mhNozzleHeight]) children();

            translate_z(mhNozzleHeight+0.5)
            rotate([0,180,0])
            tube_adapter(mhNozzleWidth, mhNozzleThickness, mhNozzleHeight, 3.65, in_dia = mhBore);
		}
	
		// removeBore
		translate([0,0,-0.01]) cylinder(h=0.02,d=mhBore);
	}

}

module modularHoseFlareNozzleTip(mhBore, mhNozzleWidth,mhNozzleThickness) {

	mhWaistOD = 1.58 * mhBore;
	mhNozzleHeight = 2 * mhBore;

	difference() {
		union() {
			translate([0,0,mhNozzleHeight]) children();

			cylinder(h= mhNozzleHeight, r1=mhWaistOD/2, r2=mhNozzleWidth/2);
		}
	
		// removeBore
		translate([0,0,-0.01]) cylinder(h=mhNozzleHeight+0.02,r1=mhBore/2, r2=mhNozzleThickness/2);
	}

}

// -----------------------------------------------------------------------------------
// Composite elements, non-chainable
// -----------------------------------------------------------------------------------

module hose_segment(mhBore) {
    stl(
        str("hose_segment", "_",
        "bore_", mhBore)
    );
	modularHoseSocket(mhBore) modularHoseWaist(mhBore, 0.24 *mhBore) modularHoseBall(mhBore);
    translate([0,0,0.24*mhBore+mhBore+mhBore])
    children();
}

module hose_extended_segment(mhBore, mhWaistHeight) {
    stl(
        str("hose_extended_segment", "_",
        "bore_", mhBore, "_",
        "h_", mhWaistHeight)
    );
	modularHoseSocket(mhBore) modularHoseWaist(mhBore, mhWaistHeight) modularHoseBall(mhBore);
    translate([0,0,mhBore+mhBore+mhWaistHeight])
    children();
}

module hose_round_nozzle(mhBore,mhNozzleID) {
    stl(
        str("hose_round_nozzle", "_",
        "bore_", mhBore, "_",
        "dia_", mhNozzleID)
    );
	modularHoseSocket(mhBore) hose_round_nozzleTip(mhBore, mhNozzleID) { sphere(d=0);}
}

module modularHoseFlareNozzle(mhBore,mhNozzleWidth,mhNozzleThickness) {
	modularHoseSocket(mhBore) modularHoseFlareNozzleTip(mhBore, mhNozzleWidth, mhNozzleThickness);
}

module hose_flat_nozzle(mhBore,mhNozzleWidth,mhNozzleThickness) {
    stl(
        str("hose_flat_nozzle", "_",
        "bore_", mhBore, "_",
        "dia_", mhNozzleWidth, "x", mhNozzleThickness)
    );
	modularHoseSocket(mhBore) modular_hose_flat_nozzle_tip(mhBore, mhNozzleWidth,mhNozzleThickness);
}

module hose_base_plate_drill_holes(mhBore, mhPlateHeight, plate_width, mhThreadDia=3, screw_offset = 6) {
	mhWaistOD = 1.58 * mhBore;
	mhScrewOffset=plate_width/2 - screw_offset;

    // remove central bore (perhaps to feed cables through?)
    translate([0,0,-0.01]) cylinder(h=mhPlateHeight+0.02,d=mhBore);
			
	
    // remove screw holes
    for ( x = [-1, 1]) {
        for ( y = [-1, 1]) {
            translate([x * mhScrewOffset,y * mhScrewOffset,-1]) 
                    cylinder(h=mhPlateHeight+2,r=mhThreadDia/2);
        }
    }    
}

module hose_base_plate(mhBore, plate_width = 0, mhThreadDia=3, screw_offset = 6) {
    stl(
        str("hose_base_plate", "_",
        "bore_", mhBore, "_",
        "dia_", mhThreadDia)
    );
    
	mhWaistOD = 1.58 * mhBore;
	mhPlateHeight = 0.5 * mhBore;
	mhPlateWidth = plate_width != 0 ? plate_width : mhWaistOD + 4*mhThreadDia;

	union() {
		translate([0,0,1 + mhPlateHeight*2]) modularHoseBall(mhBore);
		translate([0,0,1]) modularHoseWaist(mhBore, mhPlateHeight*2) sphere(d=0);
		difference() {
			translate([0,0,mhPlateHeight/2]) 
                rounded_rectangle([mhPlateWidth,mhPlateWidth,mhPlateHeight], r = 2, center = true);				
	
			// remove screw holes
			hose_base_plate_drill_holes(mhBore, mhPlateHeight, mhPlateWidth, mhThreadDia, screw_offset);
		}
	}
    translate_z(mhPlateHeight+mhBore)
    children();
}

module modularHoseDoubleSocket(mhBore) {
	union() {
		modularHoseSocket(mhBore) sphere(0);
		translate([0,0,mhSocketHeightScaleFactor * mhBore]) translate([0,0,mhSocketHeightScaleFactor * mhBore]) mirror([0,0,1]) modularHoseSocket(mhBore) sphere(0);
	}
}

// -----------------------------------------------------------------------------------
//   Debug code - shows a cross section through two "joined" hose segments with a 1mm "ruler" overlay
// -----------------------------------------------------------------------------------

if (true) {
	// top segment
	difference() {	
        rotate([0,0,90])
        translate([0,0,13.9]) hose_flat_nozzle(i4, 12, 4);    
//		translate([0,0,13.9]) hose_segment(i4);
		translate([-10,0,-1]) cube(size=[20,20,100]);
	}	
	
	// bottom segment
	difference() {	
//		hose_segment(i4);	
        hose_base_plate(i4, 30, 3, 3);
		translate([-25,0,-1]) cube(size=[50,50,50]);
	}
	
	
	// Show a ruler
	for (i= [-10 : 10]) {
		translate([i - 0.05,0,0]) rotate([90,0,0]) color([0.9,0.9,0.9,1]) square(size=[0.1,20]);
	}
}


// -----------------------------------------------------------------------------------
//   Example usage of Composite elements
// -----------------------------------------------------------------------------------

module evenlySpaceX(spacing) {
  
	for (i = [0 : $children-1])
    		translate([i * spacing , 0, 0 ]) children(i);
}

// pass "false" to if statement to hide example elements
if (true) {
//    $fn = 20;
//	translate([0,0,0]) evenlySpaceX(25) {
//		hose_round_nozzle(i4, i4);
//		hose_round_nozzle(i4, i8);
//		hose_round_nozzle(i4, i16);
//	}
//	
//	translate([0,25,0]) evenlySpaceX(25) {
//		hose_segment(i4);
//		hose_extended_segment(i4,20);
//		
//		hose_base_plate(i4);
//
//		modularHoseDoubleSocket(i4);
//	}
} else {
	// uncomment the following lines and use to quickly generate STL

	//hose_round_nozzle(i4, i8);
//	hose_segment(i4);
    $fn = 20;
    hose_base_plate(i4)
//    hose_extended_segment(i4,5)    
    hose_segment(i4) 
    hose_segment(i4)
//    modularHoseFlareNozzle(i4, 6, 5);
//    hose_round_nozzle(i4, 5);
    hose_flat_nozzle(i4, 10, 2);    
	//hose_base_plate(i4);
	//modularHoseDoubleSocket(i4);

	//modularHoseFlareNozzle(i4, i1, i16);
}