function [value, isterminal, direction] = event_ball_out_of_range(t, x)
    if x(1) > 0.25 || x(1) < -0.25 || x(3) > pi/2 - 0.01 || x(3) < -pi/2 + 0.01
        value = -1;
    else
        value = 1;
    end
    
    isterminal = 1;
    direction = -1;
end