function score = get_controller_score(ts, ps, thetas, ref_ps, us)
    if length(ts) ~= length(ps) || ...
            length(ts) ~= length(thetas) || ...
            length(ts) ~= length(ref_ps) || ...
            length(ts) ~= length(us)
        error('Wrong data size.');
    end
    if ts(end) < 90
        score = inf;
        return
    end            
    dt = ts(2) - ts(1);
    tracking_error = sum((ps - ref_ps).^2) * dt / (ts(end) - ts(1));
    control_cost = sum(us.^2) * dt / (ts(end) - ts(1));
    % binary
    safety_cost = any(ps(ts > 1) >= 0.19) || any(ps(ts > 1) <= -0.19) || ...
        any(thetas(ts > 1) >= deg2rad(60)) || any(thetas(ts > 1) <= -deg2rad(60));

    weight_tracking = 1800;
    weight_control_efficiency = 5;
    weight_safety = 10;

    fprintf('Average Tracking Error: %.4f \n', tracking_error);
    fprintf('Average Energy Consumption: %.4f \n', control_cost);
    fprintf('Safety Contraint Violation: %d \n', safety_cost);
    
    score = weight_tracking * tracking_error + weight_control_efficiency * control_cost ...
        + weight_safety * safety_cost;
    fprintf('Tracking Cost: %.2f \n', weight_tracking * tracking_error);
    fprintf('Energy Cost: %.2f \n', weight_control_efficiency * control_cost);
    fprintf('Safety Cost: %.2f \n', weight_safety * safety_cost);
    fprintf('Total Score: %.2f \n', score);
end