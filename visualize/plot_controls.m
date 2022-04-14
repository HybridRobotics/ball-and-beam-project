function plot_controls(ts, us)

fig = figure();
% Set up font size.
set(fig, 'DefaultAxesFontSize', 16);
% Set up font name
set(fig, 'DefaultTextFontName', 'Times New Roman');
% Set up interpreter
set(fig, 'DefaultTextInterpreter', 'latex');

plot(ts, us, 'LineWidth', 1.5);
ylabel('$u$ [V]');
xlabel('$t$ [sec]');
grid on;    
title('Control Input History');