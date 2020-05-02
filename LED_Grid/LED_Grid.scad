/*
 * OpenSCAD model for a 5050 LED diffuser grid.
 *
 * Copyright 2020 Tido Klaassen (tido_grid@4gh.eu).
 * Licensed under terms of Creative Commons Attribution Share Alike 4.0
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

/* [Global] */

// Number of LEDs in X direction.
num_x = 8; // [2:1:32]

// Number of LEDs in Y direction.
num_y = 8; // [2:1:32]

// Number of LEDs per meter.
leds_pm = 30; // [30, 60, 74, 96, 100, 144]

/*
 * Spacing of LEDs on strip in millimeters. Either calculate from LEDs/m
 * (rounded to two decimal places) or set direct value.
 */
cell_size = round(100000 / leds_pm) / 100;

// Wall height in millimeters.
wall_h = 20; // [7.5, 10, 15, 30]

/*
 * Minimal wall height can be calculated from LED spacing and beam angle.
 * Although most 5050 RGB LEDs claim to have a viewing angle of 120 degrees,
 * brightness tends to drop off significantly beyond 30 degrees off axis.
 */
//wall_h = (cell_size / 2) / tan(30);

// Clearance between interlocking grid modules in millimeters.
cut_clr = 0.25; // [0:0.125:0.5]

// Add border at the top side of the module.
b_top = 1; // [0, 1]

// Add border at the right side of the module.
b_right = 1; // [0, 1]

// Add border at the bottom side of the module.
b_bottom = 1; // [0, 1]

// Add border at the left side of the module.
b_left = 1; // [0, 1]

// Brim parameters           
brim_w = 10;
brim_h = 2;

// Drill screw nut holes parameters
b_drill = 1;
m_drill = 3.5;
h_drill = 15;//5;
s_nut = 5.3; //M3: 5.3;
e_nut = 6.8; //M3: 6.3;
h_nut = 3;//3; //M3: 2.3;
num_drill = 4;

/* [Hidden] */
/* Wall thickness in millimeters. */
wall_t = 1;

/*
 * Hight of the cutout for the flexible PCB at the bottom of each grid wall,
 * in millimeters.
 */
gate_h = 1;

/*
 * Width of PCB cutout. The cutout is tapered, so if you need x mm width at
 * the top, you will have to set gate_w to x + 2*gate_h.
 */
gate_w = cell_size - 2 * wall_t;

/*
 * Width and height of screw tabs. Tabs will be placed along a module's
 * border, across from the second and second-to-last perpendicular wall.
 * Setting either tab_w or tab_h to zero will prevent tabs from being
 * created.
 * tab_h should be at least 2*gate_h, otherwise you will have a hard
 * time removing the print support without breaking off the tab.
 */
tab_w = 5;
tab_h = 2;

/*
 * Only a single module will be rendered if variable borders is defined.
 * Otherwise all possible combinations of borders will be created.
 * Order is top, right, bottom, left.
 */
borders = [b_top, b_right, b_bottom, b_left];

