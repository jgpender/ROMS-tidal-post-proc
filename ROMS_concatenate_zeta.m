

if ~exist(roms.files.zetafile);
%     eval(['!ncrcat -v zeta ',roms.path,'/TS_his2_*.nc ',roms.files.zetafile]);done(['concatenating ',roms.files.zetafile])
%     eval(['!ncrcat -v zeta ',roms.path,'/TS_his_*_hourly*.nc ',roms.files.zetafile]);done(['concatenating ',roms.files.zetafile])
    eval(['!ncrcat -v zeta ',roms.path,roms.region,'_his_*_',roms.writeTime,'*.nc ',roms.files.zetafile]);done(['concatenating ',roms.files.zetafile])
end

done('concatenate zeta')
