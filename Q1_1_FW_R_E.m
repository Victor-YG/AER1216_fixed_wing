% AER1216 project
% Pouya Asgharzadeh, Vic Gao, Min Woo (David) Kong
% 1.1 Fixed-Wing UAS Development

% https://laws-lois.justice.gc.ca/eng/regulations/sor-96-433/page-56.html
% assumed altitude of the flight above sea level in (m)
Altitude = 500; % for aeroplanes, 1,000 feet above

Fuel_Cap = properties.fuel_cap; % amount of fuel in kg

% Jet A-1 is a type of aviation fuel commonly used
% https://code7700.com/fuel_density.htm
Fuel_Density = (775.0 + 840.0) / 2; % density of Jet A-1 fuel (kg/m^3)

% weight of the fuel in N
W_fuel_full = Fuel_Cap * Fuel_density * P.gravity;

% calculations
AR = properties.wing_span / properties.chord_length;
K = 1 / (pi * AR * properties.efficiency_factor);
Prop_Diam = sqrt(properties.prop_disk_area/pi) * 2 / 0.0254;
Prop_Radius = Prop_Diam / 2;
