function res = recon_image_navigator_prep(rootfname, N_readout_samples,Msize1,scale)

% please set the bart/matlab directory
addpath ~/bart/matlab

if nargin < 2
    N_readout_samples = 100;
end

if nargin < 3
    Msize1 = 50;
end

if nargin < 4
    scale = [1.2,1,1];
end

data = readcfl([rootfname '_data']);
traj = readcfl([rootfname '_traj']);
dcf = readcfl([rootfname '_dcf']);

ncoils = size(data,4);

% check tN
pN = N_readout_samples;
tN = floor(size(traj,3)/N_readout_samples);

% calc readout num
Msize1 = max(Msize1,50);
traj0 = traj(:,:,1);
traj0 = sqrt(sum(traj0.^2,1));
fN = sum(traj0<Msize1/2);

data_lrs = data(:,1:fN,1:tN*pN,:);
traj_lrs = traj(:,1:fN,1:tN*pN,1);
dcf_lrs = dcf(:,1:fN,1:tN*pN,1);

for i = 1:3
    traj_lrs(i,:) = traj_lrs(i,:)*scale(i);
end

writecfl([rootfname '_lrs_data'],data_lrs);
writecfl([rootfname '_lrs_dcf'],dcf_lrs);
writecfl([rootfname '_lrs_traj'],traj_lrs);

data_lrs = permute(reshape(data_lrs,[1,fN,tN,pN,ncoils]),[1 2 4 5 6 3]);
dcf_lrs = permute(reshape(dcf_lrs,[1,fN,tN,pN,1]),[1 2 4 5 6 3]);
traj_lrs = permute(reshape(traj_lrs,[3,fN,tN,pN,1]),[1 2 4 5 6 3]);

writecfl([rootfname '_lrs_datat'],data_lrs);
writecfl([rootfname '_lrs_trajt'],traj_lrs);
writecfl([rootfname '_lrs_dcft'],sqrt(dcf_lrs));% iterative recon requires sqrt(dcf)
