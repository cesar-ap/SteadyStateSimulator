function [ output_args ] = Main( input_args )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Performance Simulator v1.1                                              %
% Date: 2-12-2013                                                         %
% Author: C�sar �lvarez Porras (www.cesar-ap.com)                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This Peromance Simulator is intended to help people understanding the
% configuration changes they carry out on their racing cars by giving an
% aproximation of the results they can expect with every setup
% configuration.
%
% The simulator has two different and differentiated parts. The first one 
%
% INPUTS
% - Vehicle Model: defined in load_vehicle_model.m file.
%
% - Tire Model: in order to finalize the current simulator version the tire
% model has been simplified to the form Fy = c2 * Fz + c1 * Fzfl + c0.
% Where the C parameters are constants of the tire and Fy the lateral force
% generated by the tire and Fz the vertical load applied on that tire.
%
% - Circuit Model: for the current simulator version the circuit model is
% not fully developed. What the simulator expects are two different
% arrays containing segment distance (ideally sampled meter by meter) and
% the corner radious from where the script can calculate if the segment is
% part of a corner or a straight sector.
%
% OUTPUTS
% - Time needed by the vehicle to go over a certain sector of the circuit
% model.
% - Power/Torque/RPM Graphic.
% - Roll Gradient, Load Transfer and Lateral Force generated by every
% corner of the vehicle based on a given list of setup configuration.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Simulation settings
V_initial = 265; % initial speed for the first iteration.

iterations_per_corner = 3; % Number of iterations for the corner segments.
iterations_per_lap = 2; % Number of iterations for complete laps.

speed_graph = 'yes'; % plot the speed, gear and RPM traces for the circuit
power_graph = 'yes'; % plot the power graph based on the Torque and RPM 
                     % engine information.


% Physics constants
pi = 3.14159;
g = 9.81;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                              Execution                              %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call the circuit model. Currently defined by segments as:
filename = '';
path = '';
[Distance, Corner_Radius, track_length] = Load_Circuit_Model(filename, path);


Speed_initial = zeros(1,length(Distance)); % empty array to save the entry speed of every segment
Speed_final = zeros(1,length(Distance)); % empty array to save the exit speed of every segment
Sector_Time = zeros(1,length(Distance)); % empty array to save the time of every segment
Quickest_Time = 1000; % starting Quickest_Time value to compare against


% Call vehicle setup options from the configuration file.
[Total_Mass, US_Mass_F, US_Mass_R, Wheelbase, Weight_Distribution...
    , Track_F, Track_R, HCG, HRF, HRR, HUF, HUR, Torque, RPM, Gear_Ratios...
    , Final_Ratio, Tire_Radius, Brakes_G_Force, Rolling_Coef, MR_Wheel_Spring_F...
    , MR_Wheel_Spring_R, MR_ARB_F, MR_ARB_R, K_Spring_F, K_Spring_R, K_ARB_F...
    , K_ARB_R, Downforce_Coef, Drag_Coef, Area, K_Tire_F, K_Tire_R, c2, c1, c0...
    , air_t, atm_p, gearshift_delay] = Load_Vehicle_Model();

