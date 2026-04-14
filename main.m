%% ASEN 3802 - Aerodynamics Lab - Main
% Main script for Parts 1 and 2 of the aerodynamic analysis. The code generates
% NACA 4-digit airfoil geometries and evaluates sectional lift using the
% provided Vortex_Panel solver. Task 1 constructs and plots NACA airfoils.
% Task 2 performs a convergence study for NACA 0012 to determine the number
% of panels required for 1% relative error. Task 3 investigates the effect
% of airfoil thickness on lift over a range of angles of attack. Task 4
% analyzes the effect of airfoil camber on lift. Results are plotted and
% compared within a single continuous workflow. Part 2 implements the code
% for PLLT.
%
% Co-Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: 4/15/26

clc; 
clear;
close all;

toggle = 'NACA 0021'; % Select between NACA 0021 or NACA 2421 for Task 1
Part = 2; % Select between Part 1 and Part 2 of Lab 3

if Part == 1
    Task1 = 0; % Toggle 1 to activate; 0 to deactivate
    Task2 = 0;
    Task3 = 0;
    Task4 = 0;
elseif Part == 2
    Task1 = 1;
end

if Part == 1
%% TASK 1
    if Task1 == 1
        N = 50; % Number of Panels
        c = 1; % Chord [m]

        if toggle == 'NACA 0021'
            % NACA 0021
            m = 0;
            p = 0;
            t = 21;
            
            [x_0021, y_0021, x2_0021, y2_0021] = NACA_Airfoils(m,p,t,c,N);
            
            figure(1);
            hold on;
            scatter(x_0021, y_0021, 'ro');
            plot(x_0021, y_0021, 'k-')
            axis equal;
            grid on;
            xlabel('ChordWise Displacement (x-axis displacement) [m]');
            ylabel('N-S displacement (y-axis displacement) [m]');
            title('Airfoil generator: ', toggle);
            
            elseif toggle == 'NACA 2421'
            % NACA 2421
            m = 2;
            p = 4;
            t = 21;
            
            [x_2421, y_2421, x2_2421, y2_2421] = NACA_Airfoils(m,p1,t,c,N);
            
            figure(2);
            hold on;
            scatter(x_2421, y_2421, 'ro');
            plot(x_2421, y_2421, 'k-')
            axis equal;
            grid on;
            xlabel('Chordwise Displacement (x-axis displacement) [m]');
            ylabel('N-S displacement (y-axis displacement) [m]');
            title('Airfoil generator: ', toggle);
            
        end
    end

