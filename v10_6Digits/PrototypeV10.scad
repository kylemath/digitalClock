

// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 39.5;      // Optimized smaller base
base_length = 47;     // Adjusted proportionally
base_height = 10;     // Increased by 25% from 25mm

// Updated 7-Segment Display Parameters
segment_h_length = 18;    // Increased horizontal length for wider number
segment_width = 7;        // Keep wider segments

// Add diffuser parameters
diffuser_height = .56;

// Add support parameters
support_height = 8;        // Height from wall to LED strip
support_width = 13;         // Thickness of support posts
support_beam_height =10;   // Thickness of connecting beams

// vertical strip offset; // distance of strip from the center of the base
vertical_strip_offset = 10;

// Define LED positions globally
led1 = [-1.5 * led_spacing, -vertical_strip_offset];  // LED1 - 15mm left from center
led2 = [-0.5 * led_spacing, -vertical_strip_offset];  // LED2 - 5mm left from center
led3 = [0.5 * led_spacing, -vertical_strip_offset];   // LED3 - 5mm right from center
led4 = [1.5 * led_spacing, -vertical_strip_offset];   // LED4 - 15mm right from center
led5 = [-1.5 * led_spacing, vertical_strip_offset];   // LED5
led6 = [-0.5 * led_spacing, vertical_strip_offset];   // LED6
led7 = [0.5 * led_spacing, vertical_strip_offset];    // LED7
led8 = [1.5 * led_spacing, vertical_strip_offset];    // LED8

// Define sgment positions globally - Wide and squished
seg_f = [-12, 10];     // F (top left vertical) - moved outward
seg_e = [-12, -10];    // E (bottom left vertical) - moved outward
seg_a = [0, 20];      // A (top horizontal) - same height
seg_g = [-3.5, 0];       // G (middle horizontal) - unchanged
seg_h = [3.5, 0];       // G (middle horizontal) - unchanged
seg_b = [12, 10];      // B (top right vertical) - moved closer
seg_c = [12, -10];     // C (bottom right vertical) - moved closer
seg_d = [0, -20];     // D (bottom horizontal) - moved closer

// Define dot positions (positioned for visual appearance)
colon_dot1 = [0, 11];      // Top dot
colon_dot3 = [0, -11];     // Bottom dot

// Update colon parameters
colon_width = base_length;  // Same as digit length
colon_height = base_height;
colon_depth = base_width/4;  // Make it thinner than digits

// Define LED and dot positions for colon
colon_led1 = [0 * led_spacing, vertical_strip_offset];   // Top dot LED
colon_led3 = [0 * led_spacing, -vertical_strip_offset];   // Third LED


// Add spacing for colon
colon_spacing = base_width/2;  // Match the colon_depth
total_base_width = (base_width * 4) + colon_spacing;  // Updated to include colon space

side_addon = 13.5;
clip_space = 4.5;

// Update the final union to include both horizontal and vertical beams
union() {
    color("Yellow", alpha=0.9) {
        difference() {
            union() {
                // Existing digits and colon
                single_digit(-base_width*1.375 - colon_spacing/2);
                single_digit(-base_width*0.375 - colon_spacing/2);
                translate([0, 0, 0])
                    colon_base();
                single_digit(base_width*0.375 + colon_spacing/2);
                single_digit(base_width*1.375 + colon_spacing/2);
                translate([0, base_width*2.25, 0])
                    colon_base();
                single_digit(base_width*2.125 + colon_spacing + colon_spacing/2);
                single_digit(base_width*3.125 + colon_spacing + colon_spacing/2);
            
            }
        }
    }
    color("Green", alpha=0.6) {
        translate([0, 0, base_height/2])
            translate([0, base_width + 5, diffuser_height/2])
            cube([base_length, total_base_width +  base_width*2, diffuser_height], center=true);
    }
}

