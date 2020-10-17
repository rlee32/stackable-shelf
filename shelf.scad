// Units are mm.

function i2mm(x) = x * 0.0254 * 1000;

t = 2;

depth = i2mm(4);
width = i2mm(5.75);
h = i2mm(6);

tab_len = i2mm(0.5);
tab_width = i2mm(0.5);

module base_plate() {
    cube(size=[width, depth, t], center=true);
}

module leg(len, angle) {
    rotate([angle, 0, 0])
        translate([0, 0, len / 2])
            cube(size=[tab_width, t, len], center=true);
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
        leg(h, 3);
    translate([dx, -dy, 0])
        leg(h, -3);
    translate([-dx, -dy, 0])
        leg(h, -3);
    translate([-dx, dy, 0])
        leg(h, 3);
}

base_plate();
tabs();
