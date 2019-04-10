function ute_data_weighting(rootfname, do_soft, hard_Nbins)

if nargin < 2
do_soft = 1;
hard_Nbins = 4;
end

data = readcfl([rootfname '_data']);
traj = readcfl([rootfname '_traj']);
dcf = readcfl([rootfname '_dcf']);

% bellows data and temporal mapping
resp = readcfl([rootfname '_resp']);
% time = readcfl([rootfname '_time']);

% [stime,order] = sort(time);
order = 1:length(resp);

resp_ordered = resp(order);
resp_ordered_normalized = -(resp_ordered-mean(resp_ordered))/std(resp_ordered);

% extract DC/k0 navigator
k0_ordered = squeeze(double( data(:,1,order,:) ));
gate_ordered = ute_k0_gate_extract( k0_ordered, resp_ordered_normalized);
gate(order) = gate_ordered;

writecfl([rootfname,'_k0_gate'],gate);

if 0
figure(10),subplot(211) ,plot(resp),title('bellow')
subplot(212),plot(gate_ordered),title('self-gating')
end

%% Get soft-weighting
if do_soft
sg_ordered = ute_soft(gate_ordered); % ute_gui( gate_ordered ,resp_ordered_normalized);  % ute_gui missing
    sg(order) = sg_ordered;
    sgdcf = dcf .* repmat( reshape( sg, [1, 1, size(data,3), 1, 1] ), [1, size(data,2), 1, 1, 1] );
writecfl([rootfname,'_sg_dcf'],sqrt(sgdcf));
end

%% Binning
if hard_Nbins
[bin_data, bin_traj, bin_dcf] = ute_binning( gate, hard_Nbins, data, traj, dcf );
    
    %writecfl([rootfname, '_b', int2str(hard_Nbins), '_data'], bin_data);
    %writecfl([rootfname, '_b', int2str(hard_Nbins) , '_traj'], bin_traj);
    %writecfl([rootfname, '_b', int2str(hard_Nbins), '_dcf'], sqrt(bin_dcf));% iter requires sqrt(dcf)

    writecfl([rootfname, '_datam'], bin_data);
    writecfl([rootfname, '_trajm'], bin_traj);
    writecfl([rootfname, '_dcfm'], sqrt(bin_dcf));% iter requires
end

