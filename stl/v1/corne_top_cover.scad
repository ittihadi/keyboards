include <corne_config.scad>
use <corne_case.scad>
use <corne_pcb_plate.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

module cover() {
    union() {
        up(5) difference() {
            offset_sweep(
                difference([
                    round_corners(
                        offset(COVER_EDGES_INNER * UNIT, delta = 1 + CASE_SIDE_THICKNESS),
                        r = 1 * 2
                    ),
                    move(COVER_SCREWS[0] * UNIT, circle(d=2.5)),
                    move(COVER_SCREWS[1] * UNIT, circle(d=2.5))
                ]),
                height=6,
                top=os_chamfer(width=CASE_SIDE_THICKNESS / 2),
                top_hole=os_chamfer(width=0.5)
            );
            down(.1) offset_sweep(
                round_corners(
                    offset(COVER_EDGES_INNER * UNIT, delta = 1),
                    r = 1
                ),
                height=6-CASE_SIDE_THICKNESS+.1,
                top=os_chamfer(width=CASE_SIDE_THICKNESS / 4),
                bottom=os_chamfer(width=-CASE_SIDE_THICKNESS / 2)
            );
        }
        for (screw = COVER_SCREWS) {
            linear_extrude(5 + 6 - CASE_SIDE_THICKNESS + .1) translate(screw * UNIT) 
                difference(){circle(d = 4.5); circle(d = 2.5);}
        }
    }
}

// back_half(y=-18, s=800) 
cover($fn=20);

// down(CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS) %case();
down(PCB_TOTAL_THICKNESS) %pcb($fn = 10);
