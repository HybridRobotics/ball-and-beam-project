function dx = ball_and_beam_dynamics(t, x, u)
p_ball = x(1);
v_ball = x(2);
theta = x(3);
dtheta = x(4);

g = 9.81;
r_arm = 0.0254;
L = 0.4255;

a = 5 * g * r_arm / (7 * L);
b = (5 * L / 14) * (r_arm / L)^2;
c = (5 / 7) * (r_arm / L)^2;

dx = zeros(4, 1);

% dynamics
dx(1) = v_ball;
dx(2) = a * sin(theta) - b * dtheta^2 * cos(theta)^2 + c * p_ball * dtheta^2 * cos(theta)^2;
dx(3) = dtheta;
K = 10;
tau = 0.1;
dx(4) = (- dtheta + K * u) / tau; 
end