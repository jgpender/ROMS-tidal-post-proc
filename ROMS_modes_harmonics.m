function ROMS_modes_harmonics(roms)

outfile = roms.files.modes_harmonics_file
%%
if ~exist(outfile)
%%
disp([outfile,' does not exist, rerunning analysis'])
consts=tide_freqs;
files=roms.files;
disp('loading data')

 lon=roms.grd.lon_rho;
 lat=roms.grd.lat_rho;
 idxs = find(roms.grd.lon_rho(1,:)>=roms.lon0&roms.grd.lon_rho(1,:)<=roms.lon1);
 jdxs = find(roms.grd.lat_rho(:,1)>=roms.lat0&roms.grd.lat_rho(:,1)<=roms.lat1);lon=roms.grd.lon_rho(jdxs,idxs);lat=roms.grd.lat_rho(jdxs,idxs); 
 
 H  = roms.grd.h  (  jdxs,idxs);
 DZ = roms.grd.dzr(:,jdxs,idxs);

NY = length(jdxs);
NX = length(idxs);
NZ=  roms.grd.N;
sz=[NZ NY NX];

%% fill eigenfunction matrices over domain
%keyboard
%%
nModes=roms.nm;


% roms_modes = load(roms.files.cfile)
% dum=load(roms.files.cufile);roms_modes.cu=dum.cu;clearvars dum;
% dum=load(roms.files.cvfile);roms_modes.cv=dum.cv;clearvars dum;
% dum=load(roms.files.crfile);roms_modes.cr=dum.cr;roms_modes.ctime=dum.ctime;clearvars dum

done('loading eigenmodes')

%% fit spectral weigths to specific frequencies
%%
%keyboard
%%
ROMS_concatenate_zeta
%%
load(roms.files.C_hp_file,'ocean_time_rho');time=ocean_time_rho(:);
ETAN   = nc_varget(files.zetafile ,'zeta'  ,[0,jdxs(1)-1,idxs(1)-1],[-1,NY,NX]);
Ubar   = nc_varget(files.ubtfile  ,'ubar'  ,[0,jdxs(1)-1,idxs(1)-1],[-1,NY,NX]);
Vbar   = nc_varget(files.ubtfile  ,'vbar'  ,[0,jdxs(1)-1,idxs(1)-1],[-1,NY,NX]);
%%
omega = [1/consts.m2.T 1/consts.s2.T 1/consts.o1.T 1/consts.k1.T];                  % [cycles per hour]
clear amp* pha*
intime = (time(:)-datenum(roms.year,1,1))*24;


