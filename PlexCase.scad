$fn = 50;

use <PiHoles/PiHoles.scad>

wallThickness = 2;
boxDepth = 20;

piSize = piBoardDim("3B");
boxSize = [piSize.x,
           piSize.y];

boxBase();
for (pos=piHoleLocations()) {
    translate([pos.x - boxSize.x / 2,
               pos.y - boxSize.y / 2,
               -boxDepth / 2]) screwmount();
}
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
