//
// reusable openscad tools 
//
// Original work released, year of our lord, 2022
// - Commercial use, copying, altering, re-packaging, with
//   or without attribution is encouraged, but not mandatory
//


// generic smoothing parameters saves specifying every time
$fa = 4;
$fs = 0.5;


// Check if argument is defined
function defined(a) = str(a) != "undef";

// Use default value if argument undefined
function default(a,b) = (defined(a)?a:b);

// constants
function pi() = 3.141592653589793;
function e()  = 2.718281828459045;

// imperial to metric
mm_per_in=25.4;
function inToMm(in) = (in * mm_per_in);
// Threads per inch to mm thread pitch
function tpiToTp(tpi) = inToMm(1/tpi);

// overrideable scale factor
pla_shrink_scale=1.008;

//
// account for PLA shrinkage, so final part has expected dimensions
//
module preShrink(shrinkFactor)
{
    // if shrinkFactor not specified, use default    
    factor=default(shrinkFactor,pla_shrink_scale);
    
    scale([factor,factor,factor])
    {
        children();
    }
}


//
// Makes a tube with the given dimensions
//
module tube(tube_outer_diameter, tube_inner_diameter, tube_length)
{
    assert(defined(tube_outer_diameter) && defined(tube_inner_diameter) && 
        defined(tube_length),
        "Usage: tube(tube_outer_diameter, tube_inner_diameter, tube_length)");

    assert(tube_inner_diameter < tube_outer_diameter,
        "tube_inner_diameter must be less than tube_outer_diameter");
    
    difference()
    {
        cylinder(h=tube_length,d=tube_outer_diameter,center=true);
        cylinder(h=tube_length+1,d=tube_inner_diameter,center=true);
    }
}



module outer_chamfer_ring(diameter, distance)
{
    chamferAngle = 45;
    ring_height = 10;

    depth=((ring_height/2.0)/tan(chamferAngle));
    
    rotate_extrude(angle = 360) 
    {

        group()
        {
            translate([(depth+(diameter/2))-distance, -(ring_height/2), 0])
            polygon(
                points=
                [
                    [0,0],[0,ring_height], 
                    [(-depth),ring_height/2.0]
                ], 
                paths=[[0,1,2,0]]
            );
        }
    }
}


module inner_chamfer_ring(diameter)
{
    height=10;
    chamferAngle = 45;
    ring_height = abs(height);

    depth=((ring_height/2.0)/tan(chamferAngle));
    
    rotate_extrude(angle = 360) 
    {

        group()
        {
            translate([(diameter/2) - (depth/2), -(ring_height/2), 0])
            polygon(
                points=
                [
                    [0,0],[0,ring_height], 
                    [(depth),ring_height/2.0]
                ], 
                paths=[[0,1,2,0]]
            );
        }
    }
}


module chamfer_dome(diameter)
{
    difference()
    {
        difference()
        {
            sphere(d=diameter + 5);
            sphere(d=diameter);
        }

        translate([0,0,-(diameter)])
        cube([diameter*4,diameter*4,diameter*2],center=true);
    }
}


//
// creates a donut shape
// extrusion diameter is the path of the midpoint of the extruded circle
// extrusion height is the thickness of the donut
//
module torus(extrusion_diameter, extrusion_height)
{
    assert((extrusion_diameter >= extrusion_height), "extrusion_diameter must be >=  extrusion_height");

    rotate_extrude(angle = 360) 
    group()
    { 
        translate([extrusion_diameter/2,0,0])
        circle(d=extrusion_height);
    }    
}


//
// draw objects repeated in a circle
// count is how many objects ro repeat
// diameter is the diameter of the cicular path that objects are rotated through
//
module rotational_repeat(diameter, count)
{
    for(i=[0:count])
        rotate([0,0,(i*(360/count))]) 
        translate([diameter/2,0,0])
        rotate ([0, 0, 0])
        {
            children();
        }    
}


