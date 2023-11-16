% AER1216 project
% Pouya Asgharzadeh, Vic Gao, Min Woo (David) Kong
% 1.1 Fixed-Wing UAS Development

AR = properties.wing_span/properties.chord_length;
K = 1 / (pi*AR*properties.efficiency_factor);
