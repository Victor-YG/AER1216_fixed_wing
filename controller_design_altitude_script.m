run("parameters.m");

rho = P.air_density;
Va = P.Va;
c = properties.chord_length;
S = properties.wing_area;
J_y = properties.I_y;
C_m_q = properties.C_m_q;
C_m_a = properties.C_m_a;
C_m_de = properties.C_m_de;

a3 = 0.5 * rho * Va^2 * c * S * C_m_de / J_y;
a1 = -0.5 * rho * Va^2 * c * S * C_m_q * c / J_y / 2 / Va;
a2 = -0.5 * rho * Va^2 * c * S * C_m_a / J_y;