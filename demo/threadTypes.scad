include<../tools/tools.scad>


// Thread types

// Standard
translate([0,10,11])
rotate([0,180,0])
screw(default_major_diameter, default_thread_pitch, 60, default_thread_type, default_fastener_length, default_thread_length, default_head_height);

// Acme threads CHONKY!
screw(default_major_diameter, default_thread_pitch, 50, THREAD_TYPE_ACME, default_fastener_length, default_thread_length, default_head_height);
