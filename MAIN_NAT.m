%% ASEN 3802 - Aerodynamics Lab 03 Part 1 - Main
% Main script for Part 1 of the aerodynamic analysis. The code generates
% NACA 4-digit airfoil geometries and evaluates sectional lift using the
% provided Vortex_Panel solver. Task 1 constructs and plots NACA airfoils.
% Task 2 performs a convergence study for NACA 0012 to determine the number
% of panels required for 1% relative error. Task 3 investigates the effect
% of airfoil thickness on lift over a range of angles of attack. Task 4
% analyzes the effect of airfoil camber on lift. Results are plotted and
% compared within a single continuous workflow.
% 
% 
% Co-Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: 4/8/2026

clc; 
clear;
close all;

%% Toggling Panel
toggle = 'NACA 0021'; % Select between NACA 0021 or NACA 2421 for Task 1
Task1 = 0; % 1 to activate; 0 to deactivate
Task2 = 1; % 1 to activate; 0 to deactivate

%% TASK 1
if Task1 == 1
N = 50; % Number of Panels
c = 1; % Chord [m]

if toggle == 'NACA 0021'
% NACA 0021
m = 0;
p = 0;
t = 21;

[x_0012, y_0012, x2_0012, y2_0012] = NACA_Airfoils(m,p,t,c,N);

figure(1);
hold on;
scatter(x_0012, y_0012, 'ro');
plot(x_0012, y_0012, 'k-')
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

%% Task 3

%% Task 4









