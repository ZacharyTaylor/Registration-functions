function [ A_high ] = high_pass( A )
%HIGH_PASS Applies high pass filter to A
%   Uses high pass filter found in 
%Visual odometry based on the Fourier-Mellin transform for a rover using a
%monocular ground-facing camera - section III-B-2

% obtain frequency (cycles/pixel)
res_h = 1 / (size(A,1)-1);
res_w = 1 / (size(A,2)-1);
fy = -0.5:res_h:0.5;
fx = -0.5:res_w:0.5;

%high pass filter
x_filt = cos(pi*(fy'))*cos(pi*fx);
h_filt = (1-x_filt).*(2-x_filt);
A_high = A.*h_filt;

end

