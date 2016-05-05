;This program seeks to stastically probe the likelihood of given pairs of alpha and beta.
;We generate a randomized set of alphas and betas, according to cos^2 and flat PDF respectively.
;From the period, we know rho from the appropriate Johnston and Weisberg 2006 equation 
;We are then able to plot a number of alpha beta space curves and see the probability of them crashing or spanning beta (based on the relationship of rho and W)
;Ultimately, we seek to determine the fraction alpah beta pairs where W greater than rho and W less than rho (corresponds to curve behavior in alpha beta space)

pro alphabetarandomizer

numberofitterations = 50000

  common share1, W50double, W10double, EDOTdouble, Jname, P0
  ;extractor program that pulls parameter values from .txt files
  paramextractor2
  ;Values principally need: Jname and P0
  
  common share10, alpharandomarraypdf
  common share15, zetarandomarraypdf


  openw, lunw, '/data/psrdata/VeniceHayden/IDLprograms/alphabetatable.txt', /get_lun, WIDTH=400
  ;This openw works with a printf below that creates a table called alphabetatable.txt that writes the text file to the IDLprogram directory found in the larger Venice directory
  openw, luna, '/data/psrdata/VeniceHayden/IDLprograms/cummulativeWpercentages.txt', /get_lun, WIDTH=400


for pulsarnumber=0s,124 do begin

;pulsarnumber = 0
numberofitterations = 50000
;number of iterations is fed to the alpha and beta randomized programs that are called later in the program. 

print, 'The pulsar you are currently working with is ', Jname[pulsarnumber]

  
  cspeed = 299800000.0
  fixedheight = 300000.0
  Rlc = (cspeed*P0[pulsarnumber])/(2*!PI)
  ;from equation 3.21 of Lorimer and Kramer
  roverRlcConstant = 0.04
  ;This is some constant (generally 0.04) that relates the radius of the pulsar to the radius of the light cylinder
  emissionheightRlc = roverRlcConstant*Rlc
  ;This is the height of emission that can be put into the rhonaught expression

;This block sets the fixed percentage Rlc emission height or a fixed constant height for all pulsars.  

alpharandomizer 
zetarandomizer

rhonaught = 3.*sqrt((!pi*fixedheight)/(2.*P0[pulsarnumber]*cspeed))
;From Johnston and Weisberg 2006, equation 4
;Assume that the height of emission is 300km (300000m)

alpha = alpharandomarraypdf
beta = zetarandomarraypdf-alpharandomarraypdf
;shorten names of the pdf arrays for the equation below

Wlessrho = dblarr(1)
Wgreaterrho = dblarr(1)
Wequalrho = dblarr(1)
WNaN = dblarr(1)
;establish arrays to be filled by below for loop

thisW = 1
;this element is used to concatenate each array with the jth value of the for loop below

W = 2.*acos((cos(rhonaught)-cos(alpha)*cos(alpha+beta))/(sin(alpha)*sin(alpha+beta)))
;From Johnston and Weisberg 2006, equation 3 rewritten such that W became a function of alpha, beta, and rho

for j = 0s,numberofitterations-1 do begin
  thisW = W[j]
  if W[j]/2 lt rhonaught then Wlessrho=[Wlessrho,thisW] else $
  if W[j]/2 gt rhonaught then Wgreaterrho=[Wgreaterrho,thisW] else $  
  if W[j]/2 eq rhonaught then Wequalrho=[Wequalrho,thisW] else $
  WNaN = [WNaN,thisW]
endfor

;This for loop takes the jth value of W, and stuffs it into a 1d array called thisW
;If the W value is less than, greater than, or equal to rho, it is concatenated to it's correct array. 
;If the value of W is nonphysical (NaN) it is concatnated to the NaN array
;Note that each array begins with the 0.0000000 element, so when do any sizing and fractional consideration, be sure to 
;account for that by subtracting the size of the array by one

percentWlessrho = float(size(Wlessrho, /n_elements)-1)/numberofitterations*100
percentWgreaterrho = float(size(Wgreaterrho, /n_elements)-1)/numberofitterations*100
percentWequalrho = float(size(Wequalrho, /n_elements)-1)/numberofitterations*100
percentWNaN = float(size(WNaN, /n_elements)-1)/numberofitterations*100

;Take the number of each elements in the array that designates whether W<rho, W>rho, W=rho, W=NaN
;Subtract one element (Oth element at the beginning of the array)
;Divide by the number of iterations and multiply by 100 to get the percentage of that result vs. # of iterations
;Proceede to print 4 percentages for each pulsar. 

print, 'The percentange of alpha and beta values that yield ----- W less than rho = ', percentWlessrho, ' %'
print, 'The percentange of alpha and beta values that yield ----- W greater than rho =', percentWgreaterrho, ' %'
print, 'The percentange of alpha and beta values that yield ----- W equal to rho = ', percentWequalrho, ' %'
print, 'The percentange of alpha and beta values that yield ----- Unphysical= ', percentWNaN, ' %'

num = indgen(125)
;Create an integer array that can be used to designate number of pulsars on the table. 

printf, lunw, num[pulsarnumber], Jname[pulsarnumber], P0[pulsarnumber], rhonaught, percentWlessrho, percentWgreaterrho, percentWequalrho, percentWNaN 

;This printf creates a table called alphabetatable.txt that writes the text file to the IDLprogram directory found in the larger Venice directory


Wtotal = [wlessrho,wgreaterrho]
;All physical sorted values of W

;set_plot,'ps'
;set plotting to PostScript
;device, filename= Jname[pulsarnumber] + 'Histogram.Wfull.ps', xsize=28, ysize=20
;use device to set some PostScript device options
;cgHistoplot, Wtotal, binsize=0.05, /fill
;device, /close


Wtotalsort = wtotal[sort(wtotal)]

sizewtotal = size(Wtotalsort,/n_elements)
print, sizeWtotal
;Obtain the number of elements in the Wtotal element

wtotal25percent = Wtotalsort[fix(sizewtotal*0.25)]
print, wtotal25percent
;25% level, note that the fix to establish an integer for the range - same is trye fir 50% and 75%
wtotal50percent = Wtotalsort[fix(sizewtotal*0.5)]
print, wtotal50percent
wtotal75percent = Wtotalsort[fix(sizewtotal*0.75)]
print, wtotal75percent
wtotalmax = max(Wtotalsort)

printf, luna, Jname[pulsarnumber], wtotal25percent, wtotal50percent, wtotal75percent, wtotalmax
;After all the values are established for each pulsar, they are then printed out to a file called /u/tor04b/cummulativeWpercentages.txt
;From here, the values are then read into a program called cummulativebinner.pro 
;It is from here that that the measured value of W for each pulsar is binned accordingly. 
;That program that creates a histogram of how each pulsar's W value corresponds to the simulated values plotted in the corresponding histogram plot 

endfor

free_lun, lunw
free_lun, luna

end 