if(!is_undef(borders)){
    /* Create a single module with the given borders. */
    translate([-(num_x * cell_size + wall_t) / 2,
               -(num_y * cell_size + wall_t) / 2,
               0])
        color("blue") ledgrid(borders);
} else {
   /*
    * Create every possible module and arrange them with at their relative
    * position, but a little spread out.
    */
    spread = 5;

    /* Borders on top and left side. */
    translate([-1.5 * num_x * cell_size - spread,
                num_y * cell_size + 1.5 * spread,
               0])
        color("blue") ledgrid([1, 0, 0, 1]);

    /* Border on top. */
    translate([-0.5 * num_x * cell_size,
                num_y * cell_size + 1.5 * spread,
                0])
        color("blue") ledgrid([1, 0, 0, 0]);

    /* Borders on top and right side. */
    translate([0.5 * num_x * cell_size + spread,
               num_y * cell_size + 1.5 * spread,
               0])
        color("blue") ledgrid([1, 1, 0, 0]);

    /* Border on right side. */
    translate([0.5 * num_x * cell_size + spread,
              spread / 2,
              0])
        color("blue") ledgrid([0, 1, 0, 0]);

    /* Border on right side and bottom. */
    translate([0.5 * num_x * cell_size + spread,
               -num_y * cell_size - spread / 2,
               0])
        color("blue") ledgrid([0, 1, 1, 0]);

    /* Border on bottom. */
    translate([-0.5 * num_x * cell_size,
               -num_y * cell_size - spread / 2,
               0])
        color("blue") ledgrid([0, 0, 1, 0]);

    /* Border on bottom and left side. */
    translate([-1.5 * num_x * cell_size - spread,
               -num_y * cell_size - spread / 2,
               0])
        color("blue") ledgrid([0, 0, 1, 1]);

    /* Border on left side. */
    translate([-1.5 * num_x * cell_size - spread,
               spread / 2,
               0])
        color("blue") ledgrid([0, 0, 0, 1]);

    /* No borders. */
    translate([-0.5 * num_x * cell_size,
               spread / 2,
               0])
        color("blue") ledgrid([0, 0, 0, 0]);

    /* Border all around. */
    translate([-2.5 * num_x * cell_size - 2 * spread - 2 * tab_w,
               -2 * num_y * cell_size - 1.5 * spread - 2 * tab_w,
               0])
        color("blue") ledgrid([1, 1, 1, 1]);

    /* Border on top, bottom and left side. */
    translate([-1.5 * num_x * cell_size - spread,
               -2 * num_y * cell_size - 1.5 * spread - 2 * tab_w,
               0])
        color("blue") ledgrid([1, 0, 1, 1]);

    /* Border on top and bottom. */
    translate([-0.5 * num_x * cell_size,
               -2 * num_y * cell_size - 1.5 * spread - 2 * tab_w,
               0])
        color("blue") ledgrid([1, 0, 1, 0]);

    /* Border on left and right side. */
    translate([0.5 * num_x * cell_size + spread + tab_w,
               -2 * num_y * cell_size - 1.5 * spread - 2 * tab_w,
               0])
        color("blue") ledgrid([ 0, 1, 0, 1]);

    /* Border on top, bottom and right side. */
    translate([1.5 * num_x * cell_size + 2 * spread + 2 * tab_w,
               -2 * num_y * cell_size - 1.5 * spread - 2 * tab_w,
               0])
        color("blue") ledgrid([1, 1, 1, 0]);
}

/*****************************************************************************\
 * Module code starts here.                                                  *
\*****************************************************************************/

/*
 * Create a trapezoid object for cutting out the PCB gates from a row of
 * num_cells cells.
 */
module gate(num_cells)
{
    /*
     * Length of object. cell_size already includes the width of one wall,
     * so we have to account for the one wall added for closing the grid.
     */
    len = num_cells * cell_size + wall_t;

    points = [
        [0,               0,   0     ], // 0
        [gate_w,          0,   0     ], // 1
        [gate_w,          len, 0     ], // 2
        [0,               len, 0     ], // 3
        [gate_h,          0,   gate_h], // 4
        [gate_w - gate_h, 0,   gate_h], // 5
        [gate_w - gate_h, len, gate_h], // 6
        [gate_h,          len, gate_h], // 7
    ];
    faces = [
        [0, 1, 2, 3], // bottom
        [4, 5, 1, 0], // front
        [7, 6, 5, 4], // top
        [5, 6, 2, 1], // right
        [6, 7, 3, 2], // back
        [7, 4, 0, 3], // left
    ];

    /* Center object along the y axis. */
    translate([-gate_w / 2, 0, 0]) polyhedron(points, faces);
}

/* Create and position a gate cut object for each row and column. */
module gates()
{
    for(x=[0:num_x - 1]){
        translate([x * cell_size + (cell_size + wall_t) / 2, 0, 0])
            gate(num_y);
    }

    for(y=[0:num_y - 1]){
        translate([0, y * cell_size + (cell_size + wall_t) / 2, 0])
            rotate([0, 0, 270]) gate(num_x);
    }
}

/*
 * Create an object for removing a cell's border. We also want to give
 * the adjacent cells a tapered corner, so two modules can slide together
 * and have their walls line up straight.
 */
