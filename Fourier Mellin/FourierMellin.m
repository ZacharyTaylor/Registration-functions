%Fourier-Mellin transform

%% Inital setup
progress = waitbar(0,'Starting FM method', 'Name', 'Fourier Mellin'); bar = 0;
barTot = 9; %number of elements in waitbar

%% user set variables
windSize = 50; %window size for blur
sigma =  10; %gaussian blur sigma
highPass = true;

%% load images
waitbar(bar/barTot,progress,'Getting Images'); bar = bar + 1;
[A,B] = getImages();

figure('Name','Image 1');
imshow(A);

figure('Name', 'Image 2');
imshow(B);

%% getting scale and rotation
%pad and blur
waitbar(bar/barTot,progress,'Preprocessing Images'); bar = bar + 1;
[pA,pB] = padAndBlur(A,B,windSize,sigma);

%getting cross power spctrum
waitbar(bar/barTot,progress,'Finding cross power spectrum of images'); bar = bar + 1;
[crossA, ~] = crossPower(pA, highPass);
[crossB, base] = crossPower(pB, highPass);

%create phase difference matrix
pdm = exp(1i*(angle(crossA)-angle(crossB)));
%turn into cross power spectrum
cps = real(ifft2(pdm));

figure('Name','Cross power spectrum');
surf(cps);

waitbar(bar/barTot,progress,'getting scale and rotation'); bar = bar + 1;
[theta, scale] = getRotScale(cps, base, size(A));


%% getting translation

pA = imresize(imrotate(A, theta, 'bilinear', 'loose'),scale);
pB = B;

[pA,pB] = padAndBlur(pA,pB,windSize,sigma);

%getting cross power spctrum
crossA = fft2(pA);
crossB = fft2(pB);

% Create phase difference matrix
pdm = exp(1i*(angle(crossA)-angle(crossB)));
% turn into cross phase-correlation
cps = real(ifft2(pdm));

[x,y] = getTrans(cps);
cpsMax = max(max(cps));
cpsStore = cps;
fprintf('x %d  y %d  s %g  r %g\n',x,y,scale,theta);

figure('Name','Cross power spectrum');
surf(cpsStore);

%% transform image

waitbar(bar/barTot,progress,'transforming images'); bar = bar + 1;

tform = [scale*cos(theta), scale*sin(theta), 0; -scale*sin(theta), scale*cos(theta), 0; x, y, 1];
T = affine2d(tform);

RA = imref2d(size(A));
RB = imref2d(size(B));

[A2,RA] = imwarp(A,RA,T);

%waitbar(bar/barTot,progress,'displaying images'); bar = bar + 1;
figure, imshowpair(A2,RA,B,RB);

%% cleanup
delete(progress);
