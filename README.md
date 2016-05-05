# PulsarEmissionGeometrySimulation-
Pulsar emission geometry simulations using IDL with Dr. Joel Weisberg (Carleton College) 

Within this repisitory one will find code that I used to process a sample of 125+ Pulsars at the Australia National Telescope Facility in Sydney, Australia with Dr. Joel Weisberg of Carleton College and Dr. Simon Johnston of ATNF CISRO Marsfield. Most of the code was produced during the months of June-August 2015.  

Some of the newer code was created at Carleton College between November of 2015 and May of 2016.

I extracted a number of paramters from 125+ pulse profiles, including pulse width, intensity, stokes paramaters I,Q,U,V using a series of interconnected code segments.

- All of the files are located in /FileSystem/data/psrdata/VeniceHayden
(Most files from my time in Australia, some are still located on the remote disk at ATNF)

- All these different pulse profiles for approx 125 pulsars
	- Contains Polarization data, and a PA curve with error bars

- The program iquvextract13finalplotmaker.pro produces the plots found in Profiles.Finals.PAErrorBar
	- Look at comments to see old versions

- On the associated pulse profiles what are we seeing? Different parameters, I, Q, U, V, L (Stokes) 
	I = Intensity (Black)
	Q = (Red)
	U = (Blue)
	V = (Purple) 
	L = (Q^2+U^2)^(0.5) (Orange) (Linear Polarizations) 

Position Angle Psi = 0.5arctan(U/Q) 

Q and U fully describe linear polarization. If, for example, you only had Q, then Q = 0 for light polarized at 45￼! Not good.
More simply, you can say that for linear polarization, you need to find both an amplitude and a position angle. To solve for both parameters, you need two equations.
(See below link)
https://casper.berkeley.edu/astrobaki/index.php/Polarization

Good website that has a discussion of Polarization 

All the IDL programs are found in fdwHaydenVenice/IDLprograms

From the rotating vector model, we can constrain possible values of alpha and beta, where alpha is the angle between the rotation axis and the magnetic axis and beta is the angle between the magnetic axis and the line of sight. 

The program that isolates that space is called alphabetafinder.pro. This program finds possible values of different pulsars and then plots them individually to files that can be found in the \VeniceHayden\AlphaBetaSpace\IndividualPlots directory.
	- Notice that these plots plot possible alpha beta combinations in terms of radians

	- This program can also plot all of individual pulsar alpha beta sweeps onto one plot, for 	example the plot entitled 125.Pulsars.Alpha.BetaSpace.BetaTwo.300km.ps. These group plots 	are found in the \AlphaBetaSpace directory. This plot has a lot of information and Joel and I 	have puzzled over a variety of them for quite a while.

	- Notice the bizarre title that includes "300km". This refers to an assumption made on the 	emission height. Some models have the emission height as 0.04*the radius of the light cone. 	We experimented with different values for this as alpha and beta are dependent on the 	emission height. I will give the explicit equation that relates all the variable we need to 	consider, and I will explain each one when we are together.    

Now we can discuss the statistical randomized simulation that probes the likelihood of given paris of alpha and beta. 

	- We generate random values for alpha and zeta (zeta = alpha + beta)
	
	- Zeta is randomized in a similar way to alpha, beta cannot be done in the same way, so we 	pull beta from a uniform zeta randomization.
	
	- Still need to make a zeta randomization program and fix the cos^-1 pdf 

	- alphabetaranomizer.pro takes enacts the two protocols and compiles the associated alpha 	and zeta values. For each value of alpha and beta, the protocol calculates a value of W, the 	width of pulsar beam. The program bins the W values for the following cases:
	
	W < rho (intrinsic beam width) 
	W > rho
	W = rho
	W = NAN (unphysical) 

- alphabetarandomizer.pro creates a text file called alphabetatable.txt that can be found in the /Venice/IDLprograms directory
- The program alphabetarandomplotter takes the values from alphabetatable.txt and creates the period-percentage plots

	Histograms
	- After all the values are establushed for each pulsar, the are printed to a file called 	\cummulativeWpercetantages,txt where the values for each column are:
	Jname     wtotal25percent    wtotal50percent    wtotal75percent     wtotalmax
	- Look at alphabetarandomizer.pro for more details about histograms
	- Histograms are still at ATNF, if you want them just let me know I will transfer them over.
	

	-Alphabetarandomplotter.pro takes the W<rho, W>rho, etc for each pulsar and plots the 	(Percentage of Trials that fell in a certain bin)/(# of iterations) as a function of period. Each 	data point on this plot represent a specific pulsar. 

	- We have been trying to get the theoretical turquoise lines to match up with our simulated 	data 	curves. Once we have done that, we can start to use our simulation to understand 	simulated alpha beta distributions and the distributions found in the alphabeta space plots.   

