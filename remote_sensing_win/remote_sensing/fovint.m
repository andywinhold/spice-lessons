    function fovint()
% Intersecting Vectors with a Triaxial Ellipsoid (fovint)
% "Compute the intersection of the CASSINI ISS NAC camera boresight and
% field of view (FOV) boundary vectors with the surface of Phoebe."

mk = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\mk\fovint.tm';
bcvlen = 5;
cspice_furnsh(mk);
fprintf('Meta Kernel Furnished \n')

% store vector names, corneres of the FOV of NAC (i believe).
vecnam = { 'Boundary Corner 1',
           'Boundary Corner 2',
           'Boundary Corner 3',
           'Boundary Corner 4',
           'Cassini NAC Boresight' };

utc = input('   Enter  desired time string: ', 's');
et = cspice_str2et(utc);
fprintf('UTC in ET seconds past J2000: %16.3f\n', et)

% Get body code from body name for NAC.
[nacid, found] = cspice_bodn2c('CASSINI_ISS_NAC');

if ~found
    fprintf(['Unable to locate the ID code for ', ...
            'CASSINI_ISS_NAC\n'])
    return;
end

% Retrieve FOV parameters
[shape, frame, bsight, bounds] = cspice_getfov(nacid, bcvlen);
scan_vecs = [bounds, bsight];

% Perform same set of calculations for each vector in 'bounds'.
for vi = 1:5
    %determine coordinates of intersection of vector with surface of Phoebe
    [point, trgepc, srfvec, found] = ...
        cspice_sincpt('Ellipsoid','PHOEBE', et, 'IAU_PHOEBE', 'LT+S', ...
        'CASSINI', frame, scan_vecs(:,vi)                               );
    fprintf('Vector: %s\n', vecnam{vi})
    if ~found
        fprintf('No intersection point found at this epoch.')
    else
        fprintf(['  Position vector of surface intercept ', ...
                 'in the IAU_PHOEBE frame (km):\n']);
        fprintf('     X = %16.3f\n', point(1))
        fprintf('     Y = %16.3f\n', point(2))
        fprintf('     Z = %16.3f\n', point(3))
        
        [radius, lon, lat] = cspice_reclat(point);
        fprintf(['  Planetocentric coordinates of the ', ...
                 'intercept (deg):\n'                       ]);
        fprintf('     LAT = %16.3f\n', lat * cspice_dpr);
        fprintf('     LON = %16.3f\n', lon * cspice_dpr);
        
        % Compute illumination angles at this point
        [trgepc, srfvec, phase, solar, emissn] =           ...
            cspice_ilumin('Ellipsoid', 'PHOEBE', et,       ...
                          'IAU_PHOEBE', 'LT+S', 'CASSINI', ...
                          point                               );
        fprintf(['  Phase angle (deg):',          ...
                 '             %14.3f\n'],        ...
                 phase * cspice_dpr                 );
        fprintf(['  Solar incidence angle (deg):',...
                 '   %14.3f\n'],                  ...
                solar * cspice_dpr                   );
        fprintf(['  Emission angle (deg):',       ...
                 '          %14.3f\n'],           ...
                 emissn * cspice_dpr                 );
    end
    fprintf('\n');
end

% Compute local solar time at boresight intersection
if found
    [phoeid, found] = cspice_bodn2c('PHOEBE');
    if ~found
        fprintf('Unable to locate the ID code for Phoebe.')
        return
    end
% Compute local solar time corresponding to the TDB light time corrected
% epoch at the intercept.
[hr, min, sc, time, ampm] = ...
    cspice_et2lst(trgepc, phoeid, lon, 'PLANETOCENTRIC');
fprintf(['  Local Solar Time at boresight ', ...
         'intercept (24 Hour Clock):\n',     ...
         '    %s\n'],                        ...
         time                                   )
else
    fprintf(['  No boresight intercept to compute ', ...
             'local solar time.']                       )
end

cspice_unload(mk);
fprintf('Meta Kernel Unloaded \n')
         