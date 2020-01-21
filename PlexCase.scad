$fn = 50;

use <PiHoles/PiHoles.scad>
use <keystone.scad>

wallThickness = 2;
boxDepth = 20;
sideClearances = 2;

ssdSize = [115, 36, 1];
ssdUSBPlugClearance = 55;

piSize = piBoardDim("3B");
sdcardAccessSize = [17, 14, 7];
sdcardAccessOverlap = 2;

ssdPostWidth = 2;
ssdPostHeight = 8;
ssdPostHook = 1;
ssdPostGap = 1.1;
ssdSupport = ssdPostHeight - (ssdPostHook + ssdPostGap);

boxSize = [ssdSize.x + ssdUSBPlugClearance,
           piSize.y + sideClearances * 2 + ssdSize.y + 10];
           
piOffset = [-boxSize.x / 2 - sideClearances + (sdcardAccessSize.x - sdcardAccessOverlap),
            -boxSize.y / 2,
            -boxDepth / 2];

boxBase();
translate(piOffset) piPosts("3B", 5);
translate([0, 0, -boxDepth / 2 + ssdPostHeight / 2]) {
    ssdSupport(-10, boxSize.y / 2 - 36 / 2 - 5, 115, 36);
}
//keystone();

module ssdSupport(cx, cy, w, h) {
    translate([cx - w / 2, cy - h / 2 - ssdPostWidth / 2]) ssdPost(90);
    translate([cx + w / 2, cy - h / 2 - ssdPostWidth / 2]) ssdPost(90);
    translate([cx + w / 2, cy + h / 2 + ssdPostWidth / 2]) ssdPost(-90);
    translate([cx - w / 2, cy + h / 2 + ssdPostWidth / 2]) ssdPost(-90);
}

module ssdPost(angle) {
    rotate(angle) {
        union() {
            translate([ssdPostWidth / 2, 0, -ssdPostHeight / 2]) {
                cylinder(ssdPostHeight / 2, ssdPostWidth * 1.5, ssdPostWidth * 0.5);
            }
            cube([ssdPostWidth, ssdPostWidth, ssdPostHeight], center = true);
            translate([0, 0, ssdPostHeight / 2]) {
                translate([ssdPostWidth / 2, -ssdPostWidth / 2, -(ssdPostHook + ssdPostGap + ssdSupport)]) cube([ssdPostHook + 1, ssdPostWidth, ssdSupport]);
                
                translate([ssdPostWidth / 2, ssdPostWidth / 2, -ssdPostHook]) {
                    rotate([90, 0, 00]) {
                        linear_extrude(ssdPostWidth) {
                            polygon([[0, 0], [0, ssdPostHook], [ssdPostHook, 0]]);
                        }
                    }
                }
            }
        }
    }
}


module boxBase() {
    sdcao = [sdcardAccessSize.x + wallThickness * 2, 
              sdcardAccessSize.y + wallThickness * 2,
              sdcardAccessSize.z + wallThickness];
    
    difference() {
        union() {
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

            translate([-boxSize.x / 2 + sdcardAccessSize.x - sdcardAccessSize.x / 2 - wallThickness - 0.5, 
                       piOffset.y / 2, 
                       -boxDepth / 2 + sdcardAccessSize.z / 2]) {
                cube([sdcardAccessSize.x - wallThickness * 2, 
                  sdcardAccessSize.y + wallThickness * 2,
                  sdcardAccessSize.z], 
                     center = true);
                       }
            }
            
            
            translate([-boxSize.x / 2 - sideClearances + sdcardAccessSize.x - sdcardAccessSize.x / 2 - wallThickness, 
                       piOffset.y / 2, 
                       -boxDepth / 2 + sdcardAccessSize.z / 2 - wallThickness]) {
            cube([sdcao.x + 2, 
                  sdcao.y - wallThickness * 2, 
                  sdcao.z - wallThickness * 2], 
                 center = true);
            }
        }
}

