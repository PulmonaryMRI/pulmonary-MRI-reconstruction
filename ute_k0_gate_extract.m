function gate = ute_k0_gate_extract(k0, ref)
%% Use K0 to extract self-gatign signal
% ref is a reference signal (normalized bellows)

%find the largest variation coils
tmp = std(abs(k0),1);  
ind = find(tmp == max(tmp));

hh = fir1(512,1/250);
%hh = fir1(1024,1/5000);
rawdata = k0(:,ind);
tmp = [rawdata(400:-1:1);rawdata;rawdata(end:-1:end-255)];
%tmp = [rawdata(1000:-1:1);rawdata;rawdata(end:-1:end-511)];

dk0 = fftfilt(hh,medfilt1(abs(tmp),7));
gate = dk0((400+257):(400+256+length(rawdata)));
%gate = dk0((1000+513):(1000+512+length(rawdata)));
% normalize
gate = (gate-mean(gate))/std(gate);

 if(sum(gate.*ref)< 0) 
     gate = -gate;
 end

%% Adjust drifts according using Asymmetric Least-Squares
bline = baseline(gate,10^9,0.01);
gate = gate - bline;
% normalize
gate = (gate-mean(gate))/std(gate);

end

function z = baseline(y ,lambda, p)
% applies asymmetric least squares to estimate baseline, z.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this code is taken from Eilers, Boelens 'Baseline Correction with 
% Asymmetric Least Squares Smoothing' 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% .001 < p < .1
% 10e2 < lambda < 10^9

% for UTE self gating: (10^9, 0.01 )
m = length(y);
D = diff(speye(m), 2);
w = ones(m,1);
maxIter = 5;
 
for it = 1:maxIter
    W = spdiags(w, 0, m, m);
    C = chol(W + lambda * (D' * D));
    z = C \ (C' \ (w .* y)); %C \ (w .* y);
     
    % perform estimation without inverting C?
    %z = cgs(W+lambda*D'*D,w.*y,[],100);
    
    w = p * (y > z) + (1 - p) * (y < z);
end
 
end
