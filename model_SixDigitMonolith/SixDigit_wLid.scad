// Copy all content from SixDigit.scad
include <SixDigit.scad>

// Add lid parameters
wall_thickness = 2;
lid_height = 3;
lid_leg_offset = 7;
screw_head_diameter = 10;  // For countersink
screw_head_height = 3;     // Countersink depth
mounting_hole_diameter = 3.2;  // For M3 screws
grating_size = 5.5;        // 5mm LED + 0.5mm tolerance
grating_spacing = 10;      // 10mm between LED centers
grating_border = 10;       // Border from edges
lid_fit_tolerance = 1;     // Gap between lid walls and clock body
power_cutout_width = 15;   // Width of power cable cutout
side_wall_height = 20;     // Height of the side walls

// Add the back_lid module
module back_lid() {
    difference() {
        union() {
            // Main lid body
            cube([base_length, total_base_width + base_width*2, lid_height], center=true);
            
            // Left wall
            translate([-base_length/2 + wall_thickness/2, 0, side_wall_height/2 - lid_height/2]) {
                difference() {
                    cube([wall_thickness, 
                          total_base_width + base_width*2, 
                          side_wall_height], center=true);
                    
                    // Cutouts for leg clearance
                    for (y = [-base_width*2, -base_width*1, base_width-support_width, base_width*3.5]) {
                        translate([0, y, -side_wall_height/4])
                            cube([wall_thickness*2, leg_width*2, side_wall_height/2], center=true);
                    }
                }
            }
            
            // Right wall
            translate([base_length/2 - wall_thickness/2, 0, side_wall_height/2 - lid_height/2]) {
                difference() {
                    cube([wall_thickness, 
                          total_base_width + base_width*2, 
                          side_wall_height], center=true);
                    
                    // Cutouts for leg clearance
                    for (y = [-base_width*2, -base_width*1, base_width-support_width, base_width*3.5]) {
                        translate([0, y, -side_wall_height/4])
                            cube([wall_thickness*2, leg_width*2, side_wall_height/2], center=true);
                    }
                    
                    // Power cable cutout
                    translate([0, 0, side_wall_height/4])
                        cube([wall_thickness*2, power_cutout_width, side_wall_height/2], center=true);
                }
            }
            
            // Front wall
            translate([0, -(total_base_width + base_width*2)/2 + wall_thickness/2, side_wall_height/2 - lid_height/2])
                cube([base_length, wall_thickness, side_wall_height], center=true);
            
            // Back wall
            translate([0, (total_base_width + base_width*2)/2 - wall_thickness/2, side_wall_height/2 - lid_height/2])
                cube([base_length, wall_thickness, side_wall_height], center=true);
            
            // Add leg holes with press-fit attachments
            for (y = [-base_width*2, -base_width*1, base_width-support_width, base_width*3.5]) {
                for (x = [-base_width/2 - leg_width/2, base_width/2 - leg_width/2]) {
                    translate([x, y, -side_wall_height/2 + 10])
                        leg_attachment();
                }
            }
        }
        
        // Screw holes with countersinks
        for (y = [-base_width*2, -base_width*1, base_width-support_width, base_width*3.5]) {
            for (x = [-base_width/2 - leg_width/2, base_width/2 - leg_width/2]) {
                translate([x, y, 0]) {
                    cylinder(d=mounting_hole_diameter, h=lid_height*3, center=true, $fn=20);
                    translate([0, 0, -lid_height/2])
                        cylinder(d2=mounting_hole_diameter, d1=screw_head_diameter, h=screw_head_height, center=true, $fn=20);
                }
            }
        }
        
        // Ventilation grating pattern
        for(x = [-base_length/2 + grating_border : grating_spacing : base_length/2 - grating_border]) {
            for(y = [-(total_base_width + base_width*2)/2 + grating_border : grating_spacing : (total_base_width + base_width*2)/2 - grating_border]) {
                translate([x, y, 0])
                    cube([grating_size, grating_size, lid_height + 1], center=true);
            }
        }
    }
}

// Add leg_attachment module
module leg_attachment() {
    difference() {
        hull() {
            translate([0, 0, 0])
                cube([leg_width + wall_thickness*2, 
                      leg_width + wall_thickness*2, 
                      0.1], center=true);
            translate([0, 0, support_height])
                cube([leg_width + wall_thickness*2 + lid_fit_tolerance, 
                      leg_width + wall_thickness*2 + lid_fit_tolerance, 
                      0.1], center=true);
        }
        
        hull() {
            translate([0, 0, -0.05])
                cube([leg_width + lid_fit_tolerance,
                      leg_width + lid_fit_tolerance,
                      0.1], center=true);
            translate([0, 0, support_height + 0.05])
                cube([leg_width + lid_fit_tolerance * 1.5,
                      leg_width + lid_fit_tolerance * 1.5,
                      0.1], center=true);
        }
    }
}

// Main rendering
rotate([0, 0, 45])     // 45 degree rotation around Z axis
    rotate([180, 0, 0]) { // Flip upside down
        // Render the clock
        union() {
            color("Yellow", alpha=0.9) {
                difference() {
                    union() {
                        // Existing digits and colon
                        single_digit(-base_width*1.375 - colon_spacing/2, 2);
                        single_digit(-base_width*0.375 - colon_spacing/2, 0);
                        translate([0, 0, 0])
                            colon_base();
                        single_digit(base_width*0.375 + colon_spacing/2, 0);
                        single_digit(base_width*1.375 + colon_spacing/2, 0);
                        translate([0, base_width*2.25, 0])
                            colon_base();
                        single_digit(base_width*2.125 + colon_spacing + colon_spacing/2, 0);
                        single_digit(base_width*3.125 + colon_spacing + colon_spacing/2, 1);
                    }
                }
            }
        }
        
        // Add the lid - moved up and to the side
        translate([base_length/2 + 5, 100, base_height + 10]) {
            rotate([180, 0, 0])  // Flip upside down
            color("Blue", alpha=0.3) {
                back_lid();
            }
        }
    } 