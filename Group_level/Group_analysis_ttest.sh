#!/bin/bash
#$ -cwd
#$ -m be
#$ -N Group analysis
#$ -S /bin/bash

PRJDIR=~/public/HBP_phase

if [[ ! -d ${PRJDIR}/PREPROC/00_Group_analysis ]]; then
    echo "\e[35m ++ Creating ${PRJDIR}/PREPROC/00_Group_analysis ...\e[39m"
    mkdir -p ${PRJDIR}/PREPROC/00_Group_analysis
else
    echo -e "\e[35m ++ WARNING: ${PRJDIR}/PREPROC/00_Group_analysis already exist. Will overwrite results!! ...\e[39m"
fi

cd ${PRJDIR}/PREPROC/00_Group_analysis

ttest_RAW() {

GLM_TYPE1=GLM_mag_REML
GLM_TYPE2=GLM_mag_REML

CONT_TYPE1=Sentence
CONT_TYPE2=Scramble

3dttest++ -prefix RAW.paired_ttest.Sent-List.nii.gz														\
	  -AminusB																		\
	  -setA ${CONT_TYPE1}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
	  -setB ${CONT_TYPE2}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
	   -paired																		\
	   -overwrite

}

ttest_OLS() {

GLM_TYPE1=GLM_lsqrs_REML
GLM_TYPE2=GLM_lsqrs_REML

CONT_TYPE1=Sentence
CONT_TYPE2=Scramble

3dttest++ -prefix LSQ.paired_ttest.Sent-List.nii.gz														\
	  -AminusB																		\
	  -setA ${CONT_TYPE1}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
	  -setB ${CONT_TYPE2}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
	   -paired																		\
	   -overwrite

}

ttest_ODR() {

GLM_TYPE1=GLM_odr_REML
GLM_TYPE2=GLM_odr_REML

CONT_TYPE1=Sentence
CONT_TYPE2=Scramble

3dttest++ -prefix ODR.paired_ttest.Sent-List.nii.gz														\
	  -AminusB																		\
	  -setA ${CONT_TYPE1}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
	  -setB ${CONT_TYPE2}																	\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
	   -paired																		\
	   -overwrite

}

ttest_Raw_vs_ODR() {

GLM_TYPE1=GLM_mag_REML
GLM_TYPE2=GLM_odr_REML

CONT_TYPE1=Sent_vs_Scrm
CONT_TYPE2=Sent_vs_Scrm

3dttest++ -prefix RAW_vs_ODR.paired_ttest.Sent-List.nii.gz													\
	  -AminusB																		\
	  -setA RAW																		\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
	  -setB ODR																		\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
	   -paired																		\
	   -overwrite

}

ttest_Raw_vs_OLS() {

GLM_TYPE1=GLM_mag_REML
GLM_TYPE2=GLM_lsqrs_REML

CONT_TYPE1=Sent_vs_Scrm
CONT_TYPE2=Sent_vs_Scrm

3dttest++ -prefix RAW_vs_OLS.paired_ttest.Sent-List.nii.gz													\
	  -AminusB																		\
	  -setA RAW																		\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE1}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"		\
	  -setB OLS																		\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  02 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  03 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  04 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  05 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  06 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  07 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  08 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  09 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  10 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  11 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  12 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  13 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  14 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  15 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  16 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  17 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"			\
		  18 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  19 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  20 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  21 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
		  22 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE2}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"		\
	   -paired																		\
	   -overwrite

}

ttest_RAW
ttest_OLS
ttest_ODR
ttest_Raw_vs_ODR
ttest_Raw_vs_OLS
