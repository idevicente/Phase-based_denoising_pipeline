#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

# *****************************************************************************************************************************
# This script takes 6 arguments: Subject ID, PRJDIR path, TASK name, ORDER of onset times, CENSOR type, THRESHOLD for censoring
# *****************************************************************************************************************************

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
if [[ -z "${TASK}" ]]; then
  if [[ ! -z "$3" ]]; then
     TASK=$3
  else
     echo -e "\e[31m++ ERROR: You need to input TASK as ENVIRONMENT VARIABLE or $3. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${ORDER}" ]]; then
  if [[ ! -z "$4" ]]; then
     ORDER=$4
  else
     echo -e "\e[31m++ ERROR: You need to input ORDER as ENVIRONMENT VARIABLE or $4. Exiting!! ...\e[39m"
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

set -e

cd ${PRJDIR}/PREPROC/${SUBJ}/func

scaling() {

# Scale inputs before computing the GLM
echo -e "\e[32m ++ INFO: Scaling inputs before computing GLM's ...\e[39m"
echo -e "\e[32m ++ INFO: Scaling Raw Magnitude ...\e[39m"

# Compute mean from the dataset previous to the detrending step
3dTstat -mean -prefix ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz ${SUBJ}.magnitude.pb01_volreg.nii.gz -overwrite
# Include mean to the GLM input dataset
3dcalc -a ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -expr 'a+b' -prefix ${SUBJ}.magnitude.pb03_volreg_detrended_masked_mean.nii.gz -overwrite
# Normalize
3dcalc -a ${SUBJ}.magnitude.pb03_volreg_detrended_masked_mean.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -m ${SUBJ}_mask_base.nii.gz -expr 'm*(a/b)*100' -prefix ${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz -overwrite
echo -e "\e[32m ++ INFO: Scaling LSQRS-regressed Magnitude ...\e[39m"
3dcalc -a ${SUBJ}.Lsqrs.magnitude_phdenoised.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -expr 'a+b' -prefix ${SUBJ}.Lsqrs.magnitude_phdenoised_mean.nii.gz -overwrite
3dcalc -a ${SUBJ}.Lsqrs.magnitude_phdenoised_mean.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -m ${SUBJ}_mask_base.nii.gz -expr 'm*(a/b)*100' -prefix ${SUBJ}.Lsqrs.magnitude_phdenoised_scaled_mean.nii.gz -overwrite
echo -e "\e[32m ++ INFO: Scaling ODR-regressed Magnitude ...\e[39m"
3dcalc -a ${SUBJ}.odr_substracted.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -expr 'a+b' -prefix ${SUBJ}.odr_substracted_mean.nii.gz -overwrite
3dcalc -a ${SUBJ}.odr_substracted_mean.nii.gz -b ${SUBJ}.magnitude.pb01_volreg_mean.nii.gz -m ${SUBJ}_mask_base.nii.gz -expr 'm*(a/b)*100' -prefix ${SUBJ}.odr_substracted_scaled_mean.nii.gz -overwrite

}

scaling

GLM_RAW() {

echo -e "\e[34m ######################################################################################\e[39m"
	
echo -e "\e[34m +++ =================================================================================\e[39m"
echo -e "\e[34m +++ ---------------> STARTING 3DDECONVOLVE IN MAGNITUDE WITHOUT PHASE REGRESSION <-----------------\e[39m"
echo -e "\e[34m +++ =================================================================================\e[39m"

TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)


3dDeconvolve -overwrite -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz                        					\
	-polort ${POLORTORDER} -num_stimts 17	                                              							\
	-censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D               					\
	-stim_times_AM1 1 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence.1D.txt 'dmBLOCK' -stim_label 1 Sentence 	\
	-stim_times_AM1 2 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble.1D.txt 'dmBLOCK' -stim_label 2 Scramble 	\
	-stim_times 3 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt 'SPMG1' -stim_label 3 Pres 			\
	-stim_times 4 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt 'SPMG1' -stim_label 4 Hash 			\
	-stim_times 5 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt 'SPMG1' -stim_label 5 Star 			\
	-stim_file 6 ${SUBJ}_Motion_demean.1D'[0]' -stim_base 6 -stim_label 6 roll_01     							\
	-stim_file 7 ${SUBJ}_Motion_demean.1D'[1]' -stim_base 7 -stim_label 7 pitch_01 								\
	-stim_file 8 ${SUBJ}_Motion_demean.1D'[2]' -stim_base 8 -stim_label 8 yaw_01   								\
	-stim_file 9 ${SUBJ}_Motion_demean.1D'[3]' -stim_base 9 -stim_label 9 dS_01    								\
	-stim_file 10 ${SUBJ}_Motion_demean.1D'[4]' -stim_base 10 -stim_label 10 dL_01    							\
	-stim_file 11 ${SUBJ}_Motion_demean.1D'[5]' -stim_base 11 -stim_label 11 dP_01    							\
	-stim_file 12 ${SUBJ}_Motion_deriv.1D'[0]' -stim_base 12 -stim_label 12 roll_02   							\
	-stim_file 13 ${SUBJ}_Motion_deriv.1D'[1]' -stim_base 13 -stim_label 13 pitch_02  							\
	-stim_file 14 ${SUBJ}_Motion_deriv.1D'[2]' -stim_base 14 -stim_label 14 yaw_02    							\
	-stim_file 15 ${SUBJ}_Motion_deriv.1D'[3]' -stim_base 15 -stim_label 15 dS_02     							\
	-stim_file 16 ${SUBJ}_Motion_deriv.1D'[4]' -stim_base 16 -stim_label 16 dL_02     							\
	-stim_file 17 ${SUBJ}_Motion_deriv.1D'[5]' -stim_base 17 -stim_label 17 dP_02     							\
	-gltsym 'SYM: +Sentence -Scramble' -glt_label 1 Sent_vs_Scrm               								\
	-fout -tout -bout															\
	-x1D ${SUBJ}.GLM_mag.X.xmat.1D -xjpeg ${SUBJ}.GLM_mag.X.jpg -x1D_uncensored ${SUBJ}.GLM_mag.X.nocensor.xmat.1D				\
	-fitts ${SUBJ}.GLM_mag.fitts.nii.gz -errts ${SUBJ}.GLM_mag.errts.nii.gz -bucket ${SUBJ}.GLM_mag.stats_scaled_mean.nii.gz

3dREMLfit -overwrite -matrix ${SUBJ}.GLM_mag.X.xmat.1D -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz \
    -fout -tout -Rbuck ${SUBJ}.GLM_mag_REML.stats_scaled_mean.nii.gz -Rvar ${SUBJ}.GLM_mag_REMLvar.stats_scaled_mean.nii.gz \
    -Rerrts ${SUBJ}.GLM_mag_REML.errts.nii.gz -Rfitts ${SUBJ}.GLM_mag_REML.fitts.nii.gz -verb
}

