function [p_ref, v_ref, a_ref] = get_ref_traj(t)
% [p_ref, v_ref, a_ref] = get_ref_traj(t)
%% Reference trajectory at time t:
%   Inputs
%       t: query time
%   Outputs
%       p_ref: reference position of the ball
%       v_ref: reference velocity of the ball
%       a_ref: reference acceleration of the ball
    amplitude = 0.04; % m
    period = 10; % sec
    
    omega = 2 * pi / period;    
    
    %% Sine wave.
    p_ref = amplitude * sin(omega * t);
    v_ref = amplitude * omega * cos(omega * t);
    a_ref = - amplitude * omega^2 * sin(omega * t);
    %% Square wave.
%     p_ref = amplitude * sign(sin(omega * t));
%     v_ref = 0;
%     a_ref = 0;
end