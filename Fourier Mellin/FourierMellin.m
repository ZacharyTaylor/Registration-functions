%Fourier-Mellin transform

%% Inital setup
progress = waitbar(0,'Starting FM method', 'Name', 'Fourier Mellin'); bar = 0;
barTot = 9; %number of elements in waitbar

%% user set variables
windSize = 50; %window size for blur
sigma =  10; %gaussian blur sigma

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

cpsMax = 0;
sRMax = 0;

%preprocessing
waitbar(numPoints,progress,'Getting translation');

%always scale down
if(scale > 1)
    pA = A;
    pB = imresize(imrotate(B, -theta(i), 'bilinear', 'loose'),(1/scale));
else
    pA = imresize(imrotate(A, theta(i), 'bilinear', 'loose'),scale);
    pB = B;
end

[pA,pB] = padAndBlur(pA,pB,windSize,sigma);

%getting cross power spctrum
crossA = fft2(pA);
crossB = fft2(pB);

% Create phase difference matrix
pdm = exp(1i*(angle(crossA)-angle(crossB)));
% turn into cross phase-correlation
cps = real(ifft2(pdm));

if(max(max(cps)) > cpsMax)
    [x,y] = getTrans(cps);
    cpsMax = max(max(cps));
    cpsStore = cps;
    sRMax = i;
    fprintf('x %d  y %d  s %g  r %g\n',x,y,scale,theta);
end

figure('Name','Cross power spectrum');
surf(cpsStore);

%% transform image

waitbar(bar/barTot,progress,'transforming images'); bar = bar + 1;

if(scale(sRMax) > 1)
    base = A;
    move = zeros(size(A));
    if(y > size(A,1)/2)
        y = y-size(A,1);
    end
    if(x > size(A,2)/2)
        x = x-size(A,2);
    end
    B2 = imresize(imrotate(B, -theta(sRMax), 'bilinear', 'loose'),(1/scale(sRMax)));
    tform = [1,1,x,y,0,0,0];
    fastTform(double(B2), tform, move);
else
    base = B;
    move = zeros(size(B));
    if(y > size(B,1)/2)
        y = y-size(B,1);
    end
    if(x > size(B,2)/2)
        x = x-size(B,2);
    end
    A2 = imresize(imrotate(A, theta(sRMax), 'bilinear', 'loose'),(scale(sRMax)));
    tform = [1,1,x,y,0,0,0];
    fastTform(double(A2), tform, move);
end

waitbar(bar/barTot,progress,'displaying images'); bar = bar + 1;
figure, imshowpair(uint8(move),base);

%% cleanup
delete(progress);
