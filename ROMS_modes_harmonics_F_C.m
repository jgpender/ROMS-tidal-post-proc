function ROMS_modes_harmonics_F(roms)

% take tidally regressed data from  ROMS_modes_harmonics and reconstruct
% energy flux (F) and conversion (C), mode by mode, for each roms.omega
infile  = roms.files.modes_harmonics_file;
outfile = roms.files.F_C_modes_harmonics_file;
if ~exist(infile)
    error('Run ROMS_modes_harmonics first')
    return
end 
%%
load(roms.files.modes_harmonics_file);
load(roms.files.psi_file)
%%    
%[                omega,           ampu,           ampv,           ampr,           phau,           phav,           phar,           ampubt,           ampvbt,          phaubt,            phavbt,           DZ,           H]=...
% deal(roms_modes.omega,roms_modes.ampu,roms_modes.ampv,roms_modes.ampr,roms_modes.phau,roms_modes.phav,roms_modes.phar,roms_modes.ampubt,roms_modes.ampvbt,roms_modes.phaubt,roms_modes.phavbt,roms_modes.DZ,roms_modes.H);
% [                omega,           ampu,           ampv,           ampr,           phau,           phav,           phar,           ampubt,           ampvbt,          phaubt,            phavbt]=...
%  deal(roms_modes.omega,roms_modes.ampu,roms_modes.ampv,roms_modes.ampr,roms_modes.phau,roms_modes.phav,roms_modes.phar,roms_modes.ampubt,roms_modes.ampvbt,roms_modes.phaubt,roms_modes.phavbt);
%%
if ~exist(outfile)
%% compute energy flux & conversion by reconstruct a 1 period timeseries from harmonic fits

% set up some grid metrics and masks for conversion calculation
lon0 =roms.lon0;
lon1 =roms.lon1;
lat0 =roms.lat0;
lat1 =roms.lat1;

lon=roms.grd.lon_rho(2:end-1,2:end-1);
lat=roms.grd.lat_rho(2:end-1,2:end-1);
idxs = find(lon(1,:)>=lon0&lon(1,:)<=lon1);
jdxs = find(lat(:,1)>=lat0&lat(:,1)<=lat1);
roms.idxs=idxs;
roms.jdxs=jdxs;
H   = roms.grd.h  ;H   =   H(  2:end-1,2:end-1);  H = sq(  H(  jdxs,idxs));
z   =-flipdim(roms.grd.z_r,1);z   =   z(:,2:end-1,2:end-1);  z = sq(  z(:,jdxs,idxs));
dzr = flipdim(roms.grd.dzr,1);dzr = dzr(:,2:end-1,2:end-1);dzr = sq(dzr(:,jdxs,idxs));
%dzu = roms.grd.dzu;dzu = dzu(:,2:end-1,2:end-1);dzu = sq(dzu(:,jdxs,idxs)); 
%dzv = roms.grd.dzv;dzv = dzv(:,2:end-1,2:end-1);dzv = sq(dzv(:,jdxs,idxs)); 
xu       = nc_varget(roms.files.gfile,'x_u'   ,[jdxs(1)-1,idxs(1)-1],[length(jdxs)  ,length(idxs)+1]);
yv       = nc_varget(roms.files.gfile,'y_v'   ,[jdxs(1)-1,idxs(1)-1],[length(jdxs)+1,length(idxs)  ]);
dxr = diff(xu,1,2);
dyr = diff(yv,1,1);
[dDdx,dDdy]=gradient(H);dDdx=dDdx./dxr;dDdy=dDdy./dyr;

lon = lon(jdxs,idxs);
lat = lat(jdxs,idxs);
roms.lon = lon;
roms.lat = lat;
nz=length(z(:,1,1));nx=length(idxs);ny=length(jdxs);nm=roms.nm;

