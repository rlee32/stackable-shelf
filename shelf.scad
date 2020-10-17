// Units are mm.

function i2mm(x) = x * 0.0254 * 1000;

t = 2;

depth = i2mm(6);
width = i2mm(6);
h = i2mm(6.75);

tab_len = i2mm(0.5);
tab_width = i2mm(0.5);

leg_angle = 3; // deg
leg_offset = i2mm(0.5);

module base_plate() {
    difference() {
        cube(size=[width, depth, t], center=true);
        // holes
        gamma = 90 - leg_angle;
        a = h - leg_offset;
        y = cos(gamma) * a;
        dx = width / 2 - tab_width / 2;
        dy = depth / 2 - t / 2;
        loosening = 1.2;
        translate([dx, dy - y, 0])
            cube(size=[loosening * tab_width / 2, loosening * t, 2 * t], center=true);
        translate([dx, -dy + y, 0])
            cube(size=[loosening * tab_width / 2, loosening * t, 2 * t], center=true);
        translate([-dx, -dy + y, 0])
            cube(size=[loosening * tab_width / 2, loosening * t, 2 * t], center=true);
        translate([-dx, dy - y, 0])
            cube(size=[loosening * tab_width / 2, loosening * t, 2 * t], center=true);
    }
}

function side(a, b, gamma) = sqrt(pow(a, 2) + pow(b, 2) - 2 * a * b * cos(gamma));

module leg(len, angle, notch=false) {
    rotate([angle, 0, 0])
        translate([0, 0, len / 2])
            difference() {
                cube(size=[tab_width, t, len], center=true);
                if (notch) {
                    translate([0, 0, len/2]) {
                        translate([-tab_width / 2, 0, 0])
                            cube(size=[tab_width / 2, 2 * t, tab_width], center=true);
                        translate([tab_width / 2, 0, 0])
                            cube(size=[tab_width / 2, 2 * t, tab_width], center=true);
                    }
                }
            }
}

module width_tab() {
    cube(size=[width, t, tab_len], center=true);
}

module depth_tab() {
    cube(size=[t, depth, tab_len], center=true);
}

module tabs() {
    dx = width / 2 - tab_width / 2;
    dy = depth / 2 - t / 2;
    dz = tab_len / 2;
    ext = h - tab_len;
    translate([0, 0, dz]) {
        width_tab();
        depth_tab();
    }
    translate([0, dy, dz])
        width_tab();
    translate([0, -dy, dz])
        width_tab() ;
    translate([-width / 2 + t / 2, 0, dz])
        depth_tab();
    translate([width / 2 - t / 2, 0, dz])
        depth_tab();
    translate([dx, dy, 0])
        leg(h, leg_angle, true);
    translate([dx, -dy, 0])
        leg(h, -leg_angle, true);
    translate([-dx, -dy, 0])
        leg(h, -leg_angle, true);
    translate([-dx, dy, 0])
        leg(h, leg_angle, true);
    gamma = 90 - leg_angle;
    a = h - leg_offset;
    c = side(a, depth / 2 - t / 2, gamma);
    alpha = asin(a / (c / sin(gamma)));
    translate([-dx, 0, 0])
        leg(c, 90 - alpha);
    translate([dx, 0, 0])
        leg(c, 90 - alpha);
    translate([dx, 0, 0])
        leg(c, -(90 - alpha));
    translate([-dx, 0, 0])
        leg(c, -(90 - alpha));
}

base_plate();
tabs();
