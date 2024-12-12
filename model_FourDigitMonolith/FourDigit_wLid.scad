// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.8;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 39.5;      // Optimized smaller base
base_length = 68;     // Adjusted proportionally
base_height = 15;     // Increased by 25% from 25mm
base_space = 4;
// Updated 7-Segment Display Parameters
segment_h_length = 24;    // Increased horizontal length for wider number
segment_width = 6;        // Keep wider segments

// Add diffuser parameters
diffuser_height = .56;

// Add support parameters
support_height = 8;        // Height from wall to LED strip
support_width = 13;         // Thickness of support posts
support_beam_height =10;   // Thickness of connecting beams

// vertical strip offset; // distance of strip from the center of the base
vertical_strip_offset = 15;

// Define LED positions globally
led1 = [-1.5 * led_spacing, -vertical_strip_offset];  // LED1 - 15mm left from center
led2 = [-0.5 * led_spacing, -vertical_strip_offset];  // LED2 - 5mm left from center
led3 = [0.5 * led_spacing, -vertical_strip_offset];   // LED3 - 5mm right from center
led4 = [1.5 * led_spacing, -vertical_strip_offset];   // LED4 - 15mm right from center
led5 = [-1.5 * led_spacing, vertical_strip_offset];   // LED5
led6 = [-0.5 * led_spacing, vertical_strip_offset];   // LED6
led7 = [0.5 * led_spacing, vertical_strip_offset];    // LED7
led8 = [1.5 * led_spacing, vertical_strip_offset];    // LED8

// Define segment positions globally - Wide and squished
seg_f = [-15, 14];     // F (top left vertical) - moved outward
seg_e = [-15, -14];    // E (bottom left vertical) - moved outward
seg_a = [0, 29];      // A (top horizontal) - same height
seg_g = [0, 0];       // G (middle horizontal) - unchanged
seg_b = [15, 15];      // B (top right vertical) - moved closer
seg_c = [15, -15];     // C (bottom right vertical) - moved closer
seg_d = [0, -29];     // D (bottom horizontal) - moved closer

// Update colon parameters
colon_width = base_length;  // Same as digit length
colon_height = base_height;
colon_depth = base_width/2;  // Make it thinner than digits

// Define LED and dot positions for colon
colon_led1 = [-.5 * led_spacing, vertical_strip_offset];   // Top dot LED
colon_led2 = [.5 * led_spacing, vertical_strip_offset];   // Second LED
colon_led3 = [-.5 * led_spacing, -vertical_strip_offset];   // Third LED
colon_led4 = [.5 * led_spacing, -vertical_strip_offset];  // Bottom LED

// Define dot positions (positioned for visual appearance)
colon_dot1 = [0, 16];      // Top dot
colon_dot2 = [0, 0];       // Center dot
colon_dot3 = [0, -16];     // Bottom dot
colon_dot4 = [0, -29];     // Decimal - aligned with segment_d position

// Add spacing for colon
colon_spacing = base_width/2;  // Match the colon_depth
total_base_width = (base_width * 4) + colon_spacing;  // Updated to include colon space

side_addon = 13.5;
clip_space = 4.5;

// Add new parameters for mounting holes
mounting_hole_diameter = 3.2;  // For M3 screws
mounting_hole_inset = 4;      // Distance from edges
mounting_post_diameter = 7;    // Diameter of screw posts

// Add new parameters for press-fit
press_fit_tolerance = 0.4;  // Adjust this for tighter/looser fit
press_fit_height = 8;      // Height of the press-fit attachments

// Add new parameters for tapered fit
taper_angle = 2;  // Degrees of taper
taper_top_reduction = 0.8;  // Changed from 0.6 to 0.8 for less aggressive taper

// Add parameters for the side walls
side_wall_height = base_height + 2;  // Slightly taller than base height
side_wall_thickness = 2;
side_wall_offset = 2;  // How far the walls stick out from the base

// Add parameter for lid fit tolerance
lid_fit_tolerance = 1;  // Gap between lid walls and clock body

// Add parameters for power plug cutout
power_cutout_width = 15;    // Width of the cutout
power_cutout_offset = 0;    // Offset from center (0 = centered)

// Add keyhole parameters at the top with other parameters
keyhole_large_diameter = 7.14;  // 9/32 inch
keyhole_small_diameter = 3.175; // 1/8 inch
keyhole_spacing = 100;          // 100mm between centers
keyhole_offset_from_edge = 20;  // Distance from back edge