GLM_RAW

GLM_OLS() {

echo -e "\e[34m ######################################################################################\e[39m"
	
echo -e "\e[34m +++ =============================================================================================\e[39m"
echo -e "\e[34m +++ ---------------> STARTING 3DDECONVOLVE IN MAGNITUDE REGRESSED THROUGH LSQR <-----------------\e[39m"
echo -e "\e[34m +++ =============================================================================================\e[39m"

TR_COUNTS=$(3dinfo -nt ${SUBJ}.Lsqrs.magnitude_phdenoised.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.Lsqrs.magnitude_phdenoised.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)

3dDeconvolve -overwrite -input ${SUBJ}.Lsqrs.magnitude_phdenoised_scaled_mean.nii.gz                        						\
	-polort ${POLORTORDER} -num_stimts 17	                                              							\
	-censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D               					\
	-stim_times_AM1 1 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence.1D.txt 'dmBLOCK' -stim_label 1 Sentence 	\
	-stim_times_AM1 2 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble.1D.txt 'dmBLOCK' -stim_label 2 Scramble 	\
	-stim_times 3 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt 'SPMG1' -stim_label 3 Pres 			\
	-stim_times 4 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt 'SPMG1' -stim_label 4 Hash 			\
	-stim_times 5 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt 'SPMG1' -stim_label 5 Star 			\
	-stim_file 6 ${SUBJ}_Motion_demean.1D'[0]' -stim_base 6 -stim_label 6 roll_01     							\
	-stim_file 7 ${SUBJ}_Motion_demean.1D'[1]' -stim_base 7 -stim_label 7 pitch_01 								\
	-stim_file 8 ${SUBJ}_Motion_demean.1D'[2]' -stim_base 8 -stim_label 8 yaw_01   								\
	-stim_file 9 ${SUBJ}_Motion_demean.1D'[3]' -stim_base 9 -stim_label 9 dS_01    								\
	-stim_file 10 ${SUBJ}_Motion_demean.1D'[4]' -stim_base 10 -stim_label 10 dL_01    							\
	-stim_file 11 ${SUBJ}_Motion_demean.1D'[5]' -stim_base 11 -stim_label 11 dP_01    							\
	-stim_file 12 ${SUBJ}_Motion_deriv.1D'[0]' -stim_base 12 -stim_label 12 roll_02   							\
	-stim_file 13 ${SUBJ}_Motion_deriv.1D'[1]' -stim_base 13 -stim_label 13 pitch_02  							\
	-stim_file 14 ${SUBJ}_Motion_deriv.1D'[2]' -stim_base 14 -stim_label 14 yaw_02    							\
	-stim_file 15 ${SUBJ}_Motion_deriv.1D'[3]' -stim_base 15 -stim_label 15 dS_02     							\
	-stim_file 16 ${SUBJ}_Motion_deriv.1D'[4]' -stim_base 16 -stim_label 16 dL_02     							\
	-stim_file 17 ${SUBJ}_Motion_deriv.1D'[5]' -stim_base 17 -stim_label 17 dP_02     							\
	-gltsym 'SYM: +Sentence -Scramble' -glt_label 1 Sent_vs_Scrm               								\
	-fout -tout -bout															\
	-x1D ${SUBJ}.GLM_lsqrs.X.xmat.1D -xjpeg ${SUBJ}.GLM_lsqrs.X.jpg -x1D_uncensored ${SUBJ}.GLM_lsqrs.X.nocensor.xmat.1D			\
	-fitts ${SUBJ}.GLM_lsqrs.fitts.nii.gz -errts ${SUBJ}.GLM_lsqrs.errts.nii.gz -bucket ${SUBJ}.GLM_lsqrs.stats_scaled_mean.nii.gz

3dREMLfit -overwrite -matrix ${SUBJ}.GLM_lsqrs.X.xmat.1D -input ${SUBJ}.Lsqrs.magnitude_phdenoised_scaled_mean.nii.gz \
    -fout -tout -Rbuck ${SUBJ}.GLM_lsqrs_REML.stats_scaled_mean.nii.gz -Rvar ${SUBJ}.GLM_lsqrs_REMLvar.stats_scaled_mean.nii.gz \
    -Rerrts ${SUBJ}.GLM_lsqrs_REML.errts.nii.gz -Rfitts ${SUBJ}.GLM_lsqrs_REML.fitts.nii.gz -verb

}

