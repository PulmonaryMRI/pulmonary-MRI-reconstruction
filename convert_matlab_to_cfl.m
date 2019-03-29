function convert_matlab_to_cfl(data, trajectory, dcf, outfname)

%% Save to cfl files
writecfl([outfname,'_traj'],trajectory)
writecfl([outfname,'_dcf'],dcf);
writecfl([outfname,'_data'],data);