cdxs=1:length(omega)
clear Fu Fv Clin
%%
nt = 24;
for lcdx = 1:length(cdxs); % loop over frequencies
    cdx=cdxs(lcdx);
    t=linspace(0,1/omega(cdx),nt);
for mdx=1:roms.nm% 
    disp([' computing energy flux, mode mdx = ',num2str(mdx),' frequency = 1/',num2str(1/omega(cdx))])
for ii=1:nx;
    for jj=1:ny;
        
        tmppsi = sq(pmodes(:,mdx,jj,ii))'  ;u = ampu(cdx,mdx,jj,ii) * cos(2*pi*omega(cdx)*t + phau(cdx,mdx,jj,ii));u_r = tmppsi'*u;% NZ x length(t) reconstruction
                                            v = ampv(cdx,mdx,jj,ii) * cos(2*pi*omega(cdx)*t + phav(cdx,mdx,jj,ii));v_r = tmppsi'*v;
        tmppsi = sq(rmodes(:,mdx,jj,ii))';  r = ampr(cdx,mdx,jj,ii) * cos(2*pi*omega(cdx)*t + phar(cdx,mdx,jj,ii));r_r = tmppsi'*r;
ubt_r = ampubt (cdx,jj,ii) * cos(2*pi*omega(cdx)*t + phaubt(cdx,jj,ii));
vbt_r = ampvbt (cdx,jj,ii) * cos(2*pi*omega(cdx)*t + phavbt(cdx,jj,ii));
dz    = repmat(dzr(:,jj,ii),1,nt);%(repmat(sq(DZ(:,jj,ii)),1,length(t))); 
p_anom = 9.8*cumsum(r_r.*dz);

pbt = squeeze(nansum(p_anom.*dz))./H(jj,ii); pPR=p_anom-repmat(pbt,length(dz),1);

% Clin
pPR_bot = pPR(end,:);
wbt     = ubt_r.*dDdx(jj,ii)+vbt_r.*dDdy(jj,ii);
if mdx == 1;Clin(lcdx,:,jj,ii) = (pPR_bot.*wbt);end % we only compute Clin for m=1;
Fu  (lcdx,mdx,:,jj,ii) = squeeze(nansum(u_r.*pPR.*dz));
Fv  (lcdx,mdx,:,jj,ii) = squeeze(nansum(v_r.*pPR.*dz));

%%
% tmppsi = sq(pmodes(mdx,:,jj,ii))  ;u = ampu(cdx,mdx,jj,ii);
%                                    v = ampv(cdx,mdx,jj,ii);
%                                    u_r = tmppsi'*u; 
%                                    v_r = tmppsi'*v;
% tmppsi = sq(rmodes(mdx,:,jj,ii));  r   = ampr(cdx,mdx,jj,ii);r_r = tmppsi'*r;
% KE(mdx,cdx,jj,ii)   = .5*sq(sum(0.5*1020*(u_r.^2+v_r.^2).*dz(:,1)))./roms.H(jj,ii); % .5 * ... because mean (u^2 + v^2) = .5 ampu + .5 ampv
% PE(mdx,cdx,jj,ii)   = .5*sq(sum((0.5*(r_r.^2*9.8^2)./(1020*roms.N2)).*dz(:,1)))/roms.H(jj,ii);

    end % jj
end % ii
end % mdx
end % cdx
%%
ta_Fu   = sq(mean(Fu  ,3));
ta_Fv   = sq(mean(Fv  ,3));
ta_Clin = sq(mean(Clin,2));
%roms.KE   = KE;
%roms.APE  = APE;
%%
disp(['save ',outfile,' -v7.3 Fu Fv Clin ta_Fu ta_Fv ta_Clin omega'])
eval(['save ',outfile,' -v7.3 Fu Fv Clin ta_Fu ta_Fv ta_Clin omega']);done
%%
else
    disp(['exists: ',outfile])
%    disp(['load ',outfile])
%    eval(['load ',outfile]);done
end % if run already
