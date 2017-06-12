
if ~exist(roms.files.ubtfile);
    eval(['!ncrcat -v ubar,vbar ',roms.path,roms.region,'_his_*_',roms.writeTime,'*.nc ',roms.files.ubtfile]);done(['concatenating ',roms.files.ubtfile])
%     eval(['!ncrcat -v ubar,vbar ',roms.path,'/TS_his_*_hourly*.nc ',roms.files.ubtfile]);done(['concatenating ',roms.files.ubtfile])
%     eval(['!ncrcat -v ubar,vbar ',roms.path,'/TS_his2_*.nc ',roms.files.ubtfile]);done(['concatenating ',roms.files.ubtfile])
end
done('concatenate ubt')