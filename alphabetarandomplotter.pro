;This program plots values from the alphabetatable.txt.
;We consider period vs percentage of each category of W related to rho, and period vs rho.

pro alphabetarandomplotter

readcol, /silent, '/data/psrdata/VeniceHayden/IDLprograms/alphabetatable.2016050314.15h.txt',$
;enact readcol for the most up to date pulsar table. Make sure to check home directory for most up to date file
number,Jname,Period,rho,percentWlessrho,percentWgreaterrho,percentWequalrho,percentWNan,format='i,a,d,d,d,d,d,d',$
;titles for the different columins, d is double percision  
SKIPLINE=0, NLINES=125
;This table is produced by iquvextract11.pro

numberofitterations=50000

numstring = strtrim(numberofitterations,1)

set_plot,'ps'
;set plotting to PostScript
device, filename= 'PeriodvsPercentageWO2.' + numstring + 'May.ps', xsize=28, ysize=20
;use device to set some PostScript device options

plot, period,percentWNaN,$
  yrange=[55,100], ystyle=1, $
  ytitle='Percentage of Trial/#Iterations',$
  psym=1, symsize=0.65, _extra = gang_plot_pos(3,1,3)

  cspeed = 298000000
  fixedheight = 300000
  periodsample = findgen(500)*.01
  rhosample=3.*sqrt((!pi*fixedheight)/(2.*periodsample*cspeed))
  ;fractionseen = 2.*rhosample/!PI
  ;this function of fraction seen did not consider the edge cases of the pulsar, that is when rho>alpha near 0 and pi on the pulsar.
  ;We submit a new equation that is derived from the integration over 0 to pi, where 2*rho/pi is only the middle segment.
  fractionseen = ((-2.*(rhosample)^2)+(4.*!pi*rhosample)+(cos(2*rhosample))-1)/(2.*!pi^2)
  percentseen = fractionseen*100

oplot, periodsample, 100-percentseen, color=cgcolor('teal'), _extra = gang_plot_pos(3,1,2)


plot, period,percentWgreaterrho, $
  ytitle='Percentage of Trial/#Iterations',$
  yrange=[-2,40], ystyle=1, $ 
  psym=1,symsize=0.0000000000001, _extra = gang_plot_pos(3,1,1)

oplot, period, percentWlessrho,psym=1, symsize=0.65, color=cgcolor('red'), _extra = gang_plot_pos(3,1,1)
oplot, period, percentWgreaterrho, psym=1, symsize=0.65, color=cgcolor('blue'), _extra = gang_plot_pos(3,1,1) 

oplot, periodsample, percentseen, color=cgcolor('teal'), _extra = gang_plot_pos(3,1,3)
oplot, period, percentWlessrho+percentWgreaterrho, psym=2, symsize=0.5, color=cgcolor('purple'), _extra = gang_plot_pos(3,1,3) 

rhodeg = rho*180/!pi
;conversion of the the rho in radians to degrees in order to plot as a function of period

plot, period, rhodeg,$
  xtitle='Period(s)', ytitle='Rho (degrees)',$
  psym=1, symsize=0.00000001, _extra = gang_plot_pos(3,1,2) 

oplot, period, rhodeg, psym=1, symsize=0.65, color=cgcolor('orange'), _extra = gang_plot_pos(3,1,2)

xyouts,3,36.5, 'Percent W/2 < rho', charsize=1, color=cgcolor('red'), /data, _extra = gang_plot_pos(3,1,3)
xyouts,3,35, 'Percent W/2 > rho', charsize=1, color=cgcolor('blue'), /data, _extra = gang_plot_pos(3,1,3)
xyouts,3,33.5, 'Theoretical Percent Seen = 2rho/pi', charsize=1, color=cgcolor('teal'), /data, _extra = gang_plot_pos(3,1,3)
xyouts,3,31, 'Percent W/2 > rho + Percent W/2 < rho', charsize=1, color=cgcolor('purple'), /data, _extra = gang_plot_pos(3,1,3)
xyouts,3,38, 'Percent W/2 = Unphysical', charsize=1, /data, _extra = gang_plot_pos(3,1,3)

xyouts,3.7,29, '***50,000 Iterations', charsize=1, /data, _extra = gang_plot_pos(3,1,3)


device, /close


end