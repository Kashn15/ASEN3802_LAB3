function [x_b, y_b] = NACA_Airfoils(m1,p1,t1,c,N)
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

end
