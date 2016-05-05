;This program extracts values from the file completecatalogedotW10.txt (The full ATNF catalog)
;For any asterik values, this program replaces it with a 0.00000
;This extracted list is used to produce similar statistical anaylsis, much like the analysis 
;   done by alphabetarandomizer.pro and cummulativebinner.pro

pro fullcatextract

  W50double=dblarr(2525)
  W10double=dblarr(2525)
  EDOTdouble=dblarr(2525)
  Perioddouble=dblarr(2525)

  readcol, /silent,'/u/tor04b/completecatalogedotW10.txt',$
    ;enact readcol for the ascii pulsar dat
    Jname,EDOT,W10,W50,P0,format='a,a,a,a,a',$
    ;titles for the different columins
    SKIPLINE=4, NLINES=2525

  ;there are asteriks within the each column, W50, W10, and EDOT that cannot be read as double
  ;percision. Therefore, we must replace them with zeros using a for loop

  for i=0s, 2524s do begin
    if (W50(i) EQ '*') then begin
      W50double(i) = 0.0d
    endif else begin
      (W50double(i))=double(W50(i))
      ;if the ith element is not an *, return a double percision
    endelse
  endfor
  ;for loop that converts W50 * into 0.0d

  for i=0s, 2524s do begin
    if (W10(i) EQ '*') then begin
      W10double(i) = 0.0d
    endif else begin
      W10double(i)=double(W10(i))
      ;if the ith element is not an *, return a double percision
    endelse
  endfor
  ;for loop that converts W10 * into 0.0d

  for i=0s, 2524s do begin
    if (EDOT(i) EQ '*') then begin
      EDOTdouble(i) = 0.0d
    endif else begin
      EDOTdouble(i)=double(EDOT(i))
      ;if the ith element is not an *, return a double percision
    endelse
  endfor
  ;for loop that converts EDOT * into 0.0d


W10con = dblarr(1)
EDOTcon = dblarr(1)
Jnamecon = strarr(1)
Periodcon = dblarr(1)
;Keep in mind that each array has one zero at the beginning. Ensure the removal of this element. 

thisW=dblarr(1)
thisE=dblarr(1)
thisJ=strarr(1)
thisP=dblarr(1)

for i=0, 2524s do begin
  thisW = W10double(i)
  thisE = EDOTdouble(i)
  thisJ = Jname(i)
  thisP = Perioddouble(i)
  if W10double(i) gt 0 then begin
    W10con = [W10con,thisW]
    EDOTcon = [EDOTcon,thisE]
    Jnamecon = [Jnamecon,thisJ]
    Periodcon = [Periodcon,thisP]
  endif
endfor



end
