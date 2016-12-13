function etwin()
% determine the window of ephemeris time provided by kernels and convert to
% UTC format. Change 'kernel' and spkcov object id to use for other
% scenario.

kernel = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\spk\030201AP_SK_SM546_T45.bsp';
% kernel = input('   Enter file path to desired Ephemeris (SPK) file:', 's');
% id     = input('   Enter object id code:', 's');
cspice_furnsh(kernel);
fprintf('Kernel Furnished \n')

% Define format date is displayed in.
[pictur, ok, error] = cspice_tpictr('2004 Jul 01 12:12:111');

% Start and stop times of spk file.
% replace -82 with id to implement desired object id
cover = cspice_spkcov(kernel, -82, 100)
fprintf('     Interval for provided SPK file:')
cspice_timout(cover', pictur)

% This should be used but for some reason errors about a different .bsp
% file: "The file de421.bsp does not exist."
% cspice_unload(kernel)