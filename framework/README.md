# What and why?

This is a *very dirty* protective shell for the internals of a dGPU and iGPU (the empty one) expansion bay.  My primary
usage of it is for traveling, but with some work this could be turned into more.

As to the why: personally I'd likey my dGPU to not get fragged by random stuff in my luggage.  You do you however.


# printing it

## scads:
You'll find iGPU and dGPU files; print the shell you want.  If your printer isn't >300mm, use the `-split.scad` models- they have a dovetail joint through the center.  Use a rubber mallet to join it.

Be warned that the dovetail joints are *tight* on dimensional tolerance- 0.075mm gap.  Increase that as needed for your printer.  For a prusa mk4 0.4mm nozzle w/ input shaper, that 0.075mm took a bit of force and didn't wind up perfectly flush,
but I can assure you that joint is pretty much final.

## Printing suggestions

This was validated w/ prusament petg on a prusa mk4 w/ input shaper and 0.4mm nozzle.  No print issues, although I still kind of want the dovetail joints slightly tighter- which would require
fixing the underlying library, and I didn't have time.

# Stuff that could be improved upon.

## Implementation stuff
* the clips aren't great.  Specifically they extend in the z axis below the effective footprint of the chassis, and beyond the outer wall.  An area of potential improvement
  is to extend the wall to the same clip depth.  It'd look nicer, and it would protect the clips from impact.
* I'm not entirely happy with the reliance on the outer y edges- the black parts of the expansion bay adjacent to the hinge gaps.  I'd prefer better protection on that,
  but the requirements for printing- and avoiding supports- is such that I didn't see a quick solution for a printable solution.  Splitting it into parts could address this, but is a PITA.
* The magic constants are kept to a min- and where they exist, I commented.  That said, it can be improved; I wrote this using [constructive.scad](https://github.com/solidboredom/constructive)
  and while it feels superior, the learning process impacted some of the alignment.  IE, there's a few magic constants... typically with some swearing alongside about lack of understanding why it's required.
* For the interface of the 'chassis' shell- the back y (what touches the black part of the actual dGPU/shell), there are subtle clips on the framework hardware.  This protective
  shell roughly aligns, but I'd prefer that it not have that interface- those framework edges don't look designed for load.

## quality of life stuff
* Someone should emboss the framework gear logo, obviously.  I skipped this since I didn't have a good PNG source for it, and since `surface()` in
  openscad is great for ruining performance.
* An addition of clips for holding the framework screw driver.  I'd appreciate someone contributing that- I ran out of time.
* Investigating having the interposer screwed directly into the shell's underside (the inner chamber).  This isn't hard- check the mechanical specs
  below- but for my "crank out a shell for flying shortly" I decided to use the original plastic casing, and put it within the inner chamber.  Someone
  should design a proper solution for this.  An alternative is to have a attached to the 'top' that can hold the interposer- just design clip mounts for securing it.
* Fixing the terminology in the source; I found the mechanical specs *after* I knocked out the core design, and didn't have time to go make and clean that up.

## dGPU vs iGPU and unifying it.

The dGPU has some subtle differences from the iGPU- specifically in the hinge mounts (it's not a cutout, it's curved) and in the adjacent black cover.  Look inside yours- note that
there is extra bits in the way in the dGPU that don't exist in the iGPU.  Additionally, the dGPU has a longer z footprint- roughly ~3mm deeper than the iGPU.  This is why I wound up
just creating two shells.

This could be unified into one design; use the dGPU hinge measurements (they're good enough for iGPU), expand the chassis outer wall and design movable clips for it.  Specifically, design
a clip that is something like ~11mm talk; the top is designed to 'hook' into the outer wall, and the bottom is the clip bump.  That rough measurement would work for the iGPU; to make that
clip usable for the dGPU, just add an adajacent clip mount in the wall that is ~3mm from the top.  If you're using the shield on the iGPU, have the clip in the top position; if dGPU, use the
clip in the bottom position.

If I had more time, this is where I would've went- realistically for travel, one bay is inserted, one is being packed.  IE, you only need a unified shield for whichever bay isn't in use.

# License
Full: https://spdx.org/licenses/CC-BY-NC-SA-1.0.html
Roughly: non-commercial usage, give attribution, and those terms must be extended forward.

# mechanical specs from upstream
See https://github.com/FrameworkComputer/ExpansionBay/tree/main/Mechanical ; this design
was made w/out that (hand measurements taken instead).  For any corrections, refer to
the official spec- I was not aware of it when I designed this, and I deeply wish I had
been.