% Create iterations for every lap simulation
for lap = 1:iterations_per_lap

    % Create iterations for every single setup option
    for a = 1:length(Total_Mass)
        total_mass = Total_Mass(a);
        for b = 1:length(US_Mass_F)
            us_mass_f = US_Mass_F(b);
            for c = 1:length(US_Mass_R)
                us_mass_r = US_Mass_R(c);
                for d = 1:length(Wheelbase)
                    wheelbase = Wheelbase(d);
                    for e = 1:length(Weight_Distribution)
                        weight_d = Weight_Distribution(e);
                        for f = 1:length(Track_F)
                            track_f = Track_F(f);
                            for h = 1:length(Track_R)
                                track_r = Track_R(h);
                                for i = 1:length(HCG)
                                    hcg = HCG (i);
                                    for j = 1:length(HRF)
                                        hrf = HRF(j);
                                        for k = 1:length(HRR)
                                            hrr = HRR(k);
                                            for l = 1:length(HUF)
                                                huf = HUF(l);
                                                for m = 1:length(HUR)
                                                    hur = HUR(m);
                                                    tire_radius = hur;
                                                    for n = 1:length(Torque(:,1))
                                                        torque = Torque(n,:);
                                                        rpm = RPM(n,:);
                                                        for o = 1:length(Gear_Ratios(:,1))
                                                            gear_ratios = Gear_Ratios(o,:);
                                                            for p = 1:length(Final_Ratio)
                                                                final_ratio = Final_Ratio(p);
                                                                for q = 1:length(Brakes_G_Force)
                                                                    brakes_g_force = Brakes_G_Force(q);
                                                                    for r = 1:length(Rolling_Coef)
                                                                        rolling_coef = Rolling_Coef(r);
                                                                        for s = 1:length(MR_Wheel_Spring_F)
                                                                            mr_wheel_spring_f = MR_Wheel_Spring_F(s);
                                                                            for t = 1:length(MR_Wheel_Spring_R)
                                                                                mr_wheel_spring_r = MR_Wheel_Spring_R(t);
                                                                                for u = 1:length(MR_ARB_F)
                                                                                    mr_arb_f = MR_ARB_F(u);
                                                                                    for v = 1:length(MR_ARB_R)
                                                                                        mr_arb_r = MR_ARB_R(v);
                                                                                        for w = 1:length(K_Spring_F)
                                                                                            k_spring_f = K_Spring_F(w);
                                                                                            for x = 1:length(K_Spring_R)
                                                                                                k_spring_r = K_Spring_R(x);
                                                                                                for y = 1:length(K_ARB_F)
                                                                                                    k_arb_f = K_ARB_F(y);
                                                                                                    for z = 1:length(K_ARB_R)
                                                                                                        k_arb_r = K_ARB_R(z);
                                                                                                        for aa = 1:length(Area)
                                                                                                            area = Area(aa);
                                                                                                            downforce_coef = Downforce_Coef(aa);
                                                                                                            drag_coef = Drag_Coef(aa);
                                                                                                            for ab = 1:length(K_Tire_F)
                                                                                                                k_tire_f = K_Tire_F(ab);
                                                                                                                for ac = 1:length(K_Tire_R)
                                                                                                                    k_tire_r = K_Tire_R(ac);






    % Calculate the best setup option for a corner segment as well as the time
    % needed to complete the segment. This will give us the maximum corner
    % speeds needed to calculate the acceleration and braking phases on the
    % straight segments before and after every corner.
    for segment = 1:(length(Distance)-1)
        corner_radius = Corner_Radius(segment);
        distance = Distance(segment + 1) - Distance(segment);
        if corner_radius == 0
            % We are on a straight segment
        else
            % We are on a corner segment
            [sector_time, max_speed_kmh, ay] = Corner_Simulation(total_mass...
                , us_mass_f, us_mass_r, wheelbase, weight_d, track_f, track_r, hcg...
                , hrf, hrr, huf, hur, torque, rpm, gear_ratios, final_ratio...
                , tire_radius, brakes_g_force, rolling_coef, mr_wheel_spring_f...
                , mr_wheel_spring_r, mr_arb_f, mr_arb_r, k_spring_f, k_spring_r...
                , k_arb_f, k_arb_r, downforce_coef, drag_coef, area, k_tire_f...
                , k_tire_r, c2, c1, c0, air_t, atm_p, g, pi...
                , distance, corner_radius, iterations_per_corner);
            Sector_Time(segment) = sector_time;
            % The speed in the corner segments are supossed to be the maximum
            % speed to handle the corner
            Speed_initial(segment) = max_speed_kmh;
            Speed_final(segment) = max_speed_kmh;        
        end
    end


    % Calculate the best setup option for a straight segment as well as well as 
    % the time needed to complete the segment.
    for segment=1:length(Distance)
        corner_radius = Corner_Radius(segment);

        if corner_radius==0 % Analyze only straight segments
            if segment == 1
                % If we are looking at the first segment the initial speed if
                % defined on line 39.
                straight_length = Distance(segment+1)-Distance(segment);
                Speed_initial(segment) = V_initial;
                Speed_final(segment) = Speed_initial(segment+1);% Km/h
            elseif segment == length(Distance)
                % If we are looking at the last segment we set a target final
                % speed of 600 Km/h to make sure the simulator keeps pushing
                % until the end.
                straight_length = track_length - Distance(segment);
                Speed_initial(segment) = Speed_final(segment-1);% Km/h
                Speed_final(segment) = 600;
            else
                % If we are looking at any middle segments we take the initial
                % and final speeds from the previos and next segments
                % (ideally corners).
                straight_length = Distance(segment+1)-Distance(segment);
                Speed_initial(segment) = Speed_final(segment-1);% Km/h
                Speed_final(segment) = Speed_initial(segment+1);% Km/h
            end
            [sector_time, final_speed] = Straight_Simulation(total_mass...
                , us_mass_f, us_mass_r, wheelbase, weight_d, track_f, track_r, hcg...
                , hrf, hrr, huf, hur, torque, rpm, gear_ratios, final_ratio...
                , tire_radius, brakes_g_force, rolling_coef, mr_wheel_spring_f...
                , mr_wheel_spring_r, mr_arb_f, mr_arb_r, k_spring_f, k_spring_r...
                , k_arb_f, k_arb_r, downforce_coef, drag_coef, area, k_tire_f...
                , k_tire_r, c2, c1, c0, air_t, atm_p, g, pi...
                , Speed_initial(segment), Speed_final(segment), straight_length...
                , gearshift_delay);
            Sector_Time(segment) = sector_time;  
            Speed_final(segment) = final_speed; % Update the final speed of 
            % the segment          
        end
    end

    if sum(Sector_Time) < Quickest_Time
        % If the sum of the segment times is quicker than the quickest time,
        % then we update our quickest_time reference for future comparisons and
        % save the current setup.
        Quickest_Time = sum(Sector_Time);
        Speed_final_last_segment = final_speed; % Updates the final speed of the last
        % circuit segment acquired with the optimum setup configuration
        r_total_mass = total_mass;
        r_us_mass_f = us_mass_f;
        r_us_mass_r = us_mass_r;
        r_wheelbase = wheelbase;
        r_weight_d = weight_d;
        r_track_f = track_f;
        r_track_r = track_r;
        r_hcg = hcg;
        r_hrf = hrf;
        r_hrr = hrr;
        r_huf = huf;
        r_hur = hur;
        r_torque = torque;
        r_rpm = rpm;
        r_gear_ratios = gear_ratios;
        r_final_ratio = final_ratio;
        r_tire_radius = tire_radius;
        r_brakes_g_force = brakes_g_force;
        r_rolling_coef = rolling_coef;
        r_mr_wheel_spring_f = mr_wheel_spring_f;
        r_mr_wheel_spring_r = mr_wheel_spring_r;
        r_mr_arb_f = mr_arb_f;
        r_mr_arb_r = mr_arb_r;
        r_k_spring_f = k_spring_f;
        r_k_spring_r = k_spring_r;
        r_k_arb_f = k_arb_f;
        r_k_arb_r = k_arb_r;
        r_downforce_coef = downforce_coef;
        r_drag_coef = drag_coef;
        r_area = area;
        r_k_tire_f = k_tire_f;
        r_k_tire_r = k_tire_r;
        r_air_t = air_t;
        r_atm_p = atm_p;
    end 
    Speed_final(end) = Speed_final_last_segment; % Updates the final speed 
    % of the last circuit segment acquired with the optimum setup configuration



                                                                                                                end % Close K_Tire_R iteration
                                                                                                            end % Close K_Tire_F iteration
                                                                                                        end % Close Aerodynamic Area iteration
                                                                                                    end % Close K_ARB_R iteration
                                                                                                end % Close K_ARB_F iteration
                                                                                            end % Close K_Spring_R iteration
                                                                                        end % Close K_Spring_F iteration
                                                                                    end % Close MR_ARB_R iteration
                                                                                end % Close MR_ARB_F iteration
                                                                            end % Close MR_Wheel_Spring_R iteration
                                                                        end % Close MR_Wheel_Spring_F iteration
                                                                    end % Close Rolling Coef iteration
                                                                end % Close Brakes G Force iteration
                                                            end % Close Final Ratio iteration
                                                        end % Close Gear Ratios iteration
                                                    end % Close Torque iteration
                                                end % Close HUR iteration
                                            end % Close HUF iteration
                                        end % Close HRR iteration
                                    end % Close HRF iteration
                                end % Close HCG iteration
                            end % Close Track R iteration
                        end % Close Track F iteration
                    end % Close Weight Distribution iteration
                end % Close Wheelbase iteration
            end % Close US_Mass_R iteration
        end % Close US_Mass_F iteration
    end % Close Total_Mass iteration

