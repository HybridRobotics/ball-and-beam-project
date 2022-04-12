function safety_cost = get_safety_cost(ts, ps)
    if length(ts) ~= length(ps) 
        error('Wrong data size.');
    end
    % binary
    safety_cost = any(ps(ts > 1) >= 0.199) || any(ps(ts > 1) <= -0.199);
    fprintf('Safety Contraint Violation: %d \n', safety_cost);    
end