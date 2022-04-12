function [p_ref, v_ref] = get_ref_traj(t)
    amplitude = 0.04; % m
    period = 10; % sec
    
    omega = 2 * pi / period;    
    
    %% Sine wave.
    p_ref = amplitude * sin(omega * t);
    v_ref = amplitude * omega * cos(omega * t);
    %% Square wave.
%     p_ref = amplitude * sign(sin(omega * t));
%     v_ref = 0;
end