include <common.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

CASE_OUTLINE = turtle([
  "right", "move", 3, "turn", "move", 3, "xymove", [0.5, -1 + 1/8],
  "turn", ROT_UNIT / 2, "move", 2, "turn", ROT_UNIT * 1.5, "move", "left",
  "untilx", 6.5, "setdir", 90, "untily", 0.5, "left", "move",
  "right", "move", 1/8, "left", "move", "right", "move", 1/8, "left",
  "move", "right", "move", 1/8, "left", "move", "left", "move", 1/8,
  "right", "move", "left", "move", 2/8
], [-0.5, 0.5]);

case_outer_1 = offset(delta=1, CASE_OUTLINE * GRID_UNIT);
case_outer = offset(offset(delta=0.5, case_outer_1), r=2);

difference() {
  offset_sweep(case_outer, height=1.5+6+3+6,bottom=os_chamfer(width=2),top=os_circle(r=1));
  // linear_extrude(1.5 + 6 + 3 + 6, convexity = 10) 
  //   offset(delta=1 + 2.4)
  //   polygon(CASE_OUTLINE * GRID_UNIT);
  up(1.5) linear_extrude(6 + 3 + 6 + 0.1)
    offset(delta=1)
    polygon(CASE_OUTLINE * GRID_UNIT);
}

%up(1.5) right(3.5 * GRID_UNIT) back(1 * GRID_UNIT - 2.38) yrot(180)
import("../../final/corne_pcb_plate_left.stl");
