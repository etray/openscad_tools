include<../tools/tools.scad>

// demo of curve-rendering capability

// These examples are designed to have a tolerable render 
// time (minute or two). To increase smoothness, you can
// adjust the step in the for loop, and/or adjust the
// segmentExtendFactor, if there are undesired gaps.


// factor to lengthen segments, to fill in gaps
segmentExtendFactor=0.25;


// spiral demo
translate([-15,0,0])
extrudePoints(spiralPoints())
square([2,1],center=true);

// generate spiral points
function spiralPoints()=
        [for(angle=[360:15:360*4])
            // logarithmic spiral
            [
        0.6 * cos(angle) * 
        pow(e(), (angle*(pi()/180))*0.125),
        0.6 * sin(angle) * 
        pow(e(),(angle*(pi()/180))*0.125),
        0
            ]
        ];



// helix demo
translate([15,0,0])
extrudePoints(helicalPoints())
circle(d=2);

r=5;
c=0.01;

// generate helix points
function helicalPoints()=[
for(t=[0:10:360*4])        
    [
        r * cos(t),	
        r * sin(t),
        c * t
    ]        
];

