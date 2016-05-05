pro paerrtablex
 
  common share1, W50double, W10double, EDOTdouble, Jname, P0
  
  common share2, ltrue, isigma, numbinsperperiod
 
  common share3, sigpsi
   
  readcol, /silent, '/data/psrdata/VeniceHayden/IDLprograms/paerr.table',$
    ;enact readcol for the paerr.table
    signoise, psierr, format='d,d',$
  ;titles for the different columins, d is double percision
  SKIPLINE=0, NLINES=999
  
ltrueosigI = ltrue/isigma
sigIoltrue = dblarr(numbinsperperiod)

  for i=0,numbinsperperiod-1 do begin
    if ltrue(i) eq 0 then begin
      sigIoltrue(i) = 0 
    endif else begin 
      sigIoltrue(i) = isigma/ltrue(i)
    endelse
  endfor
  ;see Everett and Weisberg 2001, equation 13 and 14
  ;sub loop that that sets up sigmaI over Ltrue (probelm with 1/0)

sigpsi = dblarr(numbinsperperiod)

interp = interpol(psierr, signoise, ltrueosigI)

for i=0, numbinsperperiod-1 do begin
  if ltrueosigI[i] gt 9.99 then begin
    sigpsi[i] = 28.65*sigIoltrue[i]
  endif else begin
      if ltrueosigI[i] lt 0 then begin
        sigpsi[i] = 1000000000000
      endif else begin
        sigpsi[i] = interp[i]
      endelse
  endelse
endfor

end