run("parameters.m");

g = P.gravity;
Vg = 70 / 3.6;
rho = P.air_density;
S = properties.wing_area;
b = properties.wing_span;
C_p_p  = k3 * properties.C_l_p  + k4 * properties.C_n_p;
C_p_da = k3 * properties.C_l_da + k4 * properties.C_n_da;

a1 = -0.5 * rho * Vg^2 * S * b * C_p_p * b / 2 / Vg
a2 =  0.5 * rho * Vg^2 * S * b * C_p_da
