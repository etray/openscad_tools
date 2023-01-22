include<../tools/tools.scad>


//
// involute gear demo
//

tooth_count1=15;
tooth_count2=25;

// Number that can be tweaked to adjust gear size
gear_module=1;

// 20 degrees is the standard convention
pressure_angle=20;

thickness=3;
clearance = 0.5;
hubDiameter= 5 + clearance;
chamferDepth=0.5;

chamferedThroughHole(hubDiameter, thickness, chamferDepth)
    gear(tooth_count1, gear_module, pressure_angle, thickness);

// Handy function uses math to eliminate
// guesswork from spacing gears to run smoothly
gear_spacing=gearSpacing(tooth_count1, tooth_count2, gear_module);

translate([0,gear_spacing,0])
chamferedThroughHole(hubDiameter, thickness, chamferDepth)
    gear(tooth_count2, gear_module, pressure_angle, thickness);
