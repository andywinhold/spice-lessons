% remote sensing SPICE lesson
function convtm()

% furnsh files needed, already stored in .tm file: 'remsens_convtm.tm'
mk = 'C:\Users\awinhold\Documents\SPICE\lessons\remote_sensing_win\remote_sensing\kernels\mk\remsens_convtm.tm';
cspice_furnsh(mk)
fprintf('Meta Kernel Furnished \n')
sclkid = -82;

% define the UTC time that needs to be converted
utc = input( 'Enter UTC to be converted: ', 's' );
fprintf ( '----------------------------------------------------- \n' )
fprintf ( 'Converting UTC Time: %s\n', utc)

et = cspice_str2et(utc);
fprintf( 'Converting UTC to ET Seconds Past J2000: %16.3f\n', et)

cal = cspice_etcal(et);
fprintf ( 'Calendar ET (cspice_etcal):  %s\n', cal)

sclk = cspice_sce2s( sclkid, et );
fprintf ( 'Spacecraft Clock Time: %s\n', sclk)

cspice_unload( mk )
fprintf ( 'Meta Kernel Unloaded \n')
