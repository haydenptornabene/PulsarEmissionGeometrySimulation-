;a note about J1352-6803: The ATNF catalog reports a W10 of 330 ms and a W50 of 28 ms. The 330ms was far outside the 1024 bin
;window of the dataset so it was causing an iquvextract.pro to choke. The S/N is fairly low, causing the extremely wide W10. 
;For the purposes of summing over the main pulse, iquvextract was forced to select the W50 value by replacing the W10 in the
;parameter file with an asterik. The consequent W10 lines are not visinle on the coadded.SFTC.Stokes.Plot as they fall outside
;the 1024 bins, as the S/N is too low, rendering the calculated value of W10 as unreliable (this is true for a number of pulsars)  

PRO paramextractor 

common share1, W50double, W10double, EDOTdouble, Jname, P0

W50double=dblarr(155)
W10double=dblarr(155)
EDOTdouble=dblarr(155)

readcol, /silent,'/u/tor04b/IDLWorkspace83/Default/simonpulsarlistparam.txt',$
    ;enact readcol for the ascii pulsar dat
    Jname,P0,W50,W10,EDOT,format='a,d,a,a,a',$
    ;titles for the different columins
    SKIPLINE=4, NLINES=155
    
;there are asteriks within the each column, W50, W10, and EDOT that cannot be read as double
;percision. Therefore, we must replace them with zeros using a for loop

for i=0s, 154s do begin 
  if (W50(i) EQ '*') then begin
    W50double(i) = 0.0d
    endif else begin
      (W50double(i))=double(W50(i))
      ;if the ith element is not an *, return a double percision
    endelse
endfor    
;for loop that converts W50 * into 0.0d

for i=0s, 154s do begin
  if (W10(i) EQ '*') then begin
    W10double(i) = 0.0d
  endif else begin
    W10double(i)=double(W10(i))
    ;if the ith element is not an *, return a double percision
  endelse
endfor
;for loop that converts W10 * into 0.0d

for i=0s, 154s do begin
  if (EDOT(i) EQ '*') then begin
    EDOTdouble(i) = 0.0d
  endif else begin
    EDOTdouble(i)=double(EDOT(i))
    ;if the ith element is not an *, return a double percision
  endelse
endfor
;for loop that converts EDOT * into 0.0d

end