// SPDX-License-Identifier: CC-BY-NC-SA-1.0
include <../libs/constructive/constructive-compiled.scad>;

chassis_x=286.5;
preview=.02;
tight=.05;
$dGPU=true;
// chassis == the main square- the electronics + fans.  Non chasis (overhang) is the stuff on the sides or back.
chassis_x_overhang=($dGPU ? 14 : 31.5);
chassis_y_total=75;
chassis_y_insert=10;
chassis_y_dgpu_insert = .5;
chassis_z=7.5;
chassis_z_total = 15.9-2.5;
wall=1;
$skinThickness=wall;
// for any <some_num> - <some small number>, the first is the measurement, the next is the margin/tolerance/tweaks.
$fn=$preview ? 10 : 40;
$clip_flex=5;
$clip_flex_gap=.4;
$clip_lip=4;
$clip_offset=0;
module _merge_clip(x, y, z, flex=$clip_flex,flex_gap=$clip_flex_gap,lip=$clip_lip, offset=$clip_offset) {
    add() _clip_add (x,y,z,flex,flex_gap,lip,offset);
    remove() _clip_cut(x,y,z,flex,flex_gap,lip,offset);
};

module _clip_add(x,y,z,flex=$clip_flex,flex_gap=$clip_flex_gap,lip=$clip_lip, offset=$clip_offset) {
    Z(-offset -lip) box(x=x, y=y, z=z+ lip+ offset);
    Y(+lip/2) Z(-offset-(lip/2)) X(x/2) turnXZ(90) tube(d=lip, h=x, solid=true);
};

module _clip_cut(x,y,z,flex=$clip_flex,flex_gap=$clip_flex_gap,lip=$clip_lip, offset=$clip_offset) {
    two() X(sides(x/2 +flex_gap/2))
        Z(z)
        box(x=flex_gap, y=y+preview, z=flex);
};


module expansion_bay_shell() {
    assemble() {
        g(TOUP(), alignSkin(TODOWN)) {
            // backing that goes into the overhang- the wings/slots on the side of the chassis
            TOREAR() {
                add() {
                    box(x=chassis_x + (2 * (chassis_x_overhang - tight)), y=chassis_y_insert+tight,
                        z=chassis_z_total-tight);
                };
                remove() {
                    for(i=[-1:2:1]) align(i==-1 ? TOLEFT : TORIGHT)
                    X(i*-(chassis_x/2 + chassis_x_overhang + wall + .5)) Y(chassis_y_insert+tight - chassis_y_dgpu_insert) #box(
                        x=chassis_x_overhang+2, y=chassis_y_dgpu_insert, z=chassis_z_total+2);

                };
            };

            // main chassis
            add() TOFRONT()
                box(x=skin(chassis_x), y=skin(chassis_y_total-chassis_y_insert),
                    z=chassis_z_total-tight);

            // y axis clips that grip the hinge gap.
            for(i=[-1:2:1]) align(i==-1 ? TOLEFT : TORIGHT) TOREAR()
            let (slot=27.5)
            X(i*(-chassis_x/2)) {
                // roll these clip by hand since alignment on the main module is something I need to unfuck.
                let(lip=1.5, y=chassis_y_insert+2, w=1.5,
                     dGPU_offset=$dGPU? (chassis_z_total-chassis_z-tight)/2 : 0,
                    lip_z=chassis_z_total-chassis_z-tight - dGPU_offset,
                    flex=2, flex_gap=$clip_flex_gap)
                Z(chassis_z + dGPU_offset){
                    X(i*w) {
                        add () g() {
                            box(x=w,y=y+lip,z=lip_z);
                            X(i*-lip/2) Y(y) tube(d=lip, h=lip_z, solid=true);
                        };
                        Z(+1.1) remove() Y(chassis_y_insert - flex+.01) g() {
                            X(i*-flex_gap) box(x=flex_gap, y=flex+.1, z=lip_z+1);
                            X(i*w) box(x=flex_gap, y=flex+.1, z=lip_z+1);
                        };
                    };

                    X(i*(slot -w)) {
                        add() g() {
                            box(x=w, y=y+lip, z=lip_z);
                            X(i*(w - lip/2)) Y(y) tube(d=lip, h=lip_z, solid=true);
                        };
                        remove() g() Y(chassis_y_insert - flex+.01) {
                            X(i*w) box(x=flex_gap, y=flex+.1, z=lip_z+2);
                            X(i*-flex_gap) box(x=flex_gap, y=flex+.1, z=lip_z+2);
                        };
                    };
                };
            };

            // main chassis cutout- the actual board
            // where does this magic 1.1 fucking come from?  Why am I needing this?
            // (answer: I'm needing it because of orientation and I'm too lazy to rewrite it and retest
            //  it... or I'm wrong in that assumption.
            //The values are stable for parameter changes however.)
            remove() Y(chassis_y_insert-(2*wall)-preview) TOFRONT()
                Z(1.1 - preview) Y(10)
                    box(x=chassis_x-(wall), y=chassis_y_total+10-wall, z=chassis_z +tight+ preview);

            // front cutouts.
            // same here, where's the magic 1.2 from?
            let (chassis_edge = -chassis_x/2 + wall, z=chassis_z + 1.2-tight,
                 gap=8.5 + .5, offset=5) remove()
            TOLEFT() TOFRONT() Y(-chassis_y_total + chassis_y_insert) {
                two()
                X(sides(chassis_edge + wall + gap) + offset)  {
                    box(x=gap, y=5, z=z);
                };
                let (gap=27+1, offset=90.5) X(chassis_edge + wall + gap + offset)  {
                        box(x=gap, y=5, z=z);
                };
                let (gap=16, offset=70) X(-chassis_edge - wall -gap -offset) {
                    box(x=gap, y=5, z=z);
                };
            };

            // z clips that grip the front chassis footprint.
            // TODO: reorganize so this isn't redundant
            // offset=10 comes from measurement of the full Z of fan + bottom shield.
            let (lip=$clip_lip, chassis_edge = -chassis_x/2 + wall,,
            o=2.5  + ($dGPU? 2.5:0), f_wall=2, clip_width=4, z=0)
            TOFRONT() Y(-chassis_y_total + chassis_y_insert -wall) {
                // clips
                two() X(sides(15)) _merge_clip(x=clip_width, y=f_wall, z=z, lip=lip, offset=o);
                two() X(sides(100)) _merge_clip(x=clip_width, y=f_wall, z=z, lip=lip, offset=o);
                two() X(sides(chassis_x - wall)/2) Y((chassis_y_total-chassis_y_insert)/2) turnXY(sides(90))
                    _merge_clip(x=clip_width, y=f_wall, z=z, lip=lip, offset=o);
            };
        };
    };
};