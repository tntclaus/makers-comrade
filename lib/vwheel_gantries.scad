include <vwheel_plates.scad>
include <vwheel_assemblies.scad>


S_20_TRIANGLE_GANTRY = ["", GEOM_TR_20, [   S_XTREME_VW_SPACER,
                                            S_XTREME_VW_ECCENT,
                                            S_XTREME_VW_SPACER], 20];

S_40_TRIANGLE_GANTRY = ["", GEOM_TR_40, [   S_XTREME_VW_SPACER,
                                            S_XTREME_VW_ECCENT,
                                            S_XTREME_VW_SPACER], 40];


D_20_TRIANGLE_GANTRY = ["", GEOM_TR_20, [   D_XTREME_VW_SPACER,
                                            D_XTREME_VW_ECCENT,
                                            D_XTREME_VW_SPACER], 20];
                                            
D_40_TRIANGLE_GANTRY = ["", GEOM_TR_40, [   D_XTREME_VW_SPACER,
                                            D_XTREME_VW_ECCENT,
                                            D_XTREME_VW_SPACER], 40];

use <vwheel_gantry.scad>

//vwheel_gantry(D_40_TRIANGLE_GANTRY);