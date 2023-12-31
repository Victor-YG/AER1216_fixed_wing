function aircraft_dynamics(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the
%   name of your S-function.
%
%   It should be noted that the MATLAB S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%
%   Copyright 2003-2010 The MathWorks, Inc.

% AER1216 Fall 2023
% Fixed Wing Project Code
%
% aircraft_dynamics.m
%
% Fixed wing simulation model file, based on the Aerosonde UAV, with code
% structure adapted from Small Unmanned Aircraft: Theory and Practice by
% R.W. Beard and T. W. McLain.
%
% Inputs:
% delta_e           elevator deflection [deg]
% delta_a           aileron deflection [deg]
% delta_r           rudder deflection [deg]
% delta_t           normalized thrust []
%
% Outputs:
% pn                inertial frame x (north) position [m]
% pe                inertial frame y (east) position [m]
% pd                inertial frame z (down) position [m]
% u                 body frame x velocity [m/s]
% v                 body frame y velocity [m/s]
% w                 body frame z velocity [m/s]
% phi               roll angle [rad]
% theta             pitch angle [rad]
% psi               yaw angle [rad]
% p                 roll rate [rad/s]
% q                 pitch rate [rad/s]
% r                 yaw rate [rad/s]
%
% Last updated: Pravin Wedage 2023-10-26

%% TA NOTE
% The main code segements you must modify are located in the derivatives
% function in this .m file. In addition, for Q7, you may need to modify the
% setup function in order to input wind into the dynamics.
%
% Modify other sections at your own risk.


%
% The setup method is used to set up the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.
%
setup(block);

end


%% Function: setup ===================================================
% Abstract:
%   Set up the basic characteristics of the S-function block such as:
%   - Input ports
%   - Output ports
%   - Dialog parameters
%   - Options
%
%   Required         : Yes
%   C-Mex counterpart: mdlInitializeSizes
%
function setup(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
for i = 1:block.NumOutputPorts
    block.InputPort(1).Dimensions        = 7;
    block.InputPort(1).DatatypeID  = 0;  % double
    block.InputPort(1).Complexity  = 'Real';
    block.InputPort(1).DirectFeedthrough = false; % important to be false
end

% Override output port properties
for i = 1:block.NumOutputPorts
    block.OutputPort(i).Dimensions       = 12;
    block.OutputPort(i).DatatypeID  = 0; % double
    block.OutputPort(i).Complexity  = 'Real';
%     block.OutputPort(i).SamplingMode = 'Sample';
end

% Register parameters
block.NumDialogPrms     = 1;
P = block.DialogPrm(1).Data; % must duplicate this line in each function

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0 0];

% Register multiple instances allowable
% block.SupportMultipleExecInstances = true;

% Register number of continuous states
block.NumContStates = 12;

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

% -----------------------------------------------------------------
% The MATLAB S-function uses an internal registry for all
% block methods. You should register all relevant methods
% (optional and required) as illustrated below. You may choose
% any suitable name for the methods and implement these methods
% as local functions within the same file. See comments
% provided for each function for more information.
% -----------------------------------------------------------------

% block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup); % discrete states only
block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);
block.RegBlockMethod('InitializeConditions',    @InitializeConditions);
% block.RegBlockMethod('Start',                   @Start); % Initialize Conditions is used
block.RegBlockMethod('Outputs',                 @Outputs); % Required
% block.RegBlockMethod('Update',                  @Update); % only required for discrete states
block.RegBlockMethod('Derivatives',             @Derivatives); % Required for continuous states
block.RegBlockMethod('Terminate',               @Terminate); % Required

end


%% PostPropagationSetup:
%   Functionality    : Setup work areas and state variables. Can
%                      also register run-time methods here
%   Required         : No
%   C-Mex counterpart: mdlSetWorkWidths
%
function DoPostPropSetup(block)
block.NumDworks = 1;

  block.Dwork(1).Name            = 'x1';
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;

end


%% InitializeConditions:
%   Functionality    : Called at the start of simulation and if it is
%                      present in an enabled subsystem configured to reset
%                      states, it will be called when the enabled subsystem
%                      restarts execution to reset the states.
%   Required         : No
%   C-MEX counterpart: mdlInitializeConditions
%
function InitializeConditions(block)

% Rename parameters
P = block.DialogPrm(1).Data; % must duplicate this line in each function

% Initialize continuous states
block.ContStates.Data(1) = P.pn0;
block.ContStates.Data(2) = P.pe0;
block.ContStates.Data(3) = P.pd0;
block.ContStates.Data(4) = P.u0;
block.ContStates.Data(5) = P.v0;
block.ContStates.Data(6) = P.w0;
block.ContStates.Data(7) = P.phi0;
block.ContStates.Data(8) = P.theta0;
block.ContStates.Data(9) = P.psi0;
block.ContStates.Data(10) = P.p0;
block.ContStates.Data(11) = P.q0;
block.ContStates.Data(12) = P.r0;

