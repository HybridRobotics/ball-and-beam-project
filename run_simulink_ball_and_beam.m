setup_simulink_simulation;
% Initial state.
x0 = [-0.19; 0.00; 0; 0];
% Simulation time.
T = 10;
% plot animation if true.
plot_animation = false;
% save animation to video if true.
save_video = false;

% Run the simulink file. 
sim('simulink_simulation', T);

% Evaluate the score of the controller.
score = get_controller_score(ts, ps, thetas, ref_ps, us);

%% Plots
% Plot outputs.
plot_outputs(ts, ps, thetas, ref_ps);
% Plot output errors.
plot_tracking_errors(ts, ps, ref_ps);        
% Plot control input history.
plot_controls(ts, us);

if plot_animation
    animate_ball_and_beam(ts, ps, thetas, ref_ps, save_video);
end