// Add lid parameters right after the mounting hole parameters
wall_thickness = 2;
lid_height = 3;
screw_head_diameter = 10;  // Increased from 6mm to 8mm for wider countersink
screw_head_height = 3;    // Keep same countersink depth

// Add grating parameters at the top with other parameters
grating_size = 5.5;        // 5mm LED + 0.5mm tolerance
grating_spacing = 10;     // 10mm between LED centers
grating_border = 10;     // Border from edges

lid_leg_offset = 7;

// Update the back_lid module
module back_lid() {
    difference() {
        union() {
            // Main lid body - matches base dimensions exactly
            cube([base_length, total_base_width + side_addon * 2, lid_height], center=true);
            
            // Left wall - split into sections to avoid leg holes
            translate([-base_length/2 + side_wall_thickness/2, 0, side_wall_height/2 - 1.5 ]) {
                translate([0, 0, -.5])
                // Middle section
                cube([side_wall_thickness, 
                      total_base_width + side_addon * 2 - support_width*4.8, 
                      side_wall_height - lid_leg_offset], center=true);
                      
                // Top section
                translate([0, (total_base_width + side_addon * 2)/2 - support_width/2 -1, -.5])
                    cube([side_wall_thickness, 
                          support_width + 2, 
                          side_wall_height - lid_leg_offset], center=true);
                          
                // Bottom section
                translate([0, -(total_base_width + side_addon * 2)/2 + support_width/2 +1, -.5])
                    cube([side_wall_thickness, 
                          support_width +2, 
                          side_wall_height - lid_leg_offset], center=true);
            }
            
            // Right wall - split into sections to avoid leg holes
            translate([base_length/2 - side_wall_thickness/2, 0, side_wall_height/2 - 2]) {
                // Middle section
                cube([side_wall_thickness, 
                      total_base_width +  side_addon * 2 - support_width*4.8, 
                      side_wall_height - lid_leg_offset], center=true);
                      
                // Top section
                translate([0, (total_base_width + side_addon * 2)/2 - support_width/2 - 1, 0])
                    cube([side_wall_thickness, 
                          support_width + 2, 
                          side_wall_height - lid_leg_offset +.5], center=true);
                          
                // Bottom section
                translate([0, -(total_base_width + side_addon * 2)/2 + support_width/2 +1, 0])
                    cube([side_wall_thickness, 
                          support_width + 2, 
                          side_wall_height - lid_leg_offset], center=true);
            }
                      
            // Front wall - solid piece
            translate([0, -(total_base_width + side_addon * 2)/2 + side_wall_thickness/2, side_wall_height/2 - 2])
                cube([base_length, 
                      side_wall_thickness,
                      side_wall_height - lid_leg_offset], center=true);
                      
            // Back wall - solid piece
            translate([0, (total_base_width + side_addon * 2)/2 - side_wall_thickness/2, side_wall_height/2 - 2])
                cube([base_length, 
                      side_wall_thickness,
                      side_wall_height - lid_leg_offset], center=true);
            
            // Add press-fit attachments for each leg
            // Front right
            translate([-base_length/2 + support_width/2, total_base_width/2-support_width/2-3, -side_wall_height/2 + 10])
                leg_attachment();
            // Front left
            translate([-base_length/2 + support_width/2, -total_base_width/2+support_width/2+3, -side_wall_height/2 + 10])
                leg_attachment();
            // Back left
            translate([base_length/2 - support_width/2, -total_base_width/2+support_width/2+3, -side_wall_height/2 + 10])
                leg_attachment();
            // Back right
            translate([base_length/2 - support_width/2, total_base_width/2-support_width/2-3, -side_wall_height/2 + 10])
                leg_attachment();
        }
        
        // Screw holes aligned with support legs with countersinks on bottom
        // Front right
        translate([-base_length/2 + support_width/2, total_base_width/2-support_width/2-3, 0]) {
            cylinder(d=mounting_hole_diameter, h=lid_height + press_fit_height + 1, center=true, $fn=20);
            // Add countersink on bottom
            translate([0, 0, -lid_height/2])  // Position at bottom of lid
                cylinder(d2=mounting_hole_diameter, d1=screw_head_diameter, h=screw_head_height, center=true, $fn=20);
        }
        // Front left
        translate([-base_length/2 + support_width/2, -total_base_width/2+support_width/2+3, 0]) {
            cylinder(d=mounting_hole_diameter, h=lid_height + press_fit_height + 1, center=true, $fn=20);
            // Add countersink on bottom
            translate([0, 0, -lid_height/2])
                cylinder(d2=mounting_hole_diameter, d1=screw_head_diameter, h=screw_head_height, center=true, $fn=20);
        }
        // Back left
        translate([base_length/2 - support_width/2, -total_base_width/2+support_width/2+3, 0]) {
            cylinder(d=mounting_hole_diameter, h=lid_height + press_fit_height + 1, center=true, $fn=20);
            // Add countersink on bottom
            translate([0, 0, -lid_height/2])
                cylinder(d2=mounting_hole_diameter, d1=screw_head_diameter, h=screw_head_height, center=true, $fn=20);
        }
        // Back right
        translate([base_length/2 - support_width/2, total_base_width/2-support_width/2-3, 0]) {
            cylinder(d=mounting_hole_diameter, h=lid_height + press_fit_height + 1, center=true, $fn=20);
            // Add countersink on bottom
            translate([0, 0, -lid_height/2])
                cylinder(d2=mounting_hole_diameter, d1=screw_head_diameter, h=screw_head_height, center=true, $fn=20);
        }
        
        // Square grating pattern - skip outer rows
        for(x = [-20:grating_spacing:20]) {  // Changed from -30:grating_spacing:30
            for(y = [-20:grating_spacing:20]) {
                translate([x, y, 0])
                    cube([grating_size, grating_size, lid_height + 1], center=true);
            }
        }
        
        // Add power plug cutout in right wall (adjusted position for flush wall)
        translate([base_length/2 - side_wall_thickness/2, 
                  power_cutout_offset-2,
                  side_wall_height/4 + 4])
            rotate([0, 90, 0])
            cube([side_wall_height - 5,  // Adjusted height to match new wall height
                  power_cutout_width + 5.5, 
                  side_wall_thickness * 2], center=true);

        // Add keyhole cutouts
        // Left keyhole
        translate([-15, 50, 0]) {
            // Large circle
            cylinder(d=keyhole_large_diameter, h=lid_height*2, center=true, $fn=30);
            // Small slot above
            translate([-keyhole_large_diameter/1.66, 0, 0])
                cylinder(d=keyhole_small_diameter, h=lid_height*2, center=true, $fn=20);
        }
        
        // Right keyhole
        translate([-15, -50, 0]) {
            // Large circle
            cylinder(d=keyhole_large_diameter, h=lid_height*2, center=true, $fn=30);
            // Small slot above
            translate([-keyhole_large_diameter/1.66  , 0, 0])
                cylinder(d=keyhole_small_diameter, h=lid_height*2, center=true, $fn=20);
        }
    } 
}   



