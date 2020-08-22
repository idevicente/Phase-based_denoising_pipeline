#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

# ************************************************************************
# This script takes 4 arguments: Subject ID, RUN, PRJDIR path, TASK name
# ************************************************************************

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

set -e

if [[ ! -d ${PRJDIR}/PREPROC/${SUBJ}/func ]]; then
	mkdir -p ${PRJDIR}/PREPROC/${SUBJ}/func
else
	echo -e "\e[35m ++ WARNING: ${PRJDIR}/PREPROC/${SUBJ}/func already exists. Will overwrite results!! ... \e[39m"
fi

cd ${PRJDIR}/PREPROC/${SUBJ}/func

echo -e "\e[32m ++ INFO: Looking for SBREF data. Reference for realignment ...\e[39m"
FSBREF=`find ${PRJDIR}/BIDS_selected_subjects/$SUBJ/func/* -name "*task-${TASK}*run-${RUN}*sbref*nii.gz"`
nSbref=$(echo "$FSBREF" | tr " " "\n" | grep -c ".nii.gz")
if [[ $nSbref == "0" ]]; then
  echo -e "\e[31m ++ ERROR: SBREF dataset used as reference for realignment not found. Exiting ...\e[39m"
  exit
fi

OUTDIR=$(pwd)
TRIMSECONDS=10 # SECONDS TO ACHIEVE STEADY STATE MAGNETIZATION

echo -e "\e[34m +++ ============================================================================================\e[39m"
echo -e "\e[34m +++ ----------> STARTING SCRIPT: FUNCTIONAL PREPROCESSING OF SUBJ-${SUBJ} RUN-${RUN}  <---------\e[39m"
echo -e "\e[34m +++ ============================================================================================\e[39m"

################ FUNCTIONAL PREPROCESSING OF MAGNITUDE #####################

mag_copy_sbref() {
	
	echo -e "\e[32m ++ INFO: Copy ${FSBREF} in current directory: Reference for realignment ...\e[39m"
	3dcopy -overwrite ${FSBREF} ${SUBJ}.volreg_base.nii.gz

	# ============================ auto block: tcat ============================
	# apply 3dTcat to copy input dsets to results dir,
	# while removing the first 10 TRs

}

mag_steady_state() {
	
	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ---> Removing volumes to achieve steady-state magnetization  <-------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"

	M_BOLD=`find ${PRJDIR}/BIDS_selected_subjects/$SUBJ/func/* -name "*task-${TASK}_run-${RUN}*bold.nii.gz" -o -name "*task-${TASK}_rec-magnitude_run-${RUN}*bold.nii.gz"`
	nBold=$(echo "$M_BOLD" | tr " " "\n" | grep -c ".nii.gz")
	M_JSON_FILE=`find ${PRJDIR}/BIDS_selected_subjects/$SUBJ/func/* -name "*task-${TASK}_run-${RUN}*bold.json" -o -name "*task-${TASK}_rec-magnitude_run-${RUN}*bold.json"`
	if [[ $nBold == "0" ]]; then
	  echo -e "\e[31m ++ ERROR: BOLD magnitude dataset not found. Exiting ...\e[39m"
	  exit
	fi
	if [[ $nBold == "2" ]]; then
	  echo -e "\e[31m ++ ERROR: Two BOLD magnitude datasets found. Exiting ...\e[39m"
	  exit
	fi
	echo -e "\e[32m ++ INFO: Magnitude dataset found: ${M_BOLD} ...\e[39m"

	TR=$(3dinfo -TR ${M_BOLD})
	TRIMSTEADY=$(echo "${TRIMSECONDS}/${TR} + 1" | bc)
	
	echo -e "\e[32m ++ INFO: Removing ${TRIMSTEADY} volumes to achieve steady-state magnetization ...\e[39m"
	3dTcat -overwrite -prefix ${SUBJ}.magnitude.pb00_tcat.nii.gz ${M_BOLD}"[${TRIMSTEADY}..$]"		
}

mag_opt_poly() {

	# COMPUTE OPTIMAL ORDER OF LEGENDRE POLYNOMIALS
	# -------------------------------------------------------
	echo -e "\e[32m ++ INFO: Compute optimal order of Legendre polynomials for detrending = 1 + round(Duration/150) ...\e[39m"
	TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb00_tcat.nii.gz)
	# ORDER
	POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
	POLORTORDER=$(echo "1+${POLORTORDER}" | bc)
	echo -e "\e[32m ++ INFO: Legendre polynomials for magnitude detrending will be ${POLORTORDER}...\e[39m"

}

