include <BOSL2/std.scad>

function rotV2(vec, rot) = [
    vec[0] * cos(rot) - vec[1] * sin(rot),
    vec[0] * sin(rot) + vec[1] * cos(rot)
];

// Draw config
DRAW_DEBUG = true;

UNIT = 19.05;
SWITCH_WIDTH = 14;
ROT = -11.94;

PCB_TOTAL_THICKNESS = 6;
PCB_THICKNESS = 1.5;
PCB_PLATE_SPACING = 3.5;
PCB_GUIDE_THICKNESS = 0.8;

CASE_BASE_THICKNESS = 2.5;
CASE_SIDE_THICKNESS = 2.4;
CASE_PCB_SPACING = 5 - CASE_BASE_THICKNESS; // Maybe change this to 4

UPSIDE_DOWN_MCU = true;
MCU_POSITION = [ 2.52, -0.375, 0 ] * UNIT;

PLATE_OUTLINE = [
    [ 0, 0 ],
    [ -1, 0 ],
    [ -1, -0.125 ],
    [ -2, -0.125 ],
    [ -2, -0.375 ],
    [ -4, -0.375 ],
    [ -4, -3.375 ],
    [ -1, -3.375 ],
    [ -.5, -4.250 ],
    [ .5 + cos(ROT), -4.250 + sin(ROT) ],
    [ .5 + cos(ROT) + cos(2 * ROT), -4.250 + sin(ROT) + sin(2 * ROT) ],
    [ 3, -4.250 + sin(ROT) + sin(2 * ROT) + (1.5 * cos(2 * ROT)) ],
    [ 3, -0.375 ],
    [ 2, -0.375 ],
    [ 2, -0.250 ],
    [ 1, -0.250 ],
    [ 1, -0.125 ],
    [ 0, -0.125 ],
];

SWITCHES = [
    [ [ 0, 0 ], 0 ],
    [ [ 0, -1 ], 0 ],
    [ [ 0, -2 ], 0 ],
    [ [ -1, -0.125 ], 0 ],
    [ [ -1, -1.125 ], 0 ],
    [ [ -1, -2.125 ], 0 ],
    [ [ -2, -0.375 ], 0 ],
    [ [ -2, -1.375 ], 0 ],
    [ [ -2, -2.375 ], 0 ],
    [ [ -3, -0.375 ], 0 ],
    [ [ -3, -1.375 ], 0 ],
    [ [ -3, -2.375 ], 0 ],
    [ [ 1, -0.125 ], 0 ],
    [ [ 1, -1.125 ], 0 ],
    [ [ 1, -2.125 ], 0 ],
    [ [ 2, -0.250 ], 0 ],
    [ [ 2, -1.250 ], 0 ],
    [ [ 2, -2.250 ], 0 ],
    [ [ 0.5, -3.250 ], 0 ],
    [ [ 1 + .5 * cos(ROT) - .5 * sin(ROT), -3.750 + .5 * sin(ROT) + .5 * cos(ROT) ], ROT ],
    [
        [
            1 + cos(ROT) + .5 * cos(2 * ROT) - .5 * sin(2 * ROT),
            -3.750 + sin(ROT) + .5 * sin(2 * ROT) + .5 * cos(2 * ROT)
        ],
        2 * ROT,
    ]
];

// Ref:
/*
    [
        .5 * switch_unit + (switch_unit * cos(rot)) + (switch_unit * cos(2 * rot)) - (switch_unit * sin(2 * rot)),
        // 3 * switch_unit,
        -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)) + (switch_unit * sin(2 * rot)) +
            (switch_unit * cos(2 * rot)),
    ],
    [
        // Ok I need to precalc this
        2 * switch_unit,
        // .5 * switch_unit + (switch_unit * cos(rot)) + (switch_unit * cos(2 * rot)) - (switch_unit * sin(2 * rot))
        // - (switch_unit * cos(2 * rot)) + the_funny,
        //  "Proper" y position to make it aligned with the hole
        // -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)) + (switch_unit * sin(2 * rot)) +
        //     (switch_unit * cos(2 * rot)) - (switch_unit * sin(2 * rot)) +
        //     (the_funny * sin(2 * rot) * (1 / cos(2 * rot))),
        //  "Just what looks good?"
        -3 * dy - 3 * switch_unit,
    ],
*/


PLATE_CUTOUT = [
    [ 2, -0.375 ],
    [ 2, -3.375 ], // Funny corner
    [
        .5 + cos(ROT) + cos(2 * ROT) - sin(2 * ROT), 
        -4.250 + sin(ROT) + sin(2 * ROT) + cos(2 * ROT)
    ],
    [ 3, -4.250 + sin(ROT) + sin(2 * ROT) + (1.5 * cos(2 * ROT)) ],
    [ 3, -0.375 ]
];

_FUNNY_CORNER = offset(
    slice(PLATE_CUTOUT, 0, 2), 
    delta = (2 + CASE_SIDE_THICKNESS) / UNIT, 
    closed = false
);

COVER_EDGES_INNER = concat(
    slice(_FUNNY_CORNER, 0, 1), 
    [PLATE_CUTOUT[2] + rotV2([2 + CASE_SIDE_THICKNESS, 0] / UNIT, 2 * ROT + 90)],
    slice(PLATE_CUTOUT, 3)
);

PLATE_PCB_SCREWS = [ [ -3, -1.375 ], [ -3, -2.375 ], [ 1, -1.1875 ], [ 1, -3.250 ] ];
// CASE_PCB_SCREWS = [ [ -3.85, -1.375 ], [ -3.85, -2.375 - 0.250 ], [ 2.85, -1.9 ], [ 2.72, -3.72 ] ];

CASE_PCB_SCREWS = PLATE_PCB_SCREWS;
// CASE_PCB_SCREWS = [ 
//     [ -3, -1.375 + .5 ], [ -3, -2.375 - .5 ],
//     [ 1, -1.1875 + .5 ],
//     [ 1 + .5 * cos(ROT) - .5 * sin(ROT), -3.750 + .5 * sin(ROT) + .5 * cos(ROT) ] 
// ];

COVER_SCREWS = [
    [2 + 5.2 / UNIT, -1.875],
    COVER_EDGES_INNER[2] + rotV2([4 / UNIT, 0], 2 * ROT + 90 + 40)
    + rotV2([-1.6/UNIT,0],2*ROT+90),

    // [3 - 5.2 / UNIT, -3.650]
];

CASE_FEET = [
    [ -4, -0.375 ] + [.2, -.2],
    [ -4, -3.375 ] + [.2, .2],
    [ .5 + cos(ROT) + cos(2 * ROT), -4.250 + sin(ROT) + sin(2 * ROT) ] + 
        [.25 * sin(2 * ROT), .25 * cos(2 * ROT)],
    [ 3, -0.375 ] + [-.2, -.2],
];