end

%% Start:
%   Functionality    : Called once at start of model execution. If you
%                      have states that should be initialized once, this
%                      is the place to do it.
%   Required         : No
%   C-MEX counterpart: mdlStart
%
function Start(block)

block.Dwork(1).Data = 0;

end

%% Input Port Sampling Method:
function SetInpPortFrameData(block, idx, fd)

  block.InputPort(idx).SamplingMode = 'Sample';
  for i = 1:block.NumOutputPorts
    block.OutputPort(i).SamplingMode  = 'Sample';
  end
end

%% Outputs:
%   Functionality    : Called to generate block outputs in
%                      simulation step
%   Required         : Yes
%   C-MEX counterpart: mdlOutputs
%
function Outputs(block)

temp_mat = zeros(block.NumContStates,1); % thirteen states
for i = 1:block.NumContStates
     temp_mat(i) = block.ContStates.Data(i);
end

block.OutputPort(1).Data = temp_mat; % states

% for i = 1:block.NumOutputPorts
%     block.OutputPort(1).Data(i) = block.ContStates.Data(i);
% end

end


%% Update:
%   Functionality    : Called to update discrete states
%                      during simulation step
%   Required         : No
%   C-MEX counterpart: mdlUpdate
%
function Update(block)

block.Dwork(1).Data = block.InputPort(1).Data;

end


%% Derivatives:
%   Functionality    : Called to update derivatives of
%                      continuous states during simulation step
%   Required         : No
%   C-MEX counterpart: mdlDerivatives
%
function Derivatives(block)

load("parameters.mat")

% Rename parameters
P = block.DialogPrm(1).Data; % must duplicate this line in each function

% map states and inputs
pn    = block.ContStates.Data(1);
pe    = block.ContStates.Data(2);
pd    = block.ContStates.Data(3);
u     = block.ContStates.Data(4);
v     = block.ContStates.Data(5);
w     = block.ContStates.Data(6);
phi   = block.ContStates.Data(7);  % 1 - roll
theta = block.ContStates.Data(8);  % 2 - pitch
psi   = block.ContStates.Data(9);  % 3 - heading (yaw)
p     = block.ContStates.Data(10);
q     = block.ContStates.Data(11);
r     = block.ContStates.Data(12);

delta_e = block.InputPort(1).Data(1)*pi/180 ; % converted inputs to radians
delta_a = block.InputPort(1).Data(2)*pi/180 ; % converted inputs to radians
delta_r = block.InputPort(1).Data(3)*pi/180 ; % converted inputs to radians
delta_t = block.InputPort(1).Data(4);         % assume between 0 and 1

u_w = block.InputPort(1).Data(5); % wind speed
v_w = block.InputPort(1).Data(6);
w_w = block.InputPort(1).Data(7);

% rotation matrix
s1 = sin(phi);
c1 = cos(phi);
s2 = sin(theta);
c2 = cos(theta);
s3 = sin(psi);
c3 = cos(psi);

R = zeros(3, 3);
R(1, 1) = c2 * c3;
R(1, 2) = s1 * s2 * c3 - c1 * s3;
R(1, 3) = c1 * s2 * c3 + s1 * s3;
R(2, 1) = c2 * s3;
R(2, 2) = s1 * s2 * s3 + c1 * c3;
R(2, 3) = c1 * s2 * s3 - s1 * c3;
R(3, 1) = -s2;
R(3, 2) = s1 * c2;
R(3, 3) = c1 * c2;

wind_velocity_g = [u_w; v_w; w_w];
wind_velocity_b = transpose(R) * wind_velocity_g;

% Air Data
u_a = u - wind_velocity_b(1, 1);
v_a = v - wind_velocity_b(2, 1);
w_a = w - wind_velocity_b(3, 1);
Vg = sqrt(u^2 + v^2 + w^2);
Va = sqrt(u_a^2 + v_a^2 + w_a^2);
alpha = atan2(w_a, u_a);
beta = atan2(v_a, sqrt(u_a^2 + v_a^2 + w_a^2));

% Aerodynamic Coefficients
% compute the nondimensional aerodynamic coefficients here
scale_x = properties.chord_length / 2 / Va;
scale_y = properties.wing_span / 2 / Va;

C_L = properties.C_L_0;
C_L = C_L + properties.C_L_a * alpha;
C_L = C_L + properties.C_L_q * scale_x * q;
C_L = C_L + properties.C_L_de * delta_e;

C_D = properties.C_D_0;
C_D = C_D + properties.C_D_a * alpha;
C_D = C_D + properties.C_D_q * scale_x * q;
C_D = C_D + properties.C_D_de * delta_e;

C_m = properties.C_m_0;
C_m = C_m + properties.C_m_a * alpha;
C_m = C_m + properties.C_m_q * scale_x * q;
C_m = C_m + properties.C_m_de * delta_e;

