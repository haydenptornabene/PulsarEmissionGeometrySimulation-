;This program seeks to define alpha/beta space and determine possible alpha and beta values for different individual pulsars
;This program can produce alphabeta sweeps for individual pulsars and plots that have every alphabeta sweep superimposed on one another
;The program has been updated to just plot pulsars with high S/N (30 pulsars removed from original 155) (20150804)

pro alphabetafinder

  common share2, ltrue, isigma, numbinsperperiod
  common share5, w10measlong
  common share6, alpha, beta, rhonaught, W10rad, pulsarnumber, alphaplot, betaplot
 
 
readcol, /silent, '/data/psrdata/VeniceHayden/IDLprograms/haydentable.20150804.txt',$
;enact readcol for the most up to date pulsar table. Make sure to check home directory for most up to date file
number,J,Loi,Voi,abVoi,w50long,W10long,CF,pe,format='i,a,d,d,d,d,d,d,d',$
;titles for the different columins, d is double percision  
SKIPLINE=13, NLINES=125
;This table is produced by iquvextract11.pro

readcol, /silent, '/data/psrdata/VeniceHayden/IDLprograms/simonpulsarlistparamrevised.txt',$
  ;enact readcol for the most up to date pulsar table. Make sure to check home directory for most up to date file
  num,Jname,P0,bunk,bunk,bunk,format='i,a,d,a,a,a',$
  ;titles for the different columins, d is double percision
  SKIPLINE=4, NLINES=125
 
  
a=dindgen(1600)
alphapos=a*0.002
;alphaneg=a*(-0.002)
alpha = alphapos
;creating an alpha range to be plotted to test the relationship between alpha, beta, w10 and rho

W10rad = w10long * !PI/180.
;Converting the W10 measurements from iquvextract in degrees to radians  


setmex=[0,0]
setmey=[0,0]
;set the (0,0) point on the plot to establish the alpha beta space and its range. Varying curves will be overplotted by a for loop

set_plot,'ps'
;set plotting to PostScript
device, filename='125.Pulsars.AlphaBetaSpace.FixedRLC0.04.ps', decomposed=0
;use device to set some PostScript device options

plot,setmex,setmey,$
  xrange=[0,181],$
  yrange=[-10,22],$
  title= 'Multiple pulsars Alpha Beta Space (h_em=0.04*R_lc)',xtitle='Alpha (Degrees)', ytitle='Beta (Degrees)',$
  psym=2, symsize=0.2, xstyle=1,ystyle=1


;for pulsarnumber=0s,124 do begin
  ;for loop used to cycle through all pulsars and allow an overplot of each of alpha beta swing. 

;pulsarnumber = 5
  ;for individual curves on individual plots 

cspeed = 299800000.0 
fixedheight = 300000.0

Rlc = (cspeed*P0[pulsarnumber])/(2*!PI)   
;from equation 3.21 of Lorimer and Kramer
roverRlcConstant = 0.04
;This is some constant (generally 0.04) that relates the radius of the pulsar to the radius of the light cylinder
emissionheightRlc = roverRlcConstant*Rlc
;This is the height of emission that can be put into the rhonaught expression

rhonaught = 3.*sqrt((!pi*fixedheight)/(2.*P0[pulsarnumber]*cspeed))
;From Johnston and Weisberg 2006, equation 4
;Assume that the height of emission is 300km (300000m)

  A = cos(alpha)^2+sin(alpha)^2*cos(W10rad[pulsarnumber]/2.)
  B = -cos(alpha)*sin(alpha)+sin(alpha)*cos(alpha)*cos(W10rad[pulsarnumber]/2.)

  beta = atan(B,A)+acos(cos(rhonaught)/sqrt(A^2+B^2))
  ;this line is causing a floating illegal operand (arcsin is giving the problem) 
  
;From Johnston and Weisberg 2206, equation 3 rewritten such that Beta became a function of alpha, W, and rho 

;The following commented out script produces alpha beta curves for individual pulsars

;set_plot,'ps'
;set plotting to PostScript
;device, filename= J[pulsarnumber]+'alphabetaspace.ps'
;use device to set some PostScript device options
;plot, alpha, beta,$
  ;xrange=[min(alpha),max(alpha)],$
  ;yrange=[min(beta),max(beta)],$
  ;title= J[pulsarnumber] + ' Alpha Beta Space' ,xtitle='Alpha (radians)', ytitle='Beta (radians)',$
  ;psym=2, symsize=0.2
;device, /close
;This is for individual pulsar plots to see the relationship of alpha and beta in the accepted regime

alphaplot = alpha * 180/!PI
betaplot = beta * 180/!PI

tvlct, 355,pulsarnumber+26+.5*pulsarnumber,155,100
;if pulsarnumber eq 1 or pulsarnumber eq 17 or pulsarnumber eq 32 or pulsarnumber eq 39 or pulsarnumber eq 47 or pulsarnumber eq 48 or pulsarnumber eq 49 or pulsarnumber eq 50 or pulsarnumber eq 53 or pulsarnumber eq 61 or pulsarnumber eq 64 or pulsarnumber eq 66 or pulsarnumber eq 73 or pulsarnumber eq 75 or pulsarnumber eq 76 or pulsarnumber eq 80 or pulsarnumber eq 86 or pulsarnumber eq 102 or pulsarnumber eq 107 or pulsarnumber eq 109 or pulsarnumber eq 113 or pulsarnumber eq 114 or pulsarnumber eq 122 or pulsarnumber eq 127 or pulsarnumber eq 132 or pulsarnumber eq 134 or pulsarnumber eq 135 or pulsarnumber eq 143 or pulsarnumber eq 144 or pulsarnumber eq 148 then continue 
;removing the bad pulsars from the list
oplot, alphaplot, betaplot, color=100b, psym=2, symsize=.2


;endfor
;endfor for the full loop that makes the individual plot with every pulsar alpha-beta sweep

zeroliney=[0,0]
zerolinex=[0,300]

oplot,zerolinex,zeroliney,linestyle=4,color=cgcolor('red'), thick=4

device, /close, decomposed=1


set_plot,'ps'
;set plotting to PostScript
device, filename='PeriodvsW10.ps', decomposed=0
;use device to set some PostScript device options
plot, P0,W10long,$
  psym=2,$
  symsize=1.5,$
title= 'Multiple pulsars Alpha Beta Space (h_em=0.04*R_lc)',xtitle='P0', ytitle='W10Long(degrees)'

device, /close



end