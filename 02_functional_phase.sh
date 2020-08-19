#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu
#$ -q long.q

# **********************************************************************
# This script takes 4 arguments: Subject ID, RUN, PRJDIR path, TASK name
# **********************************************************************

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

cd ${PRJDIR}/PREPROC/${SUBJ}/func

OUTDIR=$(pwd)
TRIMSECONDS=10 # SECONDS TO ACHIEVE STEADY STATE MAGNETIZATION

ph_steady_state() {
	
	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ---> Removing volumes to achieve steady-state magnetization  <-------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"

	P_BOLD=`find ${PRJDIR}/BIDS_selected_subjects/$SUBJ/func/* -name "*task-${TASK}Phase*run-${RUN}*bold.nii.gz" -o -name "*task-${TASK}_rec-phase*run-${RUN}*bold.nii.gz"`
	nBold=$(echo "$P_BOLD" | tr " " "\n" | grep -c ".nii.gz")
	P_JSON_FILE=`find ${PRJDIR}/BIDS_selected_subjects/$SUBJ/func/* -name "*task-${TASK}Phase*run-${RUN}*bold.json" -o -name "*task-${TASK}_rec-phase*run-${RUN}*bold.json"`

	if [[ $nBold == "0" ]]; then
	  echo -e "\e[31m ++ ERROR: BOLD phase dataset not found. Exiting ...\e[39m"
	  exit
	fi
	if [[ $nBold == "2" ]]; then
	  echo -e "\e[31m ++ ERROR: Two BOLD phase datasets found... Exiting ...\e[39m"
	  exit
	fi
	echo -e "\e[32m ++ INFO: Phase dataset found: ${P_BOLD} ...\e[39m"

	TR=$(3dinfo -TR ${P_BOLD})
	TRIMSTEADY=$(echo "${TRIMSECONDS}/${TR} + 1" | bc)
	
	echo -e "\e[32m ++ INFO: Removing ${TRIMSTEADY} volumes to achieve steady-state magnetization ...\e[39m"
	
	3dTcat -overwrite -prefix ${SUBJ}.phase.pb00_tcat.nii.gz ${P_BOLD}"[${TRIMSTEADY}..$]"

}

ph_opt_poly() {

	# COMPUTE OPTIMAL ORDER OF LEGENDRE POLYNOMIALS
	# -------------------------------------------------------
	echo -e "\e[32m ++ INFO: Compute optimal order of Legendre polynomials for detrending = 1 + round(Duration/150) ...\e[39m"
	TR_COUNTS=$(3dinfo -nt ${SUBJ}.phase.pb00_tcat.nii.gz)
	# ORDER
	POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
	POLORTORDER=$(echo "1+${POLORTORDER}" | bc)
	echo -e "\e[32m ++ INFO: Legendre polynomials for detrending will be ${POLORTORDER}...\e[39m"

}

ph_convert2radians() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ----------------------> Convert to radians  <----------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	# We divide by 4096 because that is the maximum absolute voxel value in the input dataset. Note however that this value must be adjusted for each type of scanner or sequence used.
	# This then leaves a timeseries that ranges from +3.14159 to -3.14159
	3dcalc -overwrite -a ${SUBJ}.phase.pb00_tcat.nii.gz -expr '(a*3.14159)/4096' -float -prefix ${SUBJ}.phase.pb01_radians.nii.gz

}

ph_makecomplex() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ -------> Convert phase and magnitude into a complex file  <----------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	# Converts two input datasets into a complex file
	3dTwotoComplex -overwrite -prefix ${SUBJ}.phase.pb02_complex.nii.gz -MP ${SUBJ}.magnitude.pb00_tcat.nii.gz ${SUBJ}.phase.pb01_radians.nii.gz

}

ph_splitcomplex() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ -------> Splitting complex file into real and imaginary parts  <--------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	# Extracts REAL and IMAGINARY components from the datasets
	#real part
	3dcalc -overwrite -cx2r REAL -a ${SUBJ}.phase.pb02_complex.nii.gz -expr 'a' -float -prefix ${SUBJ}.phase.pb03_real.nii.gz
	#imaginary part
	3dcalc -overwrite -cx2r IMAG -a ${SUBJ}.phase.pb02_complex.nii.gz -expr 'a' -float -prefix ${SUBJ}.phase.pb03_imag.nii.gz

}

