function [val, base] = crossPower(img, highPass)
%CROSSPOWER gets cross power spectrum of image
%inputs
%   img - a double array
%outputs
%   val - the cross power spectrum
%   base - the base of the log_polar conversion

%Perform 2D FFTs 
val = fftshift(fft2(img));

%gets magnitude
val = abs(val);

%high pass filter
if(highPass)
    val = high_pass(val);
end

%log-polar conversion
[val, base] = log_polar(val);
    
%calculate cross power spectrum
val = fft2(val);

end

