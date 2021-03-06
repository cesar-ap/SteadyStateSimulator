function [speed, gear, revs] = Graphics(total_mass, us_mass_f, us_mass_r...
    , wheelbase, weight_d, track_f, track_r, hcg, hrf, hrr, huf, hur...
    , torque, rpm, gear_ratios, final_ratio, tire_radious, brakes_g_force...
    , rolling_coef, mr_wheel_spring_f, mr_wheel_spring_r, mr_arb_f...
    , mr_arb_r, k_spring_f, k_spring_r, k_arb_f, k_arb_r...
    , downforce_coef, drag_coef, area, k_tire_f, k_tire_r, c2...
    , c1, c0, air_t, atm_p, g, pi, Distance, Corner_Radius...
    , Speed_initial, Speed_final, gearshift_delay, track_length)


% Total_Mass = 1200;% Kg
% Torque = [300, 330, 370, 400, 450, 470, 520, 580, 620, 660, 680, 670, 640, 620, 600, 590, 570];
% RPM =    [2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000];
% Gear_Ratios = [3.1, 2.3, 1.9, 1.7, 1.5, 1.4];
% Final_Ratio = 2.8;
% Tire_Radious = 0.3;% m
% Brakes_G_Force = 1; % G
% rolling_coef = 0.396;
% gearshift_delay = 0.02; % s
% air_t = 23;% C degrees
% atm_p = 1000;% mbar
% Drag_Coef = 0.45;% 
% Area = 1.425;% m^2 
% total_mass = Total_Mass;
% torque = Torque;
% rpm = RPM;
% gear_ratios = Gear_Ratios;
% final_ratio = Final_Ratio;
% tire_radious = Tire_Radious;
% brakes_g_force = Brakes_G_Force;
% drag_coef = Drag_Coef;
% area = Area;
% g = 9.81;
% 
% 
% track_length = 500;
% Distance =          [0, 200, 210, 220, 225, 230, 270, 280, 285, 290, 300, 310, 325, 335];
% Corner_Radious =    [0  120, 110, 100, 110, 0,   90,  85,  80,  70,  75,  80,  100, 0];
% Speed_initial =     [265,157,151,145,151,151,138,134,130,122,126,130,145,145];
% Speed_final =       [157,157,151,145,151,138,138,134,130,122,126,130,145,600];


% track_length = 700;
% Distance =          [0,   200, 215, 225, 230, 260, 350, 360, 375, 400];
% Corner_Radious =    [0    120,  80, 100, 130, 0,   120, 90,  50,  0];
% Speed_initial =     [265, 157,  130,145, 162, 162, 157, 140, 95,  95];
% Speed_final =       [157, 157,  130,145, 162, 157, 157, 140, 95,  600];

% Distance =          [0, 200, 215, 225, 230, 235, 500];
% Corner_Radious =    [0  120,  80, 100, 130, 0, 0];
% Speed_initial =     [260, 135, 130, 135, 140, 140];
% Speed_final =       [130, 135, 130, 135, 140, 600];

% Define the final output arrays
speed = []; % array to save the speed trace for the circuit model
gear = []; % array to save the gear trace for the circuit model
revs = []; % array to save the RPM trace for the circuit model
throttle = []; % array to save the throttle segments
brake = []; % array to save the braking segments
steer = []; % array to save the steer segments

for segment = 1 : length(Distance)
    % Define the straight segment length
    if segment == length(Distance)
        % If looking at the last segment, calculate its length based on the
        % track total length.
        straight_length = track_length - Distance(segment);
    else
        % Otherwise calculate the segment length based on the next segment.
        straight_length = Distance(segment+1) - Distance(segment);
    end
    
    corner_radius = Corner_Radius(segment);
    
    V_initial = Speed_initial(segment);
    V_final = Speed_final(segment);
    
    speed_segment = zeros(1, straight_length); % new speed array for the current segment
    gear_segment = zeros(1, straight_length); % new gear array for the current segment
    revs_segment = zeros(1, straight_length); % new revs array for the current segment
    throttle_segment = zeros(1, straight_length);
    brake_segment = zeros(1, straight_length);
    steer_segment = zeros(1, straight_length);
    
    % Straight sector
    if corner_radius == 0 
        [speed_acc, acceleration, gear_segment, t_acc, revs_segment] = Straight_Acc_Simulation(pi...
        , total_mass, torque, rpm, gear_ratios, final_ratio, tire_radious...
        , drag_coef, area, air_t, atm_p, V_initial, straight_length...
        , rolling_coef, g, gearshift_delay);
    
        [speed_brake, deceleration, F_brake, Fd_brake, t_brake] = Straight_Braking_Simulation(...
        total_mass, brakes_g_force, drag_coef, area, air_t, atm_p, V_final...
        , straight_length, rolling_coef, g);

        for i=1:length(speed_acc)
            if speed_acc(i)<speed_brake(i)
                % If the braking speed is bigger than the acceleration speed we
                % use the acceleration speed since the car is still speeding
                % up.
                speed_segment(i) = speed_acc(i);
                throttle_segment(i) = 1;
            else
                % If the acceleration speed is bigger than the braking speed,
                % then we use the braking speed assuming the car has already
                % started the braking phase.
                speed_segment(i) = speed_brake(i);
                brake_segment(i) = 1;
                revs_segment(i) = 0;
            end
        end

    else % Corner sector
        for i=1:straight_length
            speed_segment(i) = V_initial;
            steer_segment(1) = 1;
        end
    end

    % Concatenate all the segment traces into the general arrays
    speed = cat(2,speed,speed_segment);
    gear = cat(2,gear,gear_segment);
    revs = cat(2,revs,revs_segment);

    throttle = cat(2,throttle,throttle_segment);
    brake = cat(2,brake,brake_segment);
    steer = cat(2,steer,steer_segment);
end


% Remove the Gear level 0 taking the next valid Gear level.
for i=length(gear):-1:1
    if gear(i)==0
        gear(i)=gear(i+1);
    end
end

% Plot of speed, gear and RPM
set(figure,'Name','Speed, Gear, RPM','NumberTitle','off');
subplot(3,1,1)
plot(speed);
ylabel('Speed [Km/h]');
subplot(3,1,2)
plot(gear);
ylim([0 6])
ylabel('Gear');
subplot(3,1,3)
plot(revs);
ylabel('RPM');
xlabel('Distance [m]');

% Plot of Throttle, Brake and Steer segments
set(figure,'Name','Throttle, Brake, Steer','NumberTitle','off');
subplot(3,1,1)
plot(throttle);
ylim([0 2])
ylabel('Throttle');
subplot(3,1,2)
plot(brake);
ylim([0 2])
ylabel('Brake');
subplot(3,1,3)
plot(steer);
ylim([0 2])
ylabel('Steer');
xlabel('Distance [m]');

end