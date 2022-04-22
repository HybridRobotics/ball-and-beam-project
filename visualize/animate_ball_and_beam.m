function animate_ball_and_beam(ts, ps, thetas, ref_ps, video, play_speed, title_str, t_final, dt_frame)
if nargin < 5
    video = false;
end
if nargin < 6
    play_speed = 1.0;
end
if nargin < 7
    title_str = ' ';
end
if nargin < 8
    t_final = ts(end);
end
if nargin < 9
    dt_frame = 0.02; % 50 fps
end

    fig = figure();
    % Set up font size.
    set(fig, 'DefaultAxesFontSize', 16);
    % Set up font name
    set(fig, 'DefaultTextFontName', 'Times New Roman');
    % Set up interpreter
    set(fig, 'DefaultTextInterpreter', 'latex');
    dt = ts(2) - ts(1);
    if dt <= dt_frame
        down_sample_ratio = floor(dt_frame / dt);
    else
        error('dt_frame should not be smaller than dt');
    end
    frame_rate = dt * down_sample_ratio / play_speed;

    if video
        extraArgs.videoFilename = ...
            [datestr(now,'YYYYMMDD_hhmmss') '.mp4'];
        vout = VideoWriter(extraArgs.videoFilename,'MPEG-4');
        vout.Quality = 100;
        vout.FrameRate = 1/frame_rate;
        vout.open;
    end
    title_str = strcat(title_str, ' (play speed: x', num2str(play_speed, '%.2f'), ')');
    
    for i =1:down_sample_ratio:length(ts) 
        if ts(i) > t_final 
            break
        end
        clf;
        theta = thetas(i);
        z = ps(i);
        r_arm = 0.0254;
        L = 0.4255;
        alpha = asin(r_arm / L * sin(theta));
        line([0, L * cos(alpha)], [0, L * sin(alpha)],'Color', 'k', 'LineWidth', 2);
        hold on;
        scatter(0, 0, 50, 'k');
        center_ball_x = (0.5 * L - z) * cos(alpha);
        center_ball_y = (0.5 * L - z) * sin(alpha);
        ball_radius = 0.01;
        center_ball_x = center_ball_x - ball_radius * sin(alpha);
        center_ball_y = center_ball_y + ball_radius * cos(alpha);
        if ts(i) > 1 && (z < -0.199 || z > 0.199)
            draw_circle([center_ball_x, center_ball_y], ball_radius, 'unsafe');
        else
            draw_circle([center_ball_x, center_ball_y], ball_radius, 'actual');
        end
            
        center_desired_x = (0.5 * L - ref_ps(i)) * cos(alpha) - ball_radius * sin(alpha);
        center_desired_y = (0.5 * L - ref_ps(i)) * sin(alpha) + ball_radius * cos(alpha);
        draw_circle([center_desired_x, center_desired_y], ball_radius, 'desired'); 
        
        servo_x = L-r_arm ; servo_y = -r_arm*1.5 ;
        draw_circle([servo_x, servo_y], r_arm, 'motor'); 
        hold on ;
        scatter(servo_x, servo_y, 50, 'k'); 
        scatter(servo_x+r_arm*cos(theta), servo_y+r_arm*sin(theta), 50, 'k') ;
        scatter(L*cos(alpha), L*sin(alpha), 50, 'k') ;
        line([servo_x+r_arm*cos(theta), L*cos(alpha)], [servo_y+r_arm*sin(theta), L*sin(alpha)],'Color', 'k', 'LineWidth', 2) ;
        line([servo_x+r_arm*cos(theta), servo_x], [servo_y+r_arm*sin(theta), servo_y],'Color', 'k', 'LineWidth', 2) ;
        
        axis([-0.05, 0.45, -0.145, 0.145]);
        axis equal;
        title(title_str);
        grid on ;
        drawnow ;
        pause(0.001) ;
        if video
            current_frame = getframe(gcf); %gca does just the plot
            writeVideo(vout,current_frame);
        end        
            
    end

     if video
          vout.close
     end
     
end

function h = draw_circle(center,r, type)

hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + center(1);
yunit = r * sin(th) + center(2);
if strcmp(type, 'desired')
    h = plot(xunit, yunit, 'r:', 'LineWidth', 1.5);    
elseif strcmp(type, 'actual')
    fill(xunit,yunit,[1,1,1],'FaceColor',[0.5, 0.5, 0.5],'EdgeColor','none')
elseif strcmp(type, 'unsafe')
    fill(xunit,yunit,[1,1,1],'FaceColor',[1.0, 0.2, 0.2],'EdgeColor','none')    
elseif strcmp(type, 'motor')
    h = plot(xunit, yunit, 'k-.', 'LineWidth', 1.5);
else
    error('Unknown type.');    
end
hold off
end
