clc;
clear;
close all;

m = 0;
p = 0;
t = 0;
c=10;
n = 12;


%% Determining x discretization

theta = linspace(0,pi,n/2+1); %

x = (c.*cos(theta)+ c )./2;

X = [x,flip(x(1:end-1))];