%% TASK 2
    if Task2 == 1
    
        % NACA 0012
        m = 0;
        p = 0;
        t = 12;
        
        c = 1; % Chord Length
        alpha = 12; % Angle of Attack [degrees]
        V_inf = 15; % Free Stream Velocity [m/s]
        
        % Convergence Plot - Data Acquisition
        N_exact = 500; % 'Exact' solution we are assuming is a very large # of panels
        [x_exact, y_exact, xcam_exact, ycam_exact] = NACA_Airfoils(m, p, t, c, N_exact); % Airfoil Displacement values 
        cl_exact = Vortex_Panel(x_exact, y_exact, V_inf, alpha); % Sectional COefficent of Lift
        
        %fprintf('Exact solution for NACA 0012 at alpha = %.2f deg \n', alpha);
        fprintf('c_l Exact Solution = %.6f \n', cl_exact);
        fprintf('Total number of panels used for exact solution = %d \n\n', N_exact);
        
        % Testing different Panel Values (N)
        N_values = 5 : 5 : N_exact; % Panels per surface
        
        cl_values = zeros(length(N_values), 1); % Initialization
        error_vals = zeros(length(N_values), 1); % Initialization
        N_tot_values = zeros(length(N_values), 1); % Initialization
        
            for i = 1 : length(N_values)
                N_i = N_values(i); 
                [x_T2, y_T2, x_camT2, y_camT2] = NACA_Airfoils(m, p, t, c, N_i);
                
                cl_i = Vortex_Panel(x_T2, y_T2, V_inf, alpha);
               
                N_tot_values(i) = N_i; % Store the total number of panels used
                cl_values(i) = cl_i; % Stores c_l Values
                error_vals(i) = abs((cl_i - cl_exact)/cl_exact) * 100; % Calculate the error between current and exact lift coefficient
            end
        
        % Error Finding
        idx_1percent = find(error_vals <= 1, 1, 'first'); % Finds minimum number of total panels need for the 1% requirement
        N_min = N_tot_values(idx_1percent);
        cl_min = cl_values(idx_1percent);
        error_min = error_vals(idx_1percent);
        
        fprintf('Predicted c_l for NACA 0012 at alpha = %.2f deg \n', alpha);
        fprintf('c_l = %.6f \n', cl_min);
        fprintf('Minimum total number of panels for <= 1 percent relative error = %d \n', N_min);
        fprintf('Relative error = %.6f percent \n\n', error_min);
        
        % Plotting Convergence
        figure(3);
        hold on;
        plot(N_tot_values, cl_values, 'bo-', 'LineWidth', 1);
        yline(cl_exact, 'r-', 'LineWidth', 1.5);
        plot(N_min, cl_min, 'Marker','diamond', 'MarkerSize', 10, 'MarkerFaceColor','g', 'MarkerEdgeColor', 'g', 'LineStyle','none');
        text(75, 1.39, sprintf('1%% Error Values\nN = %d\nc_l = %.4f', N_min, cl_min),'BackgroundColor','white','EdgeColor','black');
        yline(cl_exact-(cl_exact*0.01), 'r--', 'LineWidth', 1);
        yline(cl_exact+(cl_exact*0.01), 'r--', 'LineWidth', 1);
        grid on;
        xlabel('Total Number of Panels [N]');
        ylabel('Sectional Coefficent of Lift, c_l');
        legend('Predicted c_l', 'Exact c_l', 'First c_l within 1% error', '1% Error line', 'Location', 'best');
        title('Convergence of c_l for NACA 0012 at \alpha = 12^\circ');
        hold off;
        
    end
    
    if Task3 == 1
        %% Task 3
        %Loading Expermental Data
        
        data_0006 = load("NACA0006.mat");
        data_0012 = load("NACA0012.mat");
        data_2412 = load("NACA2412.mat");
        data_4412 = load("NACA4412.mat");
        
        data_0006 = data_0006.data;
        data_0012 = data_0012.data;
        data_2412 = data_2412.data;
        data_4412 = data_4412.data;
        
        %setting up camber for pllt
        c=1; %chord
        x_camber = linspace (0,c,1000);
        
        %Getting airfoil geometry
        N = 40; %number of decided runs from task 2
        %0006
        [x_0006, y_0006, x_c_0006, y_c_0006] = NACA_Airfoils(0,0,6,1,N);
        %0012
        [x_0012, y_0012, x_c_0012, y_c_0012] = NACA_Airfoils(0,0,12,1,N);
        %0018
        [x_0018, y_0018, x_c_0018, y_c_0018] = NACA_Airfoils(0,0,18,1,N);
        
        %Defining range of aoa's
        alphas = linspace(-3,15,100);
        
        % Vortex CL vs Alpha
            for i = 1:length(alphas)
            
                clV_0006(i) = Vortex_Panel(x_0006,y_0006,50,alphas(i));%0006
                clV_0012(i) = Vortex_Panel(x_0012,y_0012,50,alphas(i));%0012
                clV_0018(i) = Vortex_Panel(x_0018,y_0018,50,alphas(i));%0018
                
            end
            
        
        % PLLT CL vs Alpha
        aL_0_NACA0006 = aL_0(0, 0, c, x_camber); %should be all zero because symetrical
        aL_0_NACA0012 = aL_0(0, 0, c, x_camber);
        aL_0_NACA0018 = aL_0(0, 0, c, x_camber);
        
        
        cl_TAT_NACA0006 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0006));
        cl_TAT_NACA0012 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0012));
        cl_TAT_NACA0018 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0018));
        
        % Expermental CL vs Alpha
        
        alpha_0006 = data_0006(:,1);
        alpha_0012 = data_0012(:,1);
        alpha_2412 = data_2412(:,1);
        alpha_4412 = data_4412(:,1);
        
        cl0006 = data_0006(:,2);
        cl0012 = data_0012(:,2);
        cl2412 = data_2412(:,2);
        cl4412 = data_4412(:,2);
        
        %Plots
        
        %cl vs alpha for all three airfoils
        figure();
        hold on;
        
        % Vortex Panel
        plot(alphas, clV_0006, 'c',  'LineWidth', 1, 'DisplayName', 'NACA 0006 - Vortex Panel');
        plot(alphas, clV_0012, 'm',  'LineWidth', 1, 'DisplayName', 'NACA 0012 - Vortex Panel');
        plot(alphas, clV_0018, 'y',  'LineWidth', 1, 'DisplayName', 'NACA 0018 - Vortex Panel');
        
        % Thin Airfoil Theory (all identical for symmetric airfoils)
        plot(alphas, cl_TAT_NACA0006, 'k--', 'LineWidth', 1, 'DisplayName', 'Thin Airfoil Theory (all symmetric)');
        
        % Experimental
        scatter(alpha_0006, cl0006, 30, 'b', 'filled','HandleVisibility', 'off');
        scatter(alpha_0012, cl0012, 30, 'r', 'filled','HandleVisibility', 'off');
        plot(alpha_0006,cl0006,'b', 'DisplayName', 'NACA 0006 - Experimental');
        plot(alpha_0012, cl0012,'r','DisplayName', 'NACA 0012 - Experimental');
        
        grid on;
        xlabel('Angle of Attack, \alpha (deg)', 'FontSize', 12);
        ylabel('Sectional Lift Coefficient, c_l', 'FontSize', 12);
        title('Effect of Airfoil Thickness on Sectional Lift Coefficient', 'FontSize', 13);
        legend('Location', 'northwest', 'FontSize', 10);
        xlim([-2, 12]);
        hold off;
        
        %Zero Lift Angle of Attack
        % Vortex Panel: interpolate where cl = 0 (should all be 0 once again)
        aL0_V_0006 = interp1(clV_0006, alphas, 0);
        aL0_V_0012 = interp1(clV_0012, alphas, 0);
        aL0_V_0018 = interp1(clV_0018, alphas, 0);
        
        % Thin Airfoil Theory
        aL0_TAT = rad2deg(aL_0_NACA0006); % same for all three
        
        % Experimental: interpolate where cl = 0
        aL0_exp_0006 = interp1(cl0006, alpha_0006, 0);
        aL0_exp_0012 = interp1(cl0012, alpha_0012, 0);
        
        %Lift Slope per degree
        % region
        lin_idx = alphas >= -2 & alphas <= 12;
        
        slope_V_0006 = polyfit(alphas(lin_idx), clV_0006(lin_idx), 1); slope_V_0006 = slope_V_0006(1);
        slope_V_0012 = polyfit(alphas(lin_idx), clV_0012(lin_idx), 1); slope_V_0012 = slope_V_0012(1);
        slope_V_0018 = polyfit(alphas(lin_idx), clV_0018(lin_idx), 1); slope_V_0018 = slope_V_0018(1);
        
        slope_TAT = 2*pi * (pi/180); % 2*pi per radian converted to per degree
        
        lin_idx_exp_0006 = alpha_0006 >= -2 & alpha_0006 <= 12;
        lin_idx_exp_0012 = alpha_0012 >= -2 & alpha_0012 <= 12;
        slope_exp_0006 = polyfit(alpha_0006(lin_idx_exp_0006), cl0006(lin_idx_exp_0006), 1); slope_exp_0006 = slope_exp_0006(1);
        slope_exp_0012 = polyfit(alpha_0012(lin_idx_exp_0012), cl0012(lin_idx_exp_0012), 1); slope_exp_0012 = slope_exp_0012(1);
        
        % Zero Lift AoA table
        fprintf('\n--- Zero-Lift Angle of Attack (degrees) ---\n');
        fprintf('%-12s %14s %14s %14s\n', 'Airfoil', 'Vortex Panel', 'Thin Airfoil', 'Experimental');
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0006', aL0_V_0006, aL0_TAT, aL0_exp_0006);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0012', aL0_V_0012, aL0_TAT, aL0_exp_0012);
        fprintf('%-12s %14.4f %14.4f %14s\n',   'NACA 0018', aL0_V_0018, aL0_TAT, 'N/A');
        
        % Print Table: Lift Slope table
        fprintf('\n--- Lift Slope (per degree) ---\n');
        fprintf('%-12s %14s %14s %14s\n', 'Airfoil', 'Vortex Panel', 'Thin Airfoil', 'Experimental');
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0006', slope_V_0006, slope_TAT, slope_exp_0006);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0012', slope_V_0012, slope_TAT, slope_exp_0012);
        fprintf('%-12s %14.4f %14.4f %14s\n',   'NACA 0018', slope_V_0018, slope_TAT, 'N/A');
        
    end
        
        %% TASK 4
    if Task4 == 1
        
        data_0012 = load("NACA0012.mat");
        data_2412 = load("NACA2412.mat");
        data_4412 = load("NACA4412.mat");
        
        data_0012 = data_0012.data;
        data_2412 = data_2412.data;
        data_4412 = data_4412.data;
        
        c = 1;
        x_camber = linspace(0,c,1000);
        N = 40;
        V_inf = 15;
        alphas = linspace(-8,15,100);
        
        [x_0012, y_0012, x_c_0012, y_c_0012] = NACA_Airfoils(0,0,12,1,N);
        [x_2412, y_2412, x_c_2412, y_c_2412] = NACA_Airfoils(2,4,12,1,N);
        [x_4412, y_4412, x_c_4412, y_c_4412] = NACA_Airfoils(4,4,12,1,N);
        
        for i = 1:length(alphas)
            clV_0012(i) = Vortex_Panel(x_0012,y_0012,V_inf,alphas(i));
            clV_2412(i) = Vortex_Panel(x_2412,y_2412,V_inf,alphas(i));
            clV_4412(i) = Vortex_Panel(x_4412,y_4412,V_inf,alphas(i));
        end
        
        % Thin Airfoil Theory
        aL_0_NACA0012 = aL_0(0, 0, c, x_camber);
        aL_0_NACA2412 = aL_0(2, 4, c, x_camber);
        aL_0_NACA4412 = aL_0(4, 4, c, x_camber);
        
        cl_TAT_NACA0012 = 2*pi*(deg2rad(alphas) - aL_0_NACA0012);
        cl_TAT_NACA2412 = 2*pi*(deg2rad(alphas) - aL_0_NACA2412);
        cl_TAT_NACA4412 = 2*pi*(deg2rad(alphas) - aL_0_NACA4412);
        
        alpha_0012 = data_0012(:,1);
        alpha_2412 = data_2412(:,1);
        alpha_4412 = data_4412(:,1);
        
        cl0012 = data_0012(:,2);
        cl2412 = data_2412(:,2);
        cl4412 = data_4412(:,2);
        
        figure(4);
        hold on;
        marker_idx = 1:8:length(alphas);
        
        plot(alphas, clV_0012, 'k-o', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'VPM 0012');
        plot(alphas, clV_2412, 'b-o', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'VPM 2412');
        plot(alphas, clV_4412, 'r-o', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'VPM 4412');
        
        plot(alphas, cl_TAT_NACA0012, 'k--s', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'TAT 0012');
        plot(alphas, cl_TAT_NACA2412, 'b--s', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'TAT 2412');
        plot(alphas, cl_TAT_NACA4412, 'r--s', 'LineWidth', 1.5, 'MarkerIndices', marker_idx, 'DisplayName', 'TAT 4412');
        
        plot(alpha_0012, cl0012, 'k-^', 'LineWidth', 1.5, 'DisplayName', 'EXP 0012');
        plot(alpha_2412, cl2412, 'b-^', 'LineWidth', 1.5, 'DisplayName', 'EXP 2412');
        plot(alpha_4412, cl4412, 'r-^', 'LineWidth', 1.5, 'DisplayName', 'EXP 4412');
        
        grid on;
        xlabel('Angle of Attack, \alpha (deg)', 'FontSize', 12);
        ylabel('Sectional Lift Coefficient, c_l', 'FontSize', 12);
        title('Effect of Airfoil Camber on Sectional Lift Coefficient', 'FontSize', 13);
        legend('Location', 'best', 'FontSize', 10);
        xlim([-10, 18]);
        ylim([-1.1, 1.85]);
        hold off;
        
        aL0_V_0012 = interp1(clV_0012, alphas, 0);
        aL0_V_2412 = interp1(clV_2412, alphas, 0);
        aL0_V_4412 = interp1(clV_4412, alphas, 0);
        
        aL0_TAT_0012 = rad2deg(aL_0_NACA0012);
        aL0_TAT_2412 = rad2deg(aL_0_NACA2412);
        aL0_TAT_4412 = rad2deg(aL_0_NACA4412);
        
        [cl0012_u, idx0012_u] = unique(cl0012);
        [cl2412_u, idx2412_u] = unique(cl2412);
        [cl4412_u, idx4412_u] = unique(cl4412);
        
        aL0_exp_0012 = interp1(cl0012_u, alpha_0012(idx0012_u), 0);
        aL0_exp_2412 = interp1(cl2412_u, alpha_2412(idx2412_u), 0);
        aL0_exp_4412 = interp1(cl4412_u, alpha_4412(idx4412_u), 0);
        
        lin_idx = alphas >= -2 & alphas <= 10;
        
        slope_V_0012 = polyfit(alphas(lin_idx), clV_0012(lin_idx), 1); slope_V_0012 = slope_V_0012(1);
        slope_V_2412 = polyfit(alphas(lin_idx), clV_2412(lin_idx), 1); slope_V_2412 = slope_V_2412(1);
        slope_V_4412 = polyfit(alphas(lin_idx), clV_4412(lin_idx), 1); slope_V_4412 = slope_V_4412(1);
        
        slope_TAT = 2*pi*(pi/180);
        
        lin_idx_exp_0012 = alpha_0012 >= -2 & alpha_0012 <= 10;
        lin_idx_exp_2412 = alpha_2412 >= -2 & alpha_2412 <= 10;
        lin_idx_exp_4412 = alpha_4412 >= -2 & alpha_4412 <= 8;
        
        slope_exp_0012 = polyfit(alpha_0012(lin_idx_exp_0012), cl0012(lin_idx_exp_0012), 1); slope_exp_0012 = slope_exp_0012(1);
        slope_exp_2412 = polyfit(alpha_2412(lin_idx_exp_2412), cl2412(lin_idx_exp_2412), 1); slope_exp_2412 = slope_exp_2412(1);
        slope_exp_4412 = polyfit(alpha_4412(lin_idx_exp_4412), cl4412(lin_idx_exp_4412), 1); slope_exp_4412 = slope_exp_4412(1);
        
        fprintf('\n--- Zero-Lift Angle of Attack (degrees) ---\n');
        fprintf('%-12s %14s %14s %14s\n', 'Airfoil', 'Vortex Panel', 'Thin Airfoil', 'Experimental');
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0012', aL0_V_0012, aL0_TAT_0012, aL0_exp_0012);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 2412', aL0_V_2412, aL0_TAT_2412, aL0_exp_2412);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 4412', aL0_V_4412, aL0_TAT_4412, aL0_exp_4412);
        
        fprintf('\n--- Lift Slope (per degree) ---\n');
        fprintf('%-12s %14s %14s %14s\n', 'Airfoil', 'Vortex Panel', 'Thin Airfoil', 'Experimental');
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 0012', slope_V_0012, slope_TAT, slope_exp_0012);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 2412', slope_V_2412, slope_TAT, slope_exp_2412);
        fprintf('%-12s %14.4f %14.4f %14.4f\n', 'NACA 4412', slope_V_4412, slope_TAT, slope_exp_4412);
        
    end
