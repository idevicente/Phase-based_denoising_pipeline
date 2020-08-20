# Phase_based_pipeline

This pipeline is organized as following:

..*Both single-subject preprocessing and analysis are carried out by executing the script 00_main through the terminal (i.e. sh 00_main), which sequentially runs the rest of the single-subject scripts. 

..*Group-level statistics are obtained directly through the terminal (i.e. sh Group_analysis_ttest.sh and sh Group_analysis_MEMA.sh).  

For implementation, one would obviously need to change the environment variables for their own subjects, project directory, etc...
