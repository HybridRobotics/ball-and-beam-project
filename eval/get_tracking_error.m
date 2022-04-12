function tracking_error = get_tracking_error(ts, ps, ref_ps)
    if length(ts) ~= length(ps) || ...
            length(ts) ~= length(ref_ps)
        error('Wrong data size.');
    end

    dt = ts(2) - ts(1);
    tracking_error = sum((ps - ref_ps).^2) * dt / (ts(end) - ts(1));

    fprintf('Tracking error: %.2f \n', tracking_error);
end