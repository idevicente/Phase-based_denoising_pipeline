#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu
#$ -q long.q

# ***********************************************************************************************
# This script takes 5 arguments: Subject ID, RUN, PRJDIR path, TASK name, REFERENCE for alignment
# ***********************************************************************************************

if [[ -z "${SUBJ}" ]]; then
  if [[ ! -z "$1" ]]; then
     SUBJ=$1
  else
     echo -e "\e[31m++ ERROR: You need to input SUBJECT (SUBJ) as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${RUN}" ]]; then
  if [[ ! -z "$2" ]]; then
     RUN=$2
  else
     echo -e "\e[31m++ ERROR: You need to input RUN as ENVIRONMENT VARIABLE or $2. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$3" ]]; then
     PRJDIR=$3
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $3. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ -z "${TASK}" ]]; then
  if [[ ! -z "$4" ]]; then
     TASK=$4
  else
     echo -e "\e[31m++ ERROR: You need to input TASK as ENVIRONMENT VARIABLE or $4. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${CENSOR_TYPE_2USE}" ]]; then
  if [[ ! -z "$5" ]]; then
     CENSOR_TYPE_2USE=$5
  else
     echo -e "\e[31m++ ERROR: You need to input CENSOR_TYPE_2USE as ENVIRONMENT VARIABLE or $5. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${CENSOR_MOTION_TH_2USE}" ]]; then
  if [[ ! -z "$6" ]]; then
     CENSOR_MOTION_TH_2USE=$6
  else
     echo -e "\e[31m++ ERROR: You need to input CENSOR_MOTION_TH_2USE as ENVIRONMENT VARIABLE or $6. Exiting!! ...\e[39m"
     exit
  fi
fi



echo -e "\e[34m +++ ============================================================================================\e[39m"
echo -e "\e[34m +++ ----------> STARTING SCRIPT: COMPUTING HIGHCOR AND TCOMPCOR OF SUBJ-${SUBJ} RUN-${RUN}  <---------\e[39m"
echo -e "\e[34m +++ ============================================================================================\e[39m"

