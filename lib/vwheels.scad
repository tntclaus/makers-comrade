include <bearings.scad>

//              name,                              outer_dia,   outer_dia2, inner_dia,  thick, thick_edge, color
WHEEL_DERLIN = ["v_wheel(derlin): Derlin V Wheel",      24.2,         20.2,        16,  10.25,        6.2, "black"];
WHEEL_PC = ["v_wheel(pc): Polycarbonate V Wheel",       24.2,         20.2,        16,  10.25,        6.2, "white"];
WHEEL_STEEL_V = ["v_wheel(steel): Steel V Wheel",       24.35,        20.2,        16,  10.25,        5.4, "silver"];

// wheels        name           model,  bearings,   type
//MINI_DERLIN = [   "",         "mini", BB625_2RS, "black"]
//MINI_DERLIN = [   "", "mini", BB625_2RS, "black"]
//MINI_DERLIN = [   "", "mini", BB625_2RS, "black"]
S_DERLIN_2RS = [    "", "standard", BB625_2RS, WHEEL_DERLIN];
S_XTREME_2RS = [    "", "standard", BB625_2RS, WHEEL_PC];
S_STEEL_2RS = ["", "standard", BB625_2RS, WHEEL_STEEL_V];
S_STEEL_ZZ = [ "", "standard", BB625_ZZ, WHEEL_STEEL_V];

D_DERLIN_2RS = [    "", "double",   BB625_2RS, WHEEL_DERLIN];
D_XTREME_2RS = [    "", "double",   BB625_2RS, WHEEL_PC];
D_STEEL_2RS = ["", "double",   BB625_2RS, WHEEL_STEEL_V];
D_STEEL_ZZ = [ "", "double",   BB625_ZZ, WHEEL_STEEL_V];


use <vwheel.scad>

//vwheel(S_ALUMINIMUM_2RS);