//
// works like a drill was used at x,y,z
//
module drillHole(diameter, depth, x, y, z)
{
    difference()
    {
        children();
        
        translate([x,y,z-(depth/2)])
        cylinder(d=diameter,h=depth,center=true);
    }
}


//   / \ ? / \
//  /   \ /   \
//
default_thread_angle=60;


//    |--?--| 
//   / \   / \
//  /   \ /   \
//
default_thread_pitch=1.5;


//  _
// | |___        
// |-|   VVVVVV\ _ 
// | |   ||||||| _? 
// |-|___AAAAAA/ 
// |_|
//
default_minor_diameter=4;


//  _
// | |___        _ _
// |-|   VVVVVV\  |
// | |   |||||||  ?
// |-|___AAAAAA/ _|_
// |_|
//
default_major_diameter=5;


//   |--- ? ---| 
//  _
// | |___        
// |-|   VVVVVV\ 
// | |   ||||||| 
// |-|___AAAAAA/ 
// |_|
//
default_fastener_length=15;

 
//  _    |- ? -|
// | |___        
// |-|   VVVVVV\ 
// | |   |||||||
// |-|___AAAAAA/ 
// |_|
//
default_thread_length=15;


// |?| 
//  _
// | |___        
// |-|   VVVVVV\ 
// | |   |||||||
// |-|___AAAAAA/ 
// |_|
//
default_head_height=3;


//  _     ___
// | |___|   |    _  
// |-|   |---|V\  - ?
// | |   |   |||
// |-|___|---|A/ 
// |_|   |___|   
//
// (value of total addtional gap)
default_inner_thread_gap = 1.25;


//       | ? |
//  _     ___
// | |___|   |      
// |-|   |---|V\  
// | |   |   |||
// |-|___|---|A/ 
// |_|   |___|   
//
default_nut_height = 4;


//
//         /\?
//  _
// | |___  ||      
// |-|   VV||VV\ 
// | |   |||||||
// |-|___AA||AA/ 
// |_|     ||
//
default_washer_thickness=1;

//  _
// | |___  ------   -    
// |-|   VVVVVV\    - ?
// | |   |||||||
// |-|___AAAAAA/ 
// |_|     ------
//
// (value of total addtional gap)
default_bolt_gap=0.3;


//   /\    /\
//  /  \  /  \
// /    \/    \
//
THREAD_TYPE_STANDARD=1;

//    __      __
//   /  \    /  \
//  /    \__/    \
//
THREAD_TYPE_ACME=2;

default_thread_type=THREAD_TYPE_STANDARD;


module spacer(innerDiameter, spacerHeight, bolt_gap, customOuterDiameter)
{
    // if custom not specified, use nearest aesthetic size    
    outerDiameter=default(customOuterDiameter,floor((innerDiameter*2.12)+0.5));
    
    tube(outerDiameter, innerDiameter + bolt_gap, spacerHeight);
}

module washer(innerDiameter, washer_thickness, bolt_gap, customOuterDiameter)
{
    // if custom not specified, use nearest aesthetic size    
    outerDiameter=default(customOuterDiameter,floor((innerDiameter*2.12)+0.5));
    
    tube(outerDiameter, innerDiameter + bolt_gap, washer_thickness);
}


module threaded_insert(major_diameter, thread_length, thread_pitch, thread_angle, thread_type, inner_thread_gap)
{
    insertDiameter=floor(major_diameter+2.5);
    echo ("Threaded Insert height: ", thread_length);
    echo ("Diameter: ", insertDiameter);
    thread_depth=thread_length*1.3;
    difference()
    {
        // stock to be tapped
        cylinder(h=thread_length,d=insertDiameter,center=true);
        
        // negative thread sized a little bit bigger than threaded fastener

        difference()
        {
            group()
            {
                cylinder(d=major_diameter+inner_thread_gap, h=thread_depth, center=true);
            }
            
            group()
            {
                translate([0,0,(thread_depth/2)+thread_pitch/2])
                thread(major_diameter+inner_thread_gap, thread_pitch, thread_depth, thread_angle, thread_type);
            }
        }

    }
        
}