GLM_OLS

GLM_ODR() {

echo -e "\e[34m ######################################################################################\e[39m"
	
echo -e "\e[34m +++ =================================================================================\e[39m"
echo -e "\e[34m +++ ---------------> STARTING 3DDECONVOLVE IN MAGNITUDE REGRESSED THROUGH ODR <-----------------\e[39m"
echo -e "\e[34m +++ =================================================================================\e[39m"

TR_COUNTS=$(3dinfo -nt ${SUBJ}.odr_substracted.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.odr_substracted.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)

3dDeconvolve -overwrite -input ${SUBJ}.odr_substracted_scaled_mean.nii.gz                        								\
	-polort ${POLORTORDER} -num_stimts 17	                                              							\
	-censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D               					\
	-stim_times_AM1 1 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence.1D.txt 'dmBLOCK' -stim_label 1 Sentence 	\
	-stim_times_AM1 2 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble.1D.txt 'dmBLOCK' -stim_label 2 Scramble 	\
	-stim_times 3 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt 'SPMG1' -stim_label 3 Pres 			\
	-stim_times 4 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt 'SPMG1' -stim_label 4 Hash 			\
	-stim_times 5 ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt 'SPMG1' -stim_label 5 Star 			\
	-stim_file 6 ${SUBJ}_Motion_demean.1D'[0]' -stim_base 6 -stim_label 6 roll_01     							\
	-stim_file 7 ${SUBJ}_Motion_demean.1D'[1]' -stim_base 7 -stim_label 7 pitch_01 								\
	-stim_file 8 ${SUBJ}_Motion_demean.1D'[2]' -stim_base 8 -stim_label 8 yaw_01   								\
	-stim_file 9 ${SUBJ}_Motion_demean.1D'[3]' -stim_base 9 -stim_label 9 dS_01    								\
	-stim_file 10 ${SUBJ}_Motion_demean.1D'[4]' -stim_base 10 -stim_label 10 dL_01    							\
	-stim_file 11 ${SUBJ}_Motion_demean.1D'[5]' -stim_base 11 -stim_label 11 dP_01    							\
	-stim_file 12 ${SUBJ}_Motion_deriv.1D'[0]' -stim_base 12 -stim_label 12 roll_02   							\
	-stim_file 13 ${SUBJ}_Motion_deriv.1D'[1]' -stim_base 13 -stim_label 13 pitch_02  							\
	-stim_file 14 ${SUBJ}_Motion_deriv.1D'[2]' -stim_base 14 -stim_label 14 yaw_02    							\
	-stim_file 15 ${SUBJ}_Motion_deriv.1D'[3]' -stim_base 15 -stim_label 15 dS_02     							\
	-stim_file 16 ${SUBJ}_Motion_deriv.1D'[4]' -stim_base 16 -stim_label 16 dL_02     							\
	-stim_file 17 ${SUBJ}_Motion_deriv.1D'[5]' -stim_base 17 -stim_label 17 dP_02     							\
	-gltsym 'SYM: +Sentence -Scramble' -glt_label 1 Sent_vs_Scrm               								\
	-fout -tout -bout															\
	-x1D ${SUBJ}.GLM_odr.X.xmat.1D -xjpeg ${SUBJ}.GLM_odr.X.jpg -x1D_uncensored ${SUBJ}.GLM_odr.X.nocensor.xmat.1D				\
	-fitts ${SUBJ}.GLM_odr.fitts.nii.gz -errts ${SUBJ}.GLM_odr.errts.nii.gz -bucket ${SUBJ}.GLM_odr.stats_scaled_mean.nii.gz

3dREMLfit -overwrite -matrix ${SUBJ}.GLM_odr.X.xmat.1D -input ${SUBJ}.odr_substracted_scaled_mean.nii.gz \
    -fout -tout -Rbuck ${SUBJ}.GLM_odr_REML.stats_scaled_mean.nii.gz -Rvar ${SUBJ}.GLM_odr_REMLvar.stats_scaled_mean.nii.gz \
    -Rerrts ${SUBJ}.GLM_odr_REML.errts.nii.gz -Rfitts ${SUBJ}.GLM_odr_REML.fitts.nii.gz -verb

}

GLM_ODR

echo -e "\e[34m ######################################################################################################## \e[39m"

echo -e "\e[34m +++ ==================================================================================================\e[39m"
echo -e "\e[34m +++ ----------> END OF SCRIPT: FUNCTIONAL PREPROCESSING OF SUBJ-${SUBJ} RUN-${RUN} FINISHED <---------\e[39m"
echo -e "\e[34m +++ ==================================================================================================\e[39m"