module cut()
{
    points = [
        [0 , 0, 0],                                              // 0
        [cell_size + wall_t + cut_clr, 0, 0],                    // 1
        [cell_size + cut_clr / 2, wall_t + cut_clr / 2,  0],     // 2
        [wall_t + cut_clr / 2 , wall_t + cut_clr / 2, 0],        // 3
        [0, 0, wall_h],                                          // 4
        [cell_size + wall_t + cut_clr, 0, wall_h],               // 5
        [cell_size + cut_clr / 2, wall_t + cut_clr / 2, wall_h], // 6
        [wall_t + cut_clr / 2, wall_t + cut_clr / 2, wall_h],    // 7
    ];
    faces = [
        [0, 1, 2, 3], // bottom
        [4, 5, 1, 0], // front
        [7, 6, 5, 4], // top
        [5, 6, 2, 1], // right
        [6, 7, 3, 2], // back
        [7, 4, 0, 3], // left
    ];

    translate([-(cell_size + wall_t + cut_clr) / 2, -wall_t / 2, -wall_h / 2])
    	polyhedron(points, faces);
}

/*
 * Use the cut() object to remove every second cell's wall on non-border edges.
 */
module cuts(borders = [0, 0, 0, 0])
{
    /* Top border */
    if(!borders[0]){
        /*
	 * We need to over-/under-shoot by by one cell so the adjacent
	 * border's end will be tapered. Otherwise the borders will prevent
	 * modules from sliding into each other.
         */
        for(x=[-1:2:num_x]){
            translate([x * cell_size + (cell_size +wall_t) / 2,
                       num_y * cell_size + wall_t / 2,
                       wall_h / 2])
                rotate([180, 0, 0]) cut();
        }
    }

    /* Right border */
    if(!borders[1]){
        for(y=[-1:2:num_y]){
            translate([num_x * cell_size + wall_t / 2,
                       y * cell_size + (cell_size + wall_t) / 2,
                       wall_h / 2])
                rotate ([0, 0, 90]) cut();
        }
    }

    /* Bottom border */
    if(!borders[2]){
        for(x=[0:2:num_x]){
            translate([x * cell_size + (cell_size + wall_t)/ 2,
                       wall_t / 2,
                       wall_h / 2])
                rotate([0, 0, 0]) cut();
        }
    }

    /* Left border */
    if(!borders[3]){
        for(y=[0:2:num_y]){
            translate([wall_t / 2,
                       y * cell_size + (cell_size + wall_t) / 2,
                       wall_h / 2])
                rotate ([0, 0, 270]) cut();
        }
    }
}

/* Create the dividing and border walls. */
module grid()
{
    for(x=[0:num_x]){
        translate([x * cell_size, 0, 0])
            cube(size=[wall_t, num_y * cell_size + wall_t,  wall_h],
	         center=false);
    }

    for(y=[0:num_y]){
        translate([0, y * cell_size, 0])
            cube(size=[num_x * cell_size + wall_t, wall_t, wall_h],
	         center=false);
    }
}

/* Create a single screw tab. */
module tab()
{
    difference(){
        union(){
            translate([0, wall_t + tab_w / 2, 0])
                cylinder(h = tab_h, d = tab_w, center = false, $fn = 16);
            translate([-tab_w / 2, 0, 0])
                cube(size=[tab_w, wall_t + tab_w / 2, tab_h]);
        }
        translate([0, wall_t + tab_w / 2, 0])
            cylinder(h = tab_h, d = tab_w / 2, center = false, $fn = 16);
    }
}

/* Add screw tabs to module borders. */
module tabs(borders = [0, 0, 0, 0])
{
    /* Top */
    if(borders[0]){
        translate([cell_size + wall_t / 2, num_y * cell_size, 0])
            tab();

        translate([(num_x - 1) * cell_size + wall_t / 2, num_y * cell_size, 0])
            tab();
    }

    /* Right */
    if(borders[1]){
        translate([num_x * cell_size,
                  (num_y - 1) * cell_size + wall_t / 2,
                  0])
            rotate([0, 0, 270]) tab();

        translate([num_x * cell_size,
                  cell_size + wall_t / 2,
                  0])
            rotate([0, 0, 270]) tab();
    }