module nut(major_diameter, thread_length, thread_pitch, thread_angle, thread_type,  inner_thread_gap)
{
    difference()
    {
        // shape (insert/nut)
        translate([0,0,thread_length/2])
        hexHead(major_diameter, thread_length);
 
        // negative thread sized a little bit bigger than threaded fastener
        translate([0,0,-((thread_length*1.2)/2)])
        difference()
        {
            group()
            {
                // cylindrical stock for threading
                cylinder(d=major_diameter+inner_thread_gap, h=thread_length*1.2);
            }
            
            group()
            {
                // subtract threads
                translate([0,0,(thread_length*1.2)+(thread_pitch/2)])
            thread(major_diameter+inner_thread_gap, thread_pitch, thread_length*1.2, thread_angle, thread_type);

            }
        }
    }
}


module wingnut(major_diameter, thread_length, thread_pitch, thread_angle, thread_type,  inner_thread_gap)
{
    nut(major_diameter, thread_length, thread_pitch, thread_angle, thread_type,  inner_thread_gap);

    wing_thickness=3;
    wing_diameter=thread_length*1.25;
    translate([((major_diameter+wing_diameter)/2)+thread_pitch/2,0,abs((thread_length-wing_diameter)/2)])
    group()
    {
        rotate([90,0,0])
        cylinder(d=wing_diameter,h=wing_thickness,center=true);
        translate([-(wing_diameter/4),0,-(wing_diameter/4)])
        cube([wing_diameter/2,wing_thickness,wing_diameter/2],center=true);
    }

    translate([-(((major_diameter+wing_diameter)/2)+thread_pitch/2),0,abs((thread_length-wing_diameter)/2)])
    group()
    {
        rotate([90,0,0])
        cylinder(d=wing_diameter,h=wing_thickness,center=true);
        translate([(wing_diameter/4),0,-(wing_diameter/4)])
        cube([wing_diameter/2,wing_thickness,wing_diameter/2],center=true);
    }
}


module screw(major_diameter, thread_pitch, thread_angle, thread_type, fastener_length, thread_length, head_height)
{
    threadedFastener(major_diameter, thread_pitch, thread_angle, thread_type, fastener_length, thread_length, head_height);
    
    screwHead(major_diameter, head_height);
}


module bolt(major_diameter, thread_pitch, thread_angle, thread_type, fastener_length, thread_length, head_height)
{
    threadedFastener(major_diameter, thread_pitch, thread_angle, thread_type, fastener_length, thread_length, head_height);

    hexHead(major_diameter, head_height);
}


module hexHead(major_diameter, head_height, customSize)
{
    // if custom not specified, use nearest aesthetic integer head size    
    size=default(customSize,floor((major_diameter*1.6)+0.5));

    // low-res cylinder hack to get hexagon
    // 30,60,90 triangle math to get to desired wrench size
    translate([0,0,-(head_height/2.0)])
    cylinder(d=(2*(size/sqrt(3))), h=head_height, $fn=6, center=true);
}


module screwHead(major_diameter, head_height, customSize)
{
    // if custom not specified, use nearest aesthetic integer head size    
    size=default(customSize,floor((major_diameter*1.6)+0.5));
 
    translate([0,0,-(head_height/2)])
    difference()
    {
        cylinder(d=size, h=head_height, center=true);
        translate([0,0,-(head_height/2)])      
        cube([1,size*2,2],center=true);
    }
}


module thumbScrew(major_diameter, head_height, customSize)
{
    // if custom not specified, use an aesthetic size    
    size=default(customSize,floor((major_diameter*2.5)+0.5));

