include <BOSL2/rounding.scad>
include <BOSL2/std.scad>
include <corne_config.scad>

// Subdivide? count
$fn = 50;

switch_width = 14;
switch_unit = 19.05;

dy = 2.381;
rot = -11.94;

the_funny = 2 * switch_unit - (.5 * switch_unit + (switch_unit * cos(rot)) + (switch_unit * cos(2 * rot)) -
                               (switch_unit * sin(2 * rot)) - (switch_unit * cos(2 * rot)));

module hole()
{
    color("#afafaf") translate([ 0, 0, .75 ]) cube([ switch_width, switch_width, 3 ], true);
}

module holeCol()
{
    hole();
    translate([ 0, -switch_unit, 0 ]) hole();
    translate([ 0, -2 * switch_unit, 0 ]) hole();
}

module plate(height = 1)
{
    // Full plate
    /* linear_extrude(height = height) polygon([
        [ 0, 0 ],
        [ -switch_unit, 0 ],
        [ -switch_unit, -dy ],
        [ -2 * switch_unit, -dy ],
        [ -2 * switch_unit, -3 * dy ],
        [ -4 * switch_unit, -3 * dy ],
        [ -4 * switch_unit, -3 * dy - 3 * switch_unit ],
        [ -1 * switch_unit, -3 * dy - 3 * switch_unit ],
        [ -.5 * switch_unit, -2 * dy - 4 * switch_unit ],
        [
            .5 * switch_unit + (switch_unit * cos(rot)),
            -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)),
        ],
        [
            .5 * switch_unit + (switch_unit * cos(rot)) + (switch_unit * cos(2 * rot)),
            -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)) + (switch_unit * sin(2 * rot)),
        ],
        [
            3 * switch_unit,
            -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)) + (switch_unit * sin(2 * rot)) +
                (1.5 * switch_unit * cos(2 * rot)),
        ],
        [ 3 * switch_unit, -3 * dy ],
        [ 2 * switch_unit, -3 * dy ],
        [ 2 * switch_unit, -2 * dy ],
        [ 1 * switch_unit, -2 * dy ],
        [ 1 * switch_unit, -1 * dy ],
        [ 0 * switch_unit, -1 * dy ],
    ]); */

    // Without the part where the MCU will be
    linear_extrude(height = height) polygon([
        [ 0, 0 ],
        [ -switch_unit, 0 ],
        [ -switch_unit, -dy ],
        [ -2 * switch_unit, -dy ],
        [ -2 * switch_unit, -3 * dy ],
        [ -4 * switch_unit, -3 * dy ],
        [ -4 * switch_unit, -3 * dy - 3 * switch_unit ],
        [ -1 * switch_unit, -3 * dy - 3 * switch_unit ],
        [ -.5 * switch_unit, -2 * dy - 4 * switch_unit ],
        [
            .5 * switch_unit + (switch_unit * cos(rot)),
            -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)),
        ],
        [
            .5 * switch_unit + (switch_unit * cos(rot)) + (switch_unit * cos(2 * rot)),
            -2 * dy - 4 * switch_unit + (switch_unit * sin(rot)) + (switch_unit * sin(2 * rot)),
        ],
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
        // [ 3 * switch_unit, -3 * dy ],
        // [ 2 * switch_unit, -3 * dy ],
        [ 2 * switch_unit, -2 * dy ],
        [ 1 * switch_unit, -2 * dy ],
        [ 1 * switch_unit, -1 * dy ],
        [ 0 * switch_unit, -1 * dy ],
    ]);
}

echo(the_funny);

// module key()
// {
//     translate([ 0, 0, .75 ]) difference()
//     {
//         cube([ switch_unit, switch_unit, 1.5 ], true);
//         cube([ switch_width, switch_width, 3 ], true);
//     }
// }
//
// module column()
// {
//     key();
//     translate([ 0, -switch_unit, 0 ]) key();
//     translate([ 0, -2 * switch_unit, 0 ]) key();
// }

// color("#9cec74") translate([ 0, 0, 11.5 ]) import("/home/ittihadi/Downloads/corn_handwire_plate.stl");

// color("#9cec74") translate([ -100, 100, 0 ]) import("/home/ittihadi/Downloads/corne_mount_plate.stl");

