# Phase-based denoising pipeline

This pipeline is organized as following:

* Both single-subject preprocessing and analysis are carried out by executing the script `<00_main.sh>` through the terminal, which sequentially runs the rest of the single-subject scripts. 

* Group-level statistics are obtained independently through the terminal (i.e. `<sh Group_analysis_ttest.sh>` and `<sh Group_analysis_MEMA.sh>`).  

For implementation, one would obviously need to change the environment variables for their own subjects, project directory, etc...

`<00_main.sh>`
`<02_functional_phase.sh>`
`<02b_temporal_unwrapping.py>`
`<03_functional_phaseregression.sh>`
`<03b_ODR_fit.py>`
`<04_GLM_MEMA.sh>`
`<04_GLM_ttest.sh>`
`<05_anatomical.sh>`
`<06_warpingMNI.sh>`
`<Group_analysis_MEMA.sh>`
`<Group_analysis_ttest.sh>`
