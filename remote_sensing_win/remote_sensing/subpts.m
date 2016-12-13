function subpts()
%Computing Sub-spacecraft and Sub-polar Points

% Read in meta kernel.
mk = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\mk\subpts.tm';
cspice_furnsh(mk);
fprintf('Meta Kernel Furnished \n')

% prompt user for input time string and convert to ET
utc = input('Enter desired time string: ', 's');
et = cspice_str2et(utc);
fprintf('Converting UTC input to ET seconds past J2000: %16.3f\n', et)

[spoint, trgepc, srfvec] = ...
    cspice_subpnt('Near point: ellipsoid', 'PHOEBE', ...
                et, 'IAU_PHOEBE', 'NONE', 'CASSINI');
fprintf(['   Apparent sub-observer point of CASSINI ', ...
         'on Phoebe in the\n',                         ...
         '   IAU_PHOEBE frame (km):\n']                   )
fprintf('      X = %16.3f\n', spoint(1))
fprintf('      Y = %16.3f\n', spoint(2))
fprintf('      Z = %16.3f\n', spoint(3))
fprintf('    ALT = %16.3f\n', norm(srfvec))

% compute apparent sub-solar point on Phoebe as seen from CASSINI
[spoint, tgrepc, srfvec] = ...
    cspice_subslr('Near point: ellipsoid', 'PHOEBE', ...
                  et, 'IAU_PHOEBE', 'LT+S', 'CASSINI'   );
fprintf(['   Apparent sub-solar point ',        ...
         'on Phoebe as seen from CASSINI in\n', ...
         '   the IAU_PHOEBE frame (km):\n']        )
fprintf('      X = %16.3f\n', spoint(1))
fprintf('      Y = %16.3f\n', spoint(2))
fprintf('      Z = %16.3f\n', spoint(3))

%unload kernels
cspice_unload(mk)
fprintf('Meta Kernel Unloaded \n')