ph_allineate() {

	echo -e "\e[34m +++ ================================================================================\e[39m"
	echo -e "\e[34m +++ --> Apply motion correction parameters to both real and imaginary components <--\e[39m"
	echo -e "\e[34m +++ =================================================================================\e[39m"

	#Apply motion correction matrix from magnitude preprocessing

	3dAllineate -overwrite -1Dmatrix_apply ${SUBJ}.mat.vr.aff12.1D -prefix ${SUBJ}.phase.pb04_real_motioncorrected.nii.gz \
	-input ${SUBJ}.phase.pb03_real.nii.gz

	3dAllineate -overwrite -1Dmatrix_apply ${SUBJ}.mat.vr.aff12.1D -prefix ${SUBJ}.phase.pb04_imag_motioncorrected.nii.gz \
	-input ${SUBJ}.phase.pb03_imag.nii.gz

}

ph_back2complex() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ -----------------------> Make complex again  <-----------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"

	# input real and imaginary images --> output complex dataset

	3dTwotoComplex -overwrite -prefix ${SUBJ}.phase.pb05_complex_motioncorrected.nii.gz \
	-RI ${SUBJ}.phase.pb04_real_motioncorrected.nii.gz ${SUBJ}.phase.pb04_imag_motioncorrected.nii.gz

}

ph_back2phase() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ----------------------> Convert back to phase  <---------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	#Extracts Phase component of the dataset
	3dcalc -overwrite -cx2r PHASE -a ${SUBJ}.phase.pb05_complex_motioncorrected.nii.gz -expr 'a' -float -prefix ${SUBJ}.phase.pb06_phase_motioncorrected.nii.gz

}

ph_temp_unwrapping() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ------------------> Unwrapping in time domain  <---------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"

	cd ${PRJDIR}/scripts

	python temporal_unwrapping.py --in_file ${SUBJ}.phase.pb06_phase_motioncorrected.nii.gz --outdir ${PRJDIR}/PREPROC/${SUBJ}/func/ --subj ${SUBJ}  			      
	cd ${PRJDIR}/PREPROC/${SUBJ}/func/

}

ph_detrend() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ---------------------------> Detrending phase  <---------------------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	# Linear detrending 
	3dTproject -input ${SUBJ}.phase.pb07_time_unwrapped.nii.gz -prefix ${SUBJ}.phase.pb08_detrended.nii.gz -polort ${POLORTORDER} \
	-overwrite
	
}

ph_apply_mask() {

	echo -e "\e[34m +++ =====================================================================\e[39m"
	echo -e "\e[34m +++ ------> Applying mask from magnitude image to detrended phase <------\e[39m"
	echo -e "\e[34m +++ =====================================================================\e[39m"
	# Applying the mask that was calculated in the magnitude preprocessing
	3dcalc -a ${SUBJ}.phase.pb08_detrended.nii.gz -b ${SUBJ}_mask_base.nii.gz -expr 'a*b' \
	-prefix ${SUBJ}.phase.pb09_detrended_masked.nii.gz -overwrite

}

echo -e "\e[34m ######################################################################################################## \e[39m"

echo -e "\e[34m +++ ==================================================================================\e[39m"
echo -e "\e[34m +++ -------------------> STARTING PHASE FUNCTIONAL PREPROCESSING: <-------------------\e[39m"
echo -e "\e[34m +++ ==================================================================================\e[39m"

ph_steady_state
ph_opt_poly
ph_convert2radians
ph_makecomplex
ph_splitcomplex
ph_allineate
ph_back2complex
ph_back2phase
ph_temp_unwrapping
ph_detrend
ph_apply_mask

echo -e "\e[34m +++ =============================================================================\e[39m"
echo -e "\e[34m +++ -------> END OF PHASE FUNCTIONAL PREPROCESSING ------\e[39m"
echo -e "\e[34m +++ =============================================================================\e[39m"

