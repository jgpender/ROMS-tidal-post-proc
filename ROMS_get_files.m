function roms = ROMS_get_files(roms)

%%
roms.exptype   = [roms.region,roms.res];
roms.hls_base          = '/archive/u1/uaf/hsimmons/PROJ/MODELS/ROMS/roms-kate_svn/';
roms.expdir = ['/',roms.exptype,'_',num2str(roms.year),roms.expname_suffix]
%%

% jgp kludge
roms.avg_name         = [roms.region,'_avg_' ];
roms.his_hourly_name  = [roms.region,'_his_' ,'hourly'];
roms.his_name         = [roms.region,'_his_' ];
roms.his_daily_name   = [roms.region,'_his_' ,'daily'];
% % roms.his2_name        = [roms.region,'_his2_',num2str(roms.year)];
% roms.avg_name         = [roms.region,'_avg_' ,num2str(roms.year)];
% roms.his_hourly_name  = [roms.region,'_his_' ,num2str(roms.year),'_hourly'];
% roms.his_name         = [roms.region,'_his_' ,num2str(roms.year)];
% roms.his_daily_name   = [roms.region,'_his_' ,num2str(roms.year),'_daily'];



roms.gname            = [roms.exptype,'.nc'];



if strcmp(roms.user, 'jgpender')
    roms.path = [roms.jgp_base,'/',roms.exptype,'/Experiments/',roms.expdir,roms.cdfdir]
else
    roms.path = [roms.hls_base,'/',roms.exptype,'/Experiments/',roms.expdir,roms.cdfdir]
end;


%%
%keyboard
%%
if ~exist(roms.path);error(['bad path: ',roms.path]);end


roms.jgp_analysis_path = [roms.jgp_base,'/',roms.exptype,'/Experiments/',roms.expdir,'/Analysis/'];
roms.hls_analysis_path = [roms.hls_base,'/',roms.exptype,'/Experiments/',roms.expdir,'/Analysis/'];

roms.files.gfile  = [roms.path,'/../',roms.gname];

tmpfiles = [roms.path,roms.his_daily_name,'*.nc'];
tmp=dir(tmpfiles) ;
for idx=1:length(tmp);roms.files.his_daily_files{idx}=[roms.path,tmp(idx).name];end

tmpfiles = [roms.path,roms.his_hourly_name,'*.nc'];
tmp=dir(tmpfiles) ;
for idx=1:length(tmp);
    roms.files.his_hourly_files{idx}=[roms.path,tmp(idx).name];
end
%%
if ~isfield(roms.files,'his_hourly_files')
    tmpfiles = [roms.path,roms.his_name,'*.nc'];
    tmp=dir(tmpfiles) ;
    for idx=1:length(tmp);
        roms.files.his_hourly_files{idx}=[roms.path,tmp(idx).name];disp(roms.files.his_hourly_files{idx});
    end
end
%%
tmp=dir([roms.path,roms.avg_name,'*.nc']) ;
for idx=1:length(tmp);roms.files.avg_files{idx}=[roms.path,tmp(idx).name];end

% tmp=dir([roms.path,roms.his2_name,'*.nc']);
% for idx=1:length(tmp);roms.files.his2_files{idx}=[roms.path,tmp(idx).name];end
%%

% jgp kludge
if isfield(roms.files,'his_daily_files');hfile = roms.files.his_daily_files{1};else;hfile = roms.files.his_hourly_files{1};end
% hfile = '../set3_days11_15/TS_his_00722.nc';
% jgp end kludge

roms.grd           = roms_get_grid(roms.files.gfile,hfile,0,1);%done('roms_get_grid')
[~,~,roms.grd.dzu] = roms_zint(sq(nc_varget(hfile,'u'   )),roms.grd);
[~,~,roms.grd.dzv] = roms_zint(sq(nc_varget(hfile,'v'   )),roms.grd);
[~,~,roms.grd.dzr] = roms_zint(sq(nc_varget(hfile,'temp')),roms.grd);
%%
% check for the existence of analysis files first in jgp_analysis_path and hls_analysis_path
% if they do not exist in jgp_analysis_path and user is jgp then point fileto jgp directories.
% If user is hls and they are not in jgp dirs, point to hls
tmpfile = sprintf('roms_C_hp_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1) ;fname = 'C_hp_file'              ;ROMS_locate_analysis_path

% tmpfile = sprintf('roms_F_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)    ;fname = 'Ffile'                  ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_Fu_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)    ;fname = 'Fufile'                  ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_Fv_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)    ;fname = 'Fvfile'                  ;ROMS_locate_analysis_path

tmpfile = sprintf('N20_%d_%d_%d_%d.mat'     ,roms.lon0,roms.lon1,roms.lat0,roms.lat1)    ;fname = 'N20_file'               ;ROMS_locate_analysis_path

% tmpfile = sprintf('roms_c_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)   ;fname = 'cfile'                  ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_cu_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)   ;fname = 'cufile'                 ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_cv_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)   ;fname = 'cvfile'                 ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_cr_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)   ;fname = 'crfile'                 ;ROMS_locate_analysis_path

% tmpfile = sprintf('roms_hp_c_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1) ;fname = 'hpcfile'                ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_hp_cu_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1) ;fname = 'hpcufile'                ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_hp_cv_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1) ;fname = 'hpcvfile'                ;ROMS_locate_analysis_path
tmpfile = sprintf('roms_hp_cr_m_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1) ;fname = 'hpcrfile'                ;ROMS_locate_analysis_path

tmpfile = sprintf('hp_ubt_%d_%d_%d_%d.nc',roms.lon0,roms.lon1,roms.lat0,roms.lat1)       ;fname = 'hpubtfile'              ;ROMS_locate_analysis_path
tmpfile = sprintf('hp_vbt_%d_%d_%d_%d.nc',roms.lon0,roms.lon1,roms.lat0,roms.lat1)       ;fname = 'hpvbtfile'              ;ROMS_locate_analysis_path
tmpfile = sprintf('psi_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1)         ;fname = 'psi_file'               ;ROMS_locate_analysis_path
tmpfile =         'ubt_vbt.nc'                                                           ;fname = 'ubtfile'                ;ROMS_locate_analysis_path
tmpfile =         'zeta.nc'                                                              ;fname = 'zetafile'               ;ROMS_locate_analysis_path
tmpfile = sprintf('modes_harmonics_%d_%d_%d_%d.mat'    ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);fname = 'modes_harmonics_file';ROMS_locate_analysis_path
tmpfile = sprintf('F_C_modes_harmonics_%d_%d_%d_%d.mat',roms.lon0,roms.lon1,roms.lat0,roms.lat1);fname = 'F_C_modes_harmonics_file';ROMS_locate_analysis_path