    translate([0,0,-(head_height/2)])
    difference()
    {
        group()
        {
            cylinder(d=size, h=head_height, center=true);
        }

        group()
        {
            translate([0,0,(head_height/2)])
            outer_chamfer_ring(size, 0.5);

            translate([0,0,-(head_height/2)])
            outer_chamfer_ring(size,0.5);
            
            // calculate number of grooves to be even/alternating
            circumference=size*pi();
            groove_width = 0.5;
            number_of_grooves = (circumference/2)/groove_width;
            
            // do knurling
            rotational_repeat(size, number_of_grooves)
            cube([1,groove_width,head_height*1.5],center=true);

            // decorative circle
            rotate_extrude(angle = 360) 
            {
                group()
                {                        
                    translate([(size/2)-3,-((head_height)-1),0])
                    polygon(
                        points=
                        [
                            [0,0],[0,1],[0.5,1],[0.5,0] 
                        ], 
                        paths=[[0,1,2,3,0]]
                    );
                }
            }                
        }
    }
}


module threadedFastener(major_diameter, thread_pitch, thread_angle, thread_type, fastener_length, thread_length, head_height)
{
    difference()
    {
        group()
        {
            // cylindrical stock for threading
            cylinder(d=major_diameter, h=fastener_length);
        }
        
        group()
        {
            // subtract threads
            translate([0,0,fastener_length+(thread_pitch/2)])
            thread(major_diameter, thread_pitch, thread_length, thread_angle, thread_type);
            
            // round chamfer end for easy threading
            translate([0,0,fastener_length-(major_diameter*0.35)])
            chamfer_dome(major_diameter);
        }
    }
}


//
// Extrudes a 2-d cutter shape in a helical path around a cylinder body.
// Openscad does not go to any effort to make this easy or efficient.
// Attempted at being efficient by extruding arc segments and translating/rotating
// to fit the helical path.
//
module thread(major_diameter, thread_pitch, thread_length, thread_angle, thread_type)
{
    circumference=major_diameter*pi();
    
    segments=8;
    overlap_degrees=2;  // prevent gaps
    angular_segment=(360/segments);
    
    segment_width=circumference/segments;
    angle=(atan((thread_pitch/segments)/segment_width));
    
    // the +1 gives it another turn that seems to be required
    for(j=[0:((thread_length+1) / thread_pitch)])     
        translate([0,0,-thread_pitch*j])
        for(i=[0:segments])        
            translate([0,0,-(thread_pitch/segments)*i])
            rotate([0,0,-angular_segment*i])
            rotate([angle,0,0])
            rotate_extrude(angle = angular_segment+overlap_degrees) 
            {
                group()
                {
                    if(thread_type == THREAD_TYPE_STANDARD)
                    {
                        standard_cutter(thread_pitch, thread_angle, major_diameter);
                    }
                    else if(thread_type == THREAD_TYPE_ACME)
                    {
                        acme_cutter(thread_pitch, thread_angle, major_diameter);
                    }
                }
            }
}


module acme_cutter(thread_pitch, thread_angle, major_diameter)
{
   // TODO:
}


module standard_cutter(thread_pitch, thread_angle, major_diameter)
{
    depth=((thread_pitch/2.0)/tan(thread_angle/2.0));

    translate([major_diameter/2.0, 0, 0])
    polygon(
    
        //       D + - + C 
        //        /    |
        //    E +      |
        //        \    |
        //       A + - + B
        //
    
        // threads are not quite flush, so added the reverse protrusion to 
        // ensure cutting path gets all the material
    
        points=
        [
            [0,-(thread_pitch/2.0)],                // A 
            [(thread_pitch/2),-(thread_pitch/2.0)], // B (reverse protrusion)
            [(thread_pitch/2),thread_pitch/2.0],    // C (reverse protrusion)
            [0,thread_pitch/2.0],                   // D
            [(-depth),0]                            // E
        ], 
        paths=[[0,1,2,3,4,0]]
    );
}


module gear(tooth_count, gear_module, pressure_angle, thickness)
{
    
