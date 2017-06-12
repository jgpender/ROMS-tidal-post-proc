clear;

% JGP modified so I can run the script in the same directory as the
% original ROMS output

roms.user=getenv('USER');
if strcmp(roms.user, 'jgpender')
    dirname=pwd;
    cd ..
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev');
    myExpt=dum2(1:end-1);
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev | cut -d "_" -f1');
    roms.region=dum2(1:end-1);
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev | cut -d "_" -f2');
    roms.res=['_',dum2(1:end-1)]; 
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev | cut -d "_" -f3');
    roms.year=str2num(dum2(1:end-1));
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev | cut -d "_" -f4-10');
    roms.expname_suffix=['_',dum2(1:end-1)];
    
    if strcmp(roms.region, 'TS')
        roms.lon0 = 146;roms.lon1 = 169;roms.lat0 = -55;roms.lat1 =-38 ;
    end;
    
    if strcmp(roms.region, 'FLEAT')
        roms.lon0 = 105; roms.lon1 = 150; roms.lat0 = 0; roms.lat1 = 25;
    end;

    roms.nm=3;
    
%     roms.jgp_base  = '/import/c/w/jgpender/roms-kate_svn/';

    [~,dum2]=unix('pwd |rev | cut -d "/" -f4-10 | rev');
    roms.jgp_base=[dum2(1:end-1),'/'];
    
    roms.cdfdir = '/hourlySet/';
    
    [dum1,dum2]=unix('pwd |rev | cut -d "/" -f1 | rev | cut -d "_" -f5');
    tideFlag=dum2(1:end-1);
    if length( strfind(myExpt,'tidesOnly') ) ==1
        roms.type='tideonly';
    else
        roms.type='meso+tides';
    end;
    
    cd(dirname);
    
else
    %/import/c/w/jgpender/roms-kate_svn/TS_0.125/Experiments/TS_0.125_2012_001_TidesM2_10plus5_meso/
    cd ~/PROJ/TTide/MFILES/;
    
    roms.region = 'TS';roms.res = '_0.125';
    roms.lon0 = 146;roms.lon1 = 169;roms.lat0 = -55;roms.lat1 =-38 ;
    roms.nm=3;roms.type='meso+tides';
    roms.jgp_base  = '/import/c/w/jgpender/roms-kate_svn/';
    roms.cdfdir = '/hourlySet/';
    roms.year=2012 ;roms.expname_suffix  = '_001_TidesM2_10plus5_meso';
end;

% !!!!!!! choose whether you want to use daily writes or hourly writes
roms.writeTime = 'hourly';



roms

%%

roms = ROMS_get_files(roms);
ROMS_F_hp_helper_m(roms);done('ROMS_F')
ROMS_C_hp_helper_m(roms);done('ROMS_C')

% new stuff
ROMS_modes_harmonics(roms)
ROMS_modes_harmonics_F_C(roms)

done('jgp')
