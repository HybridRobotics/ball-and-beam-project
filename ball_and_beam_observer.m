function dx = ball_and_beam_observer(t, x_observer, u)
p_ball = x_observer(1);
v_ball = x_observer(2);
theta = x_observer(3);
dtheta = x_observer(4);

g = 9.81;
r_arm = 0.0254;
L = 0.4255;
K = 1.5;
tau = 0.025;

a = 5 * g * r_arm / (7 * L);
b = (5 * L / 14) * (r_arm / L)^2;
c = (5 / 7) * (r_arm / L)^2;

A = [0 1; 0 0];
C = [1 0];

F = [0 1; 0 -1/tau];
G = [0; K/tau];
H = [1 0];

y_1 = C * [p_ball; v_ball];
y_2 = H * [theta; dtheta];

phi_1 = 0;
phi_2 = a * sin(theta) - b * dtheta^2 * cos(theta)^2 + c * p_ball * dtheta^2 * cos(theta)^2;
phi = [phi_1; phi_2];

p_1 = [-1 , -2]; % poles for K_1
K_2 = place(A', C', p)' ;

p_2 = [-1 , -2]; % poles for K_2
K_2 = place(F', H', p)' ;
 
% dynamics
dx = zeros(4, 1);
x_12 = A * [p_ball; v_ball] + phi + K_1 * (y_1 - C * [p_ball; v_ball]);
x_34 = F  * [theta; dtheta] + G * u + K_2 * (y_2 - H * [theta; dtheta]);
dx(1)= x_12(1);
dx(2)= x_12(2);
dx(3)= x_34(1);
dx(4)= x_34(2);
end