C_Y = properties.C_Y_0;
C_Y = C_Y + properties.C_Y_b * beta;
C_Y = C_Y + properties.C_Y_p * scale_y * p;
C_Y = C_Y + properties.C_Y_r * scale_y * r;
C_Y = C_Y + properties.C_Y_da * delta_a;
C_Y = C_Y + properties.C_Y_dr * delta_r;

C_l = properties.C_Y_0;
C_l = C_l + properties.C_l_b * beta;
C_l = C_l + properties.C_l_p * scale_y * p;
C_l = C_l + properties.C_l_r * scale_y * r;
C_l = C_l + properties.C_l_da * delta_a;
C_l = C_l + properties.C_l_dr * delta_r;

C_n = properties.C_Y_0;
C_n = C_n + properties.C_n_b * beta;
C_n = C_n + properties.C_n_p * scale_y * p;
C_n = C_n + properties.C_n_r * scale_y * r;
C_n = C_n + properties.C_n_da * delta_a;
C_n = C_n + properties.C_n_dr * delta_r;

% aerodynamic forces and moments
% compute the aerodynamic forces and moments here
rho = P.air_density; % TODO::replace with the air density at current altitude
dynamic_pressure = 0.5 * rho * Va^2;
dynamic_force = dynamic_pressure * properties.wing_area;

F_L = C_L * dynamic_force;
F_D = C_D * dynamic_force;
F_Y = C_Y * dynamic_force;
L   = C_l * dynamic_force * properties.wing_span;
M   = C_m * dynamic_force * properties.chord_length;
N   = C_n * dynamic_force * properties.wing_span;

% propulsion forces and moments
% compute the propulsion forces and moments here
angular_velocity = delta_t * properties.prop_max_rpm * 2 * pi / 60 + 1; % add 1 to avoid divide by 0

advance_ratio = pi * Va / angular_velocity / properties.prop_radius;

C_T_J = C_T_0 + C_T_1 * advance_ratio + C_T_2 * advance_ratio^2;
C_Q_J = C_Q_0 + C_Q_1 * advance_ratio + C_Q_2 * advance_ratio^2 + C_Q_3 * advance_ratio^3;

rho_D = rho * properties.prop_diameter^4 / 4 / pi^2 * angular_velocity^2;
T_prop = C_T_J * rho_D;
Q_prop = C_Q_J * rho_D * properties.prop_diameter;

% gravity
% compute the gravitational forces here
F_G = P.g * properties.mass;

% total forces and moments (body frame)
X_sum = T_prop - F_G * s2 - F_D * cos(alpha) + F_L * sin(alpha);
Y_sum = F_G * s1 * c2 - F_Y;
Z_sum = F_G * c1 * c2 + F_D * sin(alpha) - F_L * cos(alpha);
L_sum = L - Q_prop; % assuming properller turning counterclockwise
M_sum = M;
N_sum = N;

% state derivatives
% the full aircraft dynamics model is computed here
pndot = u * c2 * c3 + v * (s1 * s2 * c3 - c1 * s3) + w * (c1 * s2 * c3 + s1 * s3);
pedot = u * c2 * s3 + v * (s1 * s2 * s3 + c1 * c3) + w * (c1 * s2 * s3 - s1 * c3);
pddot = u * (-s2) + v * s1 * c2 + w * c1 * c2;

udot = X_sum / properties.mass + r * v - q * w;
vdot = Y_sum / properties.mass + p * w - r * u;
wdot = Z_sum / properties.mass + q * u - p * v;

phidot = p + q * s1 * s2 / c2 + r * c1 * s2 / c2;
thetadot = q * c1 - r * s1;
psidot = q * s1 / c2 + r * c1 / c2;

pdot = k1 * p * q - k2 * q * r + k3 * L_sum + k4 * N_sum;
qdot = k5 * p * r - k6 * (p^2 - r^2) + M_sum / properties.I_y;
rdot = k7 * p * q - k1 * q * r + k4 * L_sum + k8 * N_sum;

% map derivatives
block.Derivatives.Data(1) = pndot;
block.Derivatives.Data(2) = pedot;
block.Derivatives.Data(3) = pddot;
block.Derivatives.Data(4) = udot;
block.Derivatives.Data(5) = vdot;
block.Derivatives.Data(6) = wdot;
block.Derivatives.Data(7) = phidot;
block.Derivatives.Data(8) = thetadot;
block.Derivatives.Data(9) = psidot;
block.Derivatives.Data(10)= pdot;
block.Derivatives.Data(11)= qdot;
block.Derivatives.Data(12)= rdot;

end


%% Terminate:
%   Functionality    : Called at the end of simulation for cleanup
%   Required         : Yes
%   C-MEX counterpart: mdlTerminate
%
function Terminate(block)

end

