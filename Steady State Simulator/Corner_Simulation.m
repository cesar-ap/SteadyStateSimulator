function [sector_time, max_speed_kmh, ay] = Corner_Simulation(total_mass, us_mass_f...
            , us_mass_r, wheelbase, weight_d, track_f, track_r, hcg...
            , hrf, hrr, huf, hur, torque, rpm, gear_ratios, final_ratio...
            , tire_radious, brakes_g_force, rolling_coef, mr_wheel_spring_f...
            , mr_wheel_spring_r, mr_arb_f, mr_arb_r, k_spring_f, k_spring_r...
            , k_arb_f, k_arb_r, downforce_coef, drag_coef, area, k_tire_f...
            , k_tire_r, c2, c1, c0, air_t, atm_p, g, pi...
            , distance, corner_radious, iterations)

% Performance Simulator v1.1
% Date: 2-12-2013
% Author: César Álvarez Porras (www.cesar-ap.com)

% Script: Calculates maximum lateral force for a given setup.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                         Variables Declaration                       %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial Scenario
ay = 1.8; % g
speed = 150; % Km/h

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                               Execution                             %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial calculations
us_mass = us_mass_f + us_mass_r; % total US Mass
s_mass = total_mass - us_mass; % total S Mass
hs = (total_mass * hcg - us_mass * (huf + hur)/2) / s_mass; % S Mass CG height
total_mass_f = total_mass * weight_d; %Kg
total_mass_r = total_mass * (1 - weight_d); %Kg 
s_mass_f = total_mass_f - us_mass_f; %Kg
s_mass_r = total_mass_r - us_mass_r; %Kg
a = total_mass_r / total_mass * wheelbase; %m
b = total_mass_f / total_mass * wheelbase; %m

% 1st - Calculate the Static Loads
Fz_static = Static_Load(total_mass, weight_d, g);

for i=1:iterations
    % Run three executions to perform the calculations with values closer
    % to the output

    % 2nd Calculate the initial AR Stiffness Distribution and the Roll Gradient
    [roll_gradient, AR_stiff_d_1, ha, ART_front, ART_rear] = Anti_Roll_Torque(...
        hs, a, b, hrf, hrr, wheelbase, track_f, track_r, k_spring_f, k_spring_r...
        , k_arb_f, k_arb_r, mr_wheel_spring_f, mr_wheel_spring_r, mr_arb_f...
        , mr_arb_r, s_mass, ay, g);
    %AR_stiff_d_1 % 1st Magic Number (1)

    % Calculate the Load Transfer Elastic distribution and total Load Transfer
    [LT_e_distribution, LT_distribution_1] = Load_Transfer(...
        s_mass_f, s_mass_r, us_mass_f, us_mass_r, AR_stiff_d_1 , huf, hur, hrf...
        , hrr, hs, ay, track_f, track_r);
    %LT_e_distribution % 1st Magic Number (2)
    %LT_distribution_1 % 2nd Magic Number 

    % Calculate the AR Stiffness Distribution considering the tire stiffness
    AR_stiff_d_2 = Third_Magic_Number(track_f, track_r, k_tire_f, k_tire_r...
        , ART_front, ART_rear);
    %AR_stiff_d_2 % 3rd Magic Number (1)

    % Re calculate the total Load Transfer considering the tire stiffness
    [LT_e_distribution, LT_distribution_2, LT_total_f, LT_total_r] = Load_Transfer(...
        s_mass_f, s_mass_r, us_mass_f, us_mass_r, AR_stiff_d_2 , huf, hur, hrf...
        , hrr, hs, ay, track_f, track_r);
    %LT_distribution_2 % 3rd Magic Number (2)
    %LT_total_f
    %LT_total_r

    % Calculate the Normal Load on each corner
    Fz = Normal_Load(Fz_static, LT_total_f, LT_total_r, ay, g);
    %Fz % Corner Loads

    % Calculate the Aerodynamic downforce
    Fz_downforce = Aerodynamics(air_t, atm_p, downforce_coef, area, speed);                    

    % Calculate the Lateral Force from the tires based on the Normal load
    Fz = Fz + Fz_downforce; % Add the Downforce to the Normal load
    Fy = Tire_Model(c2, c1, c0, g, Fz);
    %Fy % Lateral Force on each tire

    % Final calculations
    yaw_moment = a * (Fy(1,1) + Fy(1,2)) - b * (Fy(2,1) + Fy(2,2));

    Fy_total = Fy(1,1) + Fy(1,2) + Fy(2,1) + Fy(2,2);
    ay = Fy_total / total_mass;

    % Calculation of Sector Time and Maximum Speed.
    max_speed_ms = sqrt(ay * corner_radious);
    sector_time = distance / max_speed_ms;
    max_speed_kmh = max_speed_ms / 0.27;
    speed = max_speed_kmh;
end




%     % Plots Fy Fz points over Tire Response Graphs
%     Tire_Response(c2, c1, c0, g, Fz);

%     % Plotting Fy combined against Number of iterations
%     set(figure,'Name','Lateral Force Combined','NumberTitle','off');
%     scatter(number_of_iterations, Fy_combined,6,'r');
%     xlabel('Num Iterations');
%     ylabel('Lateral Force Combined [N]');
%     grid on;

%     % Plotting Lateral Force against Weight Distribution
%     set(figure,'Name','Lateral Force','NumberTitle','off');
%     subplot(2,2,1);
%     scatter(number_of_iterations, Fy(1,1,:),6,'r');
%     xlabel('Num Iterations');
%     ylabel('Lateral Force FL [N]');
%     grid on;
%     subplot(2,2,2);
%     scatter(number_of_iterations, Fy(1,2,:),6,'g');
%     xlabel('Num Iterations');
%     ylabel('Lateral Force FR [N]');
%     grid on;
%     subplot(2,2,3);
%     scatter(number_of_iterations, Fy(2,1,:),6,'b');
%     xlabel('Num Iterations');
%     ylabel('Lateral Force RL [N]');
%     grid on;
%     subplot(2,2,4);
%     scatter(number_of_iterations, Fy(2,2,:),6,'y');
%     xlabel('Num Iterations');
%     ylabel('Lateral Force RR [N]');
%     grid on;
end