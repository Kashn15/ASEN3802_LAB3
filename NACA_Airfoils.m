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
