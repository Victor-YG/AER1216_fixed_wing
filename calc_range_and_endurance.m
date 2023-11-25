% AER1216 project
% Pouya Asgharzadeh, Vic Gao, Min Woo (David) Kong
% 1.1 Fixed-Wing UAS Development

load("parameters.mat")

b = properties.wing_span
c = properties.chord_length
e = properties.efficiency_factor
S = properties.wing_area
C_D_0 = properties.C_D_0

AR = b / c
K = 1 / pi / e / AR

C_L_Pmin = sqrt(C_D_0 / K)

W1 = 9.1 * 9.81
W0 = W1 + 4 * 9.81
rho = 1.1116
SFC = 0.6651 / 1000 / 3600

E = sqrt(rho * S) / sqrt(8) / SFC * power(C_L_Pmin, 1.5) / C_D_0 * (1 / sqrt(W1) - 1 / sqrt(W0)) / 3600 % in hour

R = 1 / SFC / 2 / sqrt(K * C_D_0) * log(W0 / W1) / 1000