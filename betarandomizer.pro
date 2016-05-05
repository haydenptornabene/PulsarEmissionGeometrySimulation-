pro betarandomizer 

  common share3, betarandomarraypdf
  common randoshare, numberofitterations

  ;betarandomarray = !PI*(double(randomu(Seed,numberofitterations))-0.5)
  ;randomn is the randomu procedure with the normal keyword se

  betarandomarray = (!PI/2.)*(double(randomu(Seed,numberofitterations)))

  
  betarandomarraypdf = betarandomarray
  ;this takes the alpharandomarray and processes it through a flat pdf


end

