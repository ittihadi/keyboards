include <corne_config.scad>
use <corne_common.scad>

// Subdivide count
$fn = 30;

// LED_OFFSET = [ 0, -4.96 ];
LED_OFFSET = [ 0, 4.96 ];

unit = UNIT;
switch_width = SWITCH_WIDTH;

rot = -11.94;

plate_outer = [
    [ 0, 0 ],
    [ -1, 0 ],
    [ -1, -0.125 ],
    [ -2, -0.125 ],
    [ -2, -0.375 ],
    [ -4, -0.375 ],
    [ -4, -3.375 ],
    [ -1, -3.375 ],
    [ -.5, -4.250 ],
    [ .5 + cos(rot), -4.250 + sin(rot) ],
    [ .5 + cos(rot) + cos(2 * rot), -4.250 + sin(rot) + sin(2 * rot) ],
    [ 3, -4.250 + sin(rot) + sin(2 * rot) + (1.5 * cos(2 * rot)) ],
    [ 3, -0.375 ],
    [ 2, -0.375 ],
    [ 2, -0.250 ],
    [ 1, -0.250 ],
    [ 1, -0.125 ],
    [ 0, -0.125 ],
];

// holes = [ [ -3, -1.375 ], [ -3, -2.375 ], [ 1, -1.1875 ], [ 1, -3.250 ] ];
// holes = concat(PLATE_PCB_SCREWS, CASE_PCB_SCREWS);
holes = PLATE_PCB_SCREWS;
short_holes = COVER_SCREWS;

// switches = [
//     [ 0, 0 ],       [ 0, -1 ],      [ 0, -2 ],      [ -1, -0.125 ], [ -1, -1.125 ],  [ -1, -2.125 ], [ -2, -0.375 ],
//     [ -2, -1.375 ], [ -2, -2.375 ], [ -3, -0.375 ], [ -3, -1.375 ], [ -3, -2.375 ],  [ 1, -0.125 ],  [ 1, -1.125 ],
//     [ 1, -2.125 ],  [ 2, -0.250 ],  [ 2, -1.250 ],  [ 2, -2.250 ],  [ 0.5, -3.250 ],
// ];
switches = SWITCHES;

// mcu_offset = [ 2.5, -0.375, 0 ] * unit + [ 0, -2, 0 ];
mcu_offset = MCU_POSITION + [ 0, -0.9, 0 ];
interconnect_position = [ 3, -3.125, 0 ] * UNIT;

base_offset = PCB_TOTAL_THICKNESS - PCB_THICKNESS - PCB_GUIDE_THICKNESS;

module lineFlat(start, end, thickness = 1)
{
    hull()
    {
        translate(start) circle(d = thickness);
        translate(end) circle(d = thickness);
    }
}

// https://gist.github.com/thehans/2da9f7c608f4a689456e714eaa2189e6
// https://openhome.cc/eGossip/OpenSCAD/BezierCurve.html
function bezierCoordinate(t, n0, n1, n2, n3) = n0 * pow((1 - t), 3) + 3 * n1 * t * pow((1 - t), 2) +
                                               3 * n2 * pow(t, 2) * (1 - t) + n3 * pow(t, 3);

function bezierPoint(t, p0, p1, p2, p3) = [
    bezierCoordinate(t, p0[0], p1[0], p2[0], p3[0]), bezierCoordinate(t, p0[1], p1[1], p2[1], p3[1]),
    // bezierCoordinate(t, p0[2], p1[2], p2[2], p3[2])
];

function bezierCurve(t_step, p0, p1, p2, p3) = [for (t = [0:t_step:1]) bezierPoint(t, p0, p1, p2, p3)];

function bezierRelative(start, d_start, end, d_end) = bezierCurve(1 / $fn, start, start + d_start, end + d_end, end);

function rotateVec2D(vec, rot) = [ vec[0] * cos(rot) - vec[1] * sin(rot), vec[0] * sin(rot) + vec[1] * cos(rot) ];

