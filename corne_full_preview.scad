include <BOSL2/std.scad>
include <corne_config.scad>
use <corne_pcb_plate.scad>

//back_half(s = 200, y = -68){
// scale([100, 100, 100]) { 
union() {
import("final/corne_case_left.stl", convexity=3);
up(CASE_BASE_THICKNESS + CASE_PCB_SPACING) /* yrot(180) */ 
    // STL Breaks, don't ask, idk either
    yrot(180) import("final/corne_pcb_plate_left.stl", convexity=20);
    // pcb(mirror=false, $fn=50);
up(CASE_BASE_THICKNESS + CASE_PCB_SPACING + PCB_TOTAL_THICKNESS) yrot(180) 
    import("final/corne_top_cover_left.stl", convexity=2);
translate([ -4.318 * UNIT, (-0.375 - 4.75973) * UNIT, PCB_TOTAL_THICKNESS + PCB_PLATE_SPACING + CASE_BASE_THICKNESS + CASE_PCB_SPACING])
    import("corne_mount_plate.stl");
}
// }
//}
