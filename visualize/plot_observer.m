function plot_observer(ts, xs, x_obs_s, ref_ps, ref_vs, theta_ds)

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

subplot(4, 1, 1);
plot(ts, 100 * xs(1, :), 'LineWidth', 1.5);
hold on;
plot(ts, 100 * x_obs_s(1, :), '--', 'LineWidth', 1.5);
%plot(ts, 100 * ref_ps, '-.', 'LineWidth', 1.5);
ylabel('$z$ [cm]', 'Interpreter', 'latex');
grid on;
title('State vs. Observer');


subplot(4, 1, 2);
plot(ts, 100 * xs(2, :), 'LineWidth', 1.5);
hold on;
plot(ts, 100 * x_obs_s(2, :), '--', 'LineWidth', 1.5);
%plot(ts, 100 * ref_vs, '-.', 'LineWidth', 1.5);
grid on;
ylabel('$\dot{z}$ [cm / s]', 'Interpreter', 'latex');

subplot(4, 1, 3);
plot(ts, 180 * xs(3, :) / pi, 'LineWidth', 1.5);
hold on;
plot(ts, 180 * x_obs_s(3, :)/pi, '--', 'LineWidth', 1.5);
ylabel('$\theta$ [deg]', 'Interpreter', 'latex');
grid on;

subplot(4, 1, 4);
plot(ts, 180 * xs(4, :) / pi, 'LineWidth', 1.5);
hold on;
plot(ts, 180 * x_obs_s(4, :)/pi, '--', 'LineWidth', 1.5);
ylabel('$\dot{\theta}$ [deg/s]', 'Interpreter', 'latex');
xlabel('$t$ [sec]', 'Interpreter', 'latex');
grid on;
end