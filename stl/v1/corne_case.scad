include <corne_config.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/lists.scad>
use <corne_common.scad>
use <corne_pcb_plate.scad>
use <corne_top_cover.scad>

wall_height = CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS + 
              PCB_PLATE_SPACING + 1.5;

usb_position = MCU_POSITION;
interconnect_position = [ 3, -3.125, 0 ] * UNIT;

// module caseFillet(size = 1) {
//     render() minkowski() {
//         linear_extrude(0.001) difference() {
//             plate(r = 1, delta = 1 + CASE_SIDE_THICKNESS + .1);
//             plate(r = 1, delta = 1 + CASE_SIDE_THICKNESS);
//         }
//         translate([0, 0, size / 2]) 
//             cylinder(h = size, r1 = size, r2 = 0, center = true, $fn=4);
//     }
// }

module case(fn = 10) {
    $fn = fn;
    union() {
        /*
        render() difference() {
            linear_extrude(height = CASE_BASE_THICKNESS) difference()
            {
                plate(r = 1, delta = 1 + CASE_SIDE_THICKNESS);
                for (hole = CASE_PCB_SCREWS)
                    translate(hole * UNIT)
                    {
                        circle(d = 2);
                    }
            }
            linear_extrude(height = 1) for (foot = CASE_FEET) {
                translate(foot * UNIT)
                    circle(d = 8);
            }

            // How do I remove this
            #caseFillet(CASE_BASE_THICKNESS / 2);
        }
        */

        // 6.2 is the distance to the base of the keycaps
        // render() difference() {
            // linear_extrude(height = wall_height /* + 6.2 */) difference()
            // extrudeWithRadius(wall_height + 1, r1 = 0, r2 = 1, fn = fn) difference()
            // {
            //     plate(r = 1, delta = 1 + CASE_SIDE_THICKNESS);
            //     plate(r = 1, delta = 1);
            // }
            /* translate([0, 0, CASE_BASE_THICKNESS]) difference() {
                linear_extrude(wall_height - CASE_BASE_THICKNESS) 
                    plate(r = 1, delta = 1 + CASE_SIDE_THICKNESS);
                linear_extrude(wall_height) 
                    plate(r = 1, delta = 1);
            }

            translate(usb_position + [0, 4, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS]) 
                usbCPort();

            translate(interconnect_position + [0, 0, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS]) rotate([0, 0, 90])
                usbCPort();
        } */

        // Wow... BOSL is cool
        // rounded_plate = round_corners(PLATE_OUTLINE * UNIT, r = [
        //     1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0
        // ]);
        inner_plate = round_corners(offset(PLATE_OUTLINE * UNIT, delta = 1), r = [
            1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0
        ]);
        // outer_plate = round_corners(
        //     offset(PLATE_OUTLINE * UNIT, delta = 1 + CASE_SIDE_THICKNESS,
        //     check_valid = false), // Workaround from tight points, verify nothing breaks
        //     r = [ 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 ] * 0
        // );
        outer_plate = offset(
            offset(PLATE_OUTLINE * UNIT, delta = 1 + CASE_SIDE_THICKNESS - 1 * 2),
            r = 1 * 2
        );

        // test_1 = offset((PLATE_OUTLINE) * UNIT, delta = 1 + CASE_SIDE_THICKNESS - 2);

        // debug_polygon(test_1);
        // down(1) debug_polygon(offset(test_1, r = 2));
        // down(2) color(alpha = 1) debug_polygon(outer_plate);
        // down(1) debug_polygon(offset(PLATE_OUTLINE * UNIT, delta = 3));
        // up(2) debug_polygon(PLATE_OUTLINE * UNIT);

        difference() {
            union() {
                top_chamfer = CASE_SIDE_THICKNESS / 2;
                offset_sweep(
                    outer_plate, 
                    height=wall_height, bottom=os_chamfer(width=1),
                    top=os_chamfer(width=top_chamfer)
                );
                // This is so the cover can be put on "seamless"ly
                up(wall_height - top_chamfer) linear_extrude(top_chamfer)
                    polygon(round_corners(
                        offset(COVER_EDGES_INNER * UNIT, delta = 1 + CASE_SIDE_THICKNESS),
                        r = [0, 0, 1, 1, 1] * 2
                        )
                    );
            }

            up(CASE_BASE_THICKNESS) offset_sweep(
                reverse(inner_plate), 
                height=wall_height, bottom=os_chamfer(width=.8)
            );

            linear_extrude(height = CASE_BASE_THICKNESS) for (hole = CASE_PCB_SCREWS)
                translate(hole * UNIT)
                {
                    circle(d = 2);
                }

            linear_extrude(height = 1) for (foot = CASE_FEET) {
                translate(foot * UNIT)
                    circle(d = 8);
            }

            translate(usb_position + [0, 1.01 + CASE_SIDE_THICKNESS, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS]) 
                usbCBOSL();

            translate(interconnect_position + [1.01 + CASE_SIDE_THICKNESS, 0, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS]) rotate([0, 0, -90])
                usbCBOSL();
        }
        linear_extrude(height = CASE_BASE_THICKNESS + CASE_PCB_SPACING) {
            for (hole = CASE_PCB_SCREWS){
                translate(hole * UNIT) difference() {
                    circle(r = 2);
                    circle(r = 1);
                }
            }
        }
    }
}

case(30);


%translate([ 0, 0, CASE_BASE_THICKNESS + CASE_PCB_SPACING ]) color(alpha = 0.4) 
    pcb($fn = 10);

%translate(
      [ -4.318 * UNIT, (-0.375 - 4.75973) * UNIT, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS + 3.5 ])
{
    color(alpha = 0.4) import("corne_mount_plate.stl");
}

%translate(interconnect_position + [0, 0, CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS + .5])
    rotate([0, 0, -90]) translate([0, -7.5, 3.26]) cube([12, 13.5, 1], true);

// up(wall_height + 6) debug_polygon(offset(COVER_EDGES_INNER * UNIT, delta = 1 + CASE_SIDE_THICKNESS));
// up(wall_height + 3) debug_polygon(
//     offset(slice(COVER_EDGES_OUTER, 0, 2) * UNIT, delta = (2 + CASE_SIDE_THICKNESS), closed = false)
// );

// up(wall_height + 6) usbCBOSL();

up(wall_height - 5) %cover();
