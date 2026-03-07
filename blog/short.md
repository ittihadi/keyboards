---
layout: base.njk
published: 2025-09-30
updated: 2025-10-01
---

# Building a Handwired Keyboard (Short Version)

## Background

This project began around the beginning of 2025 when I started getting
recommendations of "ergonomic keymaps" and became interested in them. It
started with simple things like HHKB's control key in the place of caps lock,
or me swapping my alt and windows keys around for easier navigation with my
window manager. Eventually I discovered the [ZSA
Voyager](https://www.zsa.io/voyager) and wanted to try something sleek like it,
but since I couldn't buy it, I looked for alternatives.

A bit of browsing later and I landed on the Crkbd's form factor. At first I
wanted to just print its supplied PCB files but after failing to find an
economical option locally, and after seeing that it's possible to handwire a
keyboard together, I decided I could try doing that instead.

## Design

I wanted to avoid hardwiring my switches to the wires directly and instead keep
using sockets. Lucky for me I found [this reddit post]() where the author did
exactly that with a 3D printed plate, including divets which hold the key
sockets in place.

At first I thought I could edit STL files directly like I could image files,
but after messing around for some time it turns out that unfortunately I can't.
So I had to find a CAD software that ran decently well on my laptop, as last
time I tried a CAD suite, the app was running like a slideshow.

I found that both FreeCAD and OpenSCAD ran pretty well on my machine, with
OpenSCAD being more stable, so I went with that option. First I designed the
switch plate, which helps align the switches to where they're supposed to be.
For the sizing I followed both this [Keyboard Anatomy
Guide](https://matt3o.com/anatomy-of-a-keyboard/) and [Crkbd's footprint
image](https://github.com/foostan/crkbd), slightly deviating only in making the
plate 1.45mm thick instead of the full 1.5mm, in case the print ended up being
oversized instead of undersized.

![CAD preview of the switch mount plates]({{ "/images/cad_switch_plate.webp" | url }} "Switch mount plate design")

I ordered the print through a listing on Shopee and after a week or so I
received it, bent... but it wasn't the end of the world since this plate could
be flattened quite a bit and putting in the switches should also force it flat.

![Switch mount plate printed out]({{ "/images/print_result_switch_plate.webp" | url }} "Switch mount plate prints, a *bit* bent")

After seeing how well the plate went it was time for the PCB substitute, the
case, and the cover. The PCB substitute was identical in shape to the switch
plates, except it has different holes to allow only the switches' pins and legs
to go through. I considered whether or not I should even support 5 pin switches
but since it was better to play safe I did.

The measurements for the holes were taken from the specification sheet of the
[BOX White]() switches,
the [Kailh Switch Sockets](),
and the [WS2812B LED]()
I bought. Since I wanted to have slots for my sockets, LEDs, and wires, I added
those too.

Here's what I ended up with

![CAD preview of the wiring plate]({{ "/images/cad_pcb.webp" | url }} "Wiring plate design")

I also included holes for pin header legs both for the USB-C interconnect as
well as the RP2040-Zero MCU.


When I was designing the case I stumbled upon the [BOSL2 library](),
which could give me easier rounding in OpenSCAD itself. Utilizing that library I
designed both the case and the MCU cover and had significantly easier time making
it round

![CAD preview of the case]({{ "/images/cad_case.webp" | url }} "Case design")

![CAD preview of the cover]({{ "/images/cad_cover.webp" | url }} "MCU cover design")

Since most Crkbd builds use an acrylic plate or OLED screen to cover up the MCU I
had to make some creative liberties in designing a full cover that wouldn't leave
the MCU open.

After all that's done, I ordered them to be printed, this time with extra packaging
to avoid getting them bent again, or worse, broken, and in ABS instead of PLA this
time.

Thankfully they arrived safely

![Case, wiring plate, and MCU cover prints]({{ "/images/print_result_full.webp" | url }} "The print results looking good")

## Assembly

The first thing I decided to tackle once I got the prints was to install the
heat-set thread inserts for the screws. This is when I discovered that the
holes for these were undersized, and gradually, I would find out that in fact
*all* the holes I have in this were undersized.

After some quick browsing I decided to get some sandpaper and sand away some of
the plastic in order to make these holes larger, this alone ended up pushing
this project back weeks since all the holes were milimeters in diameter, and
they *had* to be enlarged.

I also didn't want to reprint these parts because they were pretty pricey and I
didn't want to discard a whole set of them for nothing.

And so I sanded, at first only the screw holes, but eventually also the socket
holes, the LED slots, the switch leg holes, the pin header holes, and even the
wire guides. The sandpaper I ended up using were 400 grit, they weren't too
hard to cut into thin strips but also wasn't so fine it took forever to remove
a substantial amount of material.

[//]: # (> Insert image of sanding the parts)

[//]: # (Editing note: I can't find images of sanding the parts either)

Once I got some holes that would actually fit my parts I could start the actual
assembly. The heat-set inserts weren't that difficult to install, though I
could've bought ones more specialized for 3D prints, as these ones were a little
hard to align properly.

![Heat-set inserts]({{ "/images/heat_set_inserts.webp" | url }} "Installing the heat-set inserts")

After a test fit I wanted to install the interconnects first, since those also
didn't have active components and... they were too far from the hole. Turns out,
not only did I make the header holes too small, I also put them milimeters too
deep and I couldn't actually insert the USB plug correctly, so I had to *move*
the holes closer. This, along with moving the MCU's header holes closer, as
that was also too far in, was annoying, but again, I didn't want to reprint.

![Shifted interconnect pin holes]({{ "/images/moved_interconnect_slots.webp" | url }} "Moved interconnect pin holes")

[//]: # (> Insert moved MCU header holes image)

[//]: # (Editing note: I don't have an image of the MCU pin holes moved, only
before it, and ages after it, it seems I did also do it in this step but I
didn't document it)

[//]: # (Editing note 2: Ok my images around this time are just very
non-linear, but I still can't find a good picture of the MCU holes elongated by
themselves)

I decided to start with the left half of the keyboard first, so I tried seeing
if the parts fit and... they don't, again, because the holes were too small. So
I had to shave off some material to get them to fit. After that then I finally
start installing, first up the interconnects.

![Glued in intercoonnect plug]({{ "/images/glued_interconnect.webp" | url }} "The interconnect plug attached with glue")

[//]: # (Editing note: Interconnects were only glued in to place by this point
but not actually wired the wiring was done after the components were glued as
well)

It was also around this time that I decided to try using hot glue to attach
parts together. Which turns out to be a horrible decision down the line, not
that hot glue won't work, but that hot glue kept melting whenever something
close to it was hot.

Next up I installed the rubber feet, of course, the holes were also slightly
undersized.

![Attaching the rubber feet]({{ "/images/rubber_feet.webp" | url }} "Installing the rubber feet")

Since I was going for hot glue, I first hot glued the LEDs and sockets in. This
was a bit messy, but in my mind it was fine.

![Left half glued components]({{ "/images/left_glued_back.webp" | url }} "The LEDs and sockets glued into place")

Then there's the handedness resistor, which is used by the firmware to decide
which half of the keymap it uses. At first I used the 5V pin from the MCU, but
I pretty quickly learned that I couldn't do that since the GPIO pins on the
RP2040-Zero doesn't handle 5V. Luckily before ever plugging in the MCU and
frying it. So I switched it to the 3.3V pin.

At this point I didn't have a concrete idea of how to structure my wiring, so I
just did what I thought was easiest first. In this case I did the interconnect
wires first, which also showed me how easy it was to melt off the wires'
insulation.

After that I soldered in the LEDs' data and power lines, because in my mind
it's the better one to do before doing the switches. And this ends up working
pretty nicely, though not without quite a few connection errors from bad joints
both for data and power.

![Left half LED wiring]({{ "/images/left_first_led_back.webp" | url }} "Wiring for the LEDs")

![Left half LED test]({{ "/images/left_first_led.webp" | url }} "Testing the LEDs")

So now that that's working, I move on to the switches, starting from the
diodes, and then the wires. I test it... and it runs!

At this point it was getting pretty late, but I felt like I just had to finish
it, and so I put it into the case and... it doesn't work... weird. I try
pushing it around in the case and it kind of works? I thought it was another
short, this time between the case and the switches, but I couldn't figure it
out.

So I was pushing around the MCU and I accidentally shorted the MCU itself.\
*Oh no*. The USB plug got really hot and it just refused to work. Not wanting
to risk a fire I decide to stop, and for a while after I took a break since I
got pretty bummed out from losing an MCU.

In my break Idecided to buy new switches and keycaps so that my old keyboard
can still be used even after I'm done making this split one.

Before starting work on the right half I also figured it'd be a great idea to
find some better wires first to make my chances better since the current ones I
had were not great to bend around. It didn't take me long to find some flexible
wires, some of which I'd end up using, and some of which I wouldn't.

Another thing I found out was that the USB holes I made were actually both too
deep and too shallow, so the plug had a hard time clicking into place since the
body of the USB couldn't fit into the slot nicely. This led to me carving out a
sizeable chunk from the holes in order to fit the plugs better, it wasn't the
best looking, but it got the job done and at this point, I just wanted to get
this done with.

This time around I decided to be significantly more methodical with how I wired
up the parts. So instead of doing all the LEDs and then all the switches, I did
all the wires that can be set without overlapping wires first. So I did the LED
data wires, then all the switch rows, then all the interconnects, then all the
LED power lines, but not connecting the rows together, then finally the wires
that will connect the switch rows with the MCU.

This kept the total height of the wiring significantly shallower than before,
and because I was also cutting longer wire segments and stripping them in the
middle instead of making many short wire segments, it was also less fragile.

This time around the wires were also sanded beforehand, because I saw a slight
increase in ease of soldering and wanted to play it safe.

![Right half first layer]({{ "/images/first_layer_right.webp" | url }} "The \"first layer\" of the right half")

Now I didn't use hot glue for this half, since I didn't want to deal with the
mess it made, and because this side held all the parts in by friction good
enough.

After finishing up all of the "first layer" I moved on to the second, which
included the column connecting all the LED power lines, the switch columns
themselves as well as the connectors to the columns for the MCU.

After all of that was done, I gave it a quick test and, after one minor LED
issue, it worked perfectly! The input was consistent, the LEDs didn't flicker,
and it fits in the case fine! After this glorious success I decided to take a
little break to work on a game dev competition submission for a bit.

![Right half second layer]({{ "/images/full_layer_right.webp" | url }} "The \"second layer\" of the right half")

![Right half assembled]({{ "/images/finished_right_assembled.webp" | url }} "The right side finished and assembled")

After a small break I got back to working on the project by desoldering the
entire left half that I've done before, because I didn't like the quality of it
and honestly didn't trust that it'd work properly. I spent a couple days
cleaning up the old glue that was there before rewiring with the same procedure
as the right half.

I started with the LED wires, the switch rows, and the interconnect. Then
blitzed through the rest of the wiring in a couple days because the new
semester was starting soon and I wanted this done before then.

In the end I finished all the soldering on the last day of vacation, and now
that I had both halves it was time to test it out.

![Left half reworked]({{ "/images/full_layer_left.webp" | url }} "Reworked left half")

Moment of truth, I connect both halves and, it works! Though the left half is a
bit dodgy, and the LEDs sometimes flicker, but it works in general. After
trying a bit more I decided that making the interconnect headers hotswap wasn't
a great idea, so I replaced them with male headers to stop the connectors from
losing contact randomly.

The interconnect cable also can't be unplugged easily yet since if I wanted to
plug it back in I'd have to hold the board with my hand to stop it from sliding.

![Complete pair]({{ "/images/full_complete.webp" | url }} "Both sides completed")
{.popout}


## A Strive for Ergonomics

On the second day of using the keyboard I decided that it's probably not the
worst idea to switch to using Colemak-DH. I wasn't originally planning on
switching but I thought I might as well so that I can make a whole new
mapping in my brain for typing on this split keyboard instead of having to
modify my muscle memory for QWERTY.

![Colemak-DH layout on an ortholinear]({{ "/images/colemak_dh_main_matrix.webp" | url }} "Colemak-DH layout")

At first it was veeeery slow, but I could see the appeal almost immediately, as
I could see that I didn't need to move my fingers nearly as much to type the
more common words.

Of course, I was still using the default number row and symbol layers, which
made me move my hands to type more common characters, I was planning on
rectifying this eventually, but not now.

## Post Build Polishing

I got some free time when my Uni gave us a study from home order for the week
so I decided it's the perfect moment to finish the assembly for real so I can
bring this keyboard everywhere easier.

The main issue I had was that I couldn't plug in the interconnect cable without
opening the top cover, to remedy this I ended up just attaching a short
toothpick with super glue to hold the pin headers in place, this seems to work
reasonably well and allowed me to plug in the interconnect without the port
sliding back.

![Toothpick hack to stop the USB plug from sliding back]({{ "/images/toothpick_hack.webp" | url }} "Using a toothpick to stop sliding")

The other issue I had was that the left half of the board was disconnecting
randomly. Thinking back to when I was attaching the MCU to this side I remember
feeling that the pin headers were loose. At first I thought I should just
change out the pin headers to male ones, but imagining the nightmare it'd be
if I ever need to press the physical buttons on the MCU I ended up just putting
on new female headers.

## Personalization

After some time getting used to Colemak-DH, I wanted to make my modifier keys
more ergonomic as well. The most common method for doing this is what are
called "Home-Row Mods", specifically where the modifier keys were placed under
the home row finger positions and activated by holding down the key instead of
tapping it.

I've known of this method for a while but I didn't want to use it since I
personally don't want to have timing based inputs. Luckily while browsing for
alternative keymaps I discovered a
[post]() that mentioned "Callum Style Mods",
named after the person who popularized it.

I decided to implement this first and after a few days of getting used to, it
actually felt nice to use, and the fact that the keys were one shot meant that
I could let go of the keys and still get a shifted input for my next key.

This change also basically removed the need for the normal modifier keys in
common typing scenarios.

![Callum mods on nav layer]({{ "/images/callum_mods_1.webp" | url }} "")

![Callum mods on sym layer]({{ "/images/callum_mods_2.webp" | url }} "Callum mods on number and symbol layers")

After seeing how nice Callum mods were and implementing it on both sides of my
keyboard I needed to change up my symbol layer as well, since it was now
conflicting with the right hand modifiers. Following a
[post]()
about symbol layers by Getreuer, I decided to adapt their symbol layer and
slightly tweak it to accomodate my modifier placement.

![Symbol layer]({{ "/images/symbol_layer.webp" | url }} "Symbol layer inspired by getreuer")

Finally, I wanted to modify my number row, especially after seeing
[Jonas Hietala's](https://www.jonashietala.se/blog/2021/06/03/the-t-34-keyboard-layout/)
keymap, though I did find a [reddit post]()
about optimizing the number row, I opted for the easier to learn layout and
adapted the alternating number row to the top row instead of the home row.

![Number row]({{ "/images/number_row.webp" | url }} "Alternating number row on num/nav layer")

```Some time later```

Alghough after some trial and error I've decided to actually move my number row
into the function layer and have both in the same place. This is also after
realizing that by doing this I can alternate between numbers and symbols much
easier by just pressing/letting go of the nav layer key.

![Numbers moved to function layer]({{ "/images/number_function.webp" | url }} "Alternating numbers on home row along with functions")

## Conclusion

This project has been quite an interesting journey and I'm looking forward to
improving on what I've made iteratively. As for actually using this new
keyboard, I've actually become quite fond of it. It's actually quite fun to
type with so little hand movement too!

After this I'm looking to revamp the physical build of the case to make it more
robust, as well adding a mechanism to secure the keyboard to my legs when I'm
typing with them on my lap.

Though in the future, should I make another keyboard from scratch, I'll choose
to use of a proper PCB instead of this substitute, unless I'm doing a really
simple build. This substitute board was a nice learning experience but it also
proved to be a bit of a headache once it was time to wrangle the wires around.

I'll also continue to iterate on my customization of this keyboard, even now
after writing this I'm finding new ways to add more nice bits in order to
minimize hand movement while maximizing comfort and speed. Things like combos
and even more layers that I find from other people's keymaps give me things I
can try.