// translate([ 42, -42, -.75 ]) linear_extrude(height = 3) circle(2, $fn = 12);
translate([ 4.318 * switch_unit, 3 * dy + 4.75973 * switch_unit, 0 ]) difference()
{
    plate(1.45);
    translate([ -.5 * switch_unit, -.5 * switch_unit, 0 ])
    {
        holeCol();

        translate([ -switch_unit, -dy, 0 ]) holeCol();
        translate([ -2 * switch_unit, -3 * dy, 0 ]) holeCol();
        translate([ -3 * switch_unit, -3 * dy, 0 ]) holeCol();

        translate([ -2.5 * switch_unit, -3 * dy - .5 * switch_unit, -.75 ]) linear_extrude(height = 3)
            circle(1, $fn = 50);

        translate([ -2.5 * switch_unit, -3 * dy - 1.5 * switch_unit, -.75 ]) linear_extrude(height = 3)
            circle(1, $fn = 50);

        translate([ 1.5 * switch_unit, -1.5 * dy - .5 * switch_unit, -.75 ]) linear_extrude(height = 3)
            circle(1, $fn = 50);

        translate([ 1.5 * switch_unit, -2 * dy - 2.5 * switch_unit, -.75 ]) linear_extrude(height = 3)
            circle(1, $fn = 50);

        translate([ switch_unit, -dy, 0 ]) holeCol();
        translate([ 2 * switch_unit, -2 * dy, 0 ]) holeCol();

        translate([ .5 * switch_unit, -2 * dy - 3 * switch_unit, 0 ]) hole();
        translate([ 1 * switch_unit, -2 * dy - 3.5 * switch_unit, 0 ]) rotate([ 0, 0, rot ])
            translate([ .5 * switch_unit, .5 * switch_unit, 0 ]) hole();
        translate([ 1 * switch_unit, -2 * dy - 3.5 * switch_unit, 0 ])
            translate([ switch_unit * cos(rot), switch_unit * sin(rot), 0 ]) rotate([ 0, 0, 2 * rot ])
                translate([ .5 * switch_unit, .5 * switch_unit, 0 ]) hole();

        // Clip off where the MCU will be
        // translate([ 3 * switch_unit, -3 * dy - switch_unit, 0 ]) cube([ switch_unit, switch_unit * 3, 3 ], true);
    }
}

/* translate([ 4.318 * switch_unit, 3 * dy + 4.75973 * switch_unit, 0 ])
    translate([ -.5 * switch_unit, -.5 * switch_unit, 0 ])

{
    translate([ .5 * switch_unit, -2 * dy - 3 * switch_unit, 0 ])
    {
        color("#ff0000") cube([ switch_unit, switch_unit, 3 ], true);
    }
    translate([ 1 * switch_unit, -2 * dy - 3.5 * switch_unit, 0 ]) rotate([ 0, 0, rot ])
        translate([ .5 * switch_unit, .5 * switch_unit, 0 ])
    {
        color("#ff0000") cube([ switch_unit, switch_unit, 3 ], true);
    }
    translate([ 1 * switch_unit, -2 * dy - 3.5 * switch_unit, 0 ])
        translate([ switch_unit * cos(rot), switch_unit * sin(rot), 0 ]) rotate([ 0, 0, 2 * rot ])
            translate([ .5 * switch_unit, .5 * switch_unit, 0 ])
    {
        color("#ff0000") cube([ switch_unit, switch_unit, 3 ], true);
    }
} */

/* translate([ -.5 * switch_unit, -.5 * switch_unit ]) union()
{
    column();

    translate([ -switch_unit, -2.381, 0 ]) column();
    translate([ -2 * switch_unit, -2.381 - 4.763, 0 ]) column();
    translate([ -3 * switch_unit, -2.381 - 4.763, 0 ]) column();

    // For better union I guess?
    // translate([ -2.5 * switch_unit - 1, -2.381 - 4.763 - (2.5 * switch_unit), 0 ]) cube([ 2, 3 * switch_unit, 1.5 ]);
    // translate([ -1.5 * switch_unit - 1, -2.381 - 4.763 - (2.5 * switch_unit), 0 ]) cube([ 2, 3 * switch_unit, 1.5 ]);
    // translate([ -2.5 * switch_unit, -2.381 - 4.763 - (.5 * switch_unit), 0.75 ])
    //     cube([ 2 * switch_unit, 2, 1.5 ], true);
    // translate([ -2.5 * switch_unit, -2.381 - 4.763 - (1.5 * switch_unit), 0.75 ])
    //     cube([ 2 * switch_unit, 2, 1.5 ], true);

    translate([ switch_unit, -2.381, 0 ]) column();
    translate([ 2 * switch_unit, -2 * 2.381, 0 ]) column();
    // translate([ 3 * switch_unit, -2.381, 0 ]) column();

    translate([ .5 * switch_unit, -2.381 - 4.763 - 3 * switch_unit, 0 ]) key();
    translate([ 1 * switch_unit, -2.381 - 4.763 - 3.5 * switch_unit, 0 ]) rotate([ 0, 0, -11.94 ])
        translate([ .5 * switch_unit, .5 * switch_unit, 0 ]) key();
    translate([ 1 * switch_unit, -2.381 - 4.763 - 3.5 * switch_unit, 0 ]) rotate([ 0, 0, -11.94 ])
        translate([ switch_unit, 0, 0 ]) rotate([ 0, 0, -11.94 ]) translate([ .5 * switch_unit, .5 * switch_unit, 0 ])
            key();
    translate([ -1.5 * switch_unit, -2.5 * switch_unit - 2.381 - 4.763, 0 ])
        cube([ 3 * switch_unit, 2.381 + 4.763, 1.5 ]);
} */
