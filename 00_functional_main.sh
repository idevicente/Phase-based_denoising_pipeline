#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

# SUBJECT LIST
list=(	'sub-01HBP6516S2'	'sub-02HBP2799S2'	'sub-03HBP3172S2'	'sub-04HBP2138S2'	'sub-08HBP3439S2'	'sub-12HBP6554S2'
'sub-20HBP4798'	'sub-35HBP2777S2'	'sub-36HBP5395S2'	'sub-40HBP4920S2'	'sub-43HBP4356S2'	'sub-46HBP3953S2'
'sub-48HBP4673S1'	'sub-60HBP4544S2'	'sub-62HBP3789S2'	'sub-66HBP6650S1'	'sub-75HBP7196S2'	'sub-79HBP7775'
'sub-85HBP7184S2'	'sub-100HBP8367'	'sub-116HBP7891S2'	'sub-126HBP8592'	'sub-132HBP1720'  )

# RUN LIST
list2=(  '01' '02' '02'	'01' '01'	'01' 
'01' '02'	'01' '01'	'01' '02'
'01' '01'	'02' '02' '02' '02'
'01' '01'	'01' '02'	'01'  )

# STIMULUS ORDER LIST
list3=(  'A' 'A' 'B' 'B' 'B' 'B' 
'B'	'B'	'B'	'B'	'A'	'A'
'B'	'B'	'A'	'A'	'B'	'B'
'A'	'B'	'B'	'A'	'B'  )

PRJDIR=~/public/HBP_phase
TASK="petit"
CENSOR_TYPE_2USE="enorm"
CENSOR_MOTION_TH_2USE="0.3"

module load afni/latest
module load python/python3

for i in ${!list[*]}
do
	SUBJ=${list[$i]}
	RUN=${list2[$i]}
	ORDER=${list3[$i]}
  
  sh ~/public/HBP_phase/scripts/01_functional_magnitude.sh ${SUBJ} ${RUN} ${PRJDIR} ${TASK}	          # Magnitude preprocessing script
  sh ~/public/HBP_phase/scripts/02_functional_phase.sh ${SUBJ} ${RUN} ${PRJDIR} ${TASK}			          # Phase preprocessing script
  sh ~/public/HBP_phase/scripts/03_functional_phaseregression.sh ${SUBJ} ${PRJDIR}			              # Phase-based regression (ODR, OLS) script
  sh ~/public/HBP_phase/scripts/04_functional_GLM.sh ${SUBJ} ${PRJDIR} ${TASK} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dttest++
  sh ~/public/HBP_phase/scripts/04b_functional_GLM.sh ${SUBJ} ${PRJDIR} ${TASK} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dMEMA
  sh ~/public/HBP_phase/scripts/05_anatomical.sh ${PRJDIR} ${SUBJ} ${ORIGDIR}                         # Anatomical preprocessing 
  sh ~/public/HBP_phase/scripts/06_warpingMNI.sh ${PRJDIR} ${SUBJ}                                    # Warping to MNI space 




