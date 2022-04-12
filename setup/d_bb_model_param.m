%% D_BB_MODEL_PARAM
%
% Calculates the Ball and Beam model gain K_bb.
%
% ************************************************************************
% Input parameters:
% r_arm     Distance between servo output gear shaft and coupled joint                                       (m)
% L         Beam length                                         (m)

%
% ************************************************************************
% Output paramters:
% K_bb      Model gain                                          (m/s^2/rad)
%
% Copyright (C) 2020 Quanser Consulting Inc.
% Quanser Consulting Inc.
%%
%
function [ K_bb ] = d_bb_model_param(r_arm, L)
    % Gravitational constant (m/s^2)
    g = 9.81;
    % Model gain (m/s^2/rad)
    K_bb = 5/7 * g * r_arm / L;
end
