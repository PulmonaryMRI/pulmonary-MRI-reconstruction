#! /bin/bash
if [ $# -ne 1 ]
then
    echo "Not enough arguments supplied"
    echo "Usage: recon.sh input"
    exit 113
fi

in=$1

bart fmac $in"_data" $in"_dcf" $in"_dcfdata"

bart nufft -a  $in"_traj" $in"_dcfdata" $in"_nufft"

bart rss 8 $in"_nufft" $in"_nufft_rss"

rm  $in"_nufft".*

rm  $in"_dcfdata".*
