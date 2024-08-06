assign("moranbir.test",
  function(varX,varY,listw,zero.policy=NULL,adjust.n=TRUE,N,graph=FALSE,
           alternative="greater", spChk=NULL, print.results=TRUE, ...){
    if (is.null(zero.policy))
      zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
    stopifnot(is.logical(zero.policy))

  observed<-moran.bi(varX,varY,listw=listw,zero.policy=zero.policy,adjust.n = adjust.n,...)
  DF <- data.frame(1:length(varX),varX,varY)
  names(DF) <- c("Obs","X","Y")
  if(length(varX)<8){
    X1<-unique(combinat::permn(DF$Obs))
  }
  else{
    X1<-randomize_vector(DF$Obs,N)
  }
  if(length(varY)<8){
    Y1<-unique(combinat::permn(DF$Obs))
  }
  else{
    Y1<-randomize_vector(DF$Obs,N)
  }
  rxy <- cor(varX,varY)
  store<-rep(NA,length(X1))
  for(i in 1:length(store)){
    store[i]<-moran.bi(varX[X1[[i]]],varY[Y1[[i]]],listw,zero.policy = zero.policy, adjust.n = adjust.n)$I
  }
  if(observed$I>=0){
    p.value<-(sum(ifelse(store>observed$I,1,0))+1)/(length(store)+1)
    expected <- -rxy/(length(varX)-1)
  }
  else if(observed$I<0){
    p.value<-(sum(ifelse(store<observed$I,1,0))+1)/(length(store)+1)
    expected <- -rxy/(length(varX)-1)
  }
  if(graph==T){
    tmp.dat<-data.frame(store=store,observed=observed$I)
    export.graph<-ggplot2::ggplot(tmp.dat,aes(x=store))+
      scale_y_sqrt()+geom_density()+
      geom_vline(aes(xintercept=observed),color="red",size=1)+
      xlab("Bivariate Moran's I Coefficient") +
      ylab("Empirical Density")+theme_bw()
    print(export.graph)
  }
  if(print.results==T){
    print(list(Observed=observed$I,Expected=expected,p.value=p.value))
  }
  z<-list(Observed=observed$I,Expected=expected,p.value=p.value,Values=store)
})
