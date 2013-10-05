function out = ImageGom(A, B)
%calculates gom of 2 images A and B
%A = image A
%B = image B (must be same size as A)

if(sum(eq(size(A), size(B))) ~= 2)
    error('Images must be the same size');
end

[AMag,AOr]= imgradient(A);
[BMag,BOr]= imgradient(B);

%convert to double vectors
AMag = double(AMag(:));
BMag = double(BMag(:));
AOr = double(AOr(:));
BOr = double(BOr(:));

alpha = cosd(2*(AOr - BOr))+1;
mu = AMag.*BMag;

out = sum(mu.*alpha)/(2*sum(mu));

end
