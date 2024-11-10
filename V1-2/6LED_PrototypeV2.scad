// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 80;      // Optimized smaller base
base_length = 55;     // Adjusted proportionally
base_height = 30;     // Reduced from 50
wire_channel_length = 10;

// Updated Light pipe parameters
cavity_width_bottom = 3;  
cavity_width_top = 6;
path_separation = 8;      

// Updated 7-Segment Display Parameters
segment_h_length = 30;    // Increased for better visibility
segment_v_length = 30;    // Increased for better visibility
segment_width = 6;
segment_depth = 15;       // Reduced from 20
segment_spacing = 3;
x_offset = 15;           // Adjusted for larger segments

// Add diffuser parameters
diffuser_height = 3;

// LED Strip Channel with wire channels - centered
module led_channel() {
    rotate([0, 0, 90]) {
        // Main channel exactly 10mm wide plus tolerance
        translate([-base_width/2 + wire_channel_length, -strip_width/2 - tolerance/2, -base_height/2])
            cube([base_width - 2*wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
        
        // Wire channels same width
        translate([-base_width/2, -strip_width/2 - tolerance/2, -base_height/2])
            cube([wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
        translate([base_width/2 - wire_channel_length, -strip_width/2 - tolerance/2, -base_height/2])
            cube([wire_channel_length, strip_width + tolerance, strip_height + tolerance]);
    }
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
        
        // Middle transition point - optimized taper
        translate([
            (led_pos[0] + segment_pos[0])/2, 
            (led_pos[1] + segment_pos[1])/2, 
            z_bottom + total_height/2
        ]) {
            rotate([0, 0, is_horizontal ? 0 : 90])
                linear_extrude(height=2)
                    segment(segment_width*2, cavity_width_top*0.8);
        }
            
        // Top (at segment) - full segment shape
        translate([segment_pos[0], segment_pos[1], z_top]) {
            rotate([0, 0, is_horizontal ? 0 : 90])
                linear_extrude(height=2)
                    segment(segment_width*4, segment_width);
        }
    }
}

// All light cavities with corrected segment positions and mirroring
module all_cavities(visualization=false) {
    color_alpha = visualization ? ["Red", 0.8] : ["Gold", 1];
    
    color(color_alpha[0], color_alpha[1])
    rotate([0, 0, 90]) {
        y_offset = -strip_width/4;
        
        // LED positions (x, y)
        led1 = [-25, y_offset];  // LED1
        led2 = [-15, y_offset];  // LED2
        led3 = [-5, y_offset];   // LED3
        led4 = [5, y_offset];    // LED4
        led5 = [15, y_offset];   // LED5
        led6 = [25, y_offset];   // LED6
        
        // Segment positions (x, y) - scaled from Python coordinates
        seg_f = [-15, 15];    // F (top left vertical)
        seg_e = [-15, -15];   // E (bottom left vertical)
        seg_a = [0, 36];      // A (top horizontal)
        seg_g = [0, 0];       // G (middle)
        seg_b = [15, 15];     // B (top right vertical)
        seg_c = [15, -15];    // C (bottom right vertical)
        seg_d = [0, -36];     // D (bottom horizontal)
        
        // Light paths
        light_cavity(led1, seg_f, false);   // LED1 → F (vertical)
        light_cavity(led2, seg_e, false);   // LED2 → E (vertical)
        light_cavity(led3, seg_a, true);    // LED3 → A (horizontal)
        light_cavity(led4, seg_g, true);    // LED4 → G (horizontal)
        light_cavity(led5, seg_b, false);   // LED5 → B (vertical)
        light_cavity(led6, seg_c, false);   // LED6 → C (vertical)
        light_cavity(led6, seg_d, true);    // LED6 → D (horizontal)
    }
}

// Base with LED channel and cavities
module base() {
    difference() {
        // Main block
        cube([base_width, base_length, base_height], center=true);
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
//all_cavities(true);  // Show paths
color("Green", alpha=0.9)
union() {
   base();
   diffuser_layer();
}
   
