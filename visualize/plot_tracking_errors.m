function plot_tracking_errors(ts, ps, ref_ps)

fig = figure();
% Set up font size.
set(fig, 'DefaultAxesFontSize', 16);
% Set up font name
set(fig, 'DefaultTextFontName', 'Times New Roman');
% Set up interpreter
set(fig, 'DefaultTextInterpreter', 'latex');

plot(ts, (100 * abs(ps - ref_ps)), 'LineWidth', 1.5);
ylabel('$|z-z_r|$ [cm]');
xlabel('$t$ [sec]', 'Interpreter', 'latex');
grid on;
title('Output error');
