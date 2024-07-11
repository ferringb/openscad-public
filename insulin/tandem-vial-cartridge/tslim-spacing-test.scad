depth=20;
vial_width=23.08;
module vial(height=depth) {
    cylinder(h=height, d=vial_width);
}
module vial_holes() {
    for(x=[0,1,2]) {
        translate([x * (vial_width+2), 0, 0]) vial();
    }
    translate([0,vial_width + 2, 0]) {
        for(x=[0,1]) {
            translate([x * (vial_width+2), 0, 0]) vial();
        }
    }
}

module cartridge_hole() {
    translate([0, 17.7, 0]) mirror([0,1,0]) rotate([0,0,90]) {
        union() {
            difference() {
                square([17.7, 9.2]);
                translate([5.5, 5.5, 0]) rotate([0,0,180]) {
                    difference() {
                        square(5.5);
                        circle(r=5.5, $fn=120);
                    }
                }
                translate([6.2, 8.9 - 1.8+1.2, ,0]) square(1.7);
                translate([17.2-1.8+1.3, 1.1, 0]) square(1.7);
            }
            translate([6.15, -0.2, 0]) square([4.1, 0.2]);
        }
    }

}

module test_cartridge_hole(height=2) {
    linear_extrude(height=height) difference() {
        translate([-13 + 1.5, -height/2]) square([13, 22]);
        cartridge_hole();
    }
}

module test_vial_hole(height=2) {
    difference() {
        cube([vial_width +4, vial_width + 4, height], center=true);
        // punch through for hole tests.
        translate([0,0, -depth/2]) vial();
    }
}

module holes() {
    vial_holes();
    translate([2*(vial_width +2) -1, vial_width - 17.2/2 + 1,0]) linear_extrude(height=depth) 
        cartridge_hole();
    translate([2*(vial_width +2)+10, vial_width - 17.2/2 + 1,0]) linear_extrude(height=depth)
        cartridge_hole();
}
// 11.5 - 7.5
// 9.18
//$fn=120;
$fa=2;
$fs=0.05;
module main() {
    difference() {
        minkowski() {
            translate([-vial_width/2 - 3, -vial_width/2 -3, -2]) 
                cube([3 * (vial_width+2) + 3, 2 * vial_width +4 + 3, depth]);
            sphere(r=1);
        }
        holes();
    }
}
module test() {
    translate([20, 0,0]) test_vial_hole();
    translate([-20, 0,0]) test_cartridge();
}
//test();
//cartridge_hole();
test_cartridge_hole();
//main();
    