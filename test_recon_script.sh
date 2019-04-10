#!/bin/bash

#  test_recon_script.sh
#  
#
#  Created by Larson, Peder on 3/29/19.
#  Modified by Zhu, Xucheng on 4/9/19.
#   Modified the script to match bart v4.0

export DEBUG_LEVEL=5
set -x

if [ $# -ne 1 ]
then
    echo "Not enough arguments supplied"
    echo "Usage: maps.sh input_root"
    echo " input_root files required include _traj, _data, _sg_dcf"
    exit 113
fi
# data prefix
in=$1
# low resolution data prefix
inl=$in'_lrs'

# Inputs needed (cfl files)
# raw data _data
# k-space trajectory _traj
# density compensation function _dcf
# respiratory bellows (optional?) _resp
# sampling times _time


# compute k0 navigator, assign soft-gating weights and bin data
matlab -nodesktop -nosplash -r "ute_data_weighting('"$in"');quit;"

# image navigator reconstruction
matlab -nodesktop -nosplash -r "recon_image_navigator_prep('"$in"');quit;"
./maps.sh $inl
time bart pics -m -R L:7:7:0.005 -p $inl"_dcft" -i 40 -C 10 -t $inl"_trajt" $inl"_datat" $inl"_maps" $inl"_nav"


# high res reconstruction
# coil sensitivity maps
./maps.sh $in

# ** no gating
./recon_nufft_nogating.sh $in

# ** soft gating
# recon
time bart pics -p $in"_sg_dcf" -i 30 -r 0.005 -l1 -s 0.00000001 -t $in"_traj" $in"_data" $in"_maps" $in"_sg_rec"


# ** motion-resolved
time bart pics -p $in"_dcfm" -i 30 -R T:1024:0:.01 -R W:7:0:0.01 -t $in"_trajm" $in"_datam" $in"_maps" $in"_mr_rec"

