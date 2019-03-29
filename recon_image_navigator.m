function res = recon_image_navigator(rootfname, N_readout_samples)

% please set the bart/matlab directory
addpath ~/bart/matlab

if nargin < 2
N_readout_samples = 100;
end


data = readcfl([rootfname '_data']);
traj = readcfl([rootfname '_traj']);
dcf = readcfl([rootfname '_dcf']);

ncoils = size(data,4);

res = [];

for ind = 1:ceil(size(data,3)/10000)
    if(ind*10000) > size(data,3)
        last = floor(size(data,3)/100)*100;
    else
        last = ind*10000;
    end
    range = (ind-1)*10000+1:last;
    
    data_lowres = data(:,1:N_readout_samples,range,:);
    traj_lowres = traj(:,1:N_readout_samples,range);
    dcf_lowres = dcf(:,1:M=N_readout_samples,range);

    im_calib = bart('bart nufft -a -t -d 24:24:24', traj_lowres, data_lowres.*repmat(dcf_lowres,[1 1 1 ncoils]));
    kcalib =  bart('bart fft 7 ',im_calib);
    kcalib_zpad =  bart('bart resize -c 0 80 1 80 2 80',kcalib);
    maps = bart('bart ecalib -S -m 1 -r 24', kcalib_zpad);

    traj_tmp = permute( reshape( traj_lowres, [size(traj_lowres,1), size(traj_lowres,2), 100, size(traj_lowres,3)/100] ), [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 4] );
    data_tmp =  permute( reshape( data_lowres, [size(data_lowres,1), size(data_lowres,2), 100,size(data_lowres,3)/100, size(data_lowres,4)] ), [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 4]);
    dcf_tmp = permute( reshape( dcf_lowres, [size(dcf_lowres,1), size(dcf_lowres,2), 100, size(dcf_lowres,3)/100] ), [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 4]);

    tmp = dcf_lowres(:,:,1);
    %% Save to cfl files
    writecfl([rootfname '_templowres_traj',traj_tmp)
    writecfl([rootfname '_templowres_dcf',dcf_tmp/max(tmp(:))*8);
    writecfl([rootfname '_templowres_data',data_tmp);
    writecfl([rootfname '_templowres_maps',maps);

              eval(['bart pics -i 200 -R L:7:7:0.0005 -H -s 0.001 -p ' rootfname '_templowres_dcf -t ' rootfname '_templowres_traj ' rootfname '_templowres_data ' rootfname '_templowres_maps ' rootfname '_templowres_rec'])
   % !bart pics -i 200 -R L:7:7:0.0005 -H -s 0.001 -p uwute_lowres_dcf -t uwute_lowres_traj uwute_lowres_data uwute_lowres_maps uwute_lowres_rec
    im = readcfl([rootfname '_templowres_rec');
    res = cat(4,res,im);
    writecfl([rootfname,'_lowres_rec'],res);
end
   
                  eval(['rm ' rootfname '_templowres*'])
                  
end


