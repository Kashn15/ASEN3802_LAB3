function [x_b, y_b] = NACA_Airfoil(m,p,t,c,N)
% NACA_Airfoil Summary of this function goes here
% Detailed explanation goes here
%
% Author: {primary author, should be you}
% Collaborators: J. Doe, J. Smith {acknowledge whomever you worked with}
% Date: {should include the date last revised}
%
% m = 
% p = 
% t = thickness
% c = chord 
% N = number of employed panels

% LE = 0; % Leading Edge
% TE = c; % Trailing Edge
% x = linspace(LE, TE, N);

% Determining x discretization

theta = linspace(0,pi,n/2+1); 

X = (c.*cos(theta)+ c )./2;

x = [X,flip(X(1:end-1))]; % x-locations

% Thickness
ratio = x / c;
y_t = ( t / 0.2 ) * (0.2969 * sqrt(ratio) - 0.1260 * (ratio) - 0.1260 ...
       * (ratio^2) * 0.2843* (ratio^3) - 0.1036*(ratio^4));

% Chamber Distribution
pc = p * c;

    if x >= 0 && x < pc
        y_c = (m * (x/p^2)) * ((2*p) - ratio);
        dy_c_dx = (2*m*pc) - (2*m*x);
    elseif x >= pc && x <= c
        y_c = m * ((c-x)/((1-p)^2)) * (1 + ratio - 2*p);
        dy_c_dx = ((-2*m*x)+(2*pc*m)) / (c*(P-1)^2);
    end

% Slope Calculations
% dy_c_dx = gradient(y_c, x); % Calculate the slope of the camber line

zeta = arctan(dy_c_dx);

x_U = x - y_t * sin(zeta);
x_L = x + y_t * sin(zeta);

y_U = y_c + y_t * cos(zeta);
y_L = y_c - y_t * cos(zeta);

x_b = [x_L, x_U];
y_b = [y_L, y_U];

end
