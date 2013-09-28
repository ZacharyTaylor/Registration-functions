function [imlp, base] = log_polar(im)

[Y,X] = size(im);

% Find the center
Xc = (1 + X)/2;
Yc = (1 + Y)/2;

% Calculate log base and angle increments
base = 10 ^ (log10(Xc-1)/(Xc-1));
dtheta = pi / Y;

% Build x-y coordinates of log-polar points
Xin = zeros([Y,X]);
Yin = zeros([Y,X]);

for y = 0:Y-1
  theta = y * dtheta;
  for x = 0:X-1
    r = base ^ (x/2) - 1;
    Xin(y+1,x+1) = r * cos(theta) + Xc;
    Yin(y+1,x+1) = r * sin(theta) + Yc;
  end
end

% Interpolate values at each l-p point
imlp = interp2(1:X,1:Y,im,Xin,Yin,'cubic');

% replace out of range values with 0s
imlp(isnan(imlp)) = 0;
