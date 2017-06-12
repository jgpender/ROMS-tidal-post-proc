
%%
% roms.files.hpcfile     = sprintf([roms.analysis_path,'roms_hp_c_m_%i_%i_%i_%i.mat'],roms.lon0,roms.lon1,roms.lat0,roms.lat1);

% if ~exist(roms.files.hpcfile)
%
% for mm=1:nm
%  disp(['highpassing mode level ',num2str(mm)])
% % only read in data for our region and time range
% for jj = 1:ny
% cu(:,mm,jj,:)=highpass(sq(cu(:,mm,jj,:)),1/36,1,6);
% cv(:,mm,jj,:)=highpass(sq(cv(:,mm,jj,:)),1/36,1,6);
% cr(:,mm,jj,:)=highpass(sq(cr(:,mm,jj,:)),1/36,1,6);
% end % jj
% end % mm
% eval(['save -v7.3 ',roms.files.hpcfile,  ' cu cv cr  ctime'])
% else
%  eval(['load       ',roms.files.hpcfile, ' cu cv cr ctime'])
% end


if ~exist(roms.files.hpcufile)
    load(roms.files.cufile, 'cu');
    for mm=1:nm
        disp(['u highpassing mode level ',num2str(mm)])
        % only read in data for our region and time range
        for jj = 1:ny
            cu(:,mm,jj,:)=highpass(sq(cu(:,mm,jj,:)),1/36,1,6);
        end % jj
    end % mm
    eval(['save -v7.3 ',roms.files.hpcufile,  ' cu ctime '])
%     clearvars cu;
end

if ~exist(roms.files.hpcvfile)
    load(roms.files.cvfile, 'cv');
    for mm=1:nm
        disp(['v highpassing mode level ',num2str(mm)])
        % only read in data for our region and time range
        for jj = 1:ny
            cv(:,mm,jj,:)=highpass(sq(cv(:,mm,jj,:)),1/36,1,6);
        end % jj
    end % mm
    eval(['save -v7.3 ',roms.files.hpcvfile,  ' cv ctime '])
%     clearvars cv;
end

if ~exist(roms.files.hpcrfile)
    load(roms.files.crfile, 'cr');
    for mm=1:nm
        disp(['r highpassing mode level ',num2str(mm)])
        % only read in data for our region and time range
        for jj = 1:ny
            cr(:,mm,jj,:)=highpass(sq(cr(:,mm,jj,:)),1/36,1,6);
        end % jj
    end % mm
    eval(['save -v7.3 ',roms.files.hpcrfile,  ' cr ctime '])
%     clearvars cr;
end



%     eval(['load       ',roms.files.hpcufile, ' cu '])   
%     eval(['load       ',roms.files.hpcvfile, ' cv '])    
%     eval(['load       ',roms.files.hpcrfile, ' cr '])


aaa=5;