V_initial = Speed_final(end); % Update the initial speed to equal the final speed of the last segment.
end % Close Lap iteration








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                               Results                               %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print results
fprintf ('--------------------------------------------------------------------------------------------\n');
fprintf ('\nThe quickest time for this circuit is %d seconds for the following configuration:\n', Quickest_Time);
fprintf ('Total Mass: %d Kg, US Mass F: %d Kg, US Mass R: %d Kg\n', r_total_mass, r_us_mass_f, r_us_mass_r);
fprintf ('Wheelbase: %d m, Weight Distribution: %d\n', r_wheelbase, r_weight_d);
fprintf ('Track F: %d m, Track R: %d m\n', r_track_f, r_track_r);
fprintf ('Hcg: %d m, Hrf: %d m, Hrr: %d m, Huf: %d m, Hur: %d m\n', r_hcg, r_hrf, r_hrr, r_huf, r_hur);
fprintf ('Torque-RPM\n');
r_torque
r_rpm
fprintf ('Gear Ratios:\n');
r_gear_ratios
fprintf ('Final Ratio: %d\n', r_final_ratio);
fprintf ('Tire Radius: %d m, Brakes G Force: %d G, Rolling Coef: %d\n', r_tire_radius, r_brakes_g_force, r_rolling_coef);
fprintf ('MR Wheel Spring F: %d, MR Wheel Spring R: %d\n', r_mr_wheel_spring_f, r_mr_wheel_spring_r);
fprintf ('MR ARB F: %d, MR ARB R: %d\n', r_mr_arb_f, r_mr_arb_r);
fprintf ('K Spring F: %d N, K Spring R: %d N\n', r_k_spring_f, r_k_spring_r);
fprintf ('K ARB F: %d N, K ARB R: %d N\n', r_k_arb_f, r_k_arb_r);
fprintf ('Downforce Coef: %d, Drag Coef: %d, Area: %d\n', r_downforce_coef, r_drag_coef, r_area);
fprintf ('K Tire F: %d N, K Tire R: %d N\n', r_k_tire_f, r_k_tire_r);
fprintf ('Air temp: %d �C, Atm P: %d mbar\n', r_air_t, r_atm_p);
Sector_Time
Speed_initial
Speed_final
fprintf ('--------------------------------------------------------------------------------------------\n\n');


