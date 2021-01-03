#!/bin/bash
#$ -cwd
#$ -m be
#$ -N MNI
#$ -S /bin/bash

# ****************************************************************************
# Compute anatomical preprocessing after freesurfer recon-all
# Scripts 01_freesurfer must be run before
# This function takes 4 arguments: PRJDIR path, Subject name, TEMPLATE, TSPACE
# ****************************************************************************

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$1" ]]; then
     PRJDIR=$1
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${SUBJ}" ]]; then
  if [[ ! -z "$2" ]]; then
     SUBJ=$2
  else
     echo -e "\e[31m++ ERROR: You need to input SUBJECT (SUBJ) as ENVIRONMENT VARIABLE or $2. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ ${HOSTAME} == *"ipsnode"* ]]; then
    echo "Loading modules"
    module load afni/latest
fi

set -e

TSPACE=MNI
TEMPLATE_BASENAME="MNI152_2009_template"
ANAT_PREPROC_DIR=${PRJDIR}/PREPROC/${SUBJ}/anat
FWHM=5.0 # FULL-WIDTH-HALF-MAXIMUM FOR SPATIAL SMOOTHING

cd ${PRJDIR}/PREPROC/${SUBJ}/func

VOXELRESZ=$(3dinfo -adk ${SUBJ}.volreg_base.nii.gz)

echo "Working in $(pwd)"

# CREATE SYMBOLIC LINK OF ANATOMICAL TEMPLATE IN CURRENT DIRECTORY
# =======================
echo -e "\e[32m ++ INFO: Creating symbolic link of ${TEMPLATE_BASENAME} to current directory   ...\e[39m"
if [[ -L ${TEMPLATE_BASENAME}.nii.gz ]] || [[ -f ${TEMPLATE_BASENAME}.nii.gz ]] ; then
  echo -e "\e[35m ++ WARNING: Deleting current file or symbolic link to ${TEMPLATE_BASENAME}  ...\e[39m"
  rm ${TEMPLATE_BASENAME}.nii.gz
fi
ln -s ${PRJDIR}/TEMPLATES_ATLAS/${TEMPLATE_BASENAME}.nii.gz ./

# CREATE SYMBOLIC LINK OF ANATOMICAL TRANSFORMATIONS IN CURRENT DIRECTORY
# =======================
echo -e "\e[32m ++ INFO: Creating symbolic link of anat.un.aff.qw_WARP.nii.gz to current directory   ...\e[39m"
if [[ -L anat.un.aff.qw_WARP.nii.gz ]] || [[ -f anat.un.aff.qw_WARP.nii.gz ]] ; then
  echo -e "\e[35m ++ WARNING: Deleting current file or symbolic link to anat.un.aff.qw_WARP.nii.gz  ...\e[39m"
  rm anat.un.aff.qw_WARP.nii.gz
fi
ln -s ${ANAT_PREPROC_DIR}/anat.un.aff.qw_WARP.nii.gz ./

# ANATOMICAL TO FUNCTIONAL REGISTRATION
# =======================
echo -e "\e[34m +++ =======================================================================\e[39m"
echo -e "\e[34m +++ ------------> ANATOMICAL TO FUNCTIONAL REGISTRATION <------------------\e[39m"
echo -e "\e[34m +++ =======================================================================\e[39m"
# for e2a: compute anat alignment transformation to EPI registration base
# (new anat will be intermediate, stripped, ${SUBJ}_SurfVol_ns+orig)
echo -e "\e[32m ++ INFO: Applying functional mask to reference functional volume  ...\e[39m"
3dcalc -overwrite -a ${SUBJ}.volreg_base.nii.gz -b ${SUBJ}_mask_base.nii.gz -expr 'a*b' -prefix rm.volreg_base.masked.nii.gz
echo -e "\e[32m ++ INFO: Coregistration of anatomical to reference functional volume  ...\e[39m"
align_epi_anat.py -overwrite -giant_move -anat2epi -anat ${ANAT_PREPROC_DIR}/${SUBJ}_T1_ns.nii.gz -suffix .al_epi -anat_has_skull no \
       -epi rm.volreg_base.masked.nii.gz -epi_base 0 -epi_strip None -volreg off -tshift off

