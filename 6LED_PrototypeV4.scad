// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 72;      // Optimized smaller base
base_length = 42;     // Adjusted proportionally
base_height = 8;     // Increased by 25% from 25mm
wire_channel_length = 10;

// Updated Light pipe parameters
cavity_width_bottom = 3;  
cavity_width_top = 8;    // Increased for better light spread
path_separation = 10;      

// Updated 7-Segment Display Parameters
segment_h_length = 18;    // Increased horizontal length for wider number
segment_v_length = 22;    // Kept reduced vertical length
segment_width = 10;        // Keep wider segments
segment_depth = 0;       // Keep same
segment_spacing = 0;      // Keep tight spacing
x_offset = 16;           // Increased horizontal spread

// Add diffuser parameters
diffuser_height = .6;

// Define LED positions globally
y_offset = -strip_width/4;
led1 = [0, -3.0 * led_spacing + y_offset];  // LED1
led2 = [0,-2.0 * led_spacing + y_offset];  // LED2
led3 = [0,-1.0 * led_spacing + y_offset];  // LED3
led4 = [0,0.0 * led_spacing + y_offset];   // LED4 - Center LED
led5 = [0,1.0 * led_spacing + y_offset];   // LED5
led6 = [0,2.0 * led_spacing + y_offset];   // LED6
led7 = [0,3.0 * led_spacing + y_offset];   // LED7

// Define segment positions globally - Wide and squished
seg_f = [-12, 15];     // F (top left vertical) - moved outward
seg_e = [-12, -15];    // E (bottom left vertical) - moved outward
seg_a = [0, 29];      // A (top horizontal) - same height
seg_g = [0, 0];       // G (middle horizontal) - unchanged
seg_b = [12, 15];      // B (top right vertical) - moved closer
seg_c = [12, -15];     // C (bottom right vertical) - moved closer
seg_d = [0, -29];     // D (bottom horizontal) - moved closer

// LED Strip Channel with wire channels - centered
module led_channel() {
        // Main channel exactly 10mm wide plus tolerance
        translate([-base_width/2 + wire_channel_length, -strip_width/2 - tolerance/2, -base_height/2])
            cube([base_width - 2*wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
        
        // Wire channels same width
        translate([-base_width/2, -strip_width/2 - tolerance/2, -base_height/2])
            cube([wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
        translate([base_width/2 - wire_channel_length, -strip_width/2 - tolerance/2, -base_height/2])
            cube([wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
    
}

// Single light pipe cavity with elongating shape
module light_cavity(led_pos, segment_pos, is_horizontal=false) {
    // Calculate heights for better progression
    z_bottom = -base_height/2 + strip_height;
    z_top = base_height/2 - segment_depth;
    total_height = z_top - z_bottom;
    
    hull() {
        // Bottom (at LED) - small square
        translate([led_pos[0] - led_size/2, led_pos[1], z_bottom])
            cube([led_size, led_size, 2]);
     
            
        // Top (at segment) - full segment shape
        translate([segment_pos[0], segment_pos[1], z_top]) {
            rotate([0, 0, is_horizontal ? 0 : 90])
                linear_extrude(height=2)
                    segment(segment_h_length, is_horizontal ? segment_width : segment_width/4);
        }
    }
    
}

// All light cavities with corrected segment positions and mirroring
module all_cavities(visualization=false) {
    color_alpha = visualization ? ["Red", 0.8] : ["Gold", 1];
    
    color(color_alpha[0], color_alpha[1])
    rotate([0, 0, 90]) {
        y_offset = -strip_width/4;
        
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
        union() {
            // Main block
            cube([base_width, base_length, base_height], center=true);
                        
        }
        
        // LED channel with wire channels
        led_channel();
        // Light pipe cavities
        all_cavities(false);  // Use same paths for actual cavities
        
        // Ensure cavities connect to segments
        translate([0, 0, base_height/2 - segment_depth])
            linear_extrude(height=segment_depth + 1)
                seven_segments();
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

module seven_segments() {
    rotate([0, 0, 90])  // Rotate the entire segment layout 90°
    union() {
        // A (now right horizontal)
        translate([0, segment_v_length + segment_spacing*2, 0]) 
            segment(segment_h_length, segment_width);
        
        // B,F (now top and bottom verticals on right side)
        translate([x_offset, segment_v_length/2 + segment_spacing, 0]) 
            rotate([0,0,90]) 
                segment(segment_v_length, segment_width);  // B
        translate([-x_offset, segment_v_length/2 + segment_spacing, 0]) 
            rotate([0,0,90]) 
                segment(segment_v_length, segment_width);  // F
        
        // G (middle horizontal, now vertical)
        translate([0, 0, 0])
            segment(segment_h_length, segment_width);
        
        // C,E (bottom verticals, now left side horizontals)
        translate([x_offset, -segment_v_length/2 - segment_spacing, 0]) 
            rotate([0,0,90]) 
                segment(segment_v_length, segment_width);  // C
        translate([-x_offset, -segment_v_length/2 - segment_spacing, 0]) 
            rotate([0,0,90]) 
                segment(segment_v_length, segment_width);  // E
        
        // D (now left horizontal)
        translate([0, -segment_v_length - segment_spacing*2, 0]) 
            segment(segment_h_length, segment_width);
    }
}

// Top layer with segment cavities
module segment_layer() {
    color("SteelBlue")
    difference() {
        // Main plate - extended to match base
        translate([0, 0, base_height/2])
            cube([base_width, base_length, segment_depth], center=true);
        
        // Individual segment cavities
        translate([0, 0, base_height/2 - segment_depth/2])
            linear_extrude(height=segment_depth + 1)
                seven_segments();
    }
}

// Diffuser layer module
module diffuser_layer() {
    color("White", alpha=0.2)  // Semi-transparent to visualize
    translate([0, 0, base_height/2])  // Changed to sit directly on base
        cube([base_width, base_length, diffuser_height], center=true);
}

// Render just the paths in red with slight transparency
all_cavities(true);  // Show paths
color("Green", alpha=0.9)
union() {
   base();
   
//   diffuser_layer();
}
   
