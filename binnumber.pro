pro binnumber

common share2, Jname, P0

header = ''
openr, lun, '/u/tor04b/IDLWorkspace83/Default/' + Jname[pulsarnumber] + '_20CM_coadded.SFTC.ascii', /get_lun
readf, lun, header
free_lun, lun
print, header
headerbin = strmid(header, 80, 4)
thebinsize = fix(headerbin)

end