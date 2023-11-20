% AER1216 project
% Pouya Asgharzadeh, Vic Gao, Min Woo (David) Kong
% 1.1 Fixed-Wing UAS Development

% Import altitude and density data from a text file
% https://www.eoas.ubc.ca/courses/atsc113/flying/met_concepts/03-met_concepts/03a-std_atmos/index.html
air_atm = importdata('air_atm.txt');
h_data = air_atm.data(1:end, 1);  % altitude data (first column)
temp_data = air_atm.data(1:end, 2);  % temperature data (second column)
press_data = air_atm.data(1:end, 3);  % pressure data (third column)
rho_data = air_atm.data(1:end, 4);  % air density data (fourth column)

for i = 1:length(h_data)
    height_curr = h_data(i);
    temp_curr = temp_data(i);
    press_curr = press_data(i);
    rho_curr = rho_data(i);

    R = press_curr / (0.2869 * (temp_curr + 273.1));
end

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
