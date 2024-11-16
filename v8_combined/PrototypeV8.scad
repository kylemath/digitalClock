

// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 40;      // Optimized smaller base
base_length = 81;     // Adjusted proportionally
base_height = 15;     // Increased by 25% from 25mm
base_space = 4;
// Updated 7-Segment Display Parameters
segment_h_length = 24;    // Increased horizontal length for wider number
segment_width = 6;        // Keep wider segments

// Add diffuser parameters
diffuser_height = .28;

// Define LED positions globally
led1 = [0, -3.0 * led_spacing];  // LED1
led2 = [0,-2.0 * led_spacing];  // LED2
led3 = [0,-1.0 * led_spacing];  // LED3
led4 = [0,0.0 * led_spacing];   // LED4 - Center LED
led5 = [0,1.0 * led_spacing];   // LED5
led6 = [0,2.0 * led_spacing];   // LED6
led7 = [0,3.0 * led_spacing];   // LED7

// Define segment positions globally - Wide and squished
seg_f = [-15, 14];     // F (top left vertical) - moved outward
seg_e = [-15, -14];    // E (bottom left vertical) - moved outward
seg_a = [0, 29];      // A (top horizontal) - same height
seg_g = [0, 0];       // G (middle horizontal) - unchanged
seg_b = [15, 15];      // B (top right vertical) - moved closer
seg_c = [15, -15];     // C (bottom right vertical) - moved closer
seg_d = [0, -29];     // D (bottom horizontal) - moved closer

// Add spacing for colon
colon_spacing = base_width/3;  // Match the colon_depth
total_base_width = (base_width * 4) + colon_spacing;  // Updated to include colon space

// LED Strip Channel with wire channels - centered
module led_channel() {
    // Main channel exactly 10mm wide plus tolerance
    translate([-base_length/2 , -strip_width/2 - tolerance/2, -base_height/2])
        cube([base_length, strip_width + tolerance, strip_height + tolerance]);
}

// Single light pipe cavity with elongating shape
module light_cavity(led_pos, segment_pos, is_horizontal=false) {
    // Calculate heights for better progression
    z_bottom = -base_height/2 + strip_height;
    z_top = base_height/2;
    total_height = z_top - z_bottom;
    
    hull() {
        // Bottom (at LED) - small square
        translate([led_pos[0] - led_size/2, led_pos[1] - led_size/2, z_bottom])
            cube([led_size, led_size, 2]);
     
            
        // Top (at segment) - full segment shape
        translate([segment_pos[0], segment_pos[1], z_top ]) {
            rotate([0, 0, is_horizontal ? 0 : 90])
                linear_extrude(height=2)
                    segment(segment_h_length, segment_width);
        }
    }
    
}

// All light cavities with corrected segment positions and mirroring
module all_cavities(visualization=false) {
    
    rotate([0, 0, 90]) {
        // Light paths
        light_cavity(led1, seg_d, true);   // LED1 → F (vertical)
        light_cavity(led2, seg_e, false);   // LED2 → E (vertical)
        light_cavity(led3, seg_c, false);    // LED3 → A (horizontal)
        light_cavity(led4, seg_g, true);    // LED4 → G (horizontal)
        light_cavity(led5, seg_b, false);   // LED5 → B (vertical)
        light_cavity(led6, seg_f, false);   // LED6 → C (vertical)
        light_cavity(led7, seg_a, true);    // LED6 → D (horizontal)
    }
}

// Create a module for a single digit
module single_digit(offset_y = 0) {
    translate([0, offset_y, 0]) {
        difference() {
            // Main block
            cube([base_length, base_width, base_height], center=true);             
            // LED channel
            led_channel();
            // Light pipe cavities
            all_cavities(false);
        }
    }
}

// Update colon parameters
colon_width = base_length;  // Same as digit length
colon_height = base_height;
colon_depth = base_width/3;  // Make it thinner than digits

// Define LED and dot positions for colon
colon_led1 = [0, 1.0 * led_spacing];   // Top dot LED
colon_led2 = [0, 0.0 * led_spacing];   // Second LED
colon_led3 = [0, -1.0 * led_spacing];   // Third LED
colon_led4 = [0, -2.0 * led_spacing];  // Bottom LED

