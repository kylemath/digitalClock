// Parameters for the LED strip
led_strip_width = 10;  // Width of the LED strip
led_height = 2;        // Typical height of LED strip
led_module_size = 5;   // Size of individual LED modules
led_spacing = 10;      // Space between LED modules
tolerance = 1;         // Tolerance for fitting

// Sphere parameters
sphere_diameter = 100;  // You can adjust this for desired size
shell_thickness = 2;    // Thickness of sphere wall
channel_depth = led_height + tolerance;
cutout_depth = channel_depth + 1; // Make cutouts slightly deeper than channel

// Calculate number of LEDs that fit around the sphere
circumference = PI * sphere_diameter;
num_leds = floor(circumference / led_spacing);

difference() {
    // Main sphere
    sphere(d=sphere_diameter);
    
    // Hollow interior (keeping outer shell for LED channel)
    sphere(d=sphere_diameter - (channel_depth + shell_thickness)*2);
    
    // Channel for LED strip
    rotate_extrude() {
        translate([sphere_diameter/2 - channel_depth/2, 0, 0])
        square([channel_depth, led_strip_width + tolerance*2], center=true);
    }
    
    // LED module cutouts
    for (i = [0:num_leds-1]) {
        angle = i * (360/num_leds);
        rotate([0, 0, angle])
        translate([sphere_diameter/2 - cutout_depth, 0, 0])
        rotate([0, 90, 0])
        linear_extrude(height=cutout_depth)
        square([led_module_size + tolerance*2, led_module_size + tolerance*2], center=true);
    }
}