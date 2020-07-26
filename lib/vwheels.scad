

// bearings
BB625_2RS =  ["625",  5,  16, 5, "orange", 1, 1];
BB625_ZZ =  ["625",  5,  16, 5, "silver", 1, 1];


// wheels        name           model,  bearings,   type
//MINI_DERLIN = [   "",         "mini", BB625_2RS, "black"]
//MINI_DERLIN = [   "", "mini", BB625_2RS, "black"]
//MINI_DERLIN = [   "", "mini", BB625_2RS, "black"]
S_DERLIN_2RS = [    "", "standard", BB625_2RS, "black"];
S_XTREME_2RS = [    "", "standard", BB625_2RS, "xtreme"];
S_ALUMINIMUM_2RS = ["", "standard", BB625_2RS, "metal"];
S_ALUMINIMUM_ZZ = [ "", "standard", BB625_ZZ, "metal"];
D_DERLIN_2RS = [    "", "double",   BB625_2RS, "black"];
D_XTREME_2RS = [    "", "double",   BB625_2RS, "xtreme"];
D_ALUMINIMUM_2RS = ["", "double",   BB625_2RS, "metal"];
D_ALUMINIMUM_ZZ = [ "", "double",   BB625_ZZ, "metal"];


use <vwheel.scad>

//vwheel(S_ALUMINIMUM_2RS);