classdef studentControllerInterface < matlab.System
    properties (Access = private)
        %% You can add values that you want to store and updae while running your controller.
        % For more information of the supported data type, see
        % https://www.mathworks.com/help/simulink/ug/data-types-supported-by-simulink.html

        % Physical/simulation parameters
        g = 9.81;
        r_arm = 0.0254;
        L = 0.4255;
        K = 1.5;
        tau = 0.025;

        % Observer parameters
        A = [0 1; 0 0];
        F = [0 1; 0 0];
        G = [0; 1];
        C = [1 0];
        H = [1 0];
        K1 = [2; 1];
        K2 = [2; 1];

        % These variables may change every step
        t_prev = -1;
        u = 0;
        theta_d = 0;
        a_ball_ref_prev = 0;
        j_ball_ref_prev = 0;
        x_obs = [-0.19 0 0 0]';
        max_angle = false;

        % To be initialized
        alpha
        beta

    end
    methods(Access = protected)
        function setupImpl(obj)
           obj.alpha = (5/7)*obj.g*obj.r_arm/obj.L;
           obj.beta = 5*obj.r_arm^2/7/obj.L^2;
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

            % Time step
            delta_t = t-obj.t_prev;

            % Extract reference trajectory at the current timestep.
            [p_ball_ref, v_ball_ref, a_ball_ref] = get_ref_traj(t);
            j_ball_ref = (a_ball_ref-obj.a_ball_ref_prev)/delta_t;
            s_ball_ref = (j_ball_ref-obj.j_ball_ref_prev)/delta_t;
            
            % Change of variables
            p_ball_ref = p_ball_ref-obj.L/2;
            p_ball = p_ball-obj.L/2;
            
            % Extract x_2 and x_4 using observer
            w = obj.x_obs(1:2);
            z = obj.x_obs(3:4);
            phi = [0; obj.alpha*sin(theta)+obj.beta*p_ball*z(2)^2*cos(theta)^2];
            w(1) = w(1)-obj.L/2;
            w = w + (obj.A*w+phi+obj.K1*(p_ball-obj.C*w))*delta_t;
            w(1) = w(1)+obj.L/2;
            z = z + (obj.F*z+obj.G*obj.u+obj.K2*(theta-obj.H*z))*delta_t;
            obj.x_obs = [w; z];
            v_ball = w(2);
            dtheta = z(2);

            % Control law
            xi = [p_ball, v_ball, obj.alpha*sin(theta), obj.alpha*dtheta*cos(theta)];
            e = [p_ball_ref, v_ball_ref, a_ball_ref, j_ball_ref] - xi;
            b = [1 1];
            k = flip(conv(b,conv(b,conv(b,b))));
            k = k(1:4);
            obj.u = (obj.alpha*dtheta^2*sin(theta)+s_ball_ref+k*e')/(obj.alpha*cos(theta));

            % Safety Catch
            if theta-pi/3 > 0
                obj.u = min(obj.u, -dtheta/delta_t);
            elseif theta+pi/3 < 0
                obj.u = max(obj.u, -dtheta/delta_t);
            end

            % Change of variables
            V_servo = (obj.u*obj.tau+dtheta)/obj.K;
            
            % Update variables
            obj.t_prev = t;
            obj.a_ball_ref_prev = a_ball_ref;
            obj.j_ball_ref_prev = j_ball_ref;
        end
    end
    
    methods(Access = public)
        % Used this for matlab simulation script. fill free to modify it as
        % however you want.
        function [V_servo, theta_d, x_obs] = stepController(obj, t, p_ball, theta)
            if t == 0
                setupImpl(obj)
            end
            V_servo = stepImpl(obj, t, p_ball, theta);
            theta_d = obj.theta_d;
            x_obs = obj.x_obs;
        end
    end
    
end
