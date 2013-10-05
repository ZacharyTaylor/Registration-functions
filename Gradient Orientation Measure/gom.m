function out = gom(AMag, AOr, BMag, BOr)
%calculates gom of 2 inputs A and B each with gradient magnitude Mag and
%orientation Or
%AMag = gradient magnitude of input A
%BMag = gradient magnitude of input B
%AOr = gradient orientation of input A in degrees
%BOr = gradient orientation of input B in degrees


if(sum(eq(size(AMag), size(BMag))) ~= 2)
    error('Images must be the same size');
end
if(sum(eq(size(AOr), size(BOr))) ~= 2)
    error('Images must be the same size');
end
if(sum(eq(size(AMag), size(AOr))) ~= 2)
    error('Images must be the same size');
end

%convert to double vectors
AMag = double(AMag(:));
BMag = double(BMag(:));
AOr = double(AOr(:));
BOr = double(BOr(:));

alpha = cosd(2*(AOr - BOr))+1;
mu = AMag.*BMag;

out = sum(mu.*alpha)/(2*sum(mu));

end