mag_opt_poly() {

	# COMPUTE OPTIMAL ORDER OF LEGENDRE POLYNOMIALS
	# -------------------------------------------------------
	echo -e "\e[32m ++ INFO: Compute optimal order of Legendre polynomials ...\e[39m"
	TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
	TR=$(3dinfo -TR ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
	POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
	POLORTORDER=$(echo "1+${POLORTORDER}" | bc)
}

mag_tSTD() {

	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[34m +++ ------------>    CALCULATE tSTD    <-------------------------\e[39m"
	echo -e "\e[34m +++ =============================================================\e[39m"

	3dTstat -overwrite -stdevNOD -prefix ${SUBJ}_tSTD.nii.gz ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz

}

mask_pearson_Xmat() {

# Correlate magnitude time-series with experimental paradigm tasks' and create a volume containing the absolute maximum value.
3dTcorr1D -prefix ${SUBJ}.pearson_mag_Xmat.nii.gz ${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz ${SUBJ}.GLM_mag.X.nocensor.xmat.1D'[4:8]' -overwrite
3dTstat -prefix rm.absmax.nii.gz -absmax ${SUBJ}.pearson_mag_Xmat.nii.gz -overwrite

# Create a mask such that those voxels with a correlation > 0.2 are equal to 0, and those with a correlation < 0.2 are equal to 1.
3dcalc -a rm.absmax.nii.gz -m ${SUBJ}_mask_base.nii.gz -expr 'm*(iszero(astep(a,0.2)))' -prefix ${SUBJ}.mask.pearson_mag_Xmat.nii.gz -overwrite

# Apply the mask to the ODR R² and the tSTD maps
3dcalc -a ${SUBJ}.odr_r2.nii.gz -b ${SUBJ}.mask.pearson_mag_Xmat.nii.gz -expr 'a*b' -prefix ${SUBJ}.odr_r2.HighCor_mask.nii.gz -overwrite
3dcalc -a ${SUBJ}_tSTD.nii.gz -b ${SUBJ}.mask.pearson_mag_Xmat.nii.gz -expr 'a*b' -prefix ${SUBJ}_tSTD.tCompCor_mask.nii.gz -overwrite

}

mag_PC_regressors_HighCor() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ----------------> COMPUTING HIGHCOR REGRESSORS <----------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[32m ++ INFO: In original subject space ...\e[39m"
	echo -e "\e[32m ++ INFO: Finding the number of voxels corresponding to a 2% of all the voxels within magnitude mask  ...\e[39m"
	
	3dBrickStat -count -non-zero ${SUBJ}_mask_base.nii.gz > ${SUBJ}.num_masked_voxels.1D
	Thresh_voxels=$(1deval -overwrite -a ${SUBJ}.num_masked_voxels.1D -expr 'a*0.02')

	echo "\e[32m ++ INFO:  ${Thresh_voxels} correspond to the 2% of all voxels within the mask. ...\e[39m" 
	echo "\e[32m ++ INFO:  Masking ${Thresh_voxels} voxels with the highest phase-magnitude correlation (i.e. R2) values ...\e[39m"	
	3dROIMaker -only_some_top ${Thresh_voxels} -volthr 1 -nifti -prefix HighCor_mask -inset ${SUBJ}.odr_r2.HighCor_mask.nii.gz -overwrite
	3dcalc -a HighCor_mask_GM.nii.gz -expr 'bool(a)' -prefix HighCor_mask.nii.gz -overwrite		# Converts ROI to a binary mask

	echo -e "\e[32m ++ INFO: Projecting out other nuisance regressors (motion, trends) and censoring before computing PCs ...\e[39m"
	3dTproject -overwrite -polort ${POLORTORDER} -ort ${SUBJ}_Motion_demean.1D -ort ${SUBJ}_Motion_deriv.1D \
	    -censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D \
	    -cenmode KILL -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -prefix rm.det_pcin.nii.gz
	echo -e "\e[32m ++ INFO: Computing PCs for highly correlated magnitude-phase voxels ...\e[39m"
	3dpc -overwrite -mask HighCor_mask.nii.gz -pcsave 10 \
	    -prefix rm.HighCor rm.det_pcin.nii.gz
	# zero pad censored TRs
	1d_tool.py -overwrite -censor_fill_parent ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D \
	    -infile rm.HighCor_vec.1D -write ROIPC.HighCor.1D

	rm rm.*
	rm HighCor_mask_GMI*
	rm HighCor_mask_GM.nim*
	rm HighCor_mask_GM.nii.gz
}

mag_PC_regressors_tCompCor() {

	echo -e "\e[34m +++ ====================================================================================\e[39m"
	echo -e "\e[34m +++ ----------------> COMPUTING temporal CompCor (tCompCor) REGRESSORS <----------------\e[39m"
	echo -e "\e[34m +++ ====================================================================================\e[39m"
	echo -e "\e[32m ++ INFO: In original subject space ...\e[39m"
	echo -e "\e[32m ++ INFO: Finding the number of voxels corresponding to a 2% of all the voxels within mask  ...\e[39m"
	3dBrickStat -count -non-zero ${SUBJ}_mask_base.nii.gz > ${SUBJ}.num_masked_voxels.1D
	Thresh_voxels=$(1deval -overwrite -a ${SUBJ}.num_masked_voxels.1D -expr 'a*0.02')

	echo "\e[32m ++ INFO:  ${Thresh_voxels} correspond to the 2% of all voxels within the brain. ...\e[39m" 
	echo "\e[32m ++ INFO:  Masking ${Thresh_voxels} voxels with the highest temporal standard deviation in magnitude data ...\e[39m"		
	3dROIMaker -only_some_top ${Thresh_voxels} -volthr 1 -nifti -prefix tCompCor_mask -inset ${SUBJ}_tSTD.tCompCor_mask.nii.gz -overwrite
	3dcalc -a tCompCor_mask_GM.nii.gz -expr 'bool(a)' -prefix tCompCor_mask.nii.gz -overwrite	# Converts ROI to a binary mask

	echo -e "\e[32m ++ INFO: Projecting out other nuisance regressors (motion, trends) and censoring before computing PCs ...\e[39m"
	3dTproject -overwrite -polort ${POLORTORDER} -ort ${SUBJ}_Motion_demean.1D -ort ${SUBJ}_Motion_deriv.1D \
	    -censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D \
	    -cenmode KILL -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -prefix rm.det_pcin.nii.gz
	echo -e "\e[32m ++ INFO: Computing PCs for voxels with high temporal STD ...\e[39m"
	3dpc -overwrite -mask tCompCor_mask.nii.gz -pcsave 10 \
	    -prefix rm.tCompCor rm.det_pcin.nii.gz
	# zero pad censored TRs
	1d_tool.py -overwrite -censor_fill_parent ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D \
	    -infile rm.tCompCor_vec.1D -write ROIPC.tCompCor.1D

	rm rm.*
	rm tCompCor_mask_GMI*
	rm tCompCor_mask_GM.nim*
	rm tCompCor_mask_GM.nii.gz
}

mag_opt_poly
mag_tSTD
mask_pearson_Xmat
mag_PC_regressors_HighCor
mag_PC_regressors_tCompCor
