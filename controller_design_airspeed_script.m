clc 

run("parameters.m"); 

g = P.g;
rho = P.air_density;
m = properties.mass;
Va0 = P.Va0;
S = properties.wing_area;
CD0 = properties.C_D_0;
CDa = properties.C_D_a;
CDde = properties.C_D_de;
alpha0 = P.delta_a0;
de0 = P.delta_e0;
Sprop = properties.prop_disk_area;
Cprop = 1;
kmotor = 0.8;
dt = P.delta_t0;
theta = P.theta0;
X = P.psi0;


%%setup to get something not 0
dt = 0.5;

aV1 = (rho/m) *( (Va0*S) ...
    *(CD0+CDa*alpha0+CDde*de0 ) + (Sprop*Cprop*Va0));
aV2 = (rho/m) *( Sprop*Cprop*kmotor^2*dt);
aV3 = g*cos(theta-X);
