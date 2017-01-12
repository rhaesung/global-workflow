echo "running on $machine using $NODES nodes"
ulimit -s unlimited

export exptname=C384_C384_test
export cores=`expr $NODES \* $corespernode`
export KMP_AFFINITY=disabled

export fg_gfs="run_fg_fv3_noiau.csh"
export ensda="enkf_run.csh"
export rungsi='run_gsi_4densvar.sh'
export rungfs='run_fv3_stochphys.sh' # ensemble forecast

export enkf_threads=8 # enkf threads
export gsi_control_threads=4
export cores_gsi=`expr 1 \* $cores \/ 2`
export cores_enkf=`expr $cores - $cores_gsi`
export fg_proc=72 # number of cores per enkf fg ens member. 
export fg_threads=1 # ens fcst threads
export recenter_fg="false"
export recenter_anal="true"
export do_cleanup='true' # if true, create tar files, delete *mem* files.
export enkfonly='false' # if true, pure enkf. If false, GSI computes mean analysis
export cleanup_fg='true'
export cleanup_fgctl='true'
export cleanup_obs='true'
export cleanup_ensmean='true'
export cleanup_anal='true'
export cleanup_controlanl='true'
export resubmit='true'
# python script checkdate.py used to check
# YYYYMMDDHH analysis date string to see if
# full ensemble should be saved to HPSS (returns 0 if 
# HPSS save should be done)
export save_hpss_subset="true" # save a subset of data each analysis time to HPSS

# override values from above for debugging.
#export cleanup_fg='false'
#export cleanup_ensmean='false'
#export cleanup_obs='false'
#export cleanup_anal='false'
#export cleanup_controlanl='false'
#export resubmit='false'
#export do_cleanup='false'
#export cleanup_fgctl='false'
#export recenter_fg="false"
#export recenter_anal="false"
 
if [ "$machine" == 'wcoss' ]; then
   export basedir=/gpfs/hps/esrl/gefsrr/noscrub/${USER}
   export datadir=/gpfs/hps/ptmp/${USER}
   export hsidir="/3year/NCEPDEV/GEFSRR/${USER}/${exptname}"
   module load hpss
   module load grib_util/1.0.3
   #module load cfp-intel-sandybridge
elif [ "$machine" == 'theia' ]; then
   export basedir=/scratch3/BMC/gsienkf/${USER}
   export datadir=$basedir
   export hsidir="/HFIP/gfsenkf/2year/${USER}/${exptname}"
elif [ "$machine" == 'jet' ]; then
   export basedir=/lfs3/projects/gfsenkf/${USER}
   export datadir=$basedir
   export hsidir="/HFIP/gfsenkf/2year/${USER}/${exptname}"
else
   echo "machine must be 'wcoss', 'theia', or 'jet', got $machine"
   exit 1
fi
export datapath="${datadir}/${exptname}"
export logdir="${datadir}/logs/${exptname}"
export corrlengthnh=1250
export corrlengthtr=1250
export corrlengthsh=1250
export lnsigcutoffnh=1.25
export lnsigcutofftr=1.25
export lnsigcutoffsh=1.25
export lnsigcutoffpsnh=1.25
export lnsigcutoffpstr=1.25
export lnsigcutoffpssh=1.25
export lnsigcutoffsatnh=1.25  
export lnsigcutoffsattr=1.25  
export lnsigcutoffsatsh=1.25  
export obtimelnh=1.e30       
export obtimeltr=1.e30       
export obtimelsh=1.e30       
export readin_localization=.true.
export massbal_adjust=.false.
export lobsdiag_forenkf=.true.

export RES=384

# Assimilation parameters
export JCAP=878 
export LONB=1760  
export LATB=880  
export LONA=$LONB
export LATA=$LATB      
export ANALINC=6

export LEVS=63
export FHMIN=3
export FHMAX=9
export FHOUT=3
# other model variables set in ${rungfs}
# other gsi variables set in ${rungsi}

export SMOOTHINF=35
export npts=`expr \( $LONA \) \* \( $LATA \)`
export obs_datapath=${basedir}/gdas1bufr
export RUN=gdas1 # use gdas obs
export DOSFCANL="NO" # do surface analyis in rungsi script
export reducedgrid=.true.
export univaroz=.false.

export iassim_order=0

export covinflatemax=1.e2
export covinflatemin=1.0                                            
export analpertwtnh=0.8 
export analpertwtsh=0.8
export analpertwttr=0.8
export pseudo_rh=.true.
export use_qsatensmean=.true.
                                                                    
export letkf_flag=.false.
# read raw pe* files from GSI
#export npefiles=`expr $cores \/ $gsi_control_threads`
# read diag files from GSI (concatenated pe* files)
export npefiles=0
export sprd_tol=1.e30
export varqc=.false.
export huber=.false.
export zhuberleft=1.e10
export zhuberright=1.e10

export biasvar=-500
if [ $enkfonly == 'true' ];  then
   export lupd_satbiasc=.true.
   export numiter=4
else
   export lupd_satbiasc=.false.
   export numiter=1
