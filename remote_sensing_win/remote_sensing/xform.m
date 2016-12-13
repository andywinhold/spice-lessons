function xform()
%Spacecraft Orientation and Reference Frames, remote sensing lesson

%Read in meta kernel
mk = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\mk\xform.tm';
cspice_furnsh(mk);
fprintf('Meta Kernel Furnished \n')

utc = input('Enter desired time string: ', 's');
et = cspice_str2et(utc);
fprintf('UTC in ET seconds past J2000: %16.3f\n', et)

% state of Phoebe relative to CASSINI in J2k reference frame
[state, ltime] = cspice_spkezr('PHOEBE', et, 'J2000', 'LT+S', 'CASSINI');

% compute state transformation matrix from J2000 to IAU_PHOEBE at
% epoch(et), ltime adjusted
[sxform] = cspice_sxform('J2000', 'IAU_PHOEBE', et-ltime);

%multiply the state of Phoebe relative to Cassini by state xformation
%matrix in previous step.
bfixst = sxform * state;
fprintf(['   Apparent state of Phoebe as seen ', ...
         'from CASSINI in the IAU_PHOEBE\n',     ...
         '      body-fixed frame (km, km/s):\n'])
fprintf('     X = %19.6f\n', bfixst(1))
fprintf('     Y = %19.6f\n', bfixst(2))
fprintf('     Z = %19.6f\n', bfixst(3))
fprintf('    VX = %19.6f\n', bfixst(4))
fprintf('    VY = %19.6f\n', bfixst(5))
fprintf('    VZ = %19.6f\n', bfixst(6))

% could also do the above steps with just cspice_spkezr('PHOEBE', et,
% 'IAU_PHOEBE', 'LT+S', 'CASSINI) this mentioned approach will provide a
% slightly more accurate method because it 'accounts for the effect of the
% rate of change of light time on the apparent angular velocity of the
% target's body-fixd reference frame.'

% compute the position of Earth relatibe to CASSINI, correct for
% aberrations.
[pos, ltime2] = cspice_spkpos('EARTH', et, 'J2000', 'LT+S', 'CASSINI');

% determine what the nominal boresight of the CASSINI high gain antenna is
% by examining the frame kernel's content. The kernel states 'The high gain
% antenna points nominally along the spacecraft -Z axis.' But the lesson
% says 'the antenna boresight is nominally the +Z.'
bsight = [ 0.D0; 0.D0; 1.D0 ];

% compute the rotation matrix from the CASSINI HGA frame to J2k and
% multiply to obtain nominal antennae boresight in J2k frame.
pform = cspice_pxform('CASSINI_HGA', 'J2000', et);
bsight = pform * bsight;

% compute the angular seperation
sep = cspice_convrt(cspice_vsep(bsight, pos), ...
                    'RADIANS', 'DEGREES'         );
                
fprintf(['   Angular separation between the ',     ...
         'apparent position of \n',                ...
         '      EARTH and the ',                   ...
         'CASSINI high gain antenna boresight ',   ...
         '(degrees):\n      %16.3f\n'],            ...
         sep                                          );

% Alternatively could work in antenna frame
% [pos, ltime] = cspice_spkpos('EARTH', et, 'CASSINI_HGA', ...
%                               'LT+S', 'CASSINI'              );
% bsight = [0.D0; 0.D0; 1.D0];
% sep = cspice_convrt ( cspice_vsep(bsight, pos), ...
%                          'RADIANS', 'DEGREES'         );
%  
%    fprintf ( [ '   Angular separation between the ',    ...
%                'apparent position of \n'                ...
%                '      Earth and the ',                  ...
%                'CASSINI high gain antenna boresight ',  ...
%                'computed \n',                           ...
%                '      using vectors in the ',           ...
%                'CASSINI_HGA frame (degrees):\n',        ...
%                '      %16.3f\n' ],                      ...
%              sep                                            );
cspice_unload(mk);
fprintf('Meta Kernel Unloaded \n')