function getSwitchLEDPivot(boardPos, north, west,
                           rotation) = ((boardPos - [ .5, .5 ]) * UNIT +
                                        rotateVec2D(LED_OFFSET + [ west ? -2.5 : 2.5, north ? 2 : -2 ], rotation));
function getSwitchLEDPivotSE(boardPos, rotation) = getSwitchLEDPivot(boardPos, false, false, rotation);
function getSwitchLEDPivotNE(boardPos, rotation) = getSwitchLEDPivot(boardPos, true, false, rotation);
function getSwitchLEDPivotSW(boardPos, rotation) = getSwitchLEDPivot(boardPos, false, true, rotation);
function getSwitchLEDPivotNW(boardPos, rotation) = getSwitchLEDPivot(boardPos, true, true, rotation);

wire_guides = [
    // Top Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[9][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[6][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[6][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[3][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[3][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[0][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[0][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivot(SWITCHES[12][0], true, true, 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[12][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivot(SWITCHES[15][0], true, true, 0), rotateVec2D([ -8, 0 ], 0)),

    // Middle Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[10][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[7][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[7][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[4][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[4][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[1][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[1][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[13][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[13][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[16][0], 0), rotateVec2D([ -8, 0 ], 0)),

    // Bottom Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[11][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[8][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[8][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[5][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[5][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[2][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[2][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[14][0], 0), rotateVec2D([ -8, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[14][0], 0), rotateVec2D([ 8, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[17][0], 0), rotateVec2D([ -8, 0 ], 0)),

    // Thumbs
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[18][0], SWITCHES[18][1]), rotateVec2D([ 8, 0 ], SWITCHES[18][1]),
                   getSwitchLEDPivotNW(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ -8, 0 ], SWITCHES[19][1])),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ 8, 0 ], SWITCHES[19][1]),
                   getSwitchLEDPivotNW(SWITCHES[20][0], SWITCHES[20][1]), rotateVec2D([ -8, 0 ], SWITCHES[20][1])),

    // Interrow connections
    // Top - Middle
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[15][0], 0), rotateVec2D([ 3, 0 ], 0),
                   getSwitchLEDPivotSE(SWITCHES[15][0], 0) + [ .5 * UNIT - 2.5 - 1.5 + 0.85, -0.3 * UNIT ],
                   rotateVec2D([ 0, 6 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[16][0], 0) + [ .5 * UNIT - 2.5 - 1.5 + 0.85, 0.7 * UNIT ],
                   rotateVec2D([ 0, -12 ], 0), getSwitchLEDPivotSE(SWITCHES[16][0], 0), rotateVec2D([ 2, 0 ], 0)),

    // Middle - Bottom
    bezierRelative(getSwitchLEDPivotNW(SWITCHES[10][0], 0), rotateVec2D([ -2, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[10][0], 0) + [ -.5 * UNIT + 2.5 + 1.5, -0.5 * UNIT ],
                   rotateVec2D([ 0, 8 ], 0)),
    bezierRelative(getSwitchLEDPivotNW(SWITCHES[11][0], 0) + [ -.5 * UNIT + 2.5 + 1.5, 0.5 * UNIT ],
                   rotateVec2D([ 0, -6 ], 0), getSwitchLEDPivotNW(SWITCHES[11][0], 0), rotateVec2D([ -2, 0 ], 0)),

    // Thumb - Bottom
    bezierRelative(getSwitchLEDPivotNW(SWITCHES[18][0], 0) + [ .1, 0.28 ] * UNIT, rotateVec2D([ -4, -1 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[18][0], 0), rotateVec2D([ -2, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNW(SWITCHES[18][0], 0) + [ .1, 0.28 ] * UNIT, rotateVec2D([ 16, 2 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[18][0], 0) + [ 1.7, 0.2 ] * UNIT, rotateVec2D([ -12, 1.2 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[17][0], 0), rotateVec2D([ 9, -1.2 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[18][0], 0) + [ 1.7, 0.2 ] * UNIT, rotateVec2D([ 12, -2 ], 0)),

    /* bezierRelative(getSwitchLEDPivotNW(SWITCHES[18][0], SWITCHES[18][1]) + [ -.1 * UNIT + 2.5 + 1.5, 0.2 * UNIT ],
                   rotateVec2D([ -6, 0 ], SWITCHES[18][1]), getSwitchLEDPivotNW(SWITCHES[18][0], SWITCHES[18][1]),
                   rotateVec2D([ -4, 0 ], SWITCHES[18][1])),
    bezierRelative(getSwitchLEDPivotNW(SWITCHES[18][0], SWITCHES[18][1]) + [ -.1 * UNIT + 2.5 + 1.5, 0.2 * UNIT ],
                   rotateVec2D([ 4, 0 ], SWITCHES[18][1]),
                   getSwitchLEDPivotNW(SWITCHES[18][0], SWITCHES[18][1]) + [ .9 * UNIT, .2 * UNIT ],
                   rotateVec2D([ -2, 0 ], SWITCHES[18][1])),

    bezierRelative(getSwitchLEDPivotSE(SWITCHES[17][0], 0) + [ .7 * UNIT - 2.5 - 4, -0.3 * UNIT ],
                   rotateVec2D([ 0, -14 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[18][0], SWITCHES[18][1]) + [ .9 * UNIT, .2 * UNIT ],
                   rotateVec2D([ 12, 0 ], SWITCHES[18][1])),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[17][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSE(SWITCHES[17][0], 0) + [ .7 * UNIT - 2.5 - 4, -0.3 * UNIT ],
                   rotateVec2D([ 0, 2 ], 0)), */

    // VCC and GND lines
    // Top Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[9][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[6][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[9][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[6][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[6][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[3][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[6][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[3][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[3][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[0][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[3][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[0][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[0][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[12][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[0][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[12][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[12][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[15][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[12][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[15][0], 0), rotateVec2D([ -4, 0 ], 0)),

    // Middle Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[10][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[7][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[10][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[7][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[7][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[4][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[7][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[4][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[4][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[1][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[4][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[1][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[1][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[13][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[1][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[13][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[13][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[16][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[13][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[16][0], 0), rotateVec2D([ -4, 0 ], 0)),

    // Bottom Row
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[11][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[8][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[8][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[5][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[5][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[2][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[2][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[14][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[14][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotSW(SWITCHES[17][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[11][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[8][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[8][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[5][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[5][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[2][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[2][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[14][0], 0), rotateVec2D([ -4, 0 ], 0)),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[14][0], 0), rotateVec2D([ 4, 0 ], 0),
                   getSwitchLEDPivotNW(SWITCHES[17][0], 0), rotateVec2D([ -4, 0 ], 0)),

    // Thumbs
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[18][0], SWITCHES[18][1]), rotateVec2D([ 4, 0 ], SWITCHES[18][1]),
                   getSwitchLEDPivotSW(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ -4, 0 ], SWITCHES[19][1])),
    bezierRelative(getSwitchLEDPivotSE(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ 4, 0 ], SWITCHES[19][1]),
                   getSwitchLEDPivotSW(SWITCHES[20][0], SWITCHES[20][1]), rotateVec2D([ -4, 0 ], SWITCHES[20][1])),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[18][0], SWITCHES[18][1]), rotateVec2D([ 4, 0 ], SWITCHES[18][1]),
                   getSwitchLEDPivotNW(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ -4, 0 ], SWITCHES[19][1])),
    bezierRelative(getSwitchLEDPivotNE(SWITCHES[19][0], SWITCHES[19][1]), rotateVec2D([ 4, 0 ], SWITCHES[19][1]),
                   getSwitchLEDPivotNW(SWITCHES[20][0], SWITCHES[20][1]), rotateVec2D([ -4, 0 ], SWITCHES[20][1])),

];

module holeFlat()
{
    rotate([ 0, 0, 180 ])
    {
        // Switch poles
        circle(r = 2);
        translate([ 4, 0 ] * 1.27) circle(r = 0.85);
        translate([ -4, 0 ] * 1.27) circle(r = 0.85);

        // Legs - As per switch standards
        // translate([ 2, 4 ] * 1.27) circle(r = 0.75);
        // translate([ -3, 2 ] * 1.27) circle(r = 0.75);
        // Legs - To fit switch socket
        translate([ 2, 4 ] * 1.27) circle(d = 2.9);
        translate([ -3, 2 ] * 1.27) circle(d = 2.9);
    }

    // LED
    // translate([ 0, -3.65 ] * 1.27) circle(d = 3.95);
    translate(LED_OFFSET) circle(d = 3.95);
}

module guideHoleFlat()
{
    rotate([ 0, 0, 180 ])
    {
        // Switch poles
        circle(r = 2);
        translate([ 4, 0 ] * 1.27) circle(r = 0.85);
        translate([ -4, 0 ] * 1.27) circle(r = 0.85);

        // Legs - As per switch standards
        // translate([ 2, 4 ] * 1.27) circle(r = 0.75);
        // translate([ -3, 2 ] * 1.27) circle(r = 0.75);
        // Legs - To fit switch socket
        // translate([ 2, 4 ] * 1.27) circle(d = 2.9);
        // translate([ -3, 2 ] * 1.27) circle(d = 2.9);
        // Socket hole
        minkowski()
        {
            offset(delta = -0.2) translate([ -0.5, 3 ] * 1.27)
            {
                // difference()
                // {
                // square(size = [ 11.2, 5.9 ], center = true);
                square(size = [ 14.6, 5.9 ], center = true);
                //     translate([ .5, -3 ] * 1.27) circle(r = 2.4);
                // }
            }
            circle(r = 0.2);
        }
        // translate([]) square([2.55, 2.5], true);
    }
    // LED
    // translate([ 0, -3.65 ] * 1.27) circle(d = 3.95);
    // translate([ 0, -3.65 ] * 1.27) square(size = 5, center = true);
    translate(LED_OFFSET) square(size = 5.4, center = true);
}

module mcuPins(diameter = .8)
{
    holeDiameter = diameter;
    for (i = [0:8])
    {
        translate([ -7.62, -1.59 - 2.54 * i ]) circle(d = holeDiameter);
        translate([ 7.62, -1.59 - 2.54 * i ]) circle(d = holeDiameter);
    }
    for (i = [-2:2])
    {
        translate([ -2.54 * i, -1.59 - 2.54 * 8 ]) circle(d = holeDiameter);
    }
}

module breakoutPins(diameter = .5) {
    for (i = [-2:1]) {
        translate([1.27 + 2.54*i, -13]) circle(d = diameter);
    }
}

module pcbPlate(mirror = false)
{
    mirrorVal = mirror ? [ 1, 0, 0 ] : [ 0, 0, 0 ];
    difference() {
        union() {
            linear_extrude(height = PCB_THICKNESS, convexity = 20) difference()
            {
                plate(delta = 0.5);
                for (switch = SWITCHES)
                    translate((switch[0]) * unit)
                    {
                        translate([ -0.5, -0.5 ] * UNIT) rotate([ 0, 0, switch[1] ]) mirror(mirrorVal)
                        {
                            holeFlat();
                        }
                    }

                // Manually translate and place thumbs
                // translate([ .5, -4.250 ] * unit) rotate([ 0, 0, rot ]) translate([ 0.5, 0.5 ] * unit) mirror(mirrorVal)
                //     holeFlat();
                // translate([ .5, -4.250 ] * unit) translate([ cos(rot), sin(rot) ] * unit) rotate([ 0, 0, 2 * rot ])
                //     translate([ 0.5, 0.5 ] * unit) mirror(mirrorVal) holeFlat();

                // Screws
                for (hole = concat(holes, short_holes))
                    translate(hole * unit)
                    {
                        // circle(r = 1);
                        circle(d = 3.4);
                    }

                // MCU pins
                translate(mcu_offset) mcuPins(1.4);

                // Breakout board pins
                translate(interconnect_position) rotate(-90) breakoutPins(1.4);
            }
        }
        /* linear_extrude(height = .8)  */for (switch = SWITCHES) {
            translate((switch[0]) * UNIT) 
                translate([ -0.5, -0.5 ] * UNIT) rotate([ 0, 0, switch[1] ]) mirror(mirrorVal)
                    translate(LED_OFFSET) cube([5, 5, 1.6], center = true);
                    // translate(LED_OFFSET) square(size = 5.4, center = true);
        }
    }
}

/* module pcbStands()
{
    linear_extrude(height = PCB_THICKNESS + PCB_PLATE_SPACING)
    {
        for (hole = holes)
            translate(hole * unit)
            {
                difference()
                {
                    offset(delta = 1.5) circle(r = 1);
                    circle(r = 1);
                }
            }
    }
} */

module pcbGuide(mirror = false)
{
    mirrorVal = mirror ? [ 1, 0, 0 ] : [ 0, 0, 0 ];
    linear_extrude(height = PCB_GUIDE_THICKNESS) difference()
    {
        plate(delta = 0.5);

        // Put in guide holes for Switch Sockets and LEDs
        for (switch = SWITCHES)
            translate((switch[0]) * unit)
            {
                translate([ -0.5, -0.5 ] * UNIT) rotate([ 0, 0, switch[1] ]) mirror(mirrorVal)
                {
                    guideHoleFlat();
                }
            }

        // Manually translate and place thumbs
        // translate([ .5, -4.250 ] * unit) rotate([ 0, 0, rot ])
        // {
        //     translate([ 0.5, 0.5 ] * unit) mirror(mirrorVal) guideHoleFlat();
        // }
        // translate([ .5, -4.250 ] * unit) translate([ cos(rot), sin(rot) ] * unit)
        // {
        //     rotate([ 0, 0, 2 * rot ]) translate([ 0.5, 0.5 ] * unit) mirror(mirrorVal) guideHoleFlat();
        // }

        // Screws
        for (hole = concat(holes, short_holes))
            translate(hole * unit)
            {
                circle(d = 3.4);
            }

        // MCU pins
        translate(mcu_offset) mcuPins(1.4);
        // translate(mcu_offset) mcuPins();
        // translate(mcu_offset - [ 9, 23.5 ]) square([ 18, 23.5 ]);

        // Breakout board pins
        translate(interconnect_position) rotate(-90) breakoutPins(1.4);

        // Wire guides
        union()
        {
            for (guide = wire_guides)
            {
                for (i = [0:len(guide) - 2])
                    lineFlat(guide[i], guide[i + 1]);
                // %translate(guide + [0, 0, 20]) circle(d = 1);
                // hull()
                // {
                //     translate([ guide[0], guide[1] ]) circle(d = 1);
                //     translate([ guide[2], guide[3] ]) circle(d = 1);
                // }
            }
        }
    }
    // % translate([ 0, 0, 20 ])
    // {
    //     translate(getSwitchLEDPivot(SWITCHES[19][0], false, false, SWITCHES[19][1])) circle(d = 1);
    //     translate(getSwitchLEDPivot(SWITCHES[20][0], false, false, SWITCHES[20][1])) circle(d = 1);
    // }
}

module pcbInsetScrews()
{
    difference() {
        // union() {
        //     for (hole = holes)
        //         translate(hole * UNIT) 
        //             cylinder(r = 5.5/2, h = PCB_TOTAL_THICKNESS - PCB_THICKNESS);
        //     for (hole = short_holes)
        //         translate(hole * UNIT + [0, 0, 3])
        //             cylinder(r = 5.5/2, h = 3);
        // }
        // for (hole = holes) {
        //     translate(hole * UNIT + [0, 0, -10]) {
        //         #cylinder(r = 3.4/2, h = PCB_TOTAL_THICKNESS + 1);
        //         #cylinder(r = 3.6/2, h = 1.5 + 1);
        //     }
        // }
        //
        // for (hole = short_holes) {
        //     translate(hole * UNIT + [0, 0, 3 - 1]) {
        //         #cylinder(r = 3.4/2, h = 3 + 1);
        //         #cylinder(r = 3.6/2, h = 1 + 1);
        //     }
        // }
        linear_extrude(height = PCB_TOTAL_THICKNESS, convexity = 20)
        {
            union() {
                for (hole = holes)
                {
                    translate(hole * unit)
                    {
                        difference()
                        {
                            circle(d = 5.5);
                            circle(d = 3.4);
                        }
                    }
                }
            }
        }
        for(hole = holes) {
            translate(hole * UNIT)
                cylinder(r1 = 3.6 / 2, r2 = 3.6 / 2, h = 1.5);
        }
    }
    difference() {
        translate([0, 0, 3]) linear_extrude(3, convexity = 20) {
            union() {
                for (hole = short_holes) {
                    translate(hole * unit) {
                        difference() {
                            circle(d = 5.5);
                            circle(d = 3.4);
                        }
                    }
                }
            }
        }
        translate([0, 0, 3]) for(hole = short_holes) {
            translate(hole * UNIT)
                cylinder(r1 = 3.6 / 2, r2 = 3.6 / 2, h = 1);
        }
    }
}

module pcb(mirror = false)
{
    mirrorVal = mirror ? [ 1, 0, 0 ] : [ 0, 0, 0 ];
    mirror(mirrorVal) union() {
        // up(base_offset + PCB_GUIDE_THICKNESS) pcbPlate2(mirror = mirror);
        translate([ 0, 0, base_offset + PCB_GUIDE_THICKNESS ]) pcbPlate(mirror = mirror);
        translate([ 0, 0, base_offset ]) pcbGuide(mirror = mirror);
        translate([ 0, 0, 0 ]) pcbInsetScrews();
        // translate([ 0, 0, PCB_GUIDE_THICKNESS ]) pcbStands();
    }
}

pcb();

// Mount plate
// % translate([ -4.318 * unit, (-0.375 - 4.75973) * unit, PCB_TOTAL_THICKNESS + PCB_PLATE_SPACING ])
// {
//     color("Silver", alpha = 0.2) import("corne_mount_plate.stl");
// }

// translate([ 125, 0, 0 ]) pcb(mirror = true);

// RP2040
// translate([ 2, 0, 0 ] * unit + [ 0, 0, 1.5 + 2.56 ]) color("Blue") cube([ 21, 51, 1 ]);

// RP2040-Zero
% translate(mcu_offset + [ -9, -23.5, PCB_TOTAL_THICKNESS + 3.26 ])
{
    // This is size specified by thing
    mcuMirror = [ 0, 0, UPSIDE_DOWN_MCU ? 1 : 0 ];
    translate(mcuMirror) mirror(mcuMirror)
    {
        color("Green", alpha = 0.5) cube([ 18, 23.5, 1 ]);
        translate([9, 23.5 + 1, 1]) usbCPort();
        // translate([ 9, 23.5 - 2.19, 1 + 1.63 ]) color("Blue", alpha = 0.4)
        // {
        //     % cube([ 8.94, 7.35, 3.26 ], true);
        // }
    }
}

%translate(interconnect_position + [0, 0, PCB_TOTAL_THICKNESS]) {
    rotate([0, 0, -90]) translate([0, -(15 - 13.5/2), 3.26 + .5]) cube([12, 13.5, 1], true);
    rotate([0, 0, -90])
        usbCPort();
}

// Pro Micro
// translate([ 2, 0, 0.250 ] * unit) color("Red") cube([ 17, 33, 1 ]);

// SUB_PCB_CASE_HEIGHT = 1.8 + 3;
//
// color("LightGrey", alpha = 0.5)
// {
//     translate([ 0, 0, -SUB_PCB_CASE_HEIGHT ]) linear_extrude(height = 6.5 + SUB_PCB_CASE_HEIGHT)
//     {
//         difference()
//         {
//             minkowski()
//             {
//                 offset(delta = 1)
//                 {
//                     polygon(plate_outer * unit);
//                 }
//                 circle(r = 1);
//             }
//             offset(delta = 0) plate();
//         }
//     }
// }
