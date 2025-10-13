include <common.scad>
include <BOSL2/std.scad>

module case_top(fn = 10) {
  $fn = fn;

  difference() {
    move_copies([[-2, 0], [-1, 0], [0, 2/8], [1, 3/8], [2, 2/8], [3, 1/8]] * GRID_UNIT)
    move_copies([[0, 0], [0, 1], [0, -1]] * GRID_UNIT)
    cuboid([GRID_UNIT + 2, GRID_UNIT + 2, 6 + PLATE_THICK - 0.05], rounding=1, anchor=BOTTOM, edges=["Z",TOP]);

    move_copies([[-2, 0], [-1, 0], [0, 2/8], [1, 3/8], [2, 2/8], [3, 1/8]] * GRID_UNIT)
    move_copies([[0, 0], [0, 1], [0, -1]] * GRID_UNIT) {
      down(0.5*HOLE_THRESHOLD)
      cuboid([HOLE_UNIT, HOLE_UNIT, 6 + PLATE_THICK + HOLE_THRESHOLD], rounding=1.2, anchor=BOTTOM, edges="Z");
      up(PLATE_THICK)
      cuboid([GRID_UNIT + 0.4, GRID_UNIT + 0.4, 6], anchor=BOTTOM, edges="Z");
    }
  }
}

case_top(10);
