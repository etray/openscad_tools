include<../tools/tools.scad>

//
// fastener demo
// - Easily adjust parameters to achieve specific length, diameter
// and thread size.
// - Imperial conversion available.
// - PLA Preshrink available, to ensure part has real-world dimensions. 

translate([0,-45,0])
screw(default_major_diameter, default_thread_pitch, default_thread_angle, default_thread_type, 7, 7, default_head_height);

// metric sized nut
translate([0,-30,0])
nut(default_major_diameter, 5, default_thread_pitch, default_thread_angle, default_thread_type,  default_inner_thread_gap);

translate([0,-15,0])
wingnut(default_major_diameter, 5, default_thread_pitch, default_thread_angle, default_thread_type,  default_inner_thread_gap);

translate([0,0,0])
washer(default_major_diameter, default_washer_thickness, default_bolt_gap);

// metric sized bolt
translate([0,15,0])
bolt(default_major_diameter, default_thread_pitch, default_thread_angle, default_thread_type, 7, 7, default_head_height);

// add threads anywhere
translate([0,30,0])
threaded_insert(default_major_diameter, 5, default_thread_pitch, default_thread_angle, default_thread_type, default_inner_thread_gap);

// thumbscrew
translate([0,45,0])
group()
{
    threadedFastener(default_major_diameter, default_thread_pitch, default_thread_angle, default_thread_type, 7, 7, default_head_height);
    thumbScrew(default_major_diameter, default_head_height);
}
