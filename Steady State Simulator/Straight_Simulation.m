function [sector_time, final_speed] = Straight_Simulation(...
    total_mass, us_mass_f, us_mass_r, wheelbase...
    , weight_distribution, track_f, track_r, hcg, hrf, hrr, huf...
    , hur, torque, rpm, gear_ratios, final_ratio, tire_radious...
    , brakes_g_force, rolling_coef, mr_wheel_spring_f...
    , mr_wheel_spring_r, mr_arb_f, mr_arb_r, k_spring_f...
    , k_spring_r, k_arb_f, k_arb_r, downforce_coef, drag_coef...
    , area, k_tire_f, k_tire_r, c2, c1, c0, air_t, atm_p, g, pi...
    , V_initial, V_final, straight_length, gearshift_delay)

% Performance Simulator v1.1
% Date: 2-12-2013
% Author: César Álvarez Porras (www.cesar-ap.com)

% Script: Calculates time spent in an straight sector given the initial
% speed, final speed, sector length and vehicle setup.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                              Execution                              %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf ('\n----------------------------------------------------------\n');
% fprintf ('Analyzing Straight Sector of length %d m.\n', straight_length);

% Calculate the accelertion part of the sector
[speed_acc, acceleration, gear, t_acc, RPM] = Straight_Acc_Simulation(pi...
    , total_mass, torque, rpm, gear_ratios, final_ratio, tire_radious...
    , drag_coef, area, air_t, atm_p, V_initial, straight_length...
    , rolling_coef, g, gearshift_delay);

% % Plotting Acceleration
% set(figure,'Name','Acceleration','NumberTitle','off');
% subplot(3,1,1);
% plot(distance,speed_acc);
% ylabel('Speed [Km/h]');
% grid on;
% subplot(3,1,2);
% plot(distance,gear);
% ylabel('Gear');
% grid on;
% subplot(3,1,3);
% plot(distance,RPM);
% xlabel('Distance [m]');
% ylabel('RPM');
% grid on;

% Calculate the braking part of the sector
[speed_brake, deceleration, F_brake, Fd_brake, t_brake] = Straight_Braking_Simulation(...
    total_mass, brakes_g_force, drag_coef, area, air_t, atm_p, V_final...
    , straight_length, rolling_coef, g);

% % Plotting Braking
% set(figure,'Name','Braking','NumberTitle','off');
% subplot(4,1,1);
% plot(distance,speed_brake);
% ylabel('Speed [Km/h]');
% grid on;
% subplot(4,1,2);
% plot(distance,F_brake);
% ylabel('Total Braking Force [N]');
% grid on;
% subplot(4,1,3);
% plot(distance,Fd_brake);
% ylabel('Aero Braking Force [N]');
% grid on;
% subplot(4,1,4);
% plot(distance,deceleration);
% xlabel('Distance [m]');
% ylabel('Deceleration [m/s^2]');
% grid on;


% % Plotting acceleration and braking together
% set(figure,'Name','Straight Sector','NumberTitle','off');
% plot(distance,speed_acc,distance,speed_brake);
% legend('Acceleration','Braking');
% grid on;


speed = zeros(1,straight_length); % array to keep speed (kmh) on every point
t = zeros(1,straight_length); % array to keep speed (kmh) on every point
acc_time = 0;
brake_time = 0;

if length(speed_acc)~=length(speed_brake)
    % Warning message if the amount of samples of acceleration and braking
    % are not equal. Cancel execution.
    fprintf('!! Warning: Acceleration speed array and Braking Speed array have different lengths !!!')
    fprintf('Execution halted on Straight_Simulation.m line 107')    
else
    % We are going to find the maximum speed the vehicle can accelerate before
    % applying brakes to satisfy the speed at the final of the sector. 
    % Since the vehicle has more deceleration than acceleration, the slope
    % of the braking speed is bigger than the slope on the acceleration
    % speed. Therefore the braking speed will be bigger than the
    % acceleration speed as long as the maximum speed point has not been
    % reached.    
    for i=1:length(speed_acc)
        if speed_acc(i)<speed_brake(i)
            % If the braking speed is bigger than the acceleration speed we
            % use the acceleration speed since the car is still speeding
            % up.
            speed(i) = speed_acc(i);
            t(i) = t_acc(i);
            acc_time = acc_time + t_acc(i);
        else
            % If the acceleration speed is bigger than the braking speed,
            % then we use the braking speed assuming the car has already
            % started the braking phase.
            speed(i) = speed_brake(i);
            t(i) = t_brake(i);
            brake_time = brake_time + t_brake(i);
        end
    end
end

% % Plotting acceleration and braking
% set(figure,'Name','Straight Sector','NumberTitle','off');
% plot(distance,speed);
% xlabel('Distance [m]');
% ylabel('Speed [Km/h]');
% grid on;

sector_time=0;
for i=1:length(t)
    sector_time = sector_time + t(i);
%     if i==1
%         t(i)=t(i);
%     elseif i>1
%         t(i)=t(i-1)+t(1);
%     end
end

final_speed = speed(end);
% fprintf ('The sector time is %d seconds (%d s accelerating and %d s under braking)\n', sector_time, acc_time, brake_time);
% fprintf ('----------------------------------------------------------\n');

end