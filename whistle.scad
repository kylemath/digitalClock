// Import the base whistle
whistle_original = "Whistle_with_ball_eye.STL";

// Parameters for modifications
scale_factor = 1.0;
ridge_count = 3;
ridge_height = 0.5;  // mm
ridge_spacing = 2;   // mm

// Main module for the modified whistle
module modified_whistle() {
    union() {  // Changed from difference() to union()
        // Base whistle
        scale([scale_factor, scale_factor, scale_factor])
            import(whistle_original);
        
        // Ridge pattern - now adding material instead of subtracting
        translate([20, 5, 2])  // Adjust these coordinates to match chamber location
        rotate([0, 0, 0])     // Adjust rotation to align with chamber
        for(i = [0:ridge_count-1]) {
            translate([0, i * ridge_spacing, 0])
            cube([5, ridge_height, 2]);  // Smaller ridges
        }
    }
}

modified_whistle();

// Preview helper (uncomment to help position ridges)
// %translate([20, 5, 2])  // Same translation as above
// rotate([0, 0, 0])      // Same rotation as above
// #cube([5, ridge_count * ridge_spacing, 2]);  // Shows full ridge area