mag_outliers() {

	# OUTCOUNT (NUMBER OF OUTLIERS PER VOLUME)
	# =======================
	echo -e "\e[34m +++ ===========================================================================\e[39m"
	echo -e "\e[34m +++ ------------------------> Detect outliers <--------------------------------\e[39m"
	echo -e "\e[34m +++ ===========================================================================\e[39m"
	echo -e "\e[32m ++ INFO: Compute outlier fraction for each volume with 3dToutcount ...\e[39m"
	3dToutcount -automask -fraction -polort ${POLORTORDER} -legendre  ${SUBJ}.magnitude.pb00_tcat.nii.gz > ${SUBJ}_outcount.1D
	# censor outlier TRs per run, ignoring the first 0 TRs
	# - censor when more than 0.1 of automask voxels are outliers
	# - step() defines which TRs to remove via censoring
	echo -e "\e[32m ++ INFO: Volumes with more than 10% of outliers will be censored: ${SUBJ}_outcount_censor.1D ...\e[39m"
	1deval -a ${SUBJ}_outcount.1D -expr "1-step(a-0.1)" > ${SUBJ}_outcount_censor.1D
	# outliers at TR 0 might suggest pre-steady state TRs

	#mtc:this line below raises an error
	if ( `1deval -a ${SUBJ}_outcount.1D"{0}" -expr "step(a-0.4)"` ); then
	    echo -e "\e[35m ++ WARNING: TR #0 outliers: possible pre-steady state TRs \e[39m" >> ${SUBJ}_out.pre_ss_warn.txt
	fi

}

mag_create_mask() {

	# ================== create mask based on reference volume ===============================

	echo -e "\e[34m +++ ========================================================================\e[39m"
	echo -e "\e[34m +++ ------------> COMPUTE MASK OF FUNCTIONAL DATASET <----------------------\e[39m"
	echo -e "\e[34m +++ ========================================================================\e[39m"
	echo -e "\e[32m ++ INFO: Compute mask of functional dataset with 3dSkullStrip  ...\e[39m"
	3dSkullStrip -overwrite -input ${SUBJ}.volreg_base.nii.gz -prefix rm.${SUBJ}_mask_base.nii.gz -mask_vol
	echo -e "\e[32m ++ INFO: Mask will be only voxels that touch the brain surface ...\e[39m"
	3dcalc -overwrite -float -a rm.${SUBJ}_mask_base.nii.gz -expr 'step(a-1)' -prefix rm.${SUBJ}_mask_base.nii.gz
	echo -e "\e[32m ++ INFO: Mask: Erode -1 and dilate +1 and fill holes ...\e[39m"
	3dmask_tool -overwrite -fill_holes -dilate_input -1 1 -inputs rm.${SUBJ}_mask_base.nii.gz -prefix ${SUBJ}_mask_base.nii.gz
	rm rm.${SUBJ}_mask_base.nii.gz

}