// All light cavities with corrected segment positions and mirroring
module all_cavities(visualization=false) {
    rotate([0, 0, 90]) {
        // Light paths
        light_cavity(led1, seg_e, false, false);   // LED2 → E (vertical)
        light_cavity(led3, seg_d, true, false);   // LED1 → F (vertical)
        light_cavity(led4, seg_c, false, false);    // LED3 → A (horizontal)
        light_cavity(led5, seg_f, false, false);   // LED6 → C (vertical)
        light_cavity(led6, seg_a, true, false);    // LED4 → G (horizontal)
        light_cavity(led8, seg_b, false, false);   // LED5 → B (vertical)

        light_cavity(led2, seg_g, true, true);    // LED6 → D (horizontal)
        light_cavity(led7, seg_h, true, true);    // LED6 → D (horizontal)
        

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
    channel_taper = 1; // How much to narrow the channel at the bottom (in mm)
    channel_height = strip_height + tolerance;
    
    // Left channel
    translate([-vertical_strip_offset-strip_width/2, -base_width/2, -base_height/2]) {
        hull() {
            // Bottom rectangle - narrower width
            translate([channel_taper/2, 0, 0])
                cube([strip_width + tolerance - channel_taper, base_width, 0.1]);
            // Top rectangle - full width
            translate([0, 0, channel_height])
                cube([strip_width + tolerance, base_width, 0.1]);
        }
    }
    
    // Right channel
    translate([vertical_strip_offset-strip_width/2, -base_width/2, -base_height/2]) {
        hull() {
            // Bottom rectangle - narrower width
            translate([channel_taper/2, 0, 0])
                cube([strip_width + tolerance - channel_taper, base_width, 0.1]);
            // Top rectangle - full width
            translate([0, 0, channel_height])
                cube([strip_width + tolerance, base_width, 0.1]);
        }
    }
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
            
        // Top (at dot) - circular dot
        translate([dot_pos[0], dot_pos[1], z_top]) {
            linear_extrude(height=.1)
                circle(d=segment_width, $fn=20);
        }
    }
}

// Update colon base module
module colon_base() {
    channel_taper = 1; // How much to narrow the channel at the bottom (in mm)
    channel_height = strip_height + tolerance;
    
    difference() {
        // Main block
        cube([colon_width, colon_depth, colon_height], center=true);
        
        // Left LED channel
        translate([-vertical_strip_offset-strip_width/2, -colon_depth/2, -colon_height/2]) {
            hull() {
                // Bottom rectangle - narrower width
                translate([channel_taper/2, 0, 0])
                    cube([strip_width + tolerance - channel_taper, colon_depth, 0.1]);
                // Top rectangle - full width
                translate([0, 0, channel_height])
                    cube([strip_width + tolerance, colon_depth, 0.1]);
            }
        }
        
        // Right LED channel
        translate([vertical_strip_offset-strip_width/2, -colon_depth/2, -colon_height/2]) {
            hull() {
                // Bottom rectangle - narrower width
                translate([channel_taper/2, 0, 0])
                    cube([strip_width + tolerance - channel_taper, colon_depth, 0.1]);
                // Top rectangle - full width
                translate([0, 0, channel_height])
                    cube([strip_width + tolerance, colon_depth, 0.1]);
            }
        }
            
        // Light cavities for dots remain unchanged
        rotate([0, 0, 90]) {
            colon_cavity(colon_led1, colon_dot1);
            colon_cavity(colon_led3, colon_dot3);
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
        // Original post
        translate([x_pos, y_pos, -10 ])
            cube([support_width, support_width, support_height], center=true);
        }
}

// New module for connecting beam
module connecting_beam(x_pos) {
    translate([x_pos, 0, -support_height + support_beam_height/2])
        cube([support_width, total_base_width + support_width + 10, support_beam_height], center=true);
}

// Add vertical beam module
module vertical_connecting_beam(y_pos) {
    translate([0, y_pos, -support_height + support_beam_height/2])
        cube([base_length + support_width + 10, support_width, support_beam_height], center=true);
}





// holder for d1 mini
module d1_mini_cropped() {
    difference() {
        difference() {
            difference() {
                scale([1.05, 1.05, .6])
                import("./D1Mini_Bottom_part.stl");

                // Cutting cube to remove bottom half
                translate([0, 0, -50])  
                    cube([100, 100, 100], center=true);
            }
            // // Cut left side
            translate([-64.5, 0, 0])
                cube([100, 100, 100], center=true);
        }
        // Cut right side
        translate([64, 0, 0])
            cube([100, 100, 100], center=true);
    }
}

// Use the cropped version with your transformations
rotate([270,90,0])

    translate([5,-9,-60])
    rotate([0,90,0])
        rotate([0,0,90])

        d1_mini_cropped();
