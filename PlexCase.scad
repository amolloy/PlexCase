$fn = 50;

use <PiHoles/PiHoles.scad>
use <keystone.scad>

wallThickness = 2;
boxDepth = 20;
sideClearances = 2;

ssdSize = [115, 36, 1];
ssdUSBPlugClearance = 55;

piSize = piBoardDim("3B");
boxSize = [max(ssdSize.x + ssdUSBPlugClearance, piSize.x + sideClearances * 2),
           piSize.y + sideClearances * 2 + ssdSize.y + 10];
           
piOffset = [-boxSize.x / 2 - sideClearances,
            -boxSize.y / 2,
            -boxDepth / 2];

boxBase();
translate([-boxSize.x / 2 + sideClearances,
           -boxSize.y / 2,
           -boxDepth / 2]) piPosts("3B", 5);

//keystone();

module boxBase() {
    difference() {
        minkowski() {
            cube([boxSize.x, boxSize.y, boxDepth], center=true);
            sphere(wallThickness / 2.0);
        }
        
        translate([0,0,wallThickness]) {
            minkowski() {
                cube([boxSize.x - wallThickness * 2, 
                      boxSize.y - wallThickness * 2, 
                      boxDepth], center=true);
                sphere(2);
            }
        }
    }
}

module screwmount() {
    difference() {
        cylinder(r=2.5, h=10);
        translate([0,0,-1]) cylinder(r=1.5, h=12);
    }
    
    rotate_extrude(convexity = 10) {
        translate([2.5, 0, 0]) {
            intersection() {
                square(5);
                difference() {
                    square(5, center=true);
                    translate([2.5,2.5]) circle(2.5);
                }
            }
        }
    }
}
