use <spindle.scad>

//    name       mount   motor   motor  motor   motor  motor  motor  shaft  shaft   shaft   shaft   shaft   mount
//               center  shield  dia    heigth  vent   vent   vent   dia    heigth  z       collar  collar  dia
//               offset  dia                    holes  holes  holes                 offset  dia     heigth  
//                                              offse  top z  top h
RS775 = ["RS775",  14.5,   45,    42,    67,   14.5,   44.75, 7.4,   5,     98,     66.5,   18,     4.5,    4.2];
RS895 = ["RS895",  14.5,   50,  47.6,    72,   16,     44.75, 7.4,   5,     85,     66.5,   18,     4.5,    4.2];

RS887 = ["RS895",   16,  47.6,  47.6,    68,   16,     44.75, 7.4,   5,     85,     66.5,   21.7,   7.5,    5.2];




//SPINDLE_ER11_assembly(RS895);
//translate_z(-SPINDLE_shaft_collar_heigth(RS895))
//cylinder(d = SPINDLE_shaft_collar_diameter(RS895), h = SPINDLE_shaft_collar_heigth(RS895));
//SPINDLE_cutouts(RS895, 20);