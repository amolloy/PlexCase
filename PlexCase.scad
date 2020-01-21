$fn = 50;

use <PiHoles/PiHoles.scad>
use <keystone.scad>

wallThickness = 4;
boxDepth = 34;
sideClearances = 2;

ssdSize = [115, 36, 1];
ssdUSBPlugClearance = 55;

piSize = piBoardDim("3B");
sdcardAccessSize = [17, 14, 7];
sdcardAccessOverlap = 2;

ssdPostWidth = 2;
ssdPostHeight = 8;
ssdPostHook = 1;
ssdPostGap = 1.4;
ssdSupport = ssdPostHeight - (ssdPostHook + ssdPostGap);

boxSize = [ssdSize.x + ssdUSBPlugClearance,
           piSize.y + sideClearances * 2 + ssdSize.y + 10];
           
piOffset = [-boxSize.x / 2 - sideClearances + (sdcardAccessSize.x - sdcardAccessOverlap),
            -boxSize.y / 2 + sideClearances,
            -boxDepth / 2];
            
keystoneOffset = [boxSize.x / 2 - 35, 
                  -(boxSize.y / 2 + wallThickness / 2),
                 13];
    
difference() {
    boxBase();
    powerPort();
    hdmiPort(0);
    hdmiPort(13.5);
    headphonePort();
    keystonePort();
    lidSlide();
}

lid();

translate(piOffset) piPosts("3B", 5);
translate([0, 0, -boxDepth / 2 + ssdPostHeight / 2]) {
    ssdSupport(-10, boxSize.y / 2 - 36 / 2 - 5, 100, 36);
}

translate(keystoneOffset) {
    rotate([270,0,0]) keystone();
}

module lid() {
    rimHeight = wallThickness / 2 * 0.9;
    middleHeight = wallThickness * 1.5;
    
    cr = 1.75;
    
    union() {
        translate([wallThickness / 2, 0, boxDepth / 2 - wallThickness / 2 + 1]) {
            cube([boxSize.x, 
                  boxSize.y * 0.99, 
                  rimHeight],
            center=true);
            
            minkowski() {
                cube([boxSize.x - wallThickness * 2 + wallThickness - cr,
                      boxSize.y - wallThickness * 1.25 - cr * 2,
                      middleHeight - cr * 2],
                center=true);
                cylinder(r=cr, h=1);
            }
        }
        
        translate([boxSize.x / 2 - wallThickness / 2 + 0.15, 0, boxDepth / 2 - wallThickness / 2 + 1.13]) {
            
        }
        
        translate([boxSize.x / 2 - 0.9, 
                   0, 
                   boxDepth / 2 + 0.245]) {
            cube([wallThickness, 
                  boxSize.y - wallThickness * 1.25, 
                  wallThickness / 2],
                 center=true);
        }

        
        intersection() {
            translate([boxSize.x / 2 - wallThickness / 2 + 0.08, 0, boxDepth / 2 - wallThickness / 2 + 1.4]) {
                minkowski() {
                    cube([wallThickness * 0.96, 
                          boxSize.y, 
                          wallThickness - 3.5],
                    center=true);
                    sphere(2);
                }
            }
            translate([boxSize.x / 2 + wallThickness / 2, 
                   0, 
                   boxDepth / 2 + 0.245]) {
                cube([wallThickness / 1.7, 
                      boxSize.y - wallThickness * 1.25, 
                      wallThickness / 2],
                center=true);
            }
        }
    }
}

module lidSlide() {
    union() {
        translate([-boxSize.x / 2 + 1, -boxSize.y / 2, boxDepth / 2 - wallThickness / 2]) {
            cube([boxSize.x - wallThickness / 2 + wallThickness * 8, 
                  boxSize.y, 
                  2]);
        }
        translate([boxSize.x / 2 - wallThickness, -boxSize.y / 2 + wallThickness / 2, boxDepth / 2 - 1]) {
            cube([wallThickness * 2, boxSize.y - wallThickness, wallThickness + 1]);
        }
    }
}

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
                cylinder(ssdPostHeight / 1.5, ssdPostWidth * 2.5, ssdPostWidth * 0.5);
            }
            cube([ssdPostWidth, ssdPostWidth, ssdPostHeight], center = true);
            translate([0, 0, ssdPostHeight / 2]) {
                translate([ssdPostWidth / 2, -ssdPostWidth / 2, -(ssdPostHook + ssdPostGap + ssdSupport)]) cube([ssdPostHook + 1, ssdPostWidth, ssdSupport]);
                
                translate([ssdPostWidth / 2, ssdPostWidth / 2, -ssdPostHook]) {
                    rotate([90, 0, 00]) {
                        linear_extrude(ssdPostWidth) {
                            polygon([[0, 0], [0, ssdPostHook], [ssdPostHook * 0.75, 0]]);
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

            translate([-boxSize.x / 2 + 6, 
                       piOffset.y / 2, 
                       -boxDepth / 2 + sdcardAccessSize.z / 2]) {
                cube([sdcardAccessSize.x - wallThickness, 
                  sdcardAccessSize.y + wallThickness * 2,
                  sdcardAccessSize.z], 
                     center = true);
                       }
            }
            
            
            translate([-boxSize.x / 2 - sideClearances + sdcardAccessSize.x - sdcardAccessSize.x / 2 - wallThickness, 
                       piOffset.y / 2, 
                       -boxDepth / 2 + sdcardAccessSize.z / 2 - wallThickness]) {
            cube([sdcao.x + 2, 
                  sdcao.y - wallThickness, 
                  sdcao.z], 
                 center = true);
            }
        }
}

module powerPort() {
    translate([piOffset.x + 3.5 + 7.7 / 2, -(boxSize.y / 2 + 3), piOffset.z + 5 + 3.2 - 3.75 / 2]) {
        minkowski() {
            cube([9.5 - 1, 5, 3.75 - 1]);
            sphere(1);
        }
    }
}

module hdmiPort(off) {
    translate([piOffset.x + 3.5 + 7.7 + 14.8 - 7 / 2 + off, -(boxSize.y / 2 + 3), piOffset.z + 5 + 3.0 - 3.75 / 2]) {
        minkowski() {
            cube([7 - 1, 5, 5 - 1]);
            sphere(1);
        }
    }
}

module headphonePort() {
    translate([piOffset.x + 53.5, -(boxSize.y / 2), piOffset.z + 5 + 6.0 - 3.75 / 2]) {
        rotate([90,0,0]) cylinder(6, 3.5, 3.5);
    }
}

module keystonePort() {
    translate([keystoneOffset.x, keystoneOffset.y - 5, keystoneOffset.z]) {
        rotate([270,0,0]) cube([30.5,23,10]);
    }
}