// Define dot positions (positioned for visual appearance)
colon_dot1 = [0, 16];      // Top dot
colon_dot2 = [0, 0];       // Center dot
colon_dot3 = [0, -16];     // Bottom dot
colon_dot4 = [0, -29];     // Decimal - aligned with segment_d position

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
            linear_extrude(height=2)
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
        translate([-colon_width/2, -strip_width/2 - tolerance/2, -colon_height/2])
            cube([colon_width, strip_width + tolerance, strip_height + tolerance]);
            
        // Light cavities for all dots
        rotate([0, 0, 90]) {
            colon_cavity(colon_led1, colon_dot1);  // Top dot - angled path
            colon_cavity(colon_led2, colon_dot2);  // Center dot - angled path
            colon_cavity(colon_led3, colon_dot3);  // Bottom dot - angled path
            colon_cavity(colon_led4, colon_dot4);  // Decimal - most angled path
        }


    
    }
}

// Add support parameters
support_height = 20;        // Height from wall to LED strip
support_width = 10;         // Thickness of support posts
support_beam_height =10;   // Thickness of connecting beams
back_cutout_width = total_base_width - (support_width * 2);  // Width between posts
back_cutout_height = support_height - support_beam_height;   // Height of back opening

// Support post module
module support_post(x_pos, y_pos) {
    translate([x_pos, y_pos, -support_height/2 +5])
        cube([support_width, support_width, support_height], center=true);
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

// Update the final union to include both horizontal and vertical beams
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
                support_post(-base_length/2 -5, total_base_width/2 -3);    // Front right
                support_post(-base_length/2 -5, -total_base_width/2 +3);   // Front left
                support_post(base_length/2 +5, -total_base_width/2 +3);    // Back left
                support_post(base_length/2 +5, total_base_width/2 -3);     // Back right
                
                // Horizontal connecting beams
                // connecting_beam(-base_length/2 -5);  // Front beam
                // connecting_beam(base_length/2 +5);   // Back beam
                
                // Vertical connecting beams
                // vertical_connecting_beam(total_base_width/2 +5);     // Right side beam
                // vertical_connecting_beam(-total_base_width/2 -30);    // Left side beam
            }
        }
    }
    color("Green", alpha=0.6) {
        translate([0, 0, base_height/2])
            translate([0, -16, diffuser_height/2])
            cube([base_length + 20, total_base_width + 36, diffuser_height], center=true);
    }
        color("Black", alpha=0.8) {
        translate([0, 0, base_height/2])
            difference() {
                // Outer surface
                translate([0, -16, -1.5])

                cube([base_length + 20, total_base_width + 36, 3], center=true);
                // Inner cutout
                translate([0, 0, -1.5])
                cube([base_length, total_base_width, 4], center=true); // Slightly thicker to ensure clean cut
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


// Module to center and orient the LED clip at origin
module led_clip() {
    difference() {
    // Center at origin and orient flat
    translate([47.5, 4, -7.5])  // Adjust these values based on your STL's actual dimensions
        rotate([0, 0, 0])  // Reset to natural orientation
            scale([1.1, 1.1, .5])
                import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");
    
    }
}


// Now use it with cleaner transforms
    rotate([90, 0, 90])
    translate([0, 0,  base_length/2 - 9.5])
        led_clip();
    rotate([90, 0, 270])
    translate([0, 0,  base_length/2 - 19.5])
        led_clip();        


    rotate([90, 0, 270])
    translate([-26.5, 0,  base_length/2])
        led_clip(); 
    rotate([90, 0, 270])
    translate([-26.5 - base_width, 0,  base_length/2])
        led_clip(); 
    rotate([90, 0, 270])
    translate([26.5, 0,  base_length/2])
        led_clip(); 
    rotate([90, 0, 270])
    translate([26.5 + base_width, 0,  base_length/2])
        led_clip(); 
rotate([90, 0, 90])
    translate([26.5, 0,  base_length/2])
        led_clip(); 
rotate([90, 0, 90])
    translate([26.5 + base_width, 0,  base_length/2])
        led_clip(); 
rotate([90, 0, 90])
    translate([-26.5, 0,  base_length/2])
        led_clip(); 
rotate([90, 0, 90])
    translate([-26.5 - base_width, 0,  base_length/2])
        led_clip(); 



// holder for d1 mini
rotate([270,90,0])
    translate([-2,-20,-103])
    rotate([0,90,0])
    import("/Users/kylemathewson/Downloads/D1Mini_Bottom_part.stl");



