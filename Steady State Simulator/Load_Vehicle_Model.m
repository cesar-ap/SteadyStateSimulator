function [Total_Mass, US_Mass_f, US_Mass_r, Wheelbase, Weight_distribution...
    , track_f, track_r, hcg, hrf, hrr, huf, hur, Torque, RPM, Gear_Ratios...
    , Final_Ratio, Tire_Radious, Brakes_G_Force, rolling_coef, MR_wheel_spring_f...
    , MR_wheel_spring_r, MR_ARB_f, MR_ARB_r, K_spring_F, K_spring_R, K_ARB_F...
    , K_ARB_R, Downforce_Coef, Drag_Coef, Area, K_tire_f, K_tire_r, c2, c1, c0...
    , air_t, atm_p, gearshift_delay] = Load_Vehicle_Model()


% Performance Simulator v1.1
% Date: 2-12-2013
% Author: C�sar �lvarez Porras (www.cesar-ap.com)

    %Vehicle
    %========================
    Total_Mass = 1200;% Kg
    US_Mass_f = 40;% Kg
    US_Mass_r = 46;% Kg
    Wheelbase = 2.890;% m
    Weight_distribution = [0.45, 0.47, 0.48, 0.49, 0.5, 0.51, 0.52, 0.53, 0.55]; %
    track_f = 1.698;% m
    track_r = 1.620;% m
    hcg = 0.45;% m
    hrf = 0;% m
    hrr = 0;% m
    huf = 0.33;% m
    hur = 0.355;% m

    % Drivetrain
    % =======================
    Torque = [300, 330, 370, 400, 450, 470, 520, 580, 620, 660, 680, 670, 640, 620, 600, 590, 570];
    RPM =    [2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000];
    % Torque and RPM arrays must have the same length
    Gear_Ratios = [3.1, 2.3, 1.9, 1.7, 1.5, 1.4];
    % Gear Ratios, Torque and RPM admit multiple sets i.e. Gear_Ratios = [[a, b, c, d, e, f];[g, h, i, j, k, l]]
    % but these are taken in sets (a,b,c,d,e,f and g,h,i,j,k,l) for
    % simulation.
    Final_Ratio = 2.8;
    Tire_Radious = hur;% m
    Brakes_G_Force = 1; % G
    rolling_coef = 0.396;
    gearshift_delay = 0.02; % s

    % Suspension
    % ========================
    MR_wheel_spring_f = 1; %
    MR_wheel_spring_r = 1; %
    MR_ARB_f = 0.8; %
    MR_ARB_r = 0.8; %
    K_spring_F = [507500, 545000, 595000, 625000];% Nm
    K_spring_R = [507500, 545000, 595000, 625000];% Nm
    K_ARB_F = [325000, 360000, 400000];% Nm
    K_ARB_R = [325000, 360000, 400000];% Nm

    % Aerodynamics
    % ========================
    % The Downforce Coef, Drag Coef and Aerodynamic Area arrays must have
    % the same length, assuming one change on any of these parameters also
    % involves a change on the other two.
    Downforce_Coef = [1.4, 1.5, 1.6, 1.65];% 
    Drag_Coef = [0.3, 0.35, 0.45 0.55];% 
    Area = [1.375, 1.400, 1.425, 1.45];% m^2

    % Tire model
    % ========================
    K_tire_f = 95000;% Nm
    K_tire_r = 95000;% Nm
    c2=[-0.00022, -0.00027];
    c1=[2.1, 2.3];
    c0=[100, 250];

    % Scenario
    % ========================
    air_t = 23;% C degrees
    atm_p = 1000;% mbar

end