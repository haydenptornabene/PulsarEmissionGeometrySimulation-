pro cummulativebinner

readcol, /silent, '/u/tor04b/cummulativeWpercentages.txt',$
    ;enact readcol for the most up to date pulsar table. Make sure to check home directory for most up to date file
   Jname,wtotal25percent, wtotal50percent, wtotal75percent, wtotalmax,format='a,d,d,d,d',$
    ;titles for the different columins, d is double percision
    SKIPLINE=0, NLINES=125
  ;This table is produced by alphabetarandomizer.pro

readcol, /silent, '/u/tor04b/HaydenTables/haydentable.20150804.txt',$
;enact readcol for the most up to date pulsar table. Make sure to check home directory for most up to date file
number,J,Loi,Voi,abVoi,w50long,W10long,CF,pe,format='i,a,d,d,d,d,d,d,d',$
  ;titles for the different columins, d is double percision
  SKIPLINE=13, NLINES=125
;This table is produced by iquvextract11.pro

W10rad = W10long*(!PI/180)

CummulativeBin1 = dblarr(1)
;W value falls between 0-25% 
CummulativeBin2 = dblarr(1)
;W value falls between 25-50%
CummulativeBin3 = dblarr(1)
;W value falls between 50-75%
CummulativeBin4 = dblarr(1)
;W value falls between 75-100%

thisW = dblarr(1)
for pulsarnumber=0s,124 do begin
thisW = W10rad[pulsarnumber]  
if W10rad[pulsarnumber] lt wtotal25percent[pulsarnumber] then CummulativeBin1 = [CummulativeBin1,thisW] else $
  ;If the W10 value in radians is less than the 25 percent value, place it in bin 1.
if W10rad[pulsarnumber] lt wtotal50percent[pulsarnumber] then CummulativeBin2 = [CummulativeBin2,thisW] else $
  ;If the W10 value in radians is less than the 50 percent value, place it in bin 2.
if W10rad[pulsarnumber] lt wtotal75percent[pulsarnumber] then CummulativeBin3 = [CummulativeBin3,thisW] else $
  ;If the W10 value in radians is less than the 75 percent value, place it in bin 3.
CummulativeBin4 = [CummulativeBin4, thisW]
  ;Otherwise, put it in bin 4. 
endfor

bin1size = size(CummulativeBin1,/n_elements)-1
bin2size = size(CummulativeBin2,/n_elements)-1
bin3size = size(CummulativeBin3,/n_elements)-1
bin4size = size(CummulativeBin4,/n_elements)-1

bins = [bin1size,bin2size,bin3size,bin4size]
labels = ['0-25%','25-50%','50-75%','75-100%']

set_plot,'ps'
;set plotting to PostScript
device, filename= 'Histogram.Cummulative.ps', xsize=28, ysize=20
;use device to set some PostScript device options

cgbarplot, bins, BarNames=labels

device, /close

end