    pitch = pi() * gear_module;
    pitch_circumference = pitch*tooth_count;
    pitch_diameter=pitch_circumference/pi();
    pitch_radius=pitch_diameter/2;
    undercut_distance=1.25*gear_module;
    cutter_tooth_height=gear_module+undercut_distance;
    stock_radius=pitch_radius+undercut_distance;
    stock_diameter=stock_radius*2;

    difference()
    {
        cylinder(h=thickness,d=stock_diameter,center=true);

        rotational_repeat(pitch_diameter, tooth_count)
        gear_cutter(cutter_tooth_height, gear_module, pitch, pressure_angle, thickness);

    }
}


module gear_cutter(cutter_tooth_height, gear_module, pitch, pressure_angle, thickness)
{
    // GEAR CUTTER SHAPE
    //      __              _
    //     /  \   1.25 M    |
    //    /----\            |  C_T_H
    // __/      \__    M    |
    //  |- pitch -|         -
    
    //| P/2 |
    //     _ _              _
    //    /|  \             |
    //   / |   \            |  C_T_H
    // _/__|    \_          |
    //  |TB|                -    
    //| | HHSZ
    //     | | HHSZ

    triangle_bottom=tan(20)*cutter_tooth_height;
    half_horiz_size=((pitch/2) - triangle_bottom)/2;
    
    p1x = -(triangle_bottom+half_horiz_size);
   
    // rotate the cutter through this many degrees to simulate
    // the motion of a wheel rolling over a rack profile
    cutter_rotation_degrees=10;
    
    // adust orientation
    rotate([0,0,90])
    
    for(i=[-(cutter_rotation_degrees/2):(cutter_rotation_degrees/2)])
    rotate([0,0,i*2])
    linear_extrude(thickness*2,center=true)
        polygon(    
            points=
            [
             [0,-cutter_tooth_height],
             [-((pitch/2)+half_horiz_size+half_horiz_size), -gear_module],
             [p1x, -gear_module],
             [-half_horiz_size, 1.25 * gear_module],
             [half_horiz_size, 1.25 * gear_module],
             [-p1x, -gear_module],
             [((pitch/2)+half_horiz_size+half_horiz_size), -gear_module]
            ], 
            paths=[[0,1,2,3,4,5,6,0]]
        );
}


// PLA is more crunchy than cut gears, so give it some additional room
additional_gear_clearance=0.5;

// find the necessay spacing between axles of 2 involute gears
function gearSpacing(tooth_count1, tooth_count2, gear_module)=
    ((gear_module*tooth_count2)/2) + ((gear_module*tooth_count1)/2) + additional_gear_clearance;

module gearFitFixture(axle_diameter, distance, axle_height)
{
    plate_thickness=2;
    plate_width = axle_diameter * 2;
    plate_length = axle_diameter + distance + axle_diameter;
    
    cube([plate_width,plate_length,plate_thickness],center=true);
    
    difference()
    {
        translate([0,distance/2,axle_height/2+plate_thickness/2])
        cylinder(h=axle_height,d=axle_diameter,center=true);
        
        translate([0,distance/2,axle_height+plate_thickness/2])
        outer_chamfer_ring(axle_diameter, 0.5);
    }

    difference()
    {
        translate([0,-(distance/2),axle_height/2+plate_thickness/2])
        cylinder(h=axle_height,d=axle_diameter,center=true);
        
        translate([0,-(distance/2),axle_height+plate_thickness/2])
        outer_chamfer_ring(axle_diameter, 0.5);
    }    
}


// get the distance between 2 points in 3D space
function pointDistance(x1,y1,z1,x2,y2,z2)=
    sqrt(pow(x2-x1,2) + pow(y2-y1,2) + pow(z2-z1,2));

// factor to lengthen segments, to fill in gaps
//segmentExtendFactor=0.25;

