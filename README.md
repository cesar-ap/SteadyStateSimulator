Steady State Simulator
====================

Steady State Simulator v1.1

The Steady State Simulator merges the two previous simulators - Steady State Corner and Steady State Straight Simulator - to calculate the best setup option for a given circuit model.



INPUTS:
========================================================================================================================
% Vehicle Model
    Total_Mass = 1200;% Kg
    US_Mass_f = 40;% Kg
    US_Mass_r = 46;% Kg
    Wheelbase = 2.890;% m
    Weight_distribution = [0.45, 0.47, 0.48, 0.49, 0.5, 0.51, 0.52, 0.53, 0.55]; 
    track_f = 1.698;% m
    track_r = 1.620;% m
    hcg = 0.45;% General CG height m
    hrf = 0;% Front Roll Centre height (measured from the ground) m
    hrr = 0;% rear Roll Centre height (measured from the ground) m
    huf = 0.33;% Front Unsprung Mass CG height m
    hur = 0.355;% Rear Unsprung Mass CG height m
    
    % Drivetrain
    Torque = [300, 330, 370, 400, 450, 470, 520, 580, 620, 660, 680, 670, 640, 620, 600, 590, 570];
    RPM = [2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000];
    % Torque and RPM arrays must have the same length
    Gear_Ratios = [3.1, 2.3, 1.9, 1.7, 1.5, 1.4];
    % Gear Ratios, Torque and RPM admit multiple sets i.e. Gear_Ratios = [[a, b, c, d, e, f];[g, h, i, j, k, l]] but these are taken in sets (a,b,c,d,e,f) for one iteration and (g,h,i,j,k,l) for the next one.
    Final_Ratio = 2.8;
    Tire_Radious = hur;% m
    Brakes_G_Force = 1; % G
    rolling_coef = 0.396;
    gearshift_delay = 0.02; % s
 
    % Suspension
    MR_wheel_spring_f = 1; % Front Motion Ratio Wheel-Spring
    MR_wheel_spring_r = 1; % rear Motion Ratio Wheel-Spring
    MR_ARB_f = 0.8; % Front Motion Ratio ARB
    MR_ARB_r = 0.8; % Rear Motion Ratio ARB
    K_spring_F = [507500, 545000, 595000, 625000];% Nm
    K_spring_R = [507500, 545000, 595000, 625000];% Nm
    K_ARB_F = [325000, 360000, 400000];% Nm
    K_ARB_R = [325000, 360000, 400000];% Nm
 
    % Aerodynamics
    % The Downforce Coef, Drag Coef and Aerodynamic Area arrays must have
    % the same length, assuming one change on any of these parameters also
    % involves a change on the other two.
    Downforce_Coef = [1.4, 1.5, 1.6, 1.65];% 
    Drag_Coef = [0.3, 0.35, 0.45 0.55];% 
    Area = [1.375, 1.400, 1.425, 1.45];% m^2
 
    % Tire model
    K_tire_f = 95000;% Nm
    K_tire_r = 95000;% Nm
    c2=[-0.00022, -0.00027];% Tire model parameters
    c1=[2.1, 2.3];% Tire model parameters
    c0=[100, 250];% Tire model parameters
 
    % Scenario
    air_t = 23;% C degrees
    atm_p = 1000;% mbar
    
Circuit Model
    track_length = 500; % m
    Distance = 	   [0, 200, 210, 220, 225, 230, 280, 285, 300, 310, 325, 335];
    Corner_Radius = [0, 120, 110, 100, 110, 0,   90,  85,  80,  70,  75,  0];
  
Corner Radius(n) = 0 means the segment is a straight of length Distance(n+1) – Distance(n). 
Corner Radius(n) = 85 means the segment is a corner of radius 85 metres and length Distance(n+1) – Distance(n). 
The last segment's length is calculated using the track_length parameter. 
Note the first and last segments must be straights and a straight is defined as the segment between two corners. There cannot be two straights together.



SIMULATION:
========================================================================================================================
The simulator starts looking for the setup configuration which gives the biggest speed through the corners. Once we know the maximum speeds the vehicle can handle on the corners, we do know the initial and final speeds for the straight sectors. We consider the speed is constant in the corner segments.

Since we know the speed and the distance of every segment we can easily calculate the time needed for every segment.

The best setup configuration will be the combination that has the smallest aggregated time to complete all the segments of the circuit.  



OUTPUT:
========================================================================================================================
  The quickest time for this circuit is 1.014755e+001 seconds for the following configuration:
  Total Mass: 1200 Kg, US Mass F: 40 Kg, US Mass R: 46 Kg
  Wheelbase: 2.890000e+000 m, Weight Distribution: 5.500000e-001
  Track F: 1.698000e+000 m, Track R: 1.620000e+000 m
  Hcg: 4.500000e-001 m, Hrf: 0 m, Hrr: 0 m, Huf: 3.300000e-001 m, Hur: 3.550000e-001 m
  Torque-RPM:
    r_torque = 300 330 370 400 450 470 520 580 620 660 680 670 640 620 600 590 		570
    r_rpm = 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 		8500 9000 9500 10000
  Gear Ratios: 3.1000    2.3000    1.9000    1.7000    1.5000    1.4000
  Final Ratio: 2.800000e+000
  Tire Radius: 3.550000e-001 m, Brakes G Force: 1 G, Rolling Coef: 3.960000e-001
  MR Wheel Spring F: 1, MR Wheel Spring R: 1
  MR ARB F: 8.000000e-001, MR ARB R: 8.000000e-001
  K Spring F: 507500 N, K Spring R: 625000 N
  K ARB F: 325000 N, K ARB R: 400000 N
  Downforce Coef: 1.400000e+000, Drag Coef: 3.000000e-001, Area: 1.375000e+000
  K Tire F: 95000 N, K Tire R: 95000 N
  Air temp: 23 ºC, Atm P: 1000 mbar
