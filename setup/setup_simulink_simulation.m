%% SETUP_BALL_BEAM
% Sets the necessary parameters to run the Ball and Beam experiment.
%
clear;

%% System Parameters
% Load Ball and Beam model parameters.
[ L, r_arm, r_b, m_b, J_b, g, THETA_OFF, THETA_MIN, THETA_MAX, K_BS] = config_bb( );
%
%% Calculate Control Parameters
% Load model parameters based on servo configuration.    
K = 1.5; % enter correct value
tau = 0.025; % enter correct value
K_bb = 0.82;


