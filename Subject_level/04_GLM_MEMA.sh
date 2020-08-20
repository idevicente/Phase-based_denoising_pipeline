#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

# ***************************************************************************************
# This script takes 4 arguments: Subject ID, PRJDIR path, TASK name, ORDER of onset times
# ***************************************************************************************

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

echo -e "\e[34m ######################################################################################\e[39m"
	
echo -e "\e[34m +++ =================================================================================\e[39m"
echo -e "\e[34m +++ ---------------> STARTING 3DDECONVOLVE IN MAGNITUDE WITHOUT PHASE REGRESSION <-----------------\e[39m"
echo -e "\e[34m +++ =================================================================================\e[39m"

Concat_files() {

# First create stim times for each run (i.e. magnitude type: RAW, ODR, LSQ)
# Note that ODR is considered as the 2nd run, and LSQ as the 3rd run. 
# Thus, ODR stimulus times must start at time point 440 (440*0.85s = 374s) and finish at 880 (880*0.85s=748s). Likewise, LSQ must start at 880 (748s) 

cd ${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times

1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt -expr 'a' > onset_${SUBJ}_task-${TASK}_${ORDER}_Pres_Raw.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt -expr 'a+374' > onset_${SUBJ}_task-${TASK}_${ORDER}_Pres_ODR.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Pres.1D.txt -expr 'a+748' > onset_${SUBJ}_task-${TASK}_${ORDER}_Pres_LSQ.1D.txt

1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt -expr 'a' > onset_${SUBJ}_task-${TASK}_${ORDER}_Hash_Raw.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt -expr 'a+374' > onset_${SUBJ}_task-${TASK}_${ORDER}_Hash_ODR.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Hash.1D.txt -expr 'a+748' > onset_${SUBJ}_task-${TASK}_${ORDER}_Hash_LSQ.1D.txt

1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt -expr 'a' > onset_${SUBJ}_task-${TASK}_${ORDER}_Star_Raw.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt -expr 'a+374' > onset_${SUBJ}_task-${TASK}_${ORDER}_Star_ODR.1D.txt
1deval -overwrite -a onset_${SUBJ}_task-${TASK}_${ORDER}_Star.1D.txt -expr 'a+748' > onset_${SUBJ}_task-${TASK}_${ORDER}_Star_LSQ.1D.txt

1dMarry -divorce onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble.1D.txt > rm.Scramble_divorce1.1D rm.Scramble_divorce2.1D
1deval -overwrite -a rm.Scramble_divorce2.1D_A.1D -expr 'a' > rm.Scramble_divorce_A_Raw.1D.txt
1deval -overwrite -a rm.Scramble_divorce2.1D_A.1D -expr 'a+374' > rm.Scramble_divorce_A_ODR.1D.txt
1deval -overwrite -a rm.Scramble_divorce2.1D_A.1D -expr 'a+748' > rm.Scramble_divorce_A_LSQ.1D.txt
1dMarry -sep ':' rm.Scramble_divorce_A_Raw.1D.txt rm.Scramble_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble_Raw.1D.txt
1dMarry -sep ':' rm.Scramble_divorce_A_ODR.1D.txt rm.Scramble_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble_ODR.1D.txt
1dMarry -sep ':' rm.Scramble_divorce_A_LSQ.1D.txt rm.Scramble_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble_LSQ.1D.txt
rm rm*
rm onset_${SUBJ}_task-${TASK}_${ORDER}_Scramble.1D.txt_*

1dMarry -divorce onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence.1D.txt > rm.Sentence_divorce1.1D rm.Sentence_divorce2.1D
1deval -overwrite -a rm.Sentence_divorce2.1D_A.1D -expr 'a' > rm.Sentence_divorce_A_Raw.1D.txt
1deval -overwrite -a rm.Sentence_divorce2.1D_A.1D -expr 'a+374' > rm.Sentence_divorce_A_ODR.1D.txt
1deval -overwrite -a rm.Sentence_divorce2.1D_A.1D -expr 'a+748' > rm.Sentence_divorce_A_LSQ.1D.txt
1dMarry -sep ':' rm.Sentence_divorce_A_Raw.1D.txt rm.Sentence_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence_Raw.1D.txt
1dMarry -sep ':' rm.Sentence_divorce_A_ODR.1D.txt rm.Sentence_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence_ODR.1D.txt
1dMarry -sep ':' rm.Sentence_divorce_A_LSQ.1D.txt rm.Sentence_divorce2.1D_B.1D > onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence_LSQ.1D.txt
rm rm*
rm onset_${SUBJ}_task-${TASK}_${ORDER}_Sentence.1D.txt_*

cd ${PRJDIR}/PREPROC/${SUBJ}/func

# CONCATENATE CENSOR; DEMEAN MOTION; DERIV MOTION FILES

cat ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D > ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2_concatenated.1D
cat ${SUBJ}_Motion_demean.1D ${SUBJ}_Motion_demean.1D ${SUBJ}_Motion_demean.1D > ${SUBJ}_Motion_demean_concatenated.1D
cat ${SUBJ}_Motion_deriv.1D ${SUBJ}_Motion_deriv.1D ${SUBJ}_Motion_deriv.1D > ${SUBJ}_Motion_deriv_concatenated.1D

}

Concat_files

GLM_MEMA() {

TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)

STIM_TIMES=${PRJDIR}/BIDS_selected_subjects/${SUBJ}/onset_times/onset_${SUBJ}_task-petit_${ORDER}

3dDeconvolve -overwrite -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz ${SUBJ}.odr_substracted_scaled_mean.nii.gz ${SUBJ}.Lsqrs.magnitude_phdenoised_scaled_mean.nii.gz						\
	-concat '1D: 0 440 880'									\
	-global_times										\
	-polort ${POLORTORDER} -num_stimts 27	                                              							\
	-censor ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2_concatenated.1D      				\
	-stim_times_AM1 1 ${STIM_TIMES}_Sentence_Raw.1D.txt 'dmBLOCK' -stim_label 1 Sentence_Raw 	\
	-stim_times_AM1 2 ${STIM_TIMES}_Scramble_Raw.1D.txt 'dmBLOCK' -stim_label 2 Scramble_Raw 	\
	-stim_times 3 ${STIM_TIMES}_Pres_Raw.1D.txt 'SPMG1' -stim_label 3 Pres_Raw 			\
	-stim_times 4 ${STIM_TIMES}_Hash_Raw.1D.txt 'SPMG1' -stim_label 4 Hash_Raw 			\
	-stim_times 5 ${STIM_TIMES}_Star_Raw.1D.txt 'SPMG1' -stim_label 5 Star_Raw 			\
	-stim_times_AM1 6 ${STIM_TIMES}_Sentence_ODR.1D.txt 'dmBLOCK' -stim_label 6 Sentence_ODR 	\
	-stim_times_AM1 7 ${STIM_TIMES}_Scramble_ODR.1D.txt 'dmBLOCK' -stim_label 7 Scramble_ODR 	\
	-stim_times 8 ${STIM_TIMES}_Pres_ODR.1D.txt 'SPMG1' -stim_label 8 Pres_ODR 			\
	-stim_times 9 ${STIM_TIMES}_Hash_ODR.1D.txt 'SPMG1' -stim_label 9 Hash_ODR 			\
	-stim_times 10 ${STIM_TIMES}_Star_ODR.1D.txt 'SPMG1' -stim_label 10 Star_ODR			\
	-stim_times_AM1 11 ${STIM_TIMES}_Sentence_LSQ.1D.txt 'dmBLOCK' -stim_label 11 Sentence_LSQ 	\
	-stim_times_AM1 12 ${STIM_TIMES}_Scramble_LSQ.1D.txt 'dmBLOCK' -stim_label 12 Scramble_LSQ 	\
	-stim_times 13 ${STIM_TIMES}_Pres_LSQ.1D.txt 'SPMG1' -stim_label 13 Pres_LSQ 			\
	-stim_times 14 ${STIM_TIMES}_Hash_LSQ.1D.txt 'SPMG1' -stim_label 14 Hash_LSQ 			\
	-stim_times 15 ${STIM_TIMES}_Star_LSQ.1D.txt 'SPMG1' -stim_label 15 Star_LSQ			\
	-stim_file 16 ${SUBJ}_Motion_demean_concatenated.1D'[0]' -stim_base 16 -stim_label 16 roll_01     							\
	-stim_file 17 ${SUBJ}_Motion_demean_concatenated.1D'[1]' -stim_base 17 -stim_label 17 pitch_01 								\
	-stim_file 18 ${SUBJ}_Motion_demean_concatenated.1D'[2]' -stim_base 18 -stim_label 18 yaw_01   								\
	-stim_file 19 ${SUBJ}_Motion_demean_concatenated.1D'[3]' -stim_base 19 -stim_label 19 dS_01    								\
	-stim_file 20 ${SUBJ}_Motion_demean_concatenated.1D'[4]' -stim_base 20 -stim_label 20 dL_01    							\
	-stim_file 21 ${SUBJ}_Motion_demean_concatenated.1D'[5]' -stim_base 21 -stim_label 21 dP_01    							\
	-stim_file 22 ${SUBJ}_Motion_deriv_concatenated.1D'[0]' -stim_base 22 -stim_label 22 roll_02   							\
	-stim_file 23 ${SUBJ}_Motion_deriv_concatenated.1D'[1]' -stim_base 23 -stim_label 23 pitch_02  							\
	-stim_file 24 ${SUBJ}_Motion_deriv_concatenated.1D'[2]' -stim_base 24 -stim_label 24 yaw_02    							\
	-stim_file 25 ${SUBJ}_Motion_deriv_concatenated.1D'[3]' -stim_base 25 -stim_label 25 dS_02     							\
	-stim_file 26 ${SUBJ}_Motion_deriv_concatenated.1D'[4]' -stim_base 26 -stim_label 26 dL_02     							\
	-stim_file 27 ${SUBJ}_Motion_deriv_concatenated.1D'[5]' -stim_base 27 -stim_label 27 dP_02     							\
	-gltsym 'SYM: +Sentence_Raw -Scramble_Raw' -glt_label 1 Sent_Raw_vs_Scrm_Raw		\
	-gltsym 'SYM: +Sentence_ODR -Scramble_ODR' -glt_label 2 Sent_ODR_vs_Scrm_ODR		\
	-gltsym 'SYM: +Sentence_LSQ -Scramble_LSQ' -glt_label 3 Sent_LSQ_vs_Scrm_LSQ		\
	-gltsym 'SYM: +Sentence_Raw -Scramble_Raw -Sentence_ODR +Scramble_ODR' -glt_label 4 Sent_vs_Scrm_VS_Raw_vs_ODR		\
	-gltsym 'SYM: +Sentence_Raw -Scramble_Raw -Sentence_LSQ +Scramble_LSQ' -glt_label 5 Sent_vs_Scrm_VS_Raw_vs_LSQ		\
	-gltsym 'SYM: +Sentence_LSQ -Scramble_LSQ -Sentence_ODR +Scramble_ODR' -glt_label 6 Sent_vs_Scrm_VS_LSQ_vs_ODR		\
	-fout -tout																\
	-x1D ${SUBJ}.GLM_4MEMA.X.xmat.1D -xjpeg ${SUBJ}.GLM_4MEMA.X.jpg -x1D_uncensored ${SUBJ}.GLM_4MEMA.X.nocensor.xmat.1D				\
	-fitts ${SUBJ}.GLM_4MEMA.fitts.nii.gz -errts ${SUBJ}.GLM_4MEMA.errts.nii.gz -bucket ${SUBJ}.GLM_4MEMA.stats_scaled_mean.nii.gz

3dREMLfit -overwrite -matrix ${SUBJ}.GLM_4MEMA.X.xmat.1D \
	-input "${SUBJ}.magnitude.pb03_volreg_detrended_masked_scaled_mean.nii.gz ${SUBJ}.odr_substracted_scaled_mean.nii.gz ${SUBJ}.Lsqrs.magnitude_phdenoised_scaled_mean.nii.gz" \
	-fout -tout -Rbuck ${SUBJ}.GLM_4MEMA_REML.stats_scaled_mean.nii.gz -Rvar ${SUBJ}.GLM_4MEMA_REMLvar.stats_scaled_mean.nii.gz \
	-Rerrts ${SUBJ}.GLM_4MEMA_REML.errts.nii.gz -Rfitts ${SUBJ}.GLM_4MEMA_REML.fitts.nii.gz -verb

}

echo -e "\e[34m ######################################################################################################## \e[39m"

echo -e "\e[34m +++ ==================================================================================================\e[39m"
echo -e "\e[34m +++ ----------> END OF SCRIPT: FUNCTIONAL PREPROCESSING OF SUBJ-${SUBJ} RUN-${RUN} FINISHED <---------\e[39m"
echo -e "\e[34m +++ ==================================================================================================\e[39m"

