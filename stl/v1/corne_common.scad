include <corne_config.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

module plate(r = 1, delta = 0)
{
    if (r > 0)
        minkowski()
        {
            offset(delta = -r + delta) polygon(PLATE_OUTLINE * UNIT);
            circle(r = r);
        }
    else
        offset(delta = delta) polygon(PLATE_OUTLINE * UNIT);
}

module usbCPort()
{
    radius = 1.28;
    translate([0, 0, 3.26 / 2]) rotate([90, 0, 0]) 
    linear_extrude(height = 7.35) {
        offset(r = radius) offset(r = -radius) square([8.94, 3.26], true);
    }
}

module usbCBOSL() {
    radius = 1.28;
    rounded_base = rect([8.96, 3.26], rounding = radius);
    xrot(90) ymove(3.26 / 2) offset_sweep(
        rounded_base, 
        height=7.35, bottom=os_chamfer(width=-CASE_SIDE_THICKNESS / 4, height=CASE_SIDE_THICKNESS / 2)
        // top=os_chamfer(width=top_chamfer)
    );
}