// Update leg_attachment module for more gradual taper
module leg_attachment() {
    difference() {
        // Outer shell - slight taper
        hull() {
            // Bottom - larger
            translate([0, 0, 0])
                cube([support_width + wall_thickness*2, 
                      support_width + wall_thickness*2, 
                      0.1], center=true);
            // Top - slightly smaller
            translate([0, 0, support_height])
                cube([support_width + wall_thickness*2 + press_fit_tolerance, 
                      support_width + wall_thickness*2 + press_fit_tolerance, 
                      0.1], center=true);
        }
        
        // Inner cutout - more gradual taper
        hull() {
            // Bottom - larger hole
            translate([0, 0, -0.05])
                cube([support_width + press_fit_tolerance,  // Changed from using taper_top_reduction
                      support_width + press_fit_tolerance,
                      0.1], center=true);
            // Top - slightly larger
            translate([0, 0, support_height + 0.05])
                cube([support_width + press_fit_tolerance * 1.5,  // More gradual increase
                      support_width + press_fit_tolerance * 1.5,
                      0.1], center=true);
        }
    }
}


union() {
    // Main clock part - move less to the left
    translate([-base_length/2 - 5, 0, 0]) {  // Changed from -base_length - 10 to -base_length/2 - 5
        union() {
            color("Yellow", alpha=0.9) {
                difference() {
                    union() {
                        // Existing digits and colon
                        single_digit(-base_width*1.5 - colon_spacing/2);
                        single_digit(-base_width*0.5 - colon_spacing/2);
                        translate([0, 0, 0])
                            colon_base();
                        single_digit(base_width*0.5 + colon_spacing/2);
                        single_digit(base_width*1.5 + colon_spacing/2);
                        
                        // Support posts
                        support_post(-base_length/2 +support_width/2, total_base_width/2-support_width/2-3);    // Front right
                        support_post(-base_length/2 +support_width/2, -total_base_width/2+support_width/2+3);   // Front left
                        support_post(base_length/2 -support_width/2, -total_base_width/2+support_width/2+3);    // Back left
                        support_post(base_length/2 -support_width/2, total_base_width/2-support_width/2-3);     // Back right
                        
                        // Add left extension block with LED channel
                        difference() {
                            translate([0, -total_base_width/2 - side_addon/2, 0])
                                cube([base_length, side_addon, base_height], center=true);
                            // LED channel cutout
                            translate([vertical_strip_offset-strip_width/2 - tolerance/2 - clip_space/2, -total_base_width/2 - side_addon + 2, -base_height/2])
                                cube([strip_width + tolerance + clip_space, side_addon, strip_height + tolerance + 10]);
                            translate([-vertical_strip_offset-strip_width/2 - tolerance/2 -clip_space/2, -total_base_width/2 - side_addon + 2, -base_height/2])
                                cube([strip_width + tolerance + clip_space *4.4, side_addon, strip_height + tolerance + 10]);
                            
                            // LED channel cutouts for side addon
                            translate([vertical_strip_offset-strip_width/2 - tolerance/2 - clip_space/2, -total_base_width/2 - side_addon + 2, -base_height/2])
                                cube([strip_width + tolerance + clip_space, side_addon, strip_height + tolerance + 2]);
                            translate([-vertical_strip_offset-strip_width/2 - tolerance/2 -clip_space/2, -total_base_width/2 - side_addon + 2, -base_height/2])
                                cube([strip_width + tolerance + clip_space *4.4, side_addon, strip_height + tolerance + 2]);


                            translate([-vertical_strip_offset-strip_width/2 - tolerance/2 -clip_space/2, -total_base_width/2 - side_addon + 2, -base_height/2])
                                rotate([0, 90,0])
                                cube([strip_width + tolerance + clip_space *4.4, side_addon, strip_height + tolerance + 2]);
                            

                        }
                        
                        // Add right extension block with LED channel
                        difference() {
                            translate([0, total_base_width/2 + side_addon/2, 0])
                                cube([base_length, side_addon, base_height], center=true);
                            // LED channel cutout
                            translate([vertical_strip_offset-strip_width/2 - tolerance/2 - clip_space/2, total_base_width/2, -base_height/2])
                                cube([strip_width + tolerance + clip_space, 10, strip_height + tolerance + 10]);
                            translate([-vertical_strip_offset-strip_width/2 - tolerance/2 -clip_space/2, total_base_width/2, -base_height/2])
                                cube([strip_width + tolerance + clip_space*4.4, 10, strip_height + tolerance+10]);
                        }
                    }
                }
            }
            color("Green", alpha=0.6) {
                translate([0, 0, base_height/2])
                    translate([0, 0, diffuser_height/2])
                    cube([base_length, total_base_width + side_addon * 2, diffuser_height], center=true);
            }
        }
    }
    
