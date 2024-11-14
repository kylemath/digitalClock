

// WS2812 LED Strip Parameters - verified measurements
led_spacing = 10;      // 10mm between LED centers
strip_width = 10;      // 10mm wide LED strip
strip_height = 2;      // Keep same
tolerance = 0.5;       // Keep same
led_size = 5;         // 5mm square LED cutouts

// Updated Base Parameters
base_width = 40;      // Optimized smaller base
base_length = 80;     // Adjusted proportionally
base_height = 10;     // Increased by 25% from 25mm
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
support_height = 30;        // Height from wall to LED strip
support_width = 8;         // Thickness of support posts
support_beam_height =10;   // Thickness of connecting beams
back_cutout_width = total_base_width - (support_width * 2);  // Width between posts
back_cutout_height = support_height - support_beam_height;   // Height of back opening

// Support post module
module support_post(x_pos, y_pos) {
    translate([x_pos, y_pos, -support_height/2])
        cube([support_width, support_width, support_height], center=true);
}

// Support beam module (now with middle cutout)
module support_beam() {
    // Left beam
    translate([-base_length/4, 0, -support_height + support_beam_height/2])
        cube([base_length/2, total_base_width, support_beam_height], center=true);
    
    // Right beam
    translate([base_length/4, 0, -support_height + support_beam_height/2])
        cube([base_length/2, total_base_width, support_beam_height], center=true);
}

// Update the final union to include supports
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
                
                // Add support structure
                // Corner posts
                support_post(-base_length/2 + support_width/2, -total_base_width/2 + support_width/2);  // Back left
                support_post(-base_length/2 + support_width/2, total_base_width/2 - support_width/2);   // Front left
                support_post(base_length/2 - support_width/2, -total_base_width/2 + support_width/2);   // Back right
                support_post(base_length/2 - support_width/2, total_base_width/2 - support_width/2);    // Front right
                support_post(-base_length/2 +support_width/2, 0 - support_width/2 - strip_width/2);    // Front right
                support_post(base_length/2 - support_width/2, 0 - support_width/2 - strip_width/2);    // Front right
                support_post(-base_length/2 +support_width/2, 0 + support_width/2 + strip_width/2);    // Front right
                support_post(base_length/2 - support_width/2, 0 + support_width/2 + strip_width/2);    // Front right

                // Split horizontal beams
            }
            side_cut("left");
            side_cut("right");
        }
    }
    color("White", alpha=0.2) {
        translate([0, 0, base_height/2 - diffuser_height/2])
            cube([base_length, total_base_width, diffuser_height], center=true);
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
    translate([0, 0, (base_height/2) - diffuser_height/2])  // Changed to sit directly on base
        cube([base_width, base_length, diffuser_height], center=true);
}

// // Render just the paths in red with slight transparency
// //all_cavities(true);  // Show paths
// union() {
//    base();
// //    diffuser_layer();
// }
   



// New module for the intersection shape
module intersection_layer() {
        color("Red", alpha=0.9)  // Semi-transparent to visualize

        intersection() {
            all_cavities(true);
            diffuser_layer();
        };
    } 

// union(){
// Replace the final union() with:
// color("Green", alpha=0.9) {
// side_cut("left");
// side_cut("right");
// }
    union() {
         color("Yellow", alpha=0.9) {

        base();
    
         }
    color("White", alpha=0.2) {
        diffuser_layer();

    }  
    
 }

rotate([-90,0,90])
    translate([74,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([-90,0,90])
    translate([114,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([-90,0,-90])
    translate([74,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");
rotate([-90,0,-90])
    translate([114,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");


rotate([-90,0,90])
    translate([21,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([-90,0,-90])
    translate([21,12.8,40])
        scale([1.1, 1.1, .5])
        import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([90,0,90])
    translate([19,-12.8,40])
        rotate([0,0,180])
            scale([1.1, 1.1, .5])
            import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([-90,900,90])
    translate([19,-12.8,40])
        rotate([0,0,180])
            scale([1.1, 1.1, .5])
            import("/Users/kylemathewson/Downloads/ARGB_solderless_clip_3_wires_1.stl");

rotate([270,180,0])
    translate([40,-70.5,86])
    import("/Users/kylemathewson/Downloads/WEMOS_D1_MINI__MOUNT.stl");


// intersection_layer();
// diffuser_layer();


