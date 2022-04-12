%% SETUP_BALL_BEAM
% Sets the necessary parameters to run the Ball and Beam experiment.
%
clear;
%
%% Servo Configuration
% External Gear Configuration: set to 'HIGH' or 'LOW'
EXT_GEAR_CONFIG = 'HIGH';
% Type of Load: set to 'NONE', 'DISC', or 'BAR'
LOAD_TYPE = 'NONE';
% Amplifier gain used. 
% Note: VoltPAQ users: Set K_AMP to 1 and Gain switch on amplifier to 1
K_AMP = 1;
% Amplifier Type
AMP_TYPE = 'VoltPAQ';
% Is servo equipped with tachometer? Set to 'YES' or 'NO'
TACH_OPTION = 'NO';
%% System Parameters
% Sets model variables according to the user-defined system configuration
[ Rm, kt, km, Kg, eta_g, Beq, Jm, Jeq, eta_m, K_POT, K_ENC, VMAX_AMP, IMAX_AMP ] = config_servo( EXT_GEAR_CONFIG, TACH_OPTION, AMP_TYPE, LOAD_TYPE );
% Load Ball and Beam model parameters.
[ L, r_arm, r_b, m_b, J_b, g, THETA_OFF, THETA_MIN, THETA_MAX, K_BS] = config_bb( );
K = 10; % enter correct value
tau = 0.1; % enter correct value
