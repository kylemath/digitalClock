// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 66;      // Optimized smaller base
base_length = 38;     // Adjusted proportionally
base_height = 10;     // Increased by 25% from 25mm

// Updated 7-Segment Display Parameters
segment_h_length = 24;    // Increased horizontal length for wider number
segment_width = 6;        // Keep wider segments

// Add diffuser parameters
diffuser_height = 1;

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

// LED Strip Channel with wire channels - centered
module led_channel() {
    // Main channel exactly 10mm wide plus tolerance
    translate([-base_width/2 , -strip_width/2 - tolerance/2, -base_height/2])
        cube([base_width, strip_width + tolerance, strip_height + tolerance]);
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

// Base with LED channel, cavities, 
module base() {
    difference() {
        // Main block
        cube([base_width, base_length, base_height], center=true);             
        // LED channel
        led_channel();
        // Light pipe cavities
        all_cavities(false);  // Use same paths for actual cavities
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

// Diffuser layer module
module diffuser_layer() {
    color("White", alpha=0.2)  // Semi-transparent to visualize
    translate([0, 0, base_height/2])  // Changed to sit directly on base
        cube([base_width, base_length, diffuser_height], center=true);
}

// Render just the paths in red with slight transparency
// all_cavities(true);  // Show paths
union() {
   base();
   //diffuser_layer();
}
   
