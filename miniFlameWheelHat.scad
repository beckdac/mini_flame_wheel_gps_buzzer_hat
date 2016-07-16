// Requires OpenSCAD 2016.3+

use <roundCornersCube.scad>;

/* [Main] */

// select part
part = "assembly";
//part = "buzzerMount";
//part = "ubloxNeo6mMount";
//part = "plate";
plateThickness = 2;

/* [Misc] */
// interference fit adjustment for 3D printer
iFitAdjust = .4;
// cylinder subtract height extension
cylHeightExt = .1; // for overcutting on differences so they render correctly, nothing more
// render quality
$fn = 64; // [24:low quality, 48:development, 64:production]

/* [ublox-neo6m] */
ubloxWidth = 21 + iFitAdjust * 2;
ubloxLength = 26 + iFitAdjust * 2;
ubloxHeight = 5;

/* [plate] */
mountHoleSep = 58;
mountHoleD = 3 + iFitAdjust;
plateLW = mountHoleSep + (2 * mountHoleD) * 2;

/* [buzzerMount] */
buzzerD = 13 + iFitAdjust;
buzzerHeight = 8 + iFitAdjust;
buzzerMountLip = 1;

render_part();

module render_part() {
	if (part == "assembly") {
		assembly();
	} else if (part == "ubloxNeo6mMount") {
		ubloxNeo6mMount();
	} else if (part == "plate") {
		plate();
	} else if (part == "buzzerMount") {
		buzzerMount();
	} else {
		// invalid value
	}
}

module assembly() {
	union() {
		plate();
		ubloxNeo6mMount();
		buzzerMount();
	}
}

module plate() {
	difference() {
		translate([0, 0, plateThickness / 2])
			roundCornersCube(plateLW, plateLW, plateThickness, 8);
		for (i = [-1, 1])
			for (j = [-1, 1])
				translate([i * mountHoleSep / 2, j * mountHoleSep / 2, plateThickness / 2])
					cylinder(h=plateThickness + cylHeightExt, d=mountHoleD, center=true);
		translate([0, -ubloxLength, -buzzerHeight])
			cylinder(h=buzzerHeight + plateThickness + cylHeightExt, d=buzzerD + 2 * plateThickness);
            cube([ubloxWidth + 2 * plateThickness,
                ubloxLength + 2 * plateThickness,
                ubloxHeight + plateThickness], center=true);
            translate([0, ubloxLength / 2 + plateThickness - 1, 2 + plateThickness])
                cube([4,
                    8,
                    10], center=true);
	}
}

module buzzerMount() {
	translate([0, -ubloxLength, -buzzerHeight]) {
		difference() {
			cylinder(h=buzzerHeight + plateThickness, d=buzzerD + 2 * plateThickness);
			translate([0, 0, plateThickness])
				cylinder(h=buzzerHeight + cylHeightExt, d=buzzerD);
			translate([0, 0, -cylHeightExt / 2])
				cylinder(h=buzzerHeight + plateThickness + cylHeightExt, d=buzzerD - 2 * buzzerMountLip);
		}
	}
}

module ubloxNeo6mMount() {
	translate([0, 0, -ubloxHeight + plateThickness - iFitAdjust - cylHeightExt + plateThickness]) {
        difference() {
            cube([ubloxWidth + 2 * plateThickness,
                ubloxLength + 2 * plateThickness,
                ubloxHeight + plateThickness], center=true);
            translate([0, 0, plateThickness + .5])
                cube([ubloxWidth,
                    ubloxLength,
                    ubloxHeight + plateThickness], center=true);
            translate([0, ubloxLength / 2 + plateThickness - 1, 2 + plateThickness])
                cube([4,
                    8,
                    10], center=true);
        }
    }
}
