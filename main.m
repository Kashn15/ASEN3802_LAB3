%% ASEN 3111 - Computational Assignment XX - Main
% Provide a brief summary of the problem statement and code so that
% you or someone else can later understand what you attempted to do
% it doesn't have to be that long.
%
% Co-Authors: Philip Austin, Charles Bailey, Nico Galindo, Natsumi Kakuda
% Date: {should include the date last revised}

clc; 
clear;
close all;

%% Task 1

% NACA 0012
m_0021 = 0;
p_0021 = 0;
t_0021 = 21;
c_0021 = 5;
N_0021 = 25;

[x_0021, y_0021] = NACA_Airfoils(m_0021,p_0021,t_0021,c_0021,N_0021);

figure(1);
hold on;
scatter(x_0021, y_0021, 'r', 'filled');
plot(x_0021, y_0021, 'k-')
axis equal;
grid on;
xlabel('ChordWise Displacement (x-axis displacement) [m]');
ylabel('N-S displacement (y-axis displacement) [m]');

% NACA 2421
m_2421 = 2;
p_2421 = 4;
t_2421 = 21;
c_2421 = 5;
N_2421 = 25;

[x_2421, y_2421] = NACA_Airfoils(m_2421,p_2421,t_2421,c_2421,N_2421);

figure(2);
hold on;
scatter(x_2421, y_2421, 'r', 'filled');
plot(x_2421, y_2421, 'k-')
axis equal;
grid on;
xlabel('ChordWise Displacement (x-axis displacement) [m]');
ylabel('N-S displacement (y-axis displacement) [m]');