load(roms.files.cufile);
for mdx = [1:roms.nm];disp(['u fit weights to specific frequencies mode = ',num2str(mdx)])
  for jj = 1:NY;
	[ampu(:,mdx,jj,:),phau(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(cu(:,mdx,jj,:)),omega);	
% 	[ampv(:,mdx,jj,:),phav(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(roms_modes.cv(:,mdx,jj,:)),omega);	
% 	[ampr(:,mdx,jj,:),phar(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(roms_modes.cr(:,mdx,jj,:)),omega);	
  end % NY
end % mdx
% clearvars cu;

load(roms.files.cvfile);
for mdx = [1:roms.nm];disp(['v fit weights to specific frequencies mode = ',num2str(mdx)])
  for jj = 1:NY;
% 	[ampu(:,mdx,jj,:),phau(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(cu(:,mdx,jj,:)),omega);	
	[ampv(:,mdx,jj,:),phav(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(cv(:,mdx,jj,:)),omega);	
% 	[ampr(:,mdx,jj,:),phar(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(roms_modes.cr(:,mdx,jj,:)),omega);	
  end % NY
end % mdx
% clearvars cv;


load(roms.files.crfile);
for mdx = [1:roms.nm];disp(['r fit weights to specific frequencies mode = ',num2str(mdx)])
  for jj = 1:NY;
% 	[ampu(:,mdx,jj,:),phau(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(cu(:,mdx,jj,:)),omega);	
% 	[ampv(:,mdx,jj,:),phav(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(roms_modes.cv(:,mdx,jj,:)),omega);	
	[ampr(:,mdx,jj,:),phar(:,mdx,jj,:)]=ROMS_harmonic_fit(intime,squeeze(cr(:,mdx,jj,:)),omega);	
  end % NY
end % mdx
% clearvars cr;

%%
intime = roms_get_date(roms.files.ubtfile);intime = (intime(:)-datenum(roms.year,1,1))*24;
for jj = 1:NY;
	[ampzbt(:,jj,:),phazbt(:,jj,:)]=ROMS_harmonic_fit(intime,squeeze(ETAN(:,jj,:)),omega);	
	[ampubt(:,jj,:),phaubt(:,jj,:)]=ROMS_harmonic_fit(intime,squeeze(Ubar(:,jj,:)),omega);	
	[ampvbt(:,jj,:),phavbt(:,jj,:)]=ROMS_harmonic_fit(intime,squeeze(Vbar(:,jj,:)),omega);	
end
ampu=squeeze(ampu)    ;phau=squeeze(phau);
ampv=squeeze(ampv)    ;phav=squeeze(phav);
ampubt=squeeze(ampubt);phaubt=squeeze(phaubt);
ampvbt=squeeze(ampvbt);phavbt=squeeze(phavbt);
ampzbt=squeeze(ampzbt);phazbt=squeeze(phazbt);
ampr=squeeze(ampr)    ;phar=squeeze(phar);
%ampd=squeeze(ampd)    ;phad=squeeze(phad);

%%
% roms.Ce     = Ce;
% roms.dmodes = dmodes;

roms_modes.ampr  = ampr;
roms_modes.phar  = phar;
%roms_modes.ampd  = ampd;
%roms_modes.phad  = phad;
roms_modes.ampu  = ampu;
roms_modes.phau  = phau;
roms_modes.ampv  = ampv;
roms_modes.phav  = phav;

roms_modes.ampubt = ampubt;
roms_modes.phaubt = phaubt;
roms_modes.ampvbt = ampvbt;
roms_modes.phavbt = phavbt;
roms_modes.ampzbt = ampzbt;
roms_modes.phazbt = phazbt;

% roms_modes.idxs = idxs;
% roms_modes.jdxs = jdxs;
% roms_modes.NX   = NX;
% roms_modes.NY   = NY;
% roms_modes.X    = roms_modes.X(idxs);
% roms_modes.Y    = roms_modes.Y(jdxs);
% roms_modes.Z    = roms_modes.Z(:,jdxs,idxs);
% roms_modes.DZ   = roms_modes.DZ(:,jdxs,idxs);
% 
roms_modes.omega=omega;
roms_modes.H=H;

%roms_modes.lon0 = lon0;
%roms_modes.lon1 = lon1;
%roms_modes.lat0 = lat0;
%roms_modes.lat1 = lat1;
% roms_modes.t0=t0;
% roms_modes.t1=t1;
% roms_modes.tdx=tdx;
%%
% roms_modes.delX    = data.delX(idxs);
% roms_modes.delY    = data.delY(jdxs);
% roms_modes.LON     = data.Lon(jdxs,idxs);
% roms_modes.LAT     = data.Lat(jdxs,idxs);
% roms_modes.alphaT  = data.alphaT;
% roms_modes.Tref    = data.Tref;
% roms_modes.N2      = data.N2;
% roms_modes.Tinit   = data.Tinit(:,1,1);
% roms_modes.rho0    = data.rho0;
% roms_modes.rho0ofZ = data.rho0ofZ;

% disp(['save ',outfile,' -v7.3 -struct roms_modes'])
% eval(['save ',outfile,' -v7.3 -struct roms_modes']);done

disp(['save ',outfile,' -v7.3 -struct roms_modes'])
eval(['save ',outfile,' -v7.3 -struct roms_modes']);done
%%
else
    disp(['already computed: ',outfile])
   disp(['load ',outfile])
%   roms_modes = load(outfile,'*');done
  roms_modes = load(outfile);done
end % if run already
