// Requires OpenSCAD 2016.3+

/* [Main] */

// select part
part = "assembly";
plateThickness = 2;

/* [Misc] */
// interference fit adjustment for 3D printer
iFitAdjust = .4;
// cylinder subtract height extension
cylHeightExt = .1; // for overcutting on differences so they render correctly, nothing more
// render quality
$fn = 64; // [24:low quality, 48:development, 64:production]

/* [ublox-neo6m] */
ubloxWidth = 20.5;
ubloxLength = 25.5;
ubloxHeight = 5;

render_part();

module render_part() {
	if (part == "assembly") {
		assembly();
	} else {
		// invalid value
	}
}

module assembly() {
    union() {
        difference() {
            cube([ubloxWidth + 2 * plateThickness,
                ubloxLength + 2 * plateThickness,
                ubloxHeight + plateThickness], center=true);
            translate([0, 0, plateThickness + .5])
                cube([ubloxWidth,
                    ubloxLength,
                    ubloxHeight + plateThickness], center=true);
            translate([0, ubloxLength / 2 + plateThickness - 1, 2 + plateThickness])
                #cube([4,
                    4,
                    10], center=true);
        }
    }
}
