# ROMS-tidal-post-proc

The idea is to fire up 
	ROMS_drive_F_C.m
in matlab and run. You might have to fiddle with some of the paths.

This version is the first I've used on chinook. For some reason the
	clearvars 
command wasn't working so I had to comment all those lines out. The
idea behind the clearvars command was simply to free up some memory.

You can run matlab in batch mode on chinook. This wasn't available on 
pacman. All you have to do is embed a single command in an sbat file, 
like this:


chinook01 % m ../ROMSbatch/ROMSbatch.sbat 
#!/bin/csh
#SBATCH --partition=t1standard
#SBATCH --ntasks=1
#SBATCH --mail-user=jgpender@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --time=10:00:00
#SBATCH --output=roms.%j
source ~/.runROMSintel
matlab -nodisplay -nosplash < ROMS_drive_F_C.m


and then type
	sbatch ROMSbatch.sbat
