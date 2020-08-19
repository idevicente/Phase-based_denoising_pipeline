import nibabel as nb
import numpy as np
import argparse

# Constructing the argument parser

ap = argparse.ArgumentParser()

# Arguments for parser

ap.add_argument("--in_file", required = True, help = "input file to unwrap")
ap.add_argument("--outdir", required = True, help = "path to output directory")
ap.add_argument("--subj", required = True, help = "subject")

args = vars(ap.parse_args())


fname = str(args['outdir'] + args['in_file'])
img = nb.load(fname)
data = np.array(img.get_data()).astype(float)

phaseuw = np.zeros_like(data, dtype=np.float)
deltaphase = np.zeros_like(data, dtype=np.float)
for x in range(data.shape[0]):
    for y in range(data.shape[1]):
        for z in range(data.shape[2]):
            deltaphase[x, y, z, :] = data[x, y, z, :] - data[x, y, z, 0]
            # Unwrap phase
            phaseuw[x, y, z, :] = np.unwrap(deltaphase[x, y, z, :])
         
out_name = str(args['outdir']) + str(args['subj']) + '.phase.pb07_time_unwrapped.nii.gz'

new_img = nb.Nifti1Image(phaseuw, img.affine, img.header)
nb.save(new_img, out_name)


