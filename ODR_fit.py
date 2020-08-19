import os
from os.path import abspath, join

import nibabel as nb
import numpy as np
import nilearn as nl
import nipype.pipeline.engine as pe
import nipype.interfaces.utility as ul
import scipy.odr.odrpack as odr
import pdb

import argparse

ap = argparse.ArgumentParser()


ap.add_argument("--phase", required = True, help = "phase image")
ap.add_argument("--magnitude", required = True, help = "magnitude image")
ap.add_argument("--mask", required = True, help = "mask")
ap.add_argument("--TR", required = True, help = "Repetition time of scan")
ap.add_argument("--noise_filter", required = True, help = "high-pass filter threshold")
ap.add_argument("--outdir", required = True, help = "path to output directory")
ap.add_argument("--subj", required = True, help = "subject")

args = vars(ap.parse_args())

# Load phase and magnitude images

phase = str(args['outdir'] + args['phase'])
mag = str(args['outdir'] + args['magnitude'])
mask_base = str(args['outdir'] + args['mask'])

f = nb.load(mag)
mag = f.get_fdata()

f = nb.load(phase)
ph = f.get_fdata()

f = nb.load(mask_base)
mask = f.get_fdata()

# Set TR and filter threshold

TR = float(args['TR'])
noise_lb = float(args['noise_filter'])

subj = str(args['subj'])


# Create variables were the outputs will be saved

saveshape = np.array(mag.shape) # 4D variable with the shape  
nt = mag.shape[-1]

scales = np.zeros(np.prod(saveshape[0:-1])) # Array of zeros with length = number of voxels
filt = np.zeros((np.prod(saveshape[0:-1]), nt)) # 2D matrix of zeros with shape voxels x timepoints 
sim = np.zeros_like(filt)
residuals = np.zeros_like(filt)

delta = np.zeros_like(filt)
eps = np.zeros_like(filt)
xshift = np.zeros_like(filt)
stdm = np.zeros(saveshape[0:-1])
stdp = np.zeros(saveshape[0:-1])
r2 = np.zeros_like(scales)

estimate = np.zeros_like(filt)


mag = np.array(mag)
mm = np.mean(mag, axis=-1)

# mask = mm > 0.03 * np.max(mm)

# define multiple regression linear function
#  def multiplelinear(beta, x):
#         f = np.zeros(x[0].shape)
#         for r in range(x.shape[0]):
#             f += beta[r]*x[r]
#         f += beta[-1]*np.ones(x[0].shape)
#         return f

def multiplelinear(beta, x):
    f = np.zeros(x.shape)
    f = beta[0]*x + beta[1]
    return f
    
# Create model
linearfit = odr.Model(multiplelinear)


# Creates a noise mask that takes only those values greater than noise_lb
freqs = np.linspace(-1.0, 1.0, nt) / (2 * TR)

noise_idx = np.where((abs(freqs) > noise_lb))[0]
noise_mask = np.fft.fftshift(1.0 * (abs(freqs) > noise_lb))

# Estimates standard deviations of magnitude and phase
for x in range(mag.shape[0]):
    temp = mag[x, :, :, :]
    #mu = np.mean(temp, -1)
    stdm[x, :, :] = np.std(np.fft.ifft(np.fft.fft(temp)* noise_mask), -1)
    temp = ph[x, :, :, :]
    #mu = np.mean(temp, -1)
    stdp[x, :, :] = np.std(np.fft.ifft(np.fft.fft(temp)* noise_mask), -1)

# Reshape variables into a single column
mag = np.reshape(mag, (-1, nt)) # Reshapes variable intro 2D matrix of voxels x timepoints 
ph = np.reshape(ph, (-1, nt))
stdm = np.reshape(stdm, (-1,)) # Reshapes variable intro array of length = number of voxels 
stdp = np.reshape(stdp, (-1,))
mask = np.reshape(mask, (-1,))

for x in range(mag.shape[0]):
    if mask[x]:
        #design = np.row_stack(((ph[x, :]), np.ones(ph[x, :].shape)))
        design = ph[x, :]
        ests = [stdm[x]/stdp[x], 1.0]
        mydata = odr.RealData(design, mag[x, :],
                              sx=stdp[x], sy=stdm[x])
        odr_obj = odr.ODR(mydata, linearfit, beta0=ests, maxit=600)
        res = odr_obj.run()
        #res.pprint()
        est = res.y
        
        r2[x] = 1.0 - (np.sum((mag[x, :] - est) ** 2) / np.sum((mag[x, :]) ** 2))
        
        # take out scaled phase signal and re-mean may need correction
        sim[x, :] = ph[x, :]*res.beta[0]

        filt[x, :] = mag[x, :] - est 
        # estimate residuals
        residuals[x, :] = np.sign(mag[x, :]-est)*(np.sum(res.delta**2,
                                                  axis=0) + res.eps**2)
        delta[x, :] = np.sum(res.delta, axis=0)					# res.delta --> Array of estimated errors in input variables (same shape as x)
        eps[x, :] = res.eps				# res.eps --> Array of estimated errors in response variables (same shape as y)
        xshift[x, :] = np.sum(res.xplus, axis=0)
        
        estimate[x, :] = res.y				# res.xplus --> Array of x + delta


# Save outputs

outname = str(args['outdir'] + args['subj'] + '.odr')


outnii1 = nb.Nifti1Image(np.reshape(sim, saveshape),
                                    affine=f.affine, header=f.get_header())
nb.save(outnii1, outname + '_sim.nii.gz')

outnii2 = nb.Nifti1Image(np.reshape(filt, saveshape), affine=f.affine,
                        header=f.get_header())
nb.save(outnii2, outname + '_filt.nii.gz')

outnii3 = nb.Nifti1Image(np.reshape(residuals, saveshape),
                        affine=f.affine, header=f.get_header())
nb.save(outnii3, outname + '_residuals.nii.gz')

outnii4 = nb.Nifti1Image(np.reshape(delta, saveshape),
                        affine=f.affine, header=f.get_header())
nb.save(outnii4, outname + '_xres.nii.gz')

outnii5 = nb.Nifti1Image(np.reshape(eps, saveshape),
                        affine=f.affine, header=f.get_header())
nb.save(outnii5, outname + '_yres.nii.gz')

outnii6 = nb.Nifti1Image(np.reshape(xshift, saveshape),
                        affine=f.affine, header=f.get_header())
nb.save(outnii6, outname + '_xplus.nii.gz')

# plot fit statistic info
outnii7 = nb.Nifti1Image(np.reshape(stdp, saveshape[0:-1]),
                        affine=f.affine, header=f.get_header())
nb.save(outnii7, outname + '_stdp.nii.gz')

outnii8 = nb.Nifti1Image(np.reshape(stdm, saveshape[0:-1]),
                        affine=f.affine, header=f.get_header())
nb.save(outnii8, outname + '_stdm.nii.gz')

outnii9 = nb.Nifti1Image(np.reshape(r2, saveshape[0:-1]),
                        affine=f.affine, header=f.get_header())
nb.save(outnii9, outname + '_r2.nii.gz')

outnii10 = nb.Nifti1Image(np.reshape(estimate, saveshape),
                        affine=f.affine, header=f.get_header())
nb.save(outnii10, outname + '_estimate.nii.gz')
        



