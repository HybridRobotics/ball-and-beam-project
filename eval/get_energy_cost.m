function control_cost = get_energy_cost(ts, us)
    if length(ts) ~= length(us)
        error('Wrong data size.');
    end
    dt = ts(2) - ts(1);

    control_cost = sum(us.^2) * dt / (ts(end) - ts(1));
    fprintf('Control cost: %.2f \n', control_cost);
end