end

if Part == 2
    %% PART 2
    if Task == 1
        %% Task 1
        taper_ratios = linspace(0, 1, 100); % 100 ok?
        AR_values = [4, 6, 8, 10];
        b_ref = 5; % can be anything
        N_terms = 20; %20 ok?
        
        % Plot
        figure();
        hold on;
        colors = {'r', 'g', 'b', 'y'};
            for k = 1:length(AR_values)
                AR_val = AR_values(k);
                delta_vals = zeros(size(taper_ratios));
                for j = 1:length(taper_ratios)
                    lambda  = taper_ratios(j);
                    c_r_val = 2 * b_ref / (AR_val * (1 + lambda));
                    c_t_val = lambda * c_r_val;
                    [e_val, ~, ~] = PLLT(b_ref, 2*pi, 2*pi, c_t_val, c_r_val, 0, 0, 5, 5, N_terms);
                    delta_vals(j) = 1/e_val - 1;
                end
                plot(taper_ratios, delta_vals, colors{k}, 'LineWidth', 1,'DisplayName', sprintf('AR = %d', AR_val));
            end
        grid on;
        xlabel('Taper Ratio c_t/c_r');
        ylabel('Induced Drag Factor \delta');
        title('Induced Drag Factor vs Taper Ratio');
        ylim([0 0.2]);
        hold off;
    end