% Show the Speed, Gear and RPM traces along the circuit
if strcmp(speed_graph, 'yes')
    [speed, gear, revs] = Graphics(r_total_mass, r_us_mass_f, r_us_mass_r...
        , r_wheelbase, r_weight_d, r_track_f, r_track_r, r_hcg, r_hrf, r_hrr...
        , r_huf, r_hur, r_torque, r_rpm, r_gear_ratios, r_final_ratio...
        , r_tire_radius, r_brakes_g_force, r_rolling_coef, r_mr_wheel_spring_f...
        , r_mr_wheel_spring_r, r_mr_arb_f, r_mr_arb_r, r_k_spring_f, r_k_spring_r...
        , r_k_arb_f, r_k_arb_r, r_downforce_coef, r_drag_coef, r_area...
        , r_k_tire_f, r_k_tire_r, c2, c1, c0, r_air_t, r_atm_p, g, pi...
        , Distance, Corner_Radius, Speed_initial, Speed_final, gearshift_delay...
        , track_length);
end

% Show the power curve of the engine
if strcmp(power_graph,'yes')
    power = Calculate_Power(Torque,RPM); % Returns an array with the BHP given 
    % at every RPM range.
end

% % Show the tire utilization for the resultant setup configuration
% if strcmp(tire_graph, 'yes')
% 
% end

end