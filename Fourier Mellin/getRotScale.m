function [theta, scale] = getRotScale(cps, base, sizeIm)
%GETROTSCALE get rotation and scale from cps

    %find largest element
    [~,topPoints] = max(cps(:));
    
    [y_max,x_max] = ind2sub(size(cps),topPoints);

    theta = 180*(y_max-1)./sizeIm(1);
    
    theta(theta > 90) = 180 - theta(theta > 90);
  
    scale_power(x_max > sizeIm(2)/2) = x_max(x_max > sizeIm(2)/2)-sizeIm(2);
    scale_power(x_max <= sizeIm(2)/2) = x_max(x_max <= sizeIm(2)/2)-1;

    scale = base.^(scale_power./2);
end