fi
# use pre-generated bias files.
#export lupd_satbiasc=.false.
#export numiter=1


#export sprd_tol=10.
#export varqc=.true.
#export huber=.true.
#export zhuberleft=1.1
#export zhuberright=1.1
                                                                    
export nanals=80                                                    
                                                                    
export paoverpb_thresh=0.99 
export saterrfact=1.0
export deterministic=.true.
export sortinc=.true.
                                                                    
export nitermax=2

if [ "$machine" == 'theia' ]; then
   export FIXGLOBAL=/scratch4/NCEPDEV/global/save/glopara/svn/gfs/tags/global_shared.v13.0.2/fix/fix_am
   #export FIXFV3=/scratch3/BMC/gsienkf/whitaker/fv3gfs/branches/jwhitaker/fix
   #export FIXFV3=/scratch3/BMC/gsienkf/whitaker/fv3gfs/branches/pegion/global_shared.v15.0.0/fix
   export FIXFV3=/scratch4/NCEPDEV/global/save/glopara/svn/fv3gfs/fix_fv3
   #export gsipath=/scratch3/BMC/gsienkf/whitaker/gsi/EXP-enkfanavinfo
   export gsipath=/scratch3/BMC/gsienkf/whitaker/gsi/EXP-enkflinhx
   export gsiexec=${gsipath}/src/global_gsi
   export fixgsi=${gsipath}/fix
   export fixcrtm=${fixgsi}/crtm-2.2.3
   export FCSTEXEC=/scratch3/BMC/gsienkf/whitaker/fv3gfs/branches/pegion/global_shared.v15.0.0/sorc/fv3gfs.fd/BUILD/bin/fv3_gfs_nh.prod.32bit.x
   export utilexec=/scratch3/BMC/gsienkf/whitaker/gsi/trunk/util/exec/
   export enkfbin=${gsipath}/src/enkf/global_enkf
   export nemsioget=/scratch4/NCEPDEV/nems/save/Jun.Wang/nems/util/nemsio_get
elif [ "$machine" == 'wcoss' ]; then
   export FIXGLOBAL=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/gfs/global_shared.v13.2.0/fix/fix_am
   #export FIXFV3=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/fv3gfs/branches/jwhitaker/fix
   #export FIXFV3=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/fv3gfs/branches/pegion/global_shared.v15.0.0/fix
   export FIXFV3=/gpfs/hps/emc/global/noscrub/emc.glopara/svn/fv3gfs/fix_fv3
   export gsipath=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/gsi/EXP-enkflinhx
   export gsiexec=${gsipath}/src/global_gsi
   export fixgsi=${gsipath}/fix
   export fixcrtm=${fixgsi}/crtm-2.2.3
   #export FCSTEXEC=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/fv3gfs/branches/jwhitaker/sorc/fv3gfs.fd/BUILD/bin/fv3_gfs_nh.prod.32bit.x
   export FCSTEXEC=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/fv3gfs/branches/pegion/global_shared.v15.0.0/sorc/fv3gfs.fd/BUILD/bin/fv3_gfs_nh.prod.32bit.x
   export utilexec=/gpfs/hps/esrl/gefsrr/noscrub/Jeffrey.S.Whitaker/gsi/EXP-enkfanavinfo.save/util/bin
   export enkfbin=${gsipath}/src/enkf/global_enkf
   export nemsioget=/gpfs/hps/emc/global/noscrub/emc.glopara/svn/gfs/q3fy17_final/global_shared.v14.1.0/exec/nemsio_get
elif [ "$machine" == 'jet' ]; then
   echo "jet not yet supported"
   exit 1
else
   echo "${machine} unsupported machine"
   exit 1
fi

export enkfscripts="${basedir}/scripts/${exptname}"
export homedir="${basedir}/scripts/${exptname}"
export incdate="${enkfscripts}/incdate.sh"
export ANAVINFO=${enkfscripts}/global_anavinfo.l63.txt
export ANAVINFO_ENKF=${ANAVINFO}
export HYBENSLOC=${enkfscripts}/global_hybens_locinfo.l63.txt
export CONVINFO=${fixgsi}/global_convinfo.txt
export OZINFO=${fixgsi}/global_ozinfo.txt

# parameters for hybrid
export beta1_inv=0.125    # 0 means all ensemble, 1 means all 3DVar.
#export beta1_inv=0 # non-hybrid, pure ensemble
# these are only used if readin_localization=F
export s_ens_h=485      # a gaussian e-folding, similar to sqrt(0.15) times Gaspari-Cohn length
export s_ens_v=-0.485   # in lnp units.
# NOTE: most other GSI namelist variables are in ${rungsi}


export IAU=.false. 
export iaufhrs="6"
export enkfstatefhrs="3,6,9"
export SPPT=0.8
export SPPT_TSCALE=21600.
export SPPT_LSCALE=250.e3
export SHUM=0.006
export SHUM_TSCALE=21600.
export SHUM_LSCALE=250.e3

cd $enkfscripts
echo "run main driver script"
csh main.csh