// extrudes a 2-d shape between two points,
// matching the direction and orientation of
// a line running through them
module extrudeBetween(x1,y1,z1,x2,y2,z2)    
{   
    distance = 
    pointDistance(x1,y1,z1,x2,y2,z2);
 
    // weak-ass Earth mathematics can't handle divide by zero
    x2_diff=((x2-x1)!=0?(x2-x1):0.00001);
    y2_diff=((y2-y1)!=0?(y2-y1):0.00001);   
    z2_diff=((z2-z1)!=0?(z2-z1):0.00001);

    
    // first, the y rotation gets us to the z height
    // of our final position
    
    //
    //    * initial (H)
    //    |     
    //    |
    // final *  * intermediate y rotation
    //    | /   |  (O)
    //    |/    |
    //    +-----------x
    //    |  (A)
    //    z
   
    new_opposite = z2_diff;
    new_hypotenuse = distance;
    raw_y_angle=abs(asin(new_opposite/new_hypotenuse));

    // determine the quadrant, so we can rotate by correct angle
    x_sign=(x2_diff<0?-1:1);
    z_sign=(z2_diff<0?-1:1);
    y_sign=(y2_diff<0?-1:1);
    
    y_rot_angle = x_sign * (90 + (raw_y_angle * (z_sign<0?1:-1)) );

    // next, the z rotation moves us to the right place on
    // the x/y plane
    
    //      * final
    //     /|  
    //    / | y2 (O)  
    // x-+------* intermediate
    //   | x2 (A)   
    //   |
    //   y
    
    raw_z_angle= abs(atan(y2_diff/x2_diff));

    // rotate by a different direction and amount depending
    // on original y rotation and quadrant
    z_rot_angle = (
        // x neg + y neg + y rot pos
        (x_sign < 0 && y_sign < 0 && y_rot_angle >= 0)?
            (180 - raw_z_angle):
        // x neg + y pos + y rot pos
        (x_sign < 0 && y_sign >= 0 && y_rot_angle >= 0)?
            -(180 - raw_z_angle):
        // x pos + y neg + y rot pos
        (x_sign >= 0 && y_sign < 0 && y_rot_angle >= 0)?
            -(raw_z_angle): 
        // x pos + y pos + y rot pos
        (x_sign >= 0 && y_sign >= 0 && y_rot_angle >= 0)?
            (raw_z_angle):
        
        // x neg + y neg + y rot neg
        (x_sign < 0 && y_sign < 0 && y_rot_angle < 0)?
            (raw_z_angle):
        // x neg + y pos + y rot neg
        (x_sign < 0 && y_sign >= 0 && y_rot_angle < 0)?
            -(raw_z_angle):
        // x pos + y neg + y rot neg
        (x_sign >= 0 && y_sign < 0 && y_rot_angle < 0)?
            (180 - raw_z_angle):
        // x pos + y pos + y rot neg
        (x_sign >= 0 && y_sign >= 0 && y_rot_angle < 0)?
            -(180 - raw_z_angle):0
    );
       
    // extrude object and
    // rotate / translate to 
    // the desired position
    translate([x1,y1,z1])
    rotate([0,y_rot_angle,z_rot_angle])
    group()
    {
        translate([0,0,distance/2])
        linear_extrude(height = distance*(1+segmentExtendFactor), center = true)
        children();
    }
}


// treat a list of 3D points as a path to extrude a 2D shape over
module extrudePoints(points)
{   
    for(count=[0:len(points)])
    {      
        if(count-1 > 0)
        {   
            if(
                defined(points[count-1][0]) &&
                defined(points[count-1][1]) &&
                defined(points[count-1][2]) &&
                defined(points[count][0]) &&
                defined(points[count][1]) &&
                defined(points[count][2])                 
              )
            {
                extrudeBetween(
                    points[count-1][0], 
                    points[count-1][1],
                    points[count-1][2],                    
                    points[count][0],
                    points[count][1],
                    points[count][2]
                )
                children();
            }
        }
    }
}