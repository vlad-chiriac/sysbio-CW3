#read in grind
source("C:/Users/vlad/OneDrive - Cardiff University/Year 3/BI3157 - Systems Biology/CW3/grindr/grind.R")

model <- function(t, state, parms) {
  with(as.list(c(state,parms)), {
    
    dx1 = ifelse((t%%1)<0.5,-lambda1*x1,r1*x1*(1-(x1+x2/k1))+a1*x1*x2)
    dx2 = ifelse((t%%1)<0.5,r2*x2*(1-(x1+x2/k1))+b1*x1*x2,-lambda2*x2)
    
    return(list(c(dx1,dx2)))  
  })
}

p <- c(r1=0.3,r2=0.3,r3=0.3,k1=0.5,k2=0.2,k3=0.1,a1=1.5,a2=0.5,b1=0.45,b2=1,c1=1.4,c2=1.5,lambda1=0.1,lambda2=0.1,lambda3=0.1,omega=3,phi=0.5)

s <- c(x1=3,x2=3)

run(tmax=30,tstep=0.1,xlab="Time [years]",ylab="Population size")

