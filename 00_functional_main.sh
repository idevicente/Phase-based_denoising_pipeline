#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu
#$ -q long.q 

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
if [[ -z "${ORDER}" ]]; then
  if [[ ! -z "$5" ]]; then
     ORDER=$5
  else
     echo -e "\e[31m++ ERROR: You need to input ORDER as ENVIRONMENT VARIABLE or $5. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${CENSOR_TYPE_2USE}" ]]; then
  if [[ ! -z "$6" ]]; then
     CENSOR_TYPE_2USE=$6
  else
     echo -e "\e[31m++ ERROR: You need to input CENSOR_TYPE_2USE as ENVIRONMENT VARIABLE or $6. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${CENSOR_MOTION_TH_2USE}" ]]; then
  if [[ ! -z "$7" ]]; then
     CENSOR_MOTION_TH_2USE=$7
  else
     echo -e "\e[31m++ ERROR: You need to input CENSOR_MOTION_TH_2USE as ENVIRONMENT VARIABLE or $7. Exiting!! ...\e[39m"
     exit
  fi
fi

ORIGDIR=~/public/HBP_MaiteCesar

module load afni/latest
module load python/python3

cd ${PRJDIR}/PREPROC/${SUBJ}/func


#sh ~/public/HBP_phase/scripts/01_functional_magnitude.sh ${SUBJ} ${RUN} ${PRJDIR} ${TASK}	# Magnitude preprocessing script
#sh ~/public/HBP_phase/scripts/02_functional_phase.sh ${SUBJ} ${RUN} ${PRJDIR} ${TASK}			# Phase preprocessing script
#sh ~/public/HBP_phase/scripts/03_functional_phaseregression.sh ${SUBJ} ${PRJDIR}			# Phase regression (ODR, Lsqrs) script
#sh ~/public/HBP_phase/scripts/04_functional_GLM.sh ${SUBJ} ${PRJDIR} ${TASK} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script
#sh ~/public/HBP_phase/scripts/04b_functional_GLM.sh ${SUBJ} ${PRJDIR} ${TASK} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dMEMA
#sh ~/public/HBP_phase/scripts/05_anatomical.sh ${PRJDIR} ${SUBJ} ${ORIGDIR}              # Anatomical preprocessing 
sh ~/public/HBP_phase/scripts/06_warpingMNI.sh ${PRJDIR} ${SUBJ}                         # Warping to MNI space 