end

%% Functions

function [x_b, y_b, x_c,y_c] = NACA_Airfoils(m1,p1,t1,c,N)
% NACA_Airfoil Generates a NACA 4-digit airfoil using cosine spacing
%
% This fuction computes that boundary coordiantes for a NACA 4-digit airfoil
% and returns the ordered panel points required for the vortex panel method.
% The airfoil geometry is constructed using the standard thickness distribution
% and the mean camber line equations. To improve trailing edge and leading edge
% we used cosine spacing to cluster points to improve accuracy.
%
% Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: 4/8/2026
%
% INPUTS:
%   m1  - maximum camber (first digit of NACA airfoil, percent)
%   p1  - location of maximum camber (second digit, tenths of chord)
%   t1  - maximum thickness (last two digits, percent of chord)
%   c   - chord length
%   N   - number of panels per surface
% OUTPUTS:
%   x_b - x-coordinates of airfoil boundary points (clockwise from TE)
%   y_b - y-coordinates of airfoil boundary points (clockwise from TE)
%   x_c - x-coordinates of camber line
%   y_c - y-coordinates of camber line


% LE = 0; % Leading Edge
% TE = c; % Trailing Edge
% x = linspace(LE, TE, N);

m = m1/100;
p = p1/10;
t = t1/100;

