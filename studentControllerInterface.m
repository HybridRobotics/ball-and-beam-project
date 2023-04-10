classdef studentControllerInterface < matlab.System
    properties (Access = private)
        %% You can add values that you want to store and updae while running your controller.
        % For more information of the supported data type, see
        % https://www.mathworks.com/help/simulink/ug/data-types-supported-by-simulink.html
        t_prev = 0 ;
        theta_d = 0;
        V_prev = 0;
        x_obs= [-0.19; 0.00; 0; 0];
    end
    methods(Access = protected)
        % function setupImpl(obj)
        %    disp("You can use this function for initializaition.");
        % end

        function dx = ball_and_beam_observer(obj, t, x_observer, u)
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
            K_1 = place(A', C', p_1)' ;
            
            p_2 = [-1 , -2]; % poles for K_2
            K_2 = place(F', H', p_2)' ;
             
            % dynamics
            dx = zeros(4, 1);
            x_12 = A * [p_ball; v_ball] + phi + K_1 * (y_1 - C * [p_ball; v_ball]);
            x_34 = F  * [theta; dtheta] + G * u + K_2 * (y_2 - H * [theta; dtheta]);
            dx(1)= x_12(1);
            dx(2)= x_12(2);
            dx(3)= x_34(1);
            dx(4)= x_34(2);
            end

        function V_servo = stepImpl(obj, t, p_ball, theta)
        % This is the main function called every iteration. You have to implement
        % the controller in this function, bu you are not allowed to
        % change the signature of this function. 
        % Input arguments:
        %   t: current time
        %   p_ball: position of the ball provided by the ball position sensor (m)
        %
        %   theta: servo motor angle provided by the encoder of the motor (rad)
        % Output:
        %   V_servo: voltage to the servo input.        
            %% Sample Controller: Simple Proportional Controller
            t_prev = obj.t_prev;
            %disp([t_prev,t]);
            % Extract reference trajectory at the current timestep.
            [p_ball_ref, v_ball_ref, a_ball_ref] = get_ref_traj(t);
            omega = 2 * pi / 10;
            j_ball_ref = - 0.04 * omega^3 * cos(omega * t);
            s_ball_ref = 0.04 * omega^4 * sin(omega * t);
            
            %Extract the x_2 and x_4 from the observer 
            [t_obs_t, x_obs_t] = ode45( ...
            @(t, x) ball_and_beam_observer(obj, t, x, obj.V_prev), ...
            [t_prev, t+1e-8], obj.x_obs);

           
            obj.x_obs = x_obs_t(end, :)';

            v_ball = obj.x_obs(2);
            dtheta = obj.x_obs(4);
            %display(x_obs_t);

            g = 9.81;
            r_arm = 0.0254;
            L = 0.4255;
            K = 1.5;
            tau = 0.025;
            
            a = 5 * g * r_arm / (7 * L);
            b = (5 * L / 14) * (r_arm / L)^2;
            c = (5 / 7) * (r_arm / L)^2;

            alpha = (5/7)*g*r_arm/L;
            beta = (5/7)*(r_arm/L)^2;

            p_ball_ref = p_ball_ref-L/2;
            p_ball = p_ball-L/2;

            k = 30*[1 4 6 4];

            phi = [p_ball,v_ball,alpha*sin(theta),alpha*dtheta*cos(theta)];
            e = [p_ball_ref,v_ball_ref,a_ball_ref,j_ball_ref] - phi;

            u = (alpha*dtheta*sin(theta)+s_ball_ref+k*e')/(alpha*cos(theta));
            V_servo = (u*tau+dtheta)/K;

            %display(V_servo);

            obj.t_prev = t;
            obj.V_prev = V_servo;
            
% 
%             A_t = zeros(4);
%             B_t = [0; 0; 0; K/tau];
%             R = 1;
%             Q = [10 0 0 0 ; 0 10 0 0 ; 0 0 1 0; 0 0 0 1];
%     
% 
%             % Decide desired servo angle based on simple proportional feedback.
%             k_p = 3;
%             theta_d = - k_p * (p_ball - p_ball_ref);
% 
%             % Make sure that the desired servo angle does not exceed the physical
%             % limit. This part of code is not necessary but highly recommended
%             % because it addresses the actual physical limit of the servo motor.
%             theta_saturation = 56 * pi / 180;    
%             theta_d = min(theta_d, theta_saturation);
%             theta_d = max(theta_d, -theta_saturation);
% 
%             % Simple position control to control servo angle to the desired
%             % position.
%             k_servo = 10;
%             V_servo = k_servo * (theta_d - theta);
%             
%             % Update class properties if necessary.
%             obj.t_prev = t;
%             obj.theta_d = theta_d;
        end
    end
    
    methods(Access = public)
        % Used this for matlab simulation script. fill free to modify it as
        % however you want.
        function [V_servo, theta_d,x_obs] = stepController(obj, t, p_ball, theta)        
            V_servo = stepImpl(obj, t, p_ball, theta);
            theta_d = obj.theta_d;
            x_obs = obj.x_obs;
        end
    end
    
end
