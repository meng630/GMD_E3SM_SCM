#!/bin/bash

export grid=1
export type="topunit"
export domainPath=/global/u2/d/daleihao/model/data/TOP_PFT/${type}/
export domainFile=domain_Topunit_grid_${grid}_c210307.nc
export surfdataFile=surfdata_Topunit_grid_${grid}_c210307.nc
export topdataFile=topodata_Topunit_grid_${grid}_c210307.nc

 

# notop
export RES=CLM_USRDAT
export COMPSET=ICLM45 
export COMPILER=intel 
export MACH=cori-knl 
export CASE_NAME=test4_PFT_TOP_${type}_notop_grid${grid}_${RES}.${COMPSET}.${COMPILER}
cd ~/model/e3sm_top/cime/scripts 
./create_newcase -compset ICLM45 -res ${RES} -case ${CASE_NAME} -compiler ${COMPILER} -mach ${MACH} -project XXXX
cd ${CASE_NAME}
./xmlchange LND_DOMAIN_FILE=${domainFile} 
./xmlchange ATM_DOMAIN_FILE=${domainFile} 
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}

 

./xmlchange NTASKS=1,STOP_N=3,STOP_OPTION=ndays,JOB_WALLCLOCK_TIME="0:05:00",RUN_STARTDATE="2000-01-01",REST_N=1,REST_OPTION=nyears
./xmlchange DATM_MODE="CLMGSWP3v1",DATM_CLMNCEP_YR_START='2000',DATM_CLMNCEP_YR_END='2010'

 

cat >> user_nl_clm << EOF
hist_empty_htapes = .true.
hist_fincl1 = 'COSZEN', 'ALBD', 'ALBI','FSA','FSR','FSDSND','FSDSNI','FSRND','FSRNI','FSDSVD','FSDSVI','FSRVD','FSRVI'
hist_fincl2 = 'FSH','EFLX_LH_TOT','TSOI_10CM','TV','TG','TSA','QSNOMELT','QRUNOFF','QOVER','PSNSUN','PSNSHA','FPSN','FSNO','SNOWDP','H2OSNO','zeta_patch','ustar_patch','LH_pft', 'SH_pft','TBOT','QBOT','RHO','EFLX_LH_TOT','Qh','FV','Q2M','TSA'
hist_nhtfrq = 1, -24
hist_mfilt  = 48, 1
fsurdat = '${domainPath}${surfdataFile}'
EOF

 

./case.setup 
./case.build 
./case.submit
