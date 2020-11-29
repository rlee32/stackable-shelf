// Units are mm.

function i2mm(x) = x * 0.0254 * 1000;

t = i2mm(1);
fudge = 1.5;
diam = i2mm(3/8) + fudge; // hole diameter
h = i2mm(6.75); // height
cutout_depth = i2mm(3.5) + fudge; // depth of board placed within cutout.
cutout_height = i2mm(0.25);
depth = i2mm(4.5);
cutout_dim = i2mm(4.5);
cutout_y = -i2mm(0.0);
min_center_width = i2mm(1);

difference() {
    union() {
        difference() {
            translate([0, 0, h / 2])
                cube(size=[t, depth, h], center=true);
            translate([0, 0, h / 2]) {
                translate([0, -depth / 2, cutout_y])
                    rotate([45, 0, 0])
                        cube(size = [cutout_dim, cutout_dim, cutout_dim], center = true);
                translate([0, depth / 2, cutout_y])
                    rotate([45, 0, 0])
                        cube(size = [cutout_dim, cutout_dim, cutout_dim], center = true);
            }
        }
        translate([0, 0, h / 2])
            cube(size=[t, min_center_width, h], center=true);
    }
    translate([0, 0, h])
        cube(size=[2 * t, cutout_depth, cutout_height * 2], center=true);
    translate([0, 0, h / 2])
        cylinder(r = diam / 2, h = 2 * h, center = true);
}
