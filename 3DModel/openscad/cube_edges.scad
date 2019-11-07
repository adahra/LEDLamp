wall_thickness = 3;
size = 35;
steps = 17;
total_rotation = 70;
layer = 0.2;

module make_cube_edges(size, rotation, must_etch_base) {
    d1 = size - wall_thickness * 2;
    d2 = size + wall_thickness;
    rotate([0, 0, rotation])
    difference() {
        cube([size, size, size], true);
        cube([d2, d1, d1], true);
        cube([d1, d2, d1], true);
        cube([d1, d1, d2], true);
        
        if (must_etch_base) {
            translate([0, 0, -size / 2])
            cube([d1, d2, layer * 2], true);
        }
    }
}

size2 = size - wall_thickness * 2;
factor = size2 / size;
angle = acos(size / size2 / sqrt(2)) - 45;

module recurse(to_go, size, angle, thickness, first) {
    if (to_go) {
        echo(thickness);
        make_cube_edges(size, angle, thickness, !first);
        recurse(to_go - 1, size * factor, angle + angle, thickness * factor, false);
    }
}

for (i = [0:steps]) {
    make_cube_edges(size / exp(i / steps), i / steps * total_rotation, i > 0);
}

// recurse(step, size, 0, wall_thickness, true);