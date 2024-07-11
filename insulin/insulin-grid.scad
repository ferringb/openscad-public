include <../libs/BOSL/shapes.scad>
use <../libs/BOSL/shapes.scad>

// x,y
grid=[3,5];
tolerances = [.5, .5, 0]; // in mm
insulin_dimensions=25.4*[1.5,1.5,3.25] + tolerances;
wall_thickness = 2; // in mm
chamfer=1;


module insulin_holder(wall_thickness, chamfer=0, cutouts=true, exposed_box=insulin_dimensions.z*.2) {
    wc = wall_thickness + chamfer;
    insulin_dimensions = insulin_dimensions - [0,0,exposed_box];
    total = [insulin_dimensions.x + 2*wc, insulin_dimensions.y + 2*wc, insulin_dimensions.z + 2*wall_thickness];
    difference() {
        cuboid(total, center=false);
        // cut out the opening where insulin goes in from the front.
        cuboid(
            p1=[wc, wc, -.1],
            p2=[insulin_dimensions.x + wc,
                insulin_dimensions.y + wc,
                insulin_dimensions.z + wall_thickness],
            chamfer=chamfer,
            edges=EDGES_Z_ALL);

        // add a bevel to that opening; basically the previous cuboid + chamfer
        cuboid(
            p1=[wall_thickness, wall_thickness, 2*chamfer],
            p2=[insulin_dimensions.x + wc+chamfer,
                insulin_dimensions.y + wc+chamfer,
                -4*chamfer],
            chamfer=2*chamfer
        );

        // cut out a hole in the back to push the box through if needed.
        cuboid(
            p1=[total.x*.2, total.y *.2, total.z - wall_thickness -.1],
            p2=[total.x*.8, total.y*.8, total.z + .1],
            chamfer=total.x*.2,
            edges=EDGES_Z_ALL
        );
        
        if(cutouts) {
            cuboid(
                p1=[-.1, total.y*.3, total.z*.1],
                p2=[total.x + .1, total.y * .7, total.z * .9],
                chamfer=total.y*.199,
                edges=EDGE_TOP_FR+EDGE_TOP_BK+EDGE_BOT_FR+EDGE_BOT_BK);
            
            cuboid(
                p1=[total.x*.3, -.1, total.z*.1],
                p2=[total.x*.7, total.y +.1, total.z * .9],
                chamfer=total.x*.199,
                edges=EDGE_TOP_RT+EDGE_TOP_LF+EDGE_BOT_RT+EDGE_BOT_LF);

        }
    };
};

module insulin_grid(grid, wall_thickness, chamfer, cutouts=true) {
    x_offset = insulin_dimensions.x + wall_thickness + 2*chamfer;
    y_offset = insulin_dimensions.y + wall_thickness + 2*chamfer;
    for (x=[0:grid[0] -1 ]) {
        for (y=[0:grid[1] -1]) {
            translate([x* x_offset,y* y_offset, 0])
                insulin_holder(wall_thickness, chamfer=chamfer, cutouts=cutouts);
        };
    };
};

rotate([180,0,0]) insulin_grid(grid, wall_thickness, chamfer);