if [[ -e ${SUBJ}_T1_ns.al_epi+orig.HEAD ]]; then
  echo -e "\e[32m ++ INFO: Converting output of alignment from AFNI format to NIFTI  ...\e[39m"
  3dAFNItoNIFTI -prefix ${SUBJ}_T1_ns.al_epi.nii.gz ${SUBJ}_T1_ns.al_epi+orig.
  rm ${SUBJ}_T1_ns.al_epi+orig.*
else
  echo -e "\e[31m ++ ERROR: Coregistration of ANAT ${SUBJ}_T1_ns.nii.gz to FUNC external ${SUBJ}.volreg_base.nii.gz FAILED ...\e[39m"
  exit
fi

echo -e "\e[34m +++ =============================================================\e[39m"
echo -e "\e[34m +++ ------->   CATENATION OF SPATIAL TRANSFORMATIONS   <---------\e[39m"
echo -e "\e[34m +++ =============================================================\e[39m"
echo -e "\e[32m ++ INFO: Inv(Anat to Func) ...\e[39m"
cat_matvec -ONELINE ${SUBJ}_T1_ns.al_epi_mat.aff12.1D -I > epi_al_${SUBJ}_T1_ns_mat.aff12.1D

echo -e "\e[32m ++ INFO: Catenate linear transformations of reference dataset to MNI ...\e[39m"
echo -e "\e[32m ++ INFO: Anat-to-MNI + Inv(Anat to Func) ...\e[39m"
cat_matvec -ONELINE ${ANAT_PREPROC_DIR}/anat.un.aff.Xat.1D ${SUBJ}_T1_ns.al_epi_mat.aff12.1D -I  > mat.warp.aff12.1D

echo -e "\e[34m +++ ========================================================================\e[39m"
echo -e "\e[34m +++ ------> ALIGNMENT OF ANATOMICAL WITH SKULL TO FUNCTIONAL SPACE  <-------\e[39m"
echo -e "\e[34m +++ ========================================================================\e[39m"
echo -e "\e[32m ++ INFO: Align anatomical with skull to functional space  ...\e[39m"
3dAllineate -overwrite -1Dmatrix_apply ${SUBJ}_T1_ns.al_epi_mat.aff12.1D \
    -final NN -input ${ANAT_PREPROC_DIR}/${SUBJ}_T1.nii.gz -prefix ${SUBJ}_T1.al_epi.nii.gz

echo -e "\e[34m +++ ===================================================================\e[39m"
echo -e "\e[34m +++ ---> WARPING FUNCTIONAL DATA AND MASK TO ${TEMPLATE_BASENAME}  <---\e[39m"
echo -e "\e[34m +++ ===================================================================\e[39m"
# apply catenated xform: volreg/epi2anat/tlrc
# then apply non-linear standard-space warp
VOXELRESZ=$(3dinfo -adk ${SUBJ}.volreg_base.nii.gz)
echo -e "\e[32m ++ INFO: Warping functional dataset to ${TEMPLATE_BASENAME} all at once ...\e[39m"
echo -e "\e[32m ++ INFO: FUNC TO ANAT, AFFINE ANAT TO TEMPLATE, NLWARP ANAT TO TEMPLATE ...\e[39m"
echo -e "\e[32m ++ INFO: Warping to MNI will be done at ${VOXELRESZ} mm isotropic (= slice thickness) ...\e[39m"
  
if [[ ! -L ${SUBJ}_T1_ns.${TSPACE}.nii.gz ]]; then
  ln -s ${ANAT_PREPROC_DIR}/${SUBJ}_T1_ns.${TSPACE}.nii.gz .
