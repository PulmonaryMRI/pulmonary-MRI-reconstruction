function sg = ute_soft(gate,thresh);
% Apply Soft-gating
%Default Threshold
if nargin < 2
    N = 4;  % get 25% of the data
    sort_sig = sort(gate);
    thresh = sort_sig(floor(length(gate)/N));
end

sg = exp(- 3 * (gate - thresh) );
sg(sg > 1) = 1;
fprintf('Effective undersampling ratio for soft-gating is %f \n',sum(sg)/length(gate) );
