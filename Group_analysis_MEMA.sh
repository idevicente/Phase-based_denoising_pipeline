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

MEMA_RAW() {

GLM_TYPE=GLM_4MEMA_REML
CONT_TYPE=Sent_Raw_vs_Scrm_Raw

3dMEMA -overwrite -prefix Raw.MEMA.Sent-List.nii.gz								\
	-missing_data 0												\
	-set Sent-List												\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  02 "${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  03 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  04 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  05 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  06 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  07 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  08 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  09 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  10 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  11 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  12 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  13 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  14 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  15 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  16 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  17 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  18 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  19 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  20 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  21 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  22 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  23 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		-overwrite

}

MEMA_OLS() {

GLM_TYPE=GLM_4MEMA_REML
CONT_TYPE=Sent_LSQ_vs_Scrm_LSQ

3dMEMA -overwrite -prefix LSQ.MEMA.Sent-List.nii.gz								\
	-missing_data 0												\
	-set Sent-List												\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  02 "${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  03 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  04 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  05 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  06 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  07 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  08 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  09 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  10 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  11 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  12 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  13 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  14 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  15 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  16 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  17 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  18 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  19 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  20 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  21 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  22 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  23 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		-overwrite

}

MEMA_ODR() {

GLM_TYPE=GLM_4MEMA_REML
CONT_TYPE=Sent_ODR_vs_Scrm_ODR

3dMEMA -overwrite -prefix ODR.MEMA.Sent-List.nii.gz								\
	-missing_data 0												\
	-set Sent-List												\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  02 "${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  03 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  04 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  05 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  06 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  07 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  08 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  09 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  10 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  11 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  12 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  13 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  14 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  15 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  16 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  17 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  18 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  19 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  20 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  21 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  22 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  23 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		-overwrite

}

MEMA_RAW_vs_ODR() {

GLM_TYPE=GLM_4MEMA_REML
CONT_TYPE=Sent_vs_Scrm_VS_Raw_vs_ODR

3dMEMA -overwrite -prefix Raw_vs_ODR.MEMA.Sent-List.nii.gz							\
	-missing_data 0												\
	-set Sent-List												\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  02 "${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  03 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  04 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  05 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  06 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  07 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  08 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  09 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  10 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  11 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  12 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  13 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  14 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  15 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  16 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  17 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  18 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  19 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  20 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  21 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  22 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  23 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		-overwrite

}

MEMA_RAW_vs_OLS() {

GLM_TYPE=GLM_4MEMA_REML
CONT_TYPE=Sent_vs_Scrm_VS_Raw_vs_LSQ

3dMEMA -overwrite -prefix Raw_vs_LSQ.MEMA.Sent-List.nii.gz							\
	-missing_data 0												\
	-set Sent-List												\
		  01 "${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-01HBP6516S2/func/sub-01HBP6516S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  02 "${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-02HBP2799S2/func/sub-02HBP2799S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  03 "${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-03HBP3172S2/func/sub-03HBP3172S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  04 "${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-04HBP2138S2/func/sub-04HBP2138S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  05 "${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-08HBP3439S2/func/sub-08HBP3439S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  06 "${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-12HBP6554S2/func/sub-12HBP6554S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  07 "${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-20HBP4798/func/sub-20HBP4798.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  08 "${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-35HBP2777S2/func/sub-35HBP2777S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  09 "${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-36HBP5395S2/func/sub-36HBP5395S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  10 "${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-40HBP4920S2/func/sub-40HBP4920S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  11 "${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-43HBP4356S2/func/sub-43HBP4356S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  12 "${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-46HBP3953S2/func/sub-46HBP3953S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  13 "${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-48HBP4673S1/func/sub-48HBP4673S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  14 "${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-60HBP4544S2/func/sub-60HBP4544S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  15 "${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-62HBP3789S2/func/sub-62HBP3789S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  16 "${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-66HBP6650S1/func/sub-66HBP6650S1.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  17 "${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-75HBP7196S2/func/sub-75HBP7196S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  18 "${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-79HBP7775/func/sub-79HBP7775.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  19 "${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-85HBP7184S2/func/sub-85HBP7184S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  20 "${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-100HBP8367/func/sub-100HBP8367.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  21 "${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-116HBP7891S2/func/sub-116HBP7891S2.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
		  22 "${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-126HBP8592/func/sub-126HBP8592.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		  23 "${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/sub-132HBP1720/func/sub-132HBP1720.${GLM_TYPE}.stats_scaled_mean.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"			\
		-overwrite

}

MEMA_RAW
MEMA_OLS
MEMA_ODR
MEMA_RAW_vs_ODR
MEMA_RAW_vs_OLS



