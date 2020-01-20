module enclosure() {
    difference() {
        minkowski() {
            difference() {
                cube([60,40,15], center=true);
                translate([-15,-10,-8]);
                cube([30,20,1.5]);
            };
            
            sphere(2);
        };
        
        cube([61.5,41.5,16], center=true);
    };
};

module enclosureHoles() {
    /* This section of the code constructs all of the independent holes and joins them into a uniform object. */

    union() {
        // Screen
        translate([-13.75,-11,5.5])
        cube([27.5, 19.375, 5]);

        // LED Backlight
        translate([-14.6875,10,5.5])
        cube([29.375, 8.75, 5]);

        // Volume Pot
        translate([0,-15.75,5.5])
        rotate([0,0,0])
        cylinder(r=1.25, h=5);

        // Pushbutton #1
        translate([21.5,0,5.5])
        rotate([0,0,0])
        cylinder(r=4.75, h=5);

        // Pushbutton #2
        translate([23.5,-12,5.5])
        rotate([0,0,0])
        cylinder(r=4.75, h=5);

        // Pushbutton #3
        translate([-21.5,0,5.5])
        rotate([0,0,0])
        cylinder(r=4.75, h=5);

        // Pushbutton #4
        translate([-23.5,-12,5.5])
        rotate([0,0,0])
        cylinder(r=4.75, h=5);
    }
}


module concat() {
    /* Difference subtracts the second object from the first */

    difference() {
        /* Our first object is the Union of two objects. Here, union attaches the texture to the enclosure. */

        union() {
            enclosure();
        };

        /* the semicolon signals that that is a complete object. Now the second object is the one we made from the various holes. */

        enclosureHoles();
    }
}

concat();
