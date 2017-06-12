% uname = getenv('USER');   % already defined
a = [roms.jgp_analysis_path,tmpfile];
b = [roms.hls_analysis_path,tmpfile];

if strcmp(roms.user,'jgpender')
    if ~exist(roms.jgp_analysis_path); eval(['! mkdir -p ',roms.jgp_analysis_path]);end;
    roms.files.(fname)=a;
    roms.analysis_path=roms.jgp_analysis_path;
end;

if strcmp(roms.user,'hsimmons')
    if exist(a);
        roms.files.(fname)=a;
    else
        if ~exist(roms.hls_analysis_path); eval(['! mkdir -p ',roms.hls_analysis_path]);end
        roms.files.(fname)=b;
    end;
end;


% if exist(a);
%   roms.files.(fname)=a;
% elseif exist(b)&strcmp(roms.user,'jgpender')  % JGP is running the script, use jgp_analysis_path
%   roms.files.(fname)=a;
% else
%   if ~exist(roms.hls_analysis_path);eval(['! mkdir -p ',roms.hls_analysis_path]);end
%   roms.files.(fname)=b;
% end

if  exist(roms.files.(fname));disp(['exists: ',roms.files.(fname)]);end
if ~exist(roms.files.(fname));disp(['does not exist, will create in: ',roms.files.(fname)]);end
