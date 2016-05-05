;Version 5 has a bug that needs to be resolved where the W50 and W10 windows are not being calculated or
;plotted correctly. Version 6 will attempt to resolve this bug (20150717)
;Version 6 correctly selects the W50 and W10 points on the profile as of (20150718)
;Version 7 attempts to deal with the fact that some pulsars only have 512 bins across (20150724) 
;Version 7 effectively prints all pulsars! Now I will go in and do a visual search and add position angle plots 
;Version 7 - this one prints individual pulsars (20150724)
;Version 8 plots postion angle and compiles all three plots into one layout (20150724)
;Version 9 correctly plots all pulsar pulse profiles with correct Stokes parameters and position angle plot
;Version 10 creates the table
;Version 11 works to address pulsars that need further inspection (spot running) see page 120-121 in notebook 1
;VERSION 11!!!!!SPOT CHECKING ONLY SPOT CHECKING ONLY DO NOT RUN FOR LOOP

PRO iquvextract12finalplotmaker


  common share1, W50double, W10double, EDOTdouble, Jname, P0
  ;extractor program that pulls parameter values from .txt files
  paramextractor
  
  common share3, sigpsi
  
  common share2, ltrue, isigma, numbinsperperiod
  
  common share5, w10measlong
  
  common share7,myW10bin1,myW10bin2,thebinsize,I,Q,U,V,Iabsolute,Longitude,Vshift,Qshift,Vabsolute,Ushift,wwindow,myW50bin1,myW50bin2,lmeas,lmeasmean,lmeassigma,thebinsizeover2
   
  ;sharing to the paerrtablex.pro procedure
mydevice = !D.Name 

;openw, lunw, '/u/tor04b/table.txt', /get_lun

;for pulsarnumber=0s,154 do begin

pulsarnumber = 0

;the pulsar number in the sample of pulsars listed in simonpulsarlist.txt
;***NOTE (pulsarnumber = 0 corresponds to J0034-0721)

print, 'The pulsar you are currently working with is ', Jname[pulsarnumber]

header = ''
openr, lun, '/u/tor04b/IDLWorkspace83/Default/PulsarAscii/' + Jname[pulsarnumber] + '_20CM_coadded.SFTC.ascii', /get_lun
readf, lun, header
free_lun, lun
;this routine reads the header from the ascii file and then extracts the number of bins (512 or 1024)

headerbin = strmid(header, 80, 4)

print, headerbin

thebinsize = fix(headerbin)
print, thebinsize
;this routine trim the header to just extract the bin size and the renders it an integer 

readcol, /silent, '/u/tor04b/IDLWorkspace83/Default/PulsarAscii/' + Jname[pulsarnumber] + '_20CM_coadded.SFTC.ascii',$
;enact readcol for the ascii pulsar dat
Time,Frequency,Bin,I,Q,U,V,format='a,a,i,d,d,d,d',$160
;titles for the different columins, d is double percision  
SKIPLINE=1, NLINES=thebinsize-2 

print, 'The maximum intensity for ', Jname[pulsarnumber] + ' is', max(I,Binmax)
;prints the maximum value of I and sets the subscript to be the corresponding bin number)
print, 'The corresponding bin to the maximum intesnity for ', Jname[pulsarnumber] + ' is', Binmax
;prints the corresponding bin number

binmaxd = fix(Binmax)

print, 'The required binshift is ', (thebinsize/2-binmaxd)

binshift = (thebinsize/2-binmaxd)

