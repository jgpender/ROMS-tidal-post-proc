
% roms.files.cfile       = sprintf([roms.analysis_path,'roms_c_m_%i_%i_%i_%i.mat']   ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);

roms.files.cufile       = sprintf([roms.analysis_path,'roms_cu_m_%i_%i_%i_%i.mat']   ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.cvfile       = sprintf([roms.analysis_path,'roms_cv_m_%i_%i_%i_%i.mat']   ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);
roms.files.crfile       = sprintf([roms.analysis_path,'roms_cr_m_%i_%i_%i_%i.mat']   ,roms.lon0,roms.lon1,roms.lat0,roms.lat1);

%% FIRST DO U

if ~exist(roms.files.cufile)
    nt = length(nc_varget(roms.files.hprhofile,'ocean_time')); ans=1;
    cu=nan*ones(nt,nm,ny,nx);
    
    cnt=1;
    for tdx = 1:nt;disp(['fitting u to eigenfunctions, file ',num2str(tdx),' of ',num2str(nt)])
        tmpu       = sq(nc_varget(roms.files.his_hourly_files{tdx},'u'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)  ,length(idxs)+1]) );
        uatr = flipdim((tmpu(:,:      ,1:end-1)+tmpu(:,:    ,2:end))/2,1);
        ctime(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_hourly_files{tdx} ,'ocean_time')/86400;
        %%
        for ii = 1:nx;
            for jj = 1:ny;
                if  ~isnan(psi.pmodes(1,1,jj,ii))
                    tmppsi = psi.pmodes(:,1:nm,jj,ii);
                    datu = (uatr(:,jj,ii));
                    cu(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datu);
                end
            end; % jj
        end; % ii
        cnt=cnt+1;
    end;
        eval(['save -v7.3 ',roms.files.cufile, ' cu ctime '])
%         clearvars cu;
    
end

%% THEN DO V

if ~exist(roms.files.cvfile)
    nt = length(nc_varget(roms.files.hprhofile,'ocean_time')); ans=1;
    cv=nan*ones(nt,nm,ny,nx);
    
    cnt=1;
    for tdx = 1:nt;disp(['fitting v to eigenfunctions, file ',num2str(tdx),' of ',num2str(nt)])
        tmpv       = sq(nc_varget(roms.files.his_hourly_files{tdx},'v'   ,[0,0,jdxs(1)-1,idxs(1)-1],[-1,-1,length(jdxs)+1,length(idxs)  ]) );
        vatr = flipdim((tmpv(:,1:end-1,:      )+tmpv(:,2:end,:    ))/2,1);
        ctime(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_hourly_files{tdx} ,'ocean_time')/86400;
        %%
        for ii = 1:nx;
            for jj = 1:ny;
                if  ~isnan(psi.pmodes(1,1,jj,ii))
                    tmppsi = psi.pmodes(:,1:nm,jj,ii);
                    datv = (vatr(:,jj,ii));
                    cv(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datv);
                end
            end; % jj
        end; % ii
        cnt=cnt+1;
    end;
    eval(['save -v7.3 ',roms.files.cvfile, ' cv  ctime '])
%     clearvars cv;
end;


%% THEN DO R
if ~exist(roms.files.crfile)
    
    nt = length(nc_varget(roms.files.hprhofile,'ocean_time')); ans=1;
    cr=nan*ones(nt,nm,ny,nx);
    
    cnt=1;
    for tdx = 1:nt;disp(['fitting r to eigenfunctions, file ',num2str(tdx),' of ',num2str(nt)])
        rhohp       = flipdim(sq(nc_varget(roms.files.hprhofile,'rho_hp'   ,[tdx-1,0,0,0],[1,-1,-1,-1]) ) ,1);
        ctime(cnt) = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.his_hourly_files{tdx} ,'ocean_time')/86400;
        %%
        for ii = 1:nx;
            for jj = 1:ny;
                if  ~isnan(psi.rmodes(1,1,jj,ii))
                    tmppsi = psi.rmodes(:,1:nm,jj,ii);
                    datr   = (rhohp(:,jj,ii));
                    cr(cnt,:,jj,ii) = (tmppsi'*tmppsi)\(tmppsi'*datr);
                end
            end; % jj
        end; % ii
        cnt=cnt+1;
    end
    eval(['save -v7.3 ',roms.files.crfile,' cr ctime '])
%     clearvars cr;
    
end;

%% LOAD IN ROMS_MODES

% roms_modes = load(roms.files.cfile);
% load(roms.files.cufile, 'cu');
% load(roms.files.cvfile, 'cv');
% load(roms.files.crfile, 'cr');
load(roms.files.crfile, 'ctime');