include <NopSCADlib/vitamins/psus.scad>

SOMPOM_S_480_24 = [
    "S_480_24",
    "SOMPOM 480-24", // part name
    215, 115, 50, // length, width, height
    M4_cap_screw, M4_clearance_radius, // screw type and clearance
    false, // true if ATX style
    13, // terminals bay depth
    0, // heatsink bay depth
        [// terminals
        9, // count
        18, // y offset
        st_terminals
        ],
    // faces
        [
            [// f_bottom, bottom
                [// holes
                    [215 / 2 - 32.5, 115 / 2 - 82.5], [215 / 2 - 32.5, 115 / 2 - 32.5], [215 / 2 - 182.5, 115 / 2 - 82.5
                ], [215 / 2 - 182.5, 115 / 2 - 32.5]
                ],
            1.5, // thickness
                [], // cutouts
            false, // grill
                [], [], [], // fan, iec, rocker
            [// vents
            // [ [pos.x, pos.y, angle], [size.x, size.y], corner radius ]
            for (x = [0:21], y = [- 1, 1]) [[- 7 * x + 215 / 2 - 34, (115 / 2 - 5) * y, 0], [3, 25], 1.5]
            ]
            ],
            [// f_top, top
                [], // holes
            0.5, // thickness
                [], // coutouts
            false, // grill
                [215 / 2 - 47.5, 115 / 2 - 37.5, fan50x15],
                [], //iec
                [], //rocker
            [// vents
            for (x = [0:4], y = [- 1, 1]) [[- 7 * x - 215 / 2 + 48, 28 * y, 0], [3, 25], 1.5]
            ]
            ],
            [// f_left, front (terminals) after rotation
                [], // holes
            0.5, // thickness
                [// cutouts
                    [
                        [- 56, - 25], [- 56, - 17],
                        [- 60, - 17], [- 60, 0],
                        [115 / 2, 0], [115 / 2, - 25]
                    ]
                ],
            false, // grill
            ],
            [// f_right, back after rotation
                [], // holes
            1.5, // thickness
                [], // cutouts
            false, // grill
            ],
            [// f_front, right after rotation
                [// holes, offset from center
                    [215 / 2 - 32.5, - 13], [215 / 2 - 182.5, - 13],
                    [215 / 2 - 32.5, 12], [215 / 2 - 182.5, 12]
                ],
            1.5, // thickness
                [], // cutouts
            false, // grill
                [], [], [], // fan, iec, rocker
            [// vents
            for (x = [0 : 21]) [[- 7 * x + 215 / 2 - 34, - 25, 0], [3, 10], 1.5],
        for(x = [0 :  1]) [[ - 7 * x, - 1, 0], [3, 25], 1.5],
for(x = [0 :  2]) [[ - 7 * x - 215 / 2+ 20, - 1, 0], [3, 25], 1.5],
]
],
[// f_back, left after rotation
[// holes, offset from center
[215 / 2 - 32.5 - 13 / 2, 13], [215 /2 - 182.5 - 13 / 2, 13]
],
1.5, // thickness
[], // cutouts
false, // grill
[], [], [], // fan, iec, rocker
[// vents
for(x = [0 : 21]) [[ - 7 * x + 215 / 2- 34 - 13 / 2, 25, 0], [3, 10], 1.5]
]
],
],
// accessories to add to BOM
[]
];
