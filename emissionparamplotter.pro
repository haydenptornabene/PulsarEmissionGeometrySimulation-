pro emissionparamplotter

alpha = indgen(190, /double, increment=.5)
beta = indgen(190, /double, increment=.5)
W = indgen(190, /double, increment=.5, start=0)
P = indgen(190, /double, increment=.5, start=0)

argy = Cos(P) 
argx = Cos(alpha)*Cos(alpha+beta)+Cos(W/2)*Sin(alpha)*Sin(alpha+beta)


set_plot,'ps'
;set plotting to PostScript
device, filename='EmissionSamplePlot.ps'
;use device to set some PostScript device options

plot, argx, argy, $
xrange=[-1.2,1.2],$
yrange=[-1.2,1.2],$
  ;symbol style
  PSYM = 7, $
  ;linestyle=0,$
  symsize=.8,$
  title= 'Equation 3 J&W06 Sample Plot'


device, /close

A = cos(alpha)^2+sin(alpha)^2*cos(W/2)
B = -cos(alpha)*sin(alpha)+sin(alpha)*cos(alpha)*cos(W/2)

argx1 = -atan(B/A)+asin(cos(P)/sqrt(A^2+B^2))

set_plot,'ps'
;set plotting to PostScript
device, filename='EmissionSamplePlotalpha.ps'
;use device to set some PostScript device options

plot, argx1, beta, $
  ;symbol style
  xrange = [-20,20],$
  PSYM = 7, $
  ;linestyle=0,$
  symsize=.3,$
  title= 'Equation 3 J&W06 alpha(beta,W)'


device, /close

print, 'Done'

end