fi
echo ${SUBJ}.magnitude.pb01_volreg.nii.gz
3dNwarpApply -overwrite -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz -dxyz ${VOXELRESZ} \
             -source ${SUBJ}.magnitude.pb01_volreg.nii.gz                         \
             -nwarp "anat.un.aff.qw_WARP.nii.gz mat.warp.aff12.1D"     \
             -prefix ${SUBJ}.magnitude.pb01_volreg.${TSPACE}.nii.gz

echo -e "\e[32m ++ INFO: Warping reference of functional dataset to ${TEMPLATE_BASENAME} all at once ...\e[39m"
echo -e "\e[32m ++ INFO: BLIP + FUNC TO ANAT, AFFINE ANAT TO TEMPLATE, NLWARP ANAT TO TEMPLATE ...\e[39m"
3dNwarpApply -overwrite -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz -dxyz ${VOXELRESZ}                 \
            -source ${SUBJ}.volreg_base.nii.gz                                \
            -nwarp "anat.un.aff.qw_WARP.nii.gz mat.warp.aff12.1D"           \
            -prefix ${SUBJ}.volreg_base.${TSPACE}.nii.gz

echo -e "\e[32m ++ INFO: Warping mask of functional dataset to ${TEMPLATE_BASENAME} at ANAT resolution all at once ...\e[39m"
echo -e "\e[32m ++ INFO: Mask was computed after BLIP. Hence, no need to BLIP now ...\e[39m"
echo -e "\e[32m ++ INFO: FUNC TO ANAT, AFFINE ANAT TO TEMPLATE, NLWARP ANAT TO TEMPLATE ...\e[39m"
3dNwarpApply -overwrite -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz \
            -source ${SUBJ}_mask_base.nii.gz                   \
            -ainterp NN -nwarp "anat.un.aff.qw_WARP.nii.gz mat.warp.aff12.1D"           \
            -prefix ${SUBJ}_mask_base.ANAT.${TSPACE}.nii.gz

echo -e "\e[32m ++ INFO: Warping mask of functional dataset to ${TEMPLATE_BASENAME} at FUNC resolution all at once ...\e[39m"
echo -e "\e[32m ++ INFO: Mask was computed after BLIP. Hence, no need to BLIP now ...\e[39m"
echo -e "\e[32m ++ INFO: FUNC TO ANAT, AFFINE ANAT TO TEMPLATE, NLWARP ANAT TO TEMPLATE ...\e[39m"
3dNwarpApply -overwrite -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz -dxyz ${VOXELRESZ}           \
            -source ${SUBJ}_mask_base.nii.gz                                \
            -ainterp NN -nwarp "anat.un.aff.qw_WARP.nii.gz mat.warp.aff12.1D"           \
            -prefix ${SUBJ}_mask_base.FUNC.${TSPACE}.nii.gz


