function [x,y] = getTrans(cps)
%GETROTSCALE get rotation and scale from cps

    %find largest element
    [m1, m2] = max(cps);
    [~, x_max] = max(m1);
    y_max = m2(x_max);

    x = x_max-1;
    y = y_max-1;
    
    x = min(x,size(cps,2) - x);
    y = min(y,size(cps,1) - y);
end