mag_volreg() {

	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[34m +++ ------------> HEAD REALIGNMENT    <--------------------------\e[39m"
	echo -e "\e[34m +++ =============================================================\e[39m"
	# register each volume to the base image
	echo -e "\e[32m ++ INFO: Realignment of functional data to reference Volume ...\e[39m"
	3dvolreg -verbose -overwrite -zpad 1 -base ${SUBJ}.volreg_base.nii.gz \
	  -1Dfile ${SUBJ}_Motion.1D -prefix ${SUBJ}.magnitude.pb01_volreg.nii.gz \
	  -maxdisp1D ${SUBJ}_MaxMotion.1D -Fourier -1Dmatrix_save ${SUBJ}.mat.vr.aff12.1D ${SUBJ}.magnitude.pb00_tcat.nii.gz

}

mag_motion_parameters() {

	echo -e "\e[32m ++ INFO: Computing demean and derivative of realignment parameters ...\e[39m"
	# compute de-meaned motion parameters (for use in regression)
	1d_tool.py -overwrite -infile ${SUBJ}_Motion.1D -set_nruns 1 -demean -write ${SUBJ}_Motion_demean.1D
	# compute motion parameter derivatives (for use in regression)
	1d_tool.py -overwrite -infile ${SUBJ}_Motion.1D -set_nruns 1 -derivative -demean -write ${SUBJ}_Motion_deriv.1D

	# Compute Framewise Displacement based on Euclidean Norm (as default in AFNI)
	echo -e "\e[32m ++ INFO: Computing Framewise Displacement based on Euclidean Norm (as default in AFNI) ...\e[39m"
	1d_tool.py -overwrite -infile ${SUBJ}_Motion.1D -derivative -collapse_cols euclidean_norm -write ${SUBJ}_Motion_enorm.1D

	# Compute Framewise Displacement (as defined by Power)
	echo -e "\e[32m ++ INFO: Computing Framewise Displacement (as defined by Power) ...\e[39m"
	1deval -overwrite -a ${SUBJ}_Motion_deriv.1D[0] -b ${SUBJ}_Motion_deriv.1D[1] \
	  -c ${SUBJ}_Motion_deriv.1D[2] -d ${SUBJ}_Motion_deriv.1D[3] \
	  -e ${SUBJ}_Motion_deriv.1D[4] -f ${SUBJ}_Motion_deriv.1D[5] \
	  -expr 'abs(a)+abs(b)+abs(c)+abs(d)+abs(e)+abs(f)' > ${SUBJ}_Motion_FD.1D

	# Compute RMS of motion derivative parameters
	echo -e "\e[32m ++ INFO: Computing Framewise Displacement based on RMS of realignment  derivative parameters ...\e[39m"
	1deval -overwrite -a ${SUBJ}_Motion_deriv.1D[0] -b ${SUBJ}_Motion_deriv.1D[1] \
	  -c ${SUBJ}_Motion_deriv.1D[2] -d ${SUBJ}_Motion_deriv.1D[3] \
	  -e ${SUBJ}_Motion_deriv.1D[4] -f ${SUBJ}_Motion_deriv.1D[5] \
	  -expr 'sqrt( (a*a + b*b +c*c + d*d + e*e + f*f)/6 )' > ${SUBJ}_Motion_RMS.1D

}

mag_censor_files() {

	# create censor file from Enorm and FD time series for censoring motion
	for CENSOR_MOTION_TH in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0
	do
	  for CENSOR_TYPE in enorm FD
	  do
	    # based on Motion_FD.1D
	    1d_tool.py -overwrite -infile ${SUBJ}_Motion_${CENSOR_TYPE}.1D -censor_prev_TR \
		-moderate_mask -${CENSOR_MOTION_TH} ${CENSOR_MOTION_TH} -show_censor_count \
		-write_censor ${SUBJ}_Motion_${CENSOR_TYPE}_censor_${CENSOR_MOTION_TH}.1D \
		-write_CENSORTR ${SUBJ}_Motion_${CENSOR_TYPE}_${CENSOR_MOTION_TH}_CENSORTR.txt
	    # combine multiple censor files
	    1deval -overwrite -a ${SUBJ}_Motion_${CENSOR_TYPE}_censor_${CENSOR_MOTION_TH}.1D -b ${SUBJ}_outcount_censor.1D \
		-expr "a*b" > ${SUBJ}_Motion_${CENSOR_TYPE}_censor_${CENSOR_MOTION_TH}_combined_2.1D
	  done
	done
	# combine multiple censor files
	echo -e "\e[32m ++ INFO: Using ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D for censoring volumes ...\e[39m"
	# note TRs that are not censored; this will be used for computing tSNR maps
	#KEEPTRS=$(1d_tool.py -infile ${SUBJ}_Motion_${CENSOR_TYPE_2USE}_censor_${CENSOR_MOTION_TH_2USE}_combined_2.1D -show_trs_uncensored encoded)

}

mag_dvars() {

	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[34m +++ ------------>   COMPUTING DVARS TIME SERIES   <--------------\e[39m"
	echo -e "\e[34m +++ ---> DVARS: Root mean square of voxelwise derivative <-------\e[39m"
	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[32m ++ INFO: Computing DVARS (method cvar=dvars/sqrt(nvoxels)/gmean) in 3dTto1D ...\e[39m"
	3dTto1D -input ${SUBJ}.magnitude.pb00_tcat.nii.gz -mask ${SUBJ}_mask_base.nii.gz -method cvar -prefix ${SUBJ}_dvars.1D

}

mag_detrend() {

	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[34m +++ --------------------->   DETRENDING DATA   <-----------------\e[39m"
	echo -e "\e[34m +++ =============================================================\e[39m"

	# DETREND MOTION CORRECTED VOLUMES (3DVOLREG OUTPUT)
	3dTproject -input ${SUBJ}.magnitude.pb01_volreg.nii.gz -prefix ${SUBJ}.magnitude.pb02_volreg_detrended.nii.gz -polort ${POLORTORDER} \
	-overwrite

}

mag_apply_mask() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ -----------------------> APPLYING MASK <-----------------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"

	3dcalc -a ${SUBJ}.magnitude.pb02_volreg_detrended.nii.gz -b ${SUBJ}_mask_base.nii.gz \
	-expr 'a*b' -overwrite -prefix ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz

}

mag_tsnr() {

	echo -e "\e[34m +++ =============================================================\e[39m"
	echo -e "\e[34m +++ ------------>    CALCULATE tSNR    <-------------------------\e[39m"
	echo -e "\e[34m +++ =============================================================\e[39m"

	3dTstat -overwrite -tsnr -prefix ${SUBJ}_tSNR.nii.gz ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz

}



echo -e "\e[34m +++ ====================================================================================================\e[39m"
echo -e "\e[34m +++ ----------------------------------> STARTING MAGNITUDE PREPROCESSING <------------------------------\e[39m"
echo -e "\e[34m +++ ====================================================================================================\e[39m"
echo -e "\e[32m ++ INFO: execution started: `date` \e[39m"

mag_copy_sbref
mag_steady_state
mag_opt_poly
mag_outliers
mag_create_mask
mag_volreg
mag_motion_parameters
mag_censor_files
mag_dvars
mag_detrend
mag_apply_mask
mag_tsnr

echo -e "\e[32m ++ INFO: execution finished: `date` \e[39m"

echo -e "\e[34m +++ ===================================================================================================\e[39m"
echo -e "\e[34m +++ ---------------------------------> END OF MAGNITUDE PREPROCESSING <--------------------------------\e[39m"
echo -e "\e[34m +++ ===================================================================================================\e[39m"

