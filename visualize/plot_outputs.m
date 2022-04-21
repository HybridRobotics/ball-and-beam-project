function plot_outputs(ts, ps, thetas, ref_ps, theta_ds)
if nargin < 4
    ref_ps = [];
end

if nargin < 5
    theta_ds = []; 
end

fig = figure();
% Set up font size.
set(fig, 'DefaultAxesFontSize', 16);
% Set up font name
set(fig, 'DefaultTextFontName', 'Times New Roman');
% Set up interpreter
set(fig, 'DefaultTextInterpreter', 'latex');

subplot(2, 1, 1);
plot(ts, 100 * ps, 'LineWidth', 1.5);
if ~isempty(ref_ps)
    hold on;
    plot(ts, 100 * ref_ps, 'r:', 'LineWidth', 1.5);
end
ylabel('$z$ [cm]', 'Interpreter', 'latex');
grid on;
title('State History');

subplot(2, 1, 2);
plot(ts, 180 * thetas / pi, 'LineWidth', 1.5);
ylabel('$\theta$ [deg]', 'Interpreter', 'latex');
xlabel('$t$ [sec]', 'Interpreter', 'latex');

if ~isempty(theta_ds)
    hold on;
    plot(ts, 180 * theta_ds / pi, 'r:', 'LineWidth', 1.5);
end
grid on;