Ishift = shift(I, binshift)
;shifts the array I by 13 (as the binmax for this pulsar is given at 499, and we want to
;center the pulse at bin 512.
Qshift = shift(Q, binshift)
Ushift = shift(U, binshift)
Vshift = shift(V, binshift)
;shift the three other stokes parameters by 13 to center the pulse profile at 512

numbinsperperiod = thebinsize 
;consider the leading edge of the 0th bin and the 1023rd bin, there is 360 degrees total
; thus, there is 1024 bins, or 512 for those that are sampled of 512

thebinsizeover2 = double(thebinsize)/2
;render the binsize as a double percision such that we can compute the longitude 
print, thebinsizeover2, 'thebinsizeover2'

longitude = bin/(numbinsperperiod/360.) - (thebinsizeover2/(numbinsperperiod/360.))
;1024 bins= 360 degrees

noisearrayI = findgen(100)
;establish an array that will be filled with the noise sample

noisearrayLmeas = findgen(100)
;establish an array that will be filled with the noise sample

noisearrayV = findgen(100)
;establish an array that will be filled with the noise sample

startbinnumber = 15
;select a bin number outside the main pulse where there is no interpulse
;this region must be 100 bins from any pulse component

lmeas = sqrt(Qshift^2+Ushift^2)
;lmeas = L value meausred from Q and U, both shifted such that the center of
;the profile is at bin 512 (or 256 for pulsars sampled of 512 bins)

for i=0s, 99s do begin
  j=startbinnumber+i
  noisearrayI(i)=Ishift(j)
  noisearrayLmeas(i)=lmeas(j)
  noisearrayV(i)=Vshift(j)
  ;noisearrayI is being filled with the 15-115 elements of the Ishift array.
endfor

isigma = stddev(noisearrayI)
;isgima is a correction factor that removes the positive noise from the above lmeas square
;root function. isigma is found in equation 11 of Everett and Weisberg 2001

lmeasmean = mean(noisearrayLmeas)
Imean = mean(noisearrayI)
Vmean = mean(noisearrayV)
;The V and I means will be used to bring the each element down to zero, establishing true zero across 360 degrees

Iabsolute = Ishift - Imean
Vabsolute = Vshift - Vmean

lmeassigma = stddev(noisearrayLmeas)
;lmeassigma is a correction factor for the PA via Weisberg 99 (figure 1 caption)
;we will plot psotion angle only at longitudes where L >= 2*lmeassigma

loverisigma = lmeas/isigma
;the conditional statement arguement of equation 11 (note that Everett and Weisberg 2001 has 
;a typo and the second isigma should be outside of the squareroot

ltruearg = (loverisigma)^2-1
;the argument from Weisberg and Everett 2001 that corrects the typo

ltrue = findgen(thebinsize)
;establish an array that will be filled with the values of ltrue across the entire profile

for e=0s,thebinsize-1 do begin
  if (loverisigma(e) GE 1.57) then begin
    ltrue(e)= sqrt(ltruearg(e))*isigma
  endif else begin
    ltrue(e) = 0
  endelse
endfor

;this for loop takes ltruearg and either takes the square root or makes it zero if
;loverisigma is greater than or less than 1.57 (equation 11 Everett and Weisberg)

;ltrue is currently over the entire profile. In order to calculate fractional L (L/I),
;we need to chop off the noise components to the left and the right of the pulse.
;In order to do this, we will consider the W50 found in psrcat and build two arrays,
;with only L, I, etc. values that correspond to the main pulse (and a little noise outside 
;the pulse components)

W50s = W50double/1000.
;converting the pulse width to seconds to match the period unit
W10s = W10double/1000
;converting the pulse width to seconds to match the period unit

print, 'The W10 for ', Jname[pulsarnumber] + ' is', W10s[pulsarnumber], ' ms'
print, 'The W50 for ', Jname[pulsarnumber] + ' is', W50s[pulsarnumber], ' ms'

wwindow = dblarr(155)
;establish a double percision array to be filled with W50 and W10 values from the ATNF 
;catalog (not the values to be measured later in this procedure) in order to sum paramters 
;with correct weighting 

for i=0s, 154s do begin
  if (W10s(i) GT 0) then begin
    wwindow(i) = 360.*W10s(i)/P0(i)
  endif else begin
    wwindow(i) = 720.*W50s(i)/P0(i)
  endelse
endfor

;Performing the conversion calculation from seconds to degrees using the period of the pulsar
;and the width of the W50 and the W10. In the conversion: for W50, we multiply by a factor of
;4 to get the entire pulse and for the W10 we multiply by a factor of 2.

;The resultant value is number of degrees left and right from 0 degrees longitude needed
;to capture the data from the pulse such that we can average L correctly

print, 'The wwindow for ', Jname[pulsarnumber], ' is ', wwindow[pulsarnumber], ' degrees'

posroundowlongitude = round(wwindow[pulsarnumber])
;rounding the positive longitude (right of the peak intensity) in order to use it as an integer
negroundowlongitude = -round(wwindow[pulsarnumber])
;rounding the negative longitude (left of the peak intensity) in order to use it as an integer


print, 'The rounded half width of the window is  ', posroundowlongitude, ' degrees'

thebinsizedouble = double(thebinsize)

longtobinwindowp = fix(0.5+(thebinsizedouble/360.)*posroundowlongitude+thebinsizeover2)
;longitude to bin window positive 
longtobinwindown = fix(0.5+(thebinsizedouble/360.)*negroundowlongitude+thebinsizeover2)
;longitude to bin window negative

print, 'The bin at which we begin summing for L is ', longtobinwindown
print, 'The bin at which we end summing for L is ', longtobinwindowp

bindiff=longtobinwindowp-longtobinwindown+1

Larray = findgen(bindiff)
Iarray = findgen(bindiff)
Qarray = findgen(bindiff)
Uarray = findgen(bindiff)
Varray = findgen(bindiff)
Bindex = indgen(bindiff)

;establish arrays that will be filled with the Ltrue, I, Q, U, and V values between the bins 
;outlined by the W10 or W50 distance

for i=0s, (bindiff-1) do begin
  j=longtobinwindown+i
  Larray(i)=ltrue(j)
  Iarray(i)=Iabsolute(j) 
  Qarray(i)=Qshift(j)
  Uarray(i)=Ushift(j)
  Varray(i)=Vabsolute(j)
  ;*array for * = L,I,Q,U and V is being filled with the longtobinwindown-longtobinwindowp elements 
  ;of the ltrue array.
endfor

;This array is taking the ltrue values, corrected with the isigma correction outlined in Everett&Weisberg
;2001, over the pulse and the outer skirts of the pulse. 

LtrueoverItrue = total(Larray)/total(Iarray)
;fractional Ltrue/I
pltoitfigonly=strtrim(LtrueoverItrue*100.,1)
;percentLtrueoverItrue for the figure only (string)

VoverI = total(Varray)/total(Iarray)
;fractional V/I
pvoifigonly = strtrim(VoverI*100.,1)
;percent V/I for the figure only (string)

VabsoverI = total(abs(Varray))/total(Iarray)
;fractional |V|/I
pvabsoifigonly = strtrim(VabsoverI*100.,1)
;percent of |V|/I for the figure only, this variable is a string

;W50 and W10 Calculations

print,'-------------------------------------------------------------------'

print, max(Iabsolute)
W50I = max(Iabsolute)*.5
W10I = max(Iabsolute)*.1
print, W50I
print, W10I

;print, 'The maximum intensity for ', Jname[pulsarnumber] + ' is', max(I,Binmax)
;prints the maximum value of I and sets the subscript to be the corresponding bin number)
;print, 'The corresponding bin to the maximum intesnity for ', Jname[pulsarnumber] + ' is', Binmax
;prints the corresponding bin number

print, 'Max Intensity ', max(Iabsolute,BinIshiftmax), ' at', BinIshiftmax

myW50bin1 = Value_Locate(Iabsolute[0:thebinsize/2-1], W50I)+1
print, 'My lower W50 bin is ', myW50bin1
;the lower bin is to the left of the peak intensity

;myW50bin2 = Value_Locate(Ishift[myW50bin1+1:*], W50I) + myW50bin1+2
;Locate the value from myW50bin1+1 until the end of the vector. We must add my W50bin1 to normalize it

myW50bin2 = 5

for i = numbinsperperiod-1, 0, -1 do begin
  if Iabsolute[i] ge W50I then begin
  myW50bin2=i+1
  break
  endif
endfor

print, 'My upper W50 bin is ', myW50bin2
;the upper bin is to the right of the peak intensity 

W50bindiff = myW50bin2-myW50bin1+1
;extracting the difference in bins, that is the number of bins across the W10

print, 'The difference in bins for the W50 is ', W50bindiff

;________________________________________________

myW10bin1 = Value_Locate(Iabsolute[[0:thebinsize/2-1]], W10I)+1
print, 'My lower W10 bin is ', myW10bin1
;the lower bin is to the left of the peak intensity

;myW10bin2 = Value_Locate(Iabsolute[myW10bin1+1:*], W10I) + myW10bin1+2
;Locate the value from myW10bin1+1 until the end of the vector. We must add my W10bin1 to normalize it

myW10bin2 = 5

for i = numbinsperperiod-1, 0, -1 do begin  
  if Iabsolute[i] ge W10I then begin
    myW10bin2=i+1
    break
  endif
endfor

print, 'My upper W10 bin is ', myW10bin2
;the upper bin is to the right of the peak intensity


W10bindiff = myW10bin2-myW10bin1+1
;extracting the difference in bins, that is the number of bins across the W10

print, 'The difference in bins for the W10 is ', W10bindiff


bintoms = P0[pulsarnumber]/numbinsperperiod*1000.
;bin to ms conversion

W50meas=bintoms*W50bindiff
;Measured value of W50 over the pulsar in ms
W10meas=bintoms*W10bindiff
;Measured value of W10 over the pulsar in ms

bintolong = 360./numbinsperperiod 
;360degrees for every 1024 (or 512) bins

W50measlong=bintolong*W50bindiff
;Measured value of W50 pver the pulsar in degrees longitude
w10measlong=bintolong*W10bindiff
;Measured value of W10 over the pulsar in degrees longitude

W50measfigonly = strtrim(W50measlong,1)
;This value of W50 is a string and is for the plot only
W10measfigonly = strtrim(W10measlong,1)
;This value of W50 is a string and is for the plot only

W50measfigonlylong = strmid(W50measfigonly,0,4)
W10measfigonlylong = strmid(W10measfigonly,0,4)
;Trimming extraneous sig figs


print, 'The W50 is ', W50meas, ' ms'
print, 'The W10 is ', W10meas, ' ms'


;________________________________________________________________________________

;plot prodcedure for the Primary Stokes Plot

set_plot,'ps'
;set plotting to PostScript
device, filename= Jname[pulsarnumber] + '.20CM.Final.ps', xsize=28, ysize=20
;use device to set some PostScript device options



;lowpapsi = ((longtobinwindown*360.)/thebinsize)-180.
;highpapsi = ((longtobinwindowp*360.)/thebinsize)-180.
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
  title= Jname[pulsarnumber] + ' 20CM',xtitle='', ytitle='Intensity',$
  xstyle=1,ystyle=1, _extra = gang_plot_pos(2,1,2)
background=100200400
color=0
;plot the array with bin on x and I on y.

oplot, longitude, Qshift, linestyle = 5, color=cgcolor('red'), _extra = gang_plot_pos(2,1,2)
oplot, longitude, Ushift, linestyle = 4, color=cgcolor('blue'),_extra = gang_plot_pos(2,1,2)
oplot, longitude, Vabsolute, linestyle = 3, color=cgcolor('purple'),_extra = gang_plot_pos(2,1,2)
oplot, longitude, Ltrue, linestyle = 6, color=cgcolor('orange'), _extra = gang_plot_pos(2,1,2)


;xyouts, wwindow[pulsarnumber]-wwindow[pulsarnumber]*.20,max(Iabsolute)+max(Iabsolute)*.0, 'Black = I', color=cgcolor('black'), charsize=0.5, /data,_extra = gang_plot_pos(2,1,2)
;xyouts, wwindow[pulsarnumber]-wwindow[pulsarnumber]*.20,max(Iabsolute)-max(Iabsolute)*.10, 'Red = Q', color=cgcolor('red'), charsize=0.5, /data,_extra = gang_plot_pos(2,1,2)
;xyouts, wwindow[pulsarnumber]-wwindow[pulsarnumber]*.20,max(Iabsolute)-max(Iabsolute)*.20, 'Blue = U', color=cgcolor('blue'), charsize=0.5, /data,_extra = gang_plot_pos(2,1,2)
;xyouts, wwindow[pulsarnumber]-wwindow[pulsarnumber]*.20,max(Iabsolute)-max(Iabsolute)*.30, 'Purple = V', color=cgcolor('purple'), charsize=0.5, /data,_extra = gang_plot_pos(2,1,2)
;xyouts, wwindow[pulsarnumber]-wwindow[pulsarnumber]*.20,max(Iabsolute)-max(Iabsolute)*.40, 'Orange = L', color=cgcolor('orange'), charsize=0.5, /data,_extra = gang_plot_pos(2,1,2)

wwxneg=[-wwindow[pulsarnumber],-wwindow[pulsarnumber]]
wwyneg=[-1000000000,4000000000]
;oplot,wwxneg, wwyneg, color=cgcolor('red')
;these oplots are to check the range of summation for the various paramaters over the pulse

wwxpos=[wwindow[pulsarnumber],wwindow[pulsarnumber]]
wwypos=[-1000000000,400000000000]
;oplot,wwxpos, wwypos, color=cgcolor('red')
;these oplots are to check the range of summation for the various paramaters over the pulse


btl501 = myW50bin1/(numbinsperperiod/360.)- (thebinsizeover2/(numbinsperperiod/360.))
;bin to longitude W50 1
btl502 = myW50bin2/(numbinsperperiod/360.)- (thebinsizeover2/(numbinsperperiod/360.))
;bin to longitude W50 2
btl101 = myW10bin1/(numbinsperperiod/360.)- (thebinsizeover2/(numbinsperperiod/360.))
;bin to longitude W10 1
btl102 = myW10bin2/(numbinsperperiod/360.)- (thebinsizeover2/(numbinsperperiod/360.))
;bin to longitude W10 2

W50negx=[btl501,btl501]
W50negy=[-100000000000,4000000000000000]
;oplot,W50negx, W50negy, color=cgcolor('black'),thick=2,_extra = gang_plot_pos(2,1,2)
;plots the first W50 line

W50posx=[btl502,btl502]
W50posy=[-1000000000000000,40000000000000]
;oplot,W50posx, W50posy, color=cgcolor('black'),thick=2, _extra = gang_plot_pos(2,1,2)
;plots the second W50 line

W10negx=[btl101,btl101]
W10negy=[-100000000000000,4000000000000000]
;oplot,W10negx, W10negy, color=cgcolor('pink'),thick=2, _extra = gang_plot_pos(2,1,2)
;plots the first W10 line

W10posx=[btl102,btl102]
W10posy=[-1000000000000,40000000000000000]
;oplot,W10posx, W10posy, color=cgcolor('pink'),thick=2, _extra = gang_plot_pos(2,1,2)
;plots the second W10 line


;xyouts, median(Bindex)+median(Bindex)*0.4,max(Iabsolute)-.00*max(Iabsolute), 'Percent L = ' + pltoitfigonly, charsize=0.6, /data, _extra = gang_plot_pos(3,1,1)
;xyouts, median(Bindex)+median(Bindex)*0.4,max(Iabsolute)-.12*max(Iabsolute), 'Percent V = ' + pvoifigonly, charsize=0.6, /data, _extra = gang_plot_pos(3,1,1)
;xyouts, median(Bindex)+median(Bindex)*0.4,max(Iabsolute)-.24*max(Iabsolute), 'Percent |V| = ' + pvabsoifigonly, charsize=0.6, /data, _extra = gang_plot_pos(3,1,1)
;xyouts, median(Bindex)+median(Bindex)*0.4,max(Iabsolute)-.36*max(Iabsolute), 'W50 = ' + W50measfigonlylong + ' deg longitude', charsize=0.6, /data, _extra = gang_plot_pos(3,1,1)
;xyouts, median(Bindex)+median(Bindex)*0.4,max(Iabsolute)-.48*max(Iabsolute), 'W10 = ' + W10measfigonlylong + ' deg longitude', charsize=0.6, /data, _extra = gang_plot_pos(3,1,1)
;xyouts, median(Bindex)+median(Bindex)*0.7,max(Iabsolute)-1.08*max(Iabsolute), 'x - axis in Bins', charsize=0.43, /data, _extra = gang_plot_pos(3,1,1)


;___________________________________


;Create an array that plots values only at longitudes where L>= 2 sigma L measured (lmeassigma).
;Initialize an array with the number, 999999999.9 in every element. Run a for loop
;such that for L>=sigma, place papsi in the new array.

;____________________________________________________________________________
;Begin calculating postion angle Psi and build the corresponding plot below

papsi = 0.5*atan(Ushift,Qshift)*(180/!PI)
; For arctan(opposite/adjacent), one should write atan(adjacent,opposite) given IDL's syntax (same as mathmatica) - Convert from radians to degrees

print, Ushift[1], Qshift[1], papsi[1]

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


;plot,longitude,papsinew, $
  ;PSYM = 3,$
  ;max_value = 90, $
  ;xrange=[lowpapsi,highpapsi],$
  ;;xrange=[-180,180], $
  ;yrange=[-100,100], $
  ;;symbol style
  ;symsize=.3,$
  ;title='',xtitle= 'Longitude,' + cgGreek('phi') + '[deg]', ytitle='P.A. (deg.)',$
  ;xstyle=1,ystyle=1, _extra = gang_plot_pos(2,1,1, size=[0.8,0.85])
 
ploterror, longitude, papsinew, sigpsi, $
  max_value = 90, $
  xrange=[lowpapsi,highpapsi],$
  yrange=[-100,100], $
  ;symbol style
  symsize=1,$
  title='',xtitle= 'Longitude,' + cgGreek('phi') + '[deg]', ytitle='P.A. (deg.)',$
  xstyle=1,ystyle=1, /nohat, _extra = gang_plot_pos(2,1,1, size=[0.8,0.85]), charsize=1
 
device, /close

;    Meausred Variables For Each Pulsar (key)
;    ________________________________________
;    
;    - Ltrue/I = LtrueoverItrue (fractional)
;    - V/I = VoverI (fractional)
;    - |V|/I = VabsoverI (fractional)
;    - W10 = W51meas (ms)
;    - W50 = W50meas (ms)

print, '______________________________________'
print, '______________________________________'
print, '______________________________________'

;________________________________________________________________



;DEBUGGING PLOTS

;set_plot,'ps'
;set plotting to PostScript
;device, filename= 'DebugPlot'
;use device to set some PostScript device options

;plot,longitude,lmeas,$
  ;PSYM = 1,$
  ;max_value = 100000, $
  ;xrange=[lowpapsi,highpapsi],$
  ;yrange=[-1,5], $
  ;symsize=.3,$
  ;color = cgcolor('red'), $
  ;title=Jname[pulsarnumber] + ' 20CM Lmeas',xtitle='' ,ytitle='P.A. (deg.)',$
  ;xstyle=1,ystyle=1, _extra = gang_plot_pos(1,1,1)

;plot,longitude,ltrue,$
    ;PSYM = 1,$
    ;max_value = 100000, $
    ;xrange=[lowpapsi,highpapsi],$
    ;yrange=[-1,5], $
    ;symsize=.3,$
    ;title=Jname[pulsarnumber] + ' 20CM Ltrue',xtitle='' ,ytitle='P.A. (deg.)',$
    ;xstyle=1,ystyle=1, _extra = gang_plot_pos(1,1,1)


;device, /close

;Debugging Plot 2

;set_plot,'ps'
;set plotting to PostScript
;device, filename= 'DebugPlot'
;use device to set some PostScript device options

;smoothi = smooth(Iabsolute,9)

;plot,longitude,Iabsolute,$
;PSYM = 1,$
;max_value = 100000, $
;xrange=[-180,180],$
;yrange=[-10,40], $
;symsize=.3,$
;color = cgcolor('black'), $
;title=Jname[pulsarnumber] + ' 20CM Smooth I',xtitle='' ,ytitle='P.A. (deg.)',$
;xstyle=1,ystyle=1, _extra = gang_plot_pos(1,1,1)

;oplot, longitude, smoothi, color = cgcolor('yellow')

;device, /close

num = indgen(155)

;print, Jname[pulsarnumber], LtrueoverItrue, VoverI, VabsoverI, W50measlong, W10measlong

;endfor

;free_lun, lunw


end