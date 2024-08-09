assign("moran.bi",
  function(varX,varY,listw,zero.policy=NULL,adjust.n=TRUE,NAOK=FALSE){
    if (!inherits(listw, "listw"))
        stop(paste(deparse(substitute(listw)), "is not a listw object"))
    if (!is.numeric(varX))
        stop(paste(deparse(substitute(varX)), "is not a numeric vector"))
    if (!is.numeric(varY))
        stop(paste(deparse(substitute(varY)), "is not a numeric vector"))
    if (is.null(zero.policy))
        zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
    stopifnot(is.logical(zero.policy))
    d <- function(x){deparse(substitute(x))}
    xname <- d(varX)
    yname <- d(varY)
    wname <- d(listw)

    na.act <- attr(na.omit(cbind(varX,varY)), "na.action")
    varX[na.act]<-NA
    varY[na.act]<-NA

#    xna.act <- attr(na.action(varX), "na.action")
#    yna.act <- attr(na.action(varY), "na.action")
#    varX<-na.action(varX)
#    varY<-na.action(varY)
    if (NAOK==TRUE) {   #(list(NULL) %in% list(xna.act,yna.act))==FALSE
      subset <- !(1:length(listw$neighbours) %in% na.act) #Reduce(union, list(xna.act,yna.act))
      listw <- subset(listw, subset, zero.policy=zero.policy)
    }
    n <- length(listw$neighbours)
    if (n != length(na.omit(varX))) stop("objects of different length")
    if (n != length(na.omit(varY))) stop("objects of different length")
   wc <- spweights.constants(listw, zero.policy=zero.policy, adjust.n=adjust.n)

#   varX[which(is.na(varY))]<-NA
#   varY[which(is.na(varX))]<-NA
#  lzy <- lag.listw(listw, varY, zero.policy = zero.policy, NAOK = NAOK)
   morans<-ifelse(NAOK == TRUE,(n/(wc$S0))%*%(t(scale(na.omit(varX)))%*%
                  as.matrix(spatialreg::as.spam.listw(listw))%*%scale(na.omit(varY)))/
                  (t(scale(na.omit(varX)))%*%scale(na.omit(varX))),
                  (n/(wc$S0))%*%(t(scale(varX))%*%as.matrix(spatialreg::as.spam.listw(listw))
                  %*%scale(varY))/(t(scale(varX))%*%scale(varX)))
 	xx <- mean(varX, na.rm=NAOK)
 	yy <- mean(varY, na.rm=NAOK)
	zx <- na.omit(varX) - xx
	zy <- na.omit(varY) - yy
	zzx <- sum(zx^2, na.rm=NAOK)
	zzy <- sum(zy^2, na.rm=NAOK)
	Kx <- (length(na.omit(varX))*sum(zx^4, na.rm=NAOK))/(zzx^2)
	Ky <- (length(na.omit(varY))*sum(zy^4, na.rm=NAOK))/(zzy^2)
 	res <- list(I=as.vector(morans), Kx=Kx, Ky=Ky)
	res
})
