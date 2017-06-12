#! /bin/csh
set echo

set exp1  = BoB_0.03125 
set exp2  = BoB_0.03125_2013_305_Tides_All_20days_Runoff_mod4_S2E2
set exp2  = BoB_0.03125_2013_320_Tides_All_20days_Runoff_mod4_S2E2
#set exp2  = BoB_0.03125_2013_335_Tides_All_20days_Runoff_mod4_S2E2
#set exp2  = BoB_0.03125_2013_350_Tides_All_20days_Runoff_mod4_S2E2
set his_name = BoB_his_2013
set his2_name = BoB_his2_2013
set base1 = /import/c/w/jgpender/roms-kate_svn/
set base2 = /import/archive/u1/uaf/hsimmons/PROJ/MODELS
set src   = $base1/$exp1/Experiments/$exp2/netcdfOutput/
set dest  = $base2/$exp1/Experiments/$exp2/netcdfOutput/
set gfile = $src/../../../InputFiles/Gridpak/BoB_grid5.nc

mkdir -p $dest;cd $dest


foreach var (zeta ubar vbar u v temp salt Hsbl shfluxd ssflux swrad latent sensible lwrad sustr svstr)
echo $var
 if (! -e   $var\_.nc)  ncrcat -v $var $src/*$his2_name* $var\_$his2_name.nc
end 

cp $gfile $dest

foreach var (zeta ubar vbar u v temp salt Hsbl shfluxd ssflux swrad latent sensible lwrad sustr svstr)
echo $var
 if (! -e   $var\_.nc)  ncrcat -v $var $src/*$his2_name* $var\_$his2_name.nc
end 






