function mi=miMatlab(A,B, normal, bins)
%calculates mutual information of 2 images A and B
%uses a sparse matrix for histogram allowing bins to be a very large number
%A = image 1
%B = image 2 (must be the same size as image 1)
%normal = if true output normal mi else output mi
%bins = number of bins to use (0 for 1 bin per value assuming A,B are ints)


if(sum(eq(size(A), size(B))) ~= 2)
    error('Images must be the same size');
end

%convert to double vectors
A = double(A(:));
B = double(B(:));

%if bins zero find value
if(bins ==0)
    bins = ceil(max(max(B)-min(B), max(A)-min(A)));
end

%set range from 1 to bins + 1
A = A - min(A);
B = B - min(B);
A = round(bins*A./max(A)) + 1;
B = round(bins*B./max(B)) + 1;

%get probabilities histogram
[val,idx] = unique(sortrows([A,B]),'rows');
h = sparse(val(:,1),val(:,2),diff([0;idx]));

%normalize
h = h./ sum(h(:));

%get individual histograms
hA = sum(h,2);
hB = sum(h,1);

%take logs (skip zero value elements)
h(h ~=0) = -h(h ~=0).*log2(h(h ~=0));
hA(hA ~=0) = -hA(hA ~=0).*log2(hA(hA ~=0));
hB(hB ~=0) = -hB(hB ~=0).*log2(hB(hB ~=0));

%sum values
entAB = full(sum(h(:)));
entA = full(sum(hA(:)));
entB = full(sum(hB(:)));

%calculate mi
if normal
    mi = (entA + entB)/entAB;
else
    mi = entA + entB - entAB;
end

end
