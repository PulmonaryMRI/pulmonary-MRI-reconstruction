#!/bin/bash

#  test_recon_script.sh
#  
#
#  Created by Larson, Peder on 3/29/19.
#

export DEBUG_LEVEL=5
set -x

in="test_data"
# Inputs (cfl files) - separate script example to generate?
# raw data
# k-space trajectory
# density compensation function
# motion estimation - data weighting
matlab -nodesktop -nosplash -r "ute_data_weighting('"$in"');quit;"

# image navigator
matlab -nodesktop -nosplash -r "recon_image_navigator('"$in"');quit;"


# coil sensitivity maps
./maps.sh $in

# ** no gating
./recon_nufft_nogating.sh $in

# ** soft gating
# recon
time bart pics -p $in"_sg_dcf" -i 30 -r 0.005 -l1 -s 0.00000001 -t $in"_traj" $in"_data" $in"_maps" $in"_sg_rec"


# ** motion-resolved
# recon - MISSING
