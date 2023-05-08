source("C:/Users/vlad/OneDrive - Cardiff University/Year 3/BI3157 - Systems Biology/CW3/grindr/grind.R")

model <- function(t, state, parms) {
  with(as.list(c(state,parms)), {

    dR <- s-d*R-a1*R*N1-a2*R*N2
    dN1 <- c1*a1*R*N1-d1*N1
    dN2 <- c2*a2*R*N2-d2*N2
    
    return(list(c(dR,dN1,dN2)))  
  }) 
}

p <- c(s=5,d=0.25,a1=0.2,a2=0.3,c1=0.13,c2=0.1,d1=0.1,d2=0.12)

s <- c(R=6,N1=2,N2=3)

#generate a data point every tstep, run for tmax
run(tmax=2000, tstep=0.1,xlab="Time [years]",ylab="Population size")

plane(xmin=0,xmax=5,ymin=0,ymax=10,eps=-.001,show=names(s),zero=F,vector=TRUE,)

#start with no fo0d
s <- c(R=0,N1=3,N2=3)
#run the model again
run(tmax=1000, tstep=0.1)

#the most relevant arguments of run() that you might want to change one day, and their default values
run(tmax=100, tstep=1, state=s, parms=p, odes=model, ymin=0, ymax=NULL,
  log="", xlab="Time", ylab="Density", tmin=0, draw=lines,
  show=NULL, timeplot=TRUE, traject=FALSE,
  table=FALSE, add=FALSE, legend=TRUE, solution=FALSE, lwd=2)
