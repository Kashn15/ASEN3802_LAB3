%% ASEN 3802 - Aerodynamics Lab - Main
% This code explores the vortex panel method and thin airfoil theory
% methods of airfoil analysis on symetrical and cambered NACA airfoils.
%
% Co-Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: 4/8/26

clc; 
clear;
close all;

toggle = 'NACA 0021'; % Select between NACA 0021 or NACA 2421 for Task 1
Task1 = 0;
Task2 = 0;
Task3 = 1;

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


cl_TAT_NACA0006 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0006);
cl_TAT_NACA0012 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0012);
cl_TAT_NACA0018 = 2*pi*(deg2rad(alphas) - deg2rad(aL_0_NACA0018);

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

function zeroLiftAoa = aL_0(m, p, c, x_camber)
    theta0 = acos(max(-1, min(1, 1 - 2*x_camber/c)));
    dzdx = derivative(m, p, c, x_camber);
    a = dzdx .* (cos(theta0) - 1);
    zeroLiftAoa = -(1/pi) * trapz(theta0, a);
    zeroLiftAoa = rad2deg(zeroLiftAoa);
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
