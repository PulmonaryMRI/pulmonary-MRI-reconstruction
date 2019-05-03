# pulmonary-MRI-reconstruction
Tools for reconstructing Pulmonary MRI datasets to manage motion

Requires BART https://mrirecon.github.io/bart/

Sample data has been tested with BART v.0.4.00, please install version later than v.0.4.00
https://github.com/mrirecon/bart/releases/

Requries MATLAB

Typically requires 100GB RAM, for 256*256*256 matrix size, 8 channel, 4 motion phase.

Current features being built in
Supports center-out k-space trajectories (e.g. UTE with radial, cones)
Soft-gating reconstruction
Motion-resolved reconstruction
Dynamic Image Navigator reconstruction
Sample dataset to test (git-lfs?)

Initial version adapted from
https://github.com/jiangwenwen1231/FB_UTE_Recon


References
https://doi.org/10.1002/mrm.26958
