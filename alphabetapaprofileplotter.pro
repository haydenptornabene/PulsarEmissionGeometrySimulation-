pro alphabetaPAprofileplotter

  common share1, W50double, W10double, EDOTdouble, Jname, P0
  paramextractor2
  common share3, sigpsi
  common share2, ltrue, isigma, numbinsperperiod
  common share5, w10measlong
  common share6, alpha, beta, rhonaught, W10rad, pulsarnumbers, alphaplot, betaplot
  
  common share7,myW10bin1,myW10bin2,thebinsize,I,Q,U,V,Iabsolute,Longitude,Vshift,Qshift,Vabsolute,Ushift,wwindow,myW50bin1,myW50bin2,lmeas,lmeasmean,lmeassigma,thebinsizeover2

;pulsarnumbers = 4

alphabetafinder
iquvextract13finalplotmaker

for pulsarnumbers=0s,124 do begin

;this is the plotting procedure from iquvextract12finalplotmaker.pro that plots individual graphics for each pulsar

set_plot,'ps'
;set plotting to PostScript
device, filename= Jname[pulsarnumbers] + '.20CM.FinalwithAlphBeta.ps', xsize=28, ysize=20
;use device to set some PostScript device options

lowpapsi = ((myW10bin1*360.)/thebinsize)-197.
highpapsi = ((myW10bin2*360.)/thebinsize)-163.

highpapsidiag = ((myW10bin2*360.)/thebinsize)-180.+1*(((myW10bin2*360.)/thebinsize)-180.)
;defined to make the yrange minimum unique for each pulsar based on the bin where summing begins and ends

bigmin = min([min(I), min(Q), min(U), min(V)])
;defined to make the yrange minimum unique for each pulsar

plot, longitude,Iabsolute,$
  min_value=-50.0,$
  xrange=[lowpapsi,highpapsi],$
  ;xrange=[-180,180], $
  yrange=[bigmin + 0.1*bigmin,max(Iabsolute)+0.1*max(Iabsolute)],$
  linestyle = 0, $
  ;symbol style
  symsize=.3,$
  title= Jname[pulsarnumbers] + ' 20CM',xtitle='', ytitle='Intensity',$
  xstyle=1,ystyle=1, _extra = gang_plot_pos(2,1,2)
background=100200400
color=0
;plot the array with bin on x and I on y.

oplot, longitude, Qshift, linestyle = 5, color=cgcolor('red'), _extra = gang_plot_pos(2,1,2)
oplot, longitude, Ushift, linestyle = 4, color=cgcolor('blue'),_extra = gang_plot_pos(2,1,2)
oplot, longitude, Vabsolute, linestyle = 3, color=cgcolor('purple'),_extra = gang_plot_pos(2,1,2)
oplot, longitude, Ltrue, linestyle = 6, color=cgcolor('orange'), _extra = gang_plot_pos(2,1,2)

;Create an array that plots values only at longitudes where L>= 2 sigma L measured (lmeassigma).
;Initialize an array with the number, 999999999.9 in every element. Run a for loop
;such that for L>=sigma, place papsi in the new array.

;____________________________________________________________________________
;Begin calculating postion angle Psi and build the corresponding plot below

papsi = 0.5*atan(Ushift,Qshift)*(180/!PI)
; For arctan(opposite/adjacent), one should write atan(adjacent,opposite) given IDL's syntax (same as mathmatica) - Convert from radians to degrees

papsinew = dblarr(thebinsize)+9999999999999.9

for i=0s, thebinsize-1 do begin
  if Lmeas(i)-lmeasmean GE 2.5*lmeassigma then begin
    papsinew(i)=papsi(i)
  endif
endfor
;Notice the inclusion of lmeasmean in the if threshold. We specify the mean of the noise array (ie the value from zero)
;defined above and then delineate 2.5 sigma above that mean as the threshold.

paerrtablex

sigpsin = papsinew-sigpsi
sigpsip = papsinew+sigpsi

ploterror, longitude, papsinew, sigpsi, $
  max_value = 90, $
  xrange=[lowpapsi,highpapsi],$
  yrange=[-100,100], $
  ;symbol style
  symsize=1,$
  title='',xtitle= 'Longitude,' + cgGreek('phi') + '[deg]', ytitle='P.A. (deg.)',$
  xstyle=1,ystyle=1, /nohat, _extra = gang_plot_pos(2,1,1, size=[0.8,0.85]), charsize=1

 
  plot, alphaplot, betaplot,$
    xrange=[0,181],$
    yrange=[-1,max(betaplot)],$
    title= '',xtitle='Alpha (degrees)', ytitle='Beta (degrees)',$
    psym=2, symsize=0.05, xstyle=1,ystyle=1, _extra = gang_plot_pos(2,1,1, size=[0.2,0.22], offset=[0.67,0.80])
  
 

device, /close
endfor

print, 'Done'

end