    // Lid - back to original position beside clock
        // translate([-base_length/2 - 5, 0, -20]) {  // Position directly above clock
    translate([base_length/2 + 5, 0, side_wall_height/2 - lid_height + 1]) {
        rotate([180, 0, 0])  // Flip upside down
        color("Blue", alpha=0.3) {
            back_lid();
        }
    }
}

// Use the cropped version with your transformations
rotate([270,90,0])
    translate([8,26,0])
    rotate([0,90,0])
        // rotate([0,0,90])
        scale([1, 1, 1.5])
            translate([0,.5,.5])
            d1_mini_cropped();
// All light cavities with corrected segment positions and mirroring
module all_cavities(visualization=false) {
    rotate([0, 0, 90]) {
        // Light paths
        light_cavity(led1, seg_e, false);   // LED2 → E (vertical)
        light_cavity(led2, seg_g, true);    // LED6 → D (horizontal)
        light_cavity(led3, seg_d, true);   // LED1 → F (vertical)
        light_cavity(led4, seg_c, false);    // LED3 → A (horizontal)
        light_cavity(led5, seg_f, false);   // LED6 → C (vertical)
        light_cavity(led6, seg_a, true);    // LED6 → D (horizontal)
        light_cavity(led7, seg_g, true);    // LED4 → G (horizontal)
        light_cavity(led8, seg_b, false);   // LED5 → B (vertical)
    }
}

// Create a module for a single digit
module single_digit(offset_y = 0) {
    translate([0, offset_y, 0]) {
        difference() {
            // Main block
            cube([base_length, base_width, base_height], center=true);             
            // LED channel
            led_channels();
            // Light pipe cavities
            all_cavities(false);
        }
    }
}