% Determining x discretization

theta = linspace(0, pi, N+1);

X = (c.*cos(theta)+ c )./2;

%x = [X,flip(X(1:end-1))]; % x-locations

% Thickness
x = X; % TE to LE, one pass only
ratio = x / c;

% Thickness
y_t = (t / 0.2) * (0.2969 * sqrt(ratio) - 0.1260 * ratio - 0.3516 * ratio.^2 ...
       + 0.2843 * ratio.^3 - 0.1036 * ratio.^4);

% Camber distribution (element-wise)
pc = p * c;
y_c      = zeros(size(x));
dy_c_dx  = zeros(size(x));

for i = 1:length(x)
    if x(i) >= 0 && x(i) < pc
        y_c(i)     = (m * x(i) / p^2) * (2*p - x(i)/c);
        dy_c_dx(i) = (2*m/p^2) * (p - x(i)/c);
    else
        y_c(i)     = (m * (c - x(i)) / (1-p)^2) * (1 + x(i)/c - 2*p);
        dy_c_dx(i) = (2*m/(1-p)^2) * (p - x(i)/c);
    end
end

% Upper and lower surfaces
zeta = atan(dy_c_dx);
x_U = x - y_t .* sin(zeta);
x_L = x + y_t .* sin(zeta);
y_U = y_c + y_t .* cos(zeta);
y_L = y_c - y_t .* cos(zeta);