    /* Bottom */
    if(borders[2]){
        translate([cell_size + wall_t / 2, wall_t, 0])
            rotate([0, 0, 180]) tab();

        translate([(num_x - 1) * cell_size + wall_t / 2, wall_t, 0])
            rotate([0, 0, 180]) tab();
    }

    /* Left */
    if(borders[3]){
        translate([wall_t,
                  (num_y - 1) * cell_size + wall_t / 2,
                  0])
            rotate([0, 0, 90]) tab();

        translate([wall_t,
                  cell_size + wall_t / 2,
                  0])
            rotate([0, 0, 90]) tab();
    }
}

module drill() {
    union() {
        translate([0, 0, - h_drill])
            cylinder($fn=36, d=m_drill, h=h_drill);
        translate([0, 0, - h_nut])
            rotate(30)
                cylinder($fn=6, d=e_nut, h=h_nut);
    };
}

module drills(borders = [0,0,0,0]) {
    
    /* Top */
    for(j=[0:3]) {        
        if(borders[j]){
            rotate(j * 90) {
                if(j%2) {
                    translate([- (num_y - 0.5) * cell_size /2, num_x * cell_size / 2 + brim_w / 2, brim_h]) {
                        for(i=[0:num_drill - 1]) {
                            translate([(num_y - 0.5) * cell_size / (num_drill - 1) * i,0,0])
                                drill();
                        }
                    };
                    
                } else {
                    translate([- (num_x - 0.5) * cell_size /2, num_y * cell_size / 2 + brim_w / 2, brim_h]) {
                        for(i=[0:num_drill - 1]) {
                            translate([(num_x - 0.5) * cell_size / (num_drill - 1) * i,0,0])
                                drill();
                        }
                    };
                }
            };
        }
    }
    
}

module brims(borders = [0,0,0,0]) {  
    
    /* Top */
    if(borders[0]){
        // offset corner left        
        brim_offs = borders[3] ? wall_t + brim_w : - cut_clr / 2 + wall_t ;
        // add corner right
        brim_add = borders[1] ? 0 : - cut_clr / 2 - wall_t;
        translate([wall_t - brim_offs, num_y * cell_size + wall_t, 0]) {        
            cube(size=[num_x * cell_size + brim_offs + brim_add, brim_w , brim_h]);
        };
    }    
    
    /* Right */
    if(borders[1]){
        // offset corner bottom        
        brim_offs = borders[2] ? wall_t : - cut_clr / 2;
        // add corner top        
        brim_add = borders[0] ? brim_w : - cut_clr / 2 ;
        
        
        translate([num_x * cell_size + wall_t, wall_t - brim_offs, 0]) {
            cube(size=[brim_w , num_y * cell_size + brim_offs + brim_add, brim_h]);
        };
    }
    
    /* Bottom */
    if(borders[2]){
        // offset corner left
        brim_offs = borders[3] ? 0 : - cut_clr / 2 ;
        // add corner right
        brim_add = borders[1] ? wall_t + brim_w : - cut_clr /2;
        translate([- brim_offs, - brim_w, 0]) {
            cube(size=[num_x * cell_size + brim_add + brim_offs, brim_w, brim_h]);
        };
    }
    
    /* Left */
    if(borders[3]){
        // offset corner bottom
        brim_offs = borders[2] ? brim_w : 0;
        // add corner top
        brim_add = borders[0] ? wall_t : - cut_clr / 2;
        translate([- brim_w, -brim_offs, 0]) {
            cube(size=[brim_w , num_y * cell_size + brim_add + brim_offs, brim_h]);
        };
    }
}

/*
 * Finally, behold the glory of the complete LED grid! I love it when a
 * plan comes together.
 */
module ledgrid(borders = [1, 1, 1, 1])
{
    difference() {
        grid();
        gates();
        cuts(borders);
    }
    if(tab_h != 0 && tab_w != 0){
        tabs(borders);
    }	
	
    difference() {
        brims(borders);
        translate([num_x * cell_size / 2 + wall_t / 2, num_y * cell_size / 2 + wall_t / 2, 0])
        // center of grid
            drills(borders);
    };
}

