function ent = entMatlab(data, bins)
%calculates entropy of input data
%uses a sparse matrix for histogram allowing bins to be a very large number
%data = input data
%bins = number of bins to use (0 for 1 bin per value assuming data contains ints)

%convert to double vectors
data = double(data(:));

%if bins zero find value
if(bins ==0)
    bins = ceil(max(data)-min(data));
end

%set range from 1 to bins + 1
data = data - min(data);
data = round(bins*data/max(data)) + 1;

%get probabilities histogram
[val,idx] = unique(sort(data));
h = sparse(val(:,1),val(:,2),diff([0;idx]));

%normalize
h = h./ sum(h(:));

%take logs (skip zero value elements)
h(h ~=0) = -h(h ~=0).*log2(h(h ~=0));

%sum values
ent = full(sum(h(:)));

end
