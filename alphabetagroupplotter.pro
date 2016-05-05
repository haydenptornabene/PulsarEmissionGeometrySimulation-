;Alphabetafinder.pro makes individual plots and a plot of all pulsars.
;Alphabetagroupplotter plots three seperate plots, one for each alpha-beta sweep geometry: UShape, NikeSwoosh,Cos1period

pro alphabetagroupplotter


  common share1, W50double, W10double, EDOTdouble, Jname, P0
  common share2, ltrue, isigma, numbinsperperiod
  common share5, w10measlong
  common share6, alpha, beta, rhonaught, W10rad, pulsarnumber

UshapePulsars=[0,2,7,11,13,14,15,16,19,25,26,27,33,34,36,38,42,43,45,51,54,58,59,60,62,63,67,72,78,79,88,90,96,97,98,99,101,103,104,105,108,112,117,118,119,121,123,124,126,128,138,140,141,146,147,149,154]
NikeSwooshPulsars=[1,8,17,22,24,29,32,39,47,48,49,50,53,61,64,66,73,75,76,77,80,81,85,86,89,91,102,107,109,113,122,127,129,132,134,135,139,143,144,148]
Cos1PeriodPulsars=[3,4,5,6,9,10,12,18,20,21,23,28,30,31,35,37,40,41,44,46,52,55,56,57,65,68,67,70,71,74,82,83,84,87,92,93,94,95,100,106,110,111,115,116,120,125,130,131,133,136,137,142,150,151,152,153]
NikeSwooshPulsarsbadremoved=[8,22,24,29,77,81,85,89,91,129,139]
;All pulsars with a bad W10 values are in the NikeSwooshPulsar list, so the above list is updated with only good W10 values.


print, size(UshapePulsars)
print, size(NikeSwooshPulsarsbadremoved)
print, size(Cos1PeriodPulsars)

setmex=[0,0]
setmey=[0,0]


set_plot,'ps'
;set plotting to PostScript
device, filename='Ushape.AlphaBetaSpace.ps', decomposed=0
;use device to set some PostScript device options

plot,setmex,setmey,$
  xrange=[-2,2],$
  yrange=[0,5],$
  title= 'Multiple pulsars Alpha Beta Space',xtitle='Alpha (radians)', ytitle='Beta (radians)',$
  psym=2, symsize=0.2, xstyle=1,ystyle=1

for UshapePulsars=0s,56 do begin

tvlct, 355,pulsarnumber+26+.5*pulsarnumber,155,100

oplot, alpha, beta, color=100b, psym=2, symsize=.2

endfor

device, /close, decomposed=1



end