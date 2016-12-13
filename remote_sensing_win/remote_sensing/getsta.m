function getsta()
% remote sensing lesson

% furnsh files from meta kernel
mk = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\mk\getsta.tm';
cspice_furnsh(mk)
fprintf ('Meta Kernel Furnished \n')

timstr = input ('Input desired time string: ', 's');

et = cspice_str2et(timstr);
fprintf('Time string converted to ET seconds past J2000 : %16.3f\n', et)

% Apparent state of Phoeve as seen from CASSINI
[state, ltime] = cspice_spkezr('PHOEBE', et, 'J2000', 'LT+S', 'CASSINI');
fprintf ( [ '   Apparent state of Phoebe as seen ', ...
               'from CASSINI in the J2000\n',          ...
               '      frame (km, km/s):\n']                )
 
   fprintf ( '      X = %16.3f\n', state(1) )
   fprintf ( '      Y = %16.3f\n', state(2) )
   fprintf ( '      Z = %16.3f\n', state(3) )
   fprintf ( '     VX = %16.3f\n', state(4) )
   fprintf ( '     VY = %16.3f\n', state(5) )
   fprintf ( '     VZ = %16.3f\n', state(6) )

% Apparent position of Earth as seen from CASSINI
[pos, ltime2] = cspice_spkpos('EARTH', et, 'J2000', 'LT+S', 'CASSINI');
fprintf ( [ '   Apparent position of Earth as seen ', ...
            'from CASSINI in the J2000\n',            ...
            '      frame (km):\n' ]                                   )
        fprintf( '      X = %16.3f\n', pos(1) )
        fprintf( '      Y = %16.3f\n', pos(2) )
        fprintf( '      Z = %16.3f\n', pos(3) )
        
fprintf( [ '   One way light time between CASSINI ', ...
           'and the apparent position\n',             ...
           '      of Earth (seconds): %16.3f\n' ],    ...
           ltime2                                         )

% Apparent position of the Sun as seen from Phoebe
[pos2, ltime3] = cspice_spkpos('SUN', et, 'J2000', 'LT+S', 'PHOEBE');
fprintf( [ '   Apparent position of Sun as seen ', ...
           'from Phoebe in the \n',                ...
           '      J2000 frame (km):\n' ]                )
fprintf( '      X = %16.3f\n', pos2(1) )
fprintf( '      Y = %16.3f\n', pos2(2) )
fprintf( '      Z = %16.3f\n', pos2(3) )

[pos3, ltime4] = cspice_spkpos('SUN', et, 'J2000', 'NONE', 'PHOEBE');

% convert distance between Sun and Phoebe from KM to AU
dist_km = norm(pos3);
dist_au = cspice_convrt(dist_km, 'KM', 'AU');
fprintf( [ '   Actual distance between Sun and Phoebe ' ...
           'body centers:\n' ]                            )
fprintf( '     (AU): %16.3f\n', dist_au                 )

cspice_unload(mk)
fprintf('Meta Kernel Unloaded \n')