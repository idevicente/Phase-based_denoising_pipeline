#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu
#$ -q long.q

# ******************************************************
# This script takes 2 arguments: Subject ID, PRJDIR path
# ******************************************************

if [[ -z "${SUBJ}" ]]; then
  if [[ ! -z "$1" ]]; then
     SUBJ=$1
  else
     echo -e "\e[31m++ ERROR: You need to input SUBJECT (SUBJ) as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$2" ]]; then
     PRJDIR=$2
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $2. Exiting!! ...\e[39m"
     exit
  fi
fi

set -e

cd ${PRJDIR}/PREPROC/${SUBJ}/func


TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb00_tcat.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.magnitude.pb00_tcat.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)


################ ORTHOGONAL DISTANCE REGRESSION (ODR) #####################

# We first need to find the respiration peak which will serve as the high pass filter in the ODR

# Compute the power spectrum map of the phase

3dPeriodogram -prefix phase.powerspectrum.nii.gz ${SUBJ}.phase.pb09_detrended_masked.nii.gz -overwrite

# This command finds the time point index of the maximum frequency peak starting from the 93th time point. 
# We chose the 93th time point because it corresponds to a frequency of 0.25 Hz.
# Note that the output will not take this into account, and thus we must add a value of 93 in later steps to obtain the real time point index

3dTstat -argmax -prefix maxfreqmap.nii.gz phase.powerspectrum.nii.gz"[93..$]" -overwrite

# We now compute the value that happens the most in the previous map. This is, we obtain (hopefully) the time point index of the respiration peak.
3dROIstats -mask ${SUBJ}_mask_base.nii.gz -nzmode -quiet -overwrite maxfreqmap.nii.gz > maxfreqmode.1D

# We multiply this index by 1.1 to consider the subpeaks around the maximum peak.
# We convert it to frequencies (Hz) by multiplying it with the frequency value of the first time point. 

Freq_peak_index=$(1deval -overwrite -a maxfreqmode.1D[1] -expr '1.1*(a+93)*0.002674')

echo ${Freq_peak_index}


odr(){

	echo -e "\e[34m ######################################################################################################## \e[39m"
	
	echo -e "\e[34m +++ =================================================================================\e[39m"
	echo -e "\e[34m +++ ---------------> STARTING ORTHOGONAL DISTANCE REGRESSION (ODR) <-----------------\e[39m"
	echo -e "\e[34m +++ =================================================================================\e[39m"
	

	cd ${PRJDIR}/scripts

	python ODR_fit.py --phase ${SUBJ}.phase.pb09_detrended_masked.nii.gz \
			--magnitude ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz \
			--mask ${SUBJ}_mask_base.nii.gz \
			--TR 0.85 \
			--noise_filter ${Freq_peak_index} \
			--outdir ${PRJDIR}/PREPROC/${SUBJ}/func/ \
			--subj ${SUBJ}

	cd ${PRJDIR}/PREPROC/${SUBJ}/func

	# Substract estimated time-series (macrovascular) from the magnitude time-series. 
	# This leaves a denoised time-series (microvascular)
	3dcalc -a ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz \
		-b ${SUBJ}.odr_estimate.nii.gz \
		-m ${SUBJ}_mask_base.nii.gz \
		-expr 'm*(a-b)' \
		-prefix ${SUBJ}.odr_substracted.nii.gz \
		-overwrite

	# Fix python-to-afni header issue
	3dcopy ${SUBJ}.odr_substracted.nii.gz ${SUBJ}.odr_substracted.nii.gz -overwrite

	echo -e "\e[34m +++ ===========================================================\e[39m"
	echo -e "\e[34m +++ -------> END OF ORTHOGONAL DISTANCE REGRESSION (ODR) ------\e[39m"
	echo -e "\e[34m +++ ===========================================================\e[39m"

}

#odr

#_______________________________________________________________________________________________________________#


################ LEAST SQUARES REGRESSION WITH 3DTPROJECT #####################


Lsqrs() {

	echo -e "\e[34m ######################################################################################################## \e[39m"

	echo -e "\e[34m +++ =====================================================================================\e[39m"
	echo -e "\e[34m +++ ---------------> STARTING LEAST SQUARES REGRESSION WITH 3DTPROJECT: <-----------------\e[39m"
	echo -e "\e[34m +++ =====================================================================================\e[39m"
	# Denoising the magnitude signal with the phase information through 3dTproject
	# polort 0 if mean is included in magnitude!!! 
	3dTproject -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -dsort ${SUBJ}.phase.pb09_detrended_masked.nii.gz \
	-polort -1 -mask ${SUBJ}_mask_base.nii.gz -prefix ${SUBJ}.Lsqrs.magnitude_phdenoised.nii.gz -overwrite 
	
	
	
	# Computing the Sums Of Squares of both denoised and preprocessed magnitude datasets
	3dTstat -sos -prefix rm.${SUBJ}.Lsqrs.magnitude_phdenoised_sos.nii.gz ${SUBJ}.Lsqrs.magnitude_phdenoised.nii.gz -overwrite
	
	# Use only if mean is included in magnitude
	#3dTproject -polort 0 \   # polort 0 if mean is included in magnitude!!! 
	#-mask ${SUBJ}_mask_base.nii.gz -prefix rm.${SUBJ}.Lsqrs.magnitude_demean.nii.gz \
	#-input ${SUBJ}.magnitude.pb04_volreg_detrended_mean_masked.nii.gz -overwrite
	
	
	3dTstat -sos -prefix rm.${SUBJ}.Lsqrs.magnitude.detrended_masked_sos.nii.gz \
		${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -overwrite
	
	# Calculating R² 
	3dcalc -a rm.${SUBJ}.Lsqrs.magnitude_phdenoised_sos.nii.gz -b rm.${SUBJ}.Lsqrs.magnitude.detrended_masked_sos.nii.gz \
		-m ${SUBJ}_mask_base.nii.gz -expr 'm*(1-(a/b))' -prefix ${SUBJ}.Lsqrs.R2.nii.gz -overwrite

	rm rm.${SUBJ}.Lsqrs.magnitude.detrended_masked_sos.nii.gz
	rm rm.${SUBJ}.Lsqrs.magnitude_phdenoised_sos.nii.gz
	#rm rm.${SUBJ}.Lsqrs.magnitude_demean.nii.gz

	echo -e "\e[34m +++ ==================================================================================\e[39m"
	echo -e "\e[34m +++ ---------------> END OF LEAST SQUARES REGRESSION WITH 3DTPROJECT <-----------------\e[39m"
	echo -e "\e[34m +++ ==================================================================================\e[39m"

}

#Lsqrs