echo -e "\e[34m +++ =================================================================================\e[39m"
echo -e "\e[34m +++ --> ALIGNMENT OF ANATOMICAL MASKS, WM, CSF AND FS PARCELLATIONS TO FUNCTIONAL <--\e[39m"
echo -e "\e[34m +++ -->                                AND                                        <--\e[39m"
echo -e "\e[34m +++ -->    WARPING ANATOMICAL MASKS, WM, CSF AND FS PARCELLATIONS TO ${TSPACE}    <--\e[39m"
echo -e "\e[34m +++ =================================================================================\e[39m"
for DATA_ANAT in ${SUBJ}_T1_mask aparc.a2009s+aseg aparc.a2009s+aseg_rank lh.ribbon rh.ribbon FS_Vent FS_Vent_Superficial FS_Vent_Deep FS_WM FS_WM_Superficial FS_WM_Middle FS_WM_Deep FS_Cerebellum FS_Subcortical FS_GM FS_Rh_mask FS_Lh_mask
do
  echo -e "\e[32m ++ INFO: Align ${DATA_ANAT} to functional original space at anatomical resolution  ...\e[39m"
  3dAllineate -overwrite -master ${SUBJ}.volreg_base.nii.gz -1Dmatrix_apply ${SUBJ}_T1_ns.al_epi_mat.aff12.1D \
               -final NN -input ${ANAT_PREPROC_DIR}/${DATA_ANAT}.nii.gz -prefix ${DATA_ANAT}.al_epi.FUNC.nii.gz
  echo -e "\e[32m ++ INFO: Align ${DATA_ANAT} to functional original space at functional resolution ...\e[39m"
  3dAllineate -overwrite -master ${SUBJ}_T1_ns.al_epi.nii.gz -1Dmatrix_apply ${SUBJ}_T1_ns.al_epi_mat.aff12.1D \
               -final NN -input ${ANAT_PREPROC_DIR}/${DATA_ANAT}.nii.gz -prefix ${DATA_ANAT}.al_epi.ANAT.nii.gz
  echo -e "\e[32m ++ INFO:  Warping of ${DATA_ANAT}.nii.gz to ${TSPACE} at functional resolution ...\e[39m"
  3dNwarpApply -overwrite -source ${ANAT_PREPROC_DIR}/${DATA_ANAT}.nii.gz -master ${SUBJ}.volreg_base.${TSPACE}.nii.gz \
               -ainterp NN -nwarp anat.un.aff.qw_WARP.nii ${ANAT_PREPROC_DIR}/anat.un.aff.Xat.1D    \
               -prefix ${DATA_ANAT}.FUNC.${TSPACE}.nii.gz
   echo -e "\e[32m ++ INFO: Linking ${DATA_ANAT}.ANAT.${TSPACE}.nii.gz to current directory ...\e[39m"
   #ln -s ${ANAT_PREPROC_DIR}/${DATA_ANAT}.ANAT.${TSPACE}.nii.gz ./
done


echo -e "\e[34m +++ =================================================================\e[39m"
echo -e "\e[34m +++ -->  WARPING and SPATIAL SMOOTHING OF GLM STATS TO ${TSPACE}  <--\e[39m"
echo -e "\e[34m +++ =================================================================\e[39m"

for GLM_TYPE in GLM_mag_REML GLM_lsqrs_REML GLM_odr_REML
do
    echo -e "\e[32m ++ INFO: Warping ${GLM_TYPE} to ${TSPACE} ...\e[39m"
    3dNwarpApply -overwrite -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz -dxyz ${VOXELRESZ} \
             -source ${SUBJ}.${GLM_TYPE}.stats_scaled_mean.nii.gz                         \
             -nwarp "anat.un.aff.qw_WARP.nii.gz mat.warp.aff12.1D"     \
             -prefix ${SUBJ}.${GLM_TYPE}.stats_scaled_mean.${TSPACE}.nii.gz

    echo -e "\e[32m ++ INFO: Spatial smoothing ${FWHM} of ${GLM_TYPE} in ${TSPACE} space ...\e[39m"
    3dBlurInMask -overwrite -float -preserve -FWHM ${FWHM} -mask ${SUBJ}_mask_base.FUNC.${TSPACE}.nii.gz \
             -prefix rm.${SUBJ}.${GLM_TYPE}.stats_scaled_mean.blur.${TSPACE}.nii.gz ${SUBJ}.${GLM_TYPE}.stats_scaled_mean.${TSPACE}.nii.gz
    3dcalc -overwrite -a rm.${SUBJ}.${GLM_TYPE}.stats_scaled_mean.blur.${TSPACE}.nii.gz -m ${SUBJ}_mask_base.FUNC.${TSPACE}.nii.gz \
             -expr 'a*m' -prefix ${SUBJ}.${GLM_TYPE}.stats_scaled_mean.blur.${TSPACE}.nii.gz

done

echo -e "\e[32m ++ INFO: Deleting temporary files ...\e[39m"
rm  rm* 

echo -e "\e[34m +++ ===============================================================\e[39m"
echo -e "\e[34m +++ ---------> END OF SCRIPT: WARPING ${TSPACE}  FINISHED  <-------\e[39m"
echo -e "\e[34m +++ ===============================================================\e[39m"