// LED Strip Channel with wire channels - centered
module led_channels() {
    // Main channel exactly 10mm wide plus tolerance
    translate([ vertical_strip_offset-strip_width/2 - tolerance/2, -base_width/2 ,-base_height/2])
        cube([ strip_width + tolerance, base_width, strip_height + tolerance]);
            // Main channel exactly 10mm wide plus tolerance
    translate([ -vertical_strip_offset-strip_width/2 - tolerance/2, -base_width/2 ,-base_height/2])
        cube([ strip_width + tolerance, base_width, strip_height + tolerance]);
}

// Single light pipe cavity with elongating shape
module light_cavity(led_pos, segment_pos, is_horizontal=false, is_center=false) {
    z_bottom = -base_height/2 + strip_height;
    z_top = base_height/2;
    total_height = z_top - z_bottom;

    // Bottom (at LED) - small square with centered tolerance
    translate([led_pos[0] - (led_size + tolerance)/2, 
              led_pos[1] - (led_size + tolerance)/2, 
              z_bottom])
        cube([led_size + tolerance, led_size + tolerance, 2]);            
        
    hull() {
        // Bottom (at LED) - small square exactly 5mm
        translate([led_pos[0] - led_size/2, 
                  led_pos[1] - led_size/2, 
                  z_bottom + 2])
            cube([led_size, led_size, 2]);            
        
        // Top (at segment) - full segment shape
        translate([segment_pos[0], segment_pos[1], z_top ]) {
            rotate([0, 0, is_horizontal ? 0 : 90])
                linear_extrude(height=.1)
                    segment(is_center ? segment_h_length*.2 : segment_h_length, segment_width);
        }
    }
}


// Update colon cavity module
module colon_cavity(led_pos, dot_pos) {
    z_bottom = -colon_height/2 + strip_height;
    z_top = colon_height/2;
    
    hull() {
        // Bottom (at LED) - small square
        translate([led_pos[0] - led_size/2, led_pos[1] - led_size/2, z_bottom])
            cube([led_size, led_size, 2]);
            
        // Top (at dot) - circular dot
        translate([dot_pos[0], dot_pos[1], z_top]) {
            linear_extrude(height=.1)
                circle(d=segment_width, $fn=20);
        }
    }
}

// Update colon base module
module colon_base() {
    difference() {
        // Main block
        cube([colon_width, colon_depth, colon_height], center=true);
        
        // LED channel
        translate([ vertical_strip_offset-strip_width/2 - tolerance/2, -colon_depth/2, -colon_height/2])
            cube([ strip_width + tolerance, colon_depth, strip_height + tolerance]);
                 // LED channel
        translate([ -vertical_strip_offset-strip_width/2 - tolerance/2, -colon_depth/2, -colon_height/2])
            cube([ strip_width + tolerance, colon_depth, strip_height + tolerance]);
            
        // Light cavities for all dots
        rotate([0, 0, 90]) {
            colon_cavity(colon_led1, colon_dot1);  // Top dot - angled path
            colon_cavity(colon_led2, colon_dot2);  // Center dot - angled path
            colon_cavity(colon_led3, colon_dot3);  // Bottom dot - angled path
            colon_cavity(colon_led4, colon_dot4);  // Decimal - most angled path
        }   
    }
}

module segment(length, width) {
    // Elongated hexagonal shape
    hull() {
        translate([-length/2 + width/2, 0, 0]) 
            circle(d=width, $fn=6);
        translate([length/2 - width/2, 0, 0])  
            circle(d=width, $fn=6);
    }
}
// Support post module with keyhole mounting slot
module support_post(x_pos, y_pos) {
    difference() {
       hull() {
        // Original post
        translate([x_pos, y_pos, -7.5-support_height])
            cube([support_width - 1.5, support_width - 1.5, 1], center=true);
        translate([x_pos, y_pos, 0])
            cube([support_width, support_width, 1], center=true);
       }
        // Add mounting hole
        translate([x_pos, y_pos, -10])
            cylinder(d=mounting_hole_diameter, h=support_height + 10, center=true, $fn=20);
    }
}


// holder for d1 mini
module d1_mini_cropped() {
    difference() {
        import("./D1Mini_Bottom_part.stl");
        // Cutting cube to remove bottom half
        translate([0, 0, -51])  // Adjust Z position to cut at desired height
            cube([100, 100, 100], center=true);  // Make sure cube is large enough
    }
}

