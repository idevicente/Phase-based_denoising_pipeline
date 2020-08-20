# Phase_based_pipeline

This pipeline is organized as following:

Both single-subject preprocessing and analysis are carried out by executing the script 00_main through the terminal (i.e. sh 00_main), which sequentially runs the rest of the single-subject scripts. 

Note that the script 02b_temporal_unwrapping.py is called within 02_functional_phase.sh, and 03b_ODR_fit.py is called within 03_functional_phaseregression.sh. 

Group-level statistics are obtained directly through the terminal (i.e. sh Group_analysis_ttest.sh or sh Group_analysis_MEMA.sh).  

For implementation, one would obviously need to change the environment variables for their own subjects, project directory, etc...
