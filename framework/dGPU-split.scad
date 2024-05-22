// SPDX-License-Identifier: CC-BY-NC-SA-1.0
include <expansion-bay-shell.scad>;
include <../libs/dovetail/dovetail.scad>;

turnXZ(180)
intersection() {
    let(teeth_count=8, teeth_height=5, teeth_clearance=0.075)
    for(male=[true, false]) {
        X(male?10:-10)
        intersection() {
            expansion_bay_shell();
            turnXY(90) X(1) cutter(position=[-30,0,0], dimension=[100, 200, 50],
               teeths=[teeth_count, teeth_height, teeth_clearance], male=male);
        };
    };
};