% Output: lower TE->LE, then upper LE->TE (TE repeated once)
x_b = [x_L, flip(x_U(1:end-1))];
y_b = [y_L, flip(y_U(1:end-1))];

%flipping camber line coordinates so they plot nice
x_c = flip(x);
y_c = flip(y_c);

end

function zeroLiftAoa = aL_0(m1, p1, c, x_camber)
    m = m1/100;
    p = p1/10;
    theta0 = acos(max(-1, min(1, 1 - 2*x_camber/c)));
    dzdx = derivative(m, p, c, x_camber);
    a = dzdx .* (cos(theta0) - 1);
    zeroLiftAoa = -(1/pi) * trapz(theta0, a);
end

function dzdx = derivative(m, p, c, x_camber)
    dzdx = zeros(size(x_camber));
    if p == 0 ||m == 0
        return; %for symetric airfoils
    end
    %In front of max camber
    index1 = x_camber <= p*c;
    dzdx(index1) = (2*m/p^2) * (p - x_camber(index1)/c);
    %Behind max camber
    index2 = p*c < x_camber;
    dzdx(index2) = (2*m/(1-p)^2) * (p - x_camber(index2)/c);
end

function [CL] = Vortex_Panel(XB,YB,VINF,ALPHA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:                           %
%                                  %
% XB  = Boundary Points x-location %
% YB  = Boundary Points y-location %
% VINF  = Free-stream Flow Speed   %
% ALPHA = AOA                      %
%                                  %
% Output:                          %
%                                  %
% CL = Sectional Lift Coefficient  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Convert to Radians %
%%%%%%%%%%%%%%%%%%%%%%

ALPHA = ALPHA*pi/180;

%%%%%%%%%%%%%%%%%%%%%
% Compute the Chord %
%%%%%%%%%%%%%%%%%%%%%

CHORD = max(XB)-min(XB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine the Number of Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = max(size(XB,1),size(XB,2))-1;
MP1 = M+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-Panel Relationships:                                  %
%                                                             %
% Determine the Control Points, Panel Sizes, and Panel Angles %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    IP1 = I+1;
    X(I) = 0.5*(XB(I)+XB(IP1));
    Y(I) = 0.5*(YB(I)+YB(IP1));
    S(I) = sqrt( (XB(IP1)-XB(I))^2 +( YB(IP1)-YB(I))^2 );
    THETA(I) = atan2( YB(IP1)-YB(I), XB(IP1)-XB(I) );
    SINE(I) = sin( THETA(I) );
    COSINE(I) = cos( THETA(I) );
    RHS(I) = sin( THETA(I)-ALPHA );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:             %
%                                        %
% Determine the Integrals between Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    for J = 1:M
        if I == J
            CN1(I,J) = -1.0;
            CN2(I,J) = 1.0;
            CT1(I,J) = 0.5*pi;
            CT2(I,J) = 0.5*pi;
        else
            A = -(X(I)-XB(J))*COSINE(J) - (Y(I)-YB(J))*SINE(J);
            B = (X(I)-XB(J))^2 + (Y(I)-YB(J))^2;
            C = sin( THETA(I)-THETA(J) );
            D = cos( THETA(I)-THETA(J) );
            E = (X(I)-XB(J))*SINE(J) - (Y(I)-YB(J))*COSINE(J);
            F = log( 1.0 + S(J)*(S(J)+2*A)/B );
            G = atan2( E*S(J), B+A*S(J) );
            P = (X(I)-XB(J)) * sin( THETA(I) - 2*THETA(J) ) ...
              + (Y(I)-YB(J)) * cos( THETA(I) - 2*THETA(J) );
            Q = (X(I)-XB(J)) * cos( THETA(I) - 2*THETA(J) ) ...
              - (Y(I)-YB(J)) * sin( THETA(I) - 2*THETA(J) );
            CN2(I,J) = D + 0.5*Q*F/S(J) - (A*C+D*E)*G/S(J);
            CN1(I,J) = 0.5*D*F + C*G - CN2(I,J);
            CT2(I,J) = C + 0.5*P*F/S(J) + (A*D-C*E)*G/S(J);
            CT1(I,J) = 0.5*C*F - D*G - CT2(I,J);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:           %
%                                      %
% Determine the Influence Coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    AN(I,1) = CN1(I,1);
    AN(I,MP1) = CN2(I,M);
    AT(I,1) = CT1(I,1);
    AT(I,MP1) = CT2(I,M);
    for J = 2:M
        AN(I,J) = CN1(I,J) + CN2(I,J-1);
        AT(I,J) = CT1(I,J) + CT2(I,J-1);
    end
end
AN(MP1,1) = 1.0;
AN(MP1,MP1) = 1.0;
for J = 2:M
    AN(MP1,J) = 0.0;
end
RHS(MP1) = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for the gammas %
%%%%%%%%%%%%%%%%%%%%%%%%

GAMA = AN\RHS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Tangential Veloity and Coefficient of Pressure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    V(I) = cos( THETA(I)-ALPHA );
    for J = 1:MP1
        V(I) = V(I) + AT(I,J)*GAMA(J);
    end
    CP(I) = 1.0 - V(I)^2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Sectional Coefficient of Lift %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CIRCULATION = sum(S.*V);
CL = 2*CIRCULATION/CHORD;
end

function [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N)
% PLLT - Prandtl Lifting Line Theory for finite wings
%
% Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: 4/15/2026
%
% INPUTS:
%   b - wingspan (feet)
%   a0_t - sectional lift slope at tip (per radian)
%   a0_r - sectional lift slope at root (per radian)
%   c_t - chord at tip (feet)
%   c_r - chord at root (feet)
%   aero_t - zero-lift AoA at tip (degrees)
%   aero_r - zero-lift AoA at root (degrees)
%   geo_t - geometric AoA at tip (degrees)
%   geo_r - geometric AoA at root (degrees)
%   N - number of odd terms in the Fourier series
%
% OUTPUTS:
%   e- span efficiency factor
%   c_L - wing lift coefficient
%   c_Di - induced drag coefficient

% theta locations from equation 
theta = (1:N)' * pi / (2*N); % column vector wth N points

% Spanwise coordinates y = (b/2)*cos(theta)
% theta_i = i*pi/(2N) so theta goes from pi/(2N) to pi/2
% meaning we cover from near tip to root on one half the span position
eta = cos(theta); % 0 at root (theta=pi/2), 1 at tip (theta=0)

% Linear variation from root (eta=0) to tip (eta=1)
c_local    = c_r + (c_t - c_r) .* eta;
a0_local   = a0_r + (a0_t - a0_r) .* eta;
aero_local = aero_r + (aero_t - aero_r) .* eta; % degrees not rad
geo_local  = geo_r  + (geo_t  - geo_r)  .* eta; % degrees not rad

% Effective geometric angle of attack in radians
alpha_eff = deg2rad(geo_local - aero_local);

% Odd Fourier terms: n = 1, 3, 5, ...
n = (2*(1:N) - 1); % row vector (convert back later?)

%From equation 1 in lab sheet
%alpha(theta) = sum_n [ An * sin(n*theta) * (4b/(a0*c) + n/sin(theta))]
LHS = zeros(N, N);
for i = 1:N
    for j = 1:N
        nj = n(j);
        LHS(i,j) = sin(nj * theta(i)) * (4*b / (a0_local(i) * c_local(i)) + nj / sin(theta(i)));
    end
end

%Solving for fourier coefficients
A = LHS \ alpha_eff;% column vector of all the odd coefficents.

%Wing reference area from vehicle design
S = 0.5 * (c_r + c_t) * b;

%Aspect ratio
AR = b^2 / S;

%Wing lift coefficient only A1 (the n=1 term) contributes
c_L = A(1) * pi * AR;

% Induced drag factor delta: sum over all terms
% delta = sum_{k=1}^{N} n_k * (A_k/A_1)^2  but without the last term
delta = sum(n(2:end) .* (A(2:end)' ./ A(1)).^2);

%Span efficiency factor
e = 1 / (1 + delta);

%Induced drag coefficient
c_Di = c_L^2 / (pi * AR * e);

end
