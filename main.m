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

% Task 1

m_21 = 0;
p_21 = 0;
t_21 = 21;
c_21 = 5;
N_21 = 25;

[x_21, y_21] = NACA_Airfoils(m_21,p_21,t_21,c_21,N_21);

figure(1);
plot(x_21, y_21);
axis equal;
