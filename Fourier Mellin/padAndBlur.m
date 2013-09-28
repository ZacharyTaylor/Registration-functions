function [A,B] = padAndBlur(A,B,windSize,sigma)
%PADANDBLUR pads images to same size and blurs edges

A = double(A);
B = double(B);

%blur edges to get rid of + shape in fft
PSF = fspecial('gaussian',windSize,sigma);
A = edgetaper(A,PSF);
B = edgetaper(B,PSF);

%pads images so they are the same size
maxX = max(size(A,2),size(B,2));
maxY = max(size(A,1),size(B,1));

A = padarray(A,[max(maxY-size(A,1),0), max(maxX-size(A,2),0)],'replicate','post');
B = padarray(B,[max(maxY-size(B,1),0), max(maxX-size(B,2),0)],'replicate','post');

end

