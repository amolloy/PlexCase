$fn = 50;

use <PiHoles/PiHoles.scad>
use <keystone.scad>

piModel = "3B";

piEdgeToMt = 3.5;
piMntToPwr = 7.7;
piPwrToHDMI1 = 14.8;
piHDMI1ToHDMI2 = 13.5;

lidFix = 0.35;

wallThickness = 3;
boxDepth = 34;
sideClearances = 2;

ssdSize = [115, 36, 1];
ssdUSBPlugClearance = 55;

piSize = piBoardDim(piModel);
sdcardAccessSize = [17, 14, 7];
sdcardAccessOverlap = 1.5;

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
    
// Uncomment to render the main box
enclosure();
// Uncomment to render the box lid.
//lid();

module piScrewHoles (board, depth = 5, preview=true) {
	hd = 1.375 * 2; // hole large enough to accomodate M2.5 screws 

	//preview of the board itself
	if(preview==true)
		% piBoard(board);
	
	//mounting holes
	for(holePos = piHoleLocations(board)) {
		translate([holePos[0], holePos[1], -depth]) cylinder(d=hd, h=depth);
	}
}

module enclosure() {
    difference() {
        boxBase();
        portDent();
        powerPort();
        hdmiPort(0);
        hdmiPort(piHDMI1ToHDMI2);
        headphonePort();
        keystonePort();
        lidSlide();
        enclosureVents();
        translate(piOffset) translate([0,0,5]) piScrewHoles(piModel, 10);
        for (i = [0 : 3]) piNutInset(i);
    }
  
//    translate(piOffset) piPosts(piModel, 5);
    
    translate([0, 0, -boxDepth / 2 + ssdPostHeight / 2]) {
        ssdSupport(-10, boxSize.y / 2 - 36 / 2 - 5, 100, 36);
    }

    translate(keystoneOffset) {
        rotate([270,0,0]) keystone();
    }
}

module piSupportLeg(index) {
    pihl = piHoleLocations(piModel);
    pidm = piBoardDim(piModel);
    h = 3.1; // Calculated very scientifically by leaving the old posts in place and tweaking the value until they lined up.
    td = 6 / 2;
    bd = 10 / 2;
    translate([piOffset.x + pihl[index].x, 
               piOffset.y + pihl[index].y, 
               -boxDepth / 2 - 0.5 + h / 2]) {
        cylinder((h + 0.5) / 2, bd, td, center = true);
        translate([0,0,h/2]) cylinder((h + 0.5) / 2, td, td, center = true);
        
    }
}

module piNutInset(index) {
    pihl = piHoleLocations(piModel);
    pidm = piBoardDim(piModel);
    h=2.5;
    translate([piOffset.x + pihl[index].x, 
               piOffset.y + pihl[index].y, 
               -boxDepth / 2 - (wallThickness - h - 0.25)]) {
         cylinder(r=2.6, h=h, center=true);
    }
}

module enclosureVents() {
    ventCount = 18;
    for (x = [-1, 1]) {
        for (i = [0 : ventCount]) {
            translate([x * boxSize.x / 2, (i - ventCount / 2) * 5, 0]) {
                minkowski() {
                    cube([10, 1, boxDepth * 0.5], center=true);
                    sphere(1);
                }
            }
        }
    }
}

module lid() {
    difference() {
        rimHeight = wallThickness / 2 * 0.9;
        middleHeight = wallThickness * 1.5;
        
        cr = 1.75;
        
        union() {
            translate([-boxSize.x / 2 + 15,
                       0,
                       boxDepth / 2 - 0.3]) {
                rotate([90, 0, 0]) cylinder(r=0.5, h=boxSize.y * 0.99, center=true);
            }
            
            translate([wallThickness / 2, 0, boxDepth / 2 - wallThickness / 2 + 1]) {
                translate([0,0, -0.5 * lidFix])
                cube([boxSize.x, 
                      boxSize.y * 0.99, 
                      rimHeight + lidFix],
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
    
        lidVents();
    }
}

module lidVents() {
    ventSpacing = 5;
    ventCount = piSize.x / ventSpacing;
    for (i = [0 : ventCount]) {
        translate([i * ventSpacing + piOffset.x,
                   piOffset.y / 2, 
                   boxDepth / 2]) {
            minkowski() {
                cube([1, piSize.y * 0.75, boxDepth * 0.5], center=true);
                sphere(1);
            }
        }
    }
}

module lidSlide() {
    difference() {
        union() {
            translate([-boxSize.x / 2 + 1, -boxSize.y / 2, boxDepth / 2 - wallThickness / 2 - lidFix * 2 / 2]) {
                cube([boxSize.x - wallThickness / 2 + wallThickness * 8, 
                      boxSize.y, 
                      2 + lidFix * 2]);
            }
            translate([boxSize.x / 2 - wallThickness, -boxSize.y / 2 + wallThickness / 2, boxDepth / 2 - 1]) {
                cube([wallThickness * 2, boxSize.y - wallThickness, wallThickness + 1]);
            }
        }
    
        translate([-boxSize.x / 2 + 14,
               0,
               boxDepth / 2 + 0.1]) {
        rotate([90, 0, 0]) cylinder(r=0.5, h=boxSize.y * 2, center=true);
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
            for(i = [0 : 3]) piSupportLeg(i);

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

module portDent() {
    w = ((piOffset.x + piEdgeToMt + piMntToPwr / 2) + (piOffset.x + 53.5));
    x = w / 2;
    translate([x, -(boxSize.y / 2 + 2), piOffset.z + 6 + 5.0 - 3.75 / 2]) {
        minkowski() {
            cube([abs(w) * 0.7, 1, 10], center=true);
            sphere(1);
        }
    }
}

module powerPort() {
    translate([piOffset.x + piEdgeToMt + piMntToPwr / 2, -(boxSize.y / 2 + 3), piOffset.z + 5 + 3.2 - 3.75 / 2]) {
        minkowski() {
            cube([9.5 - 1, 5, 3.75 - 1]);
            sphere();
        }
    }
}

module hdmiPort(off) {
    translate([piOffset.x + piEdgeToMt + piMntToPwr + piPwrToHDMI1 - 7 / 2 + off, -(boxSize.y / 2 + 3), piOffset.z + 5 + 3.0 - 3.75 / 2]) {
        minkowski() {
            cube([7 - 1, 5, 5 - 1]);
            sphere(1);
        }
    }
}

module headphonePort() {
    translate([piOffset.x + 53.5, -(boxSize.y / 2 - 3), piOffset.z + 5 + 6.0 - 3.75 / 2]) {
        rotate([90,0,0]) cylinder(6, 3.5, 3.5);
    }
}

module keystonePort() {
    translate([keystoneOffset.x, keystoneOffset.y - 5, keystoneOffset.z]) {
        rotate([270,0,0]) cube([30.5,23,10]);
    }
}
