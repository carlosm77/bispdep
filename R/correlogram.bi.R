"correlogram.bi" <-
  function (coords, varX, varY, method = "Moran", nbclass = NULL, zero.policy=NULL, ...)
  {
    if (is.null(zero.policy))
      zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
    stopifnot(is.logical(zero.policy))
    coords <- as.matrix(coords)
    matdist <- dist(coords)
    if (is.null(nbclass))
        nbclass <- nclass.Sturges(matdist)
    etendue <- range(matdist)
    breaks1 <- seq(etendue[1], etendue[2], l = nbclass + 1)
    breaks2 <- breaks1 + 1e-06
    breaks <- cbind(breaks1[1:length(breaks1) - 1], breaks2[2:length(breaks2)])
    breaks[1, 1] <- breaks[1, 1] - 1e-06
    lst.nb1 <- rep(list(NA), nbclass)
    lst.z1 <- rep(list(NA), nbclass)
    lst.z2 <- rep(list(NA), nbclass)
    for (i in 1:length(breaks[, 1])) {
      lst.z1[[i]] <- varX
      lst.z2[[i]] <- varY
      lst.nb1[[i]] <- dnearneigh(coords, breaks[i, 1], breaks[i,2])
      zero <- which(card(lst.nb1[[i]]) == 0)
      if (length(zero) > 0) {
        lst.nb1[[i]] <- dnearneigh(coords[-zero, ], breaks[i, 1], breaks[i, 2])
        lst.z1[[i]] <- varX[-zero]
        lst.z2[[i]] <- varY[-zero]
      }
    }
    lst.res1 <- rep(list(NA), nbclass)
    for (i in 1:length(breaks[, 1])) {
      xt <- switch(pmatch(method, c("Moran", "Geary"), nomatch = 3),
                   try(moranbi.test(lst.z1[[i]], lst.z2[[i]], nb2listw(lst.nb1[[i]],
             style = "W"),zero.policy=zero.policy, ...), silent = TRUE), try(gearybi.test(lst.z1[[i]],
          lst.z2[[i]],nb2listw(lst.nb1[[i]], style = "W"), zero.policy=zero.policy, ...), silent = TRUE),
                   stop("Method must be 'Moran' or 'Geary'"))
      if (inherits(xt, "try-error")) {
        stop("Bad selection of class breaks, try another one...")
      }
      else {
        x <- xt$estimate[1]
        p <- xt$p.value
        N <- sum(card(lst.nb1[[i]]))
      }
      lst.res1[[i]] <- c(x = x, p = p, N = N)
    }
    meth <- names(xt[[3]][1])
    mat <- matrix(unlist(lst.res1), ncol = 3, byrow = TRUE)
    res <- cbind(dist.class = rowMeans(breaks), coef = mat[,1], p.value = mat[, 2],
                 n = mat[, 3], low.l = breaks[,1], up.l = breaks[,2])
    attributes(res) <- c(attributes(res), list(Method = meth))
    class(res) <- c("correlogrambi", "matrix")
    res
  }

"plot.correlogrambi"<-function (x,type,xlab,ylab,main,...) {
  if (!inherits(x, "correlogrambi")) stop("Object must be of class 'correlogrambi'")
  if (missing(main)) main<-paste(attributes(x)$Method," = f(distance classes)",sep="")
  if (missing(type)) type<-"b"
  if (missing(ylab)) ylab<-attributes(x)$Method
  if (missing(xlab)) xlab<-"distance classes"
  plot(x[,1:2,drop=FALSE],type=type,xlab=xlab,ylab=ylab,main=main,xaxt="n",...)
  inc<-(x[2,1]-x[1,1])/2
  breaks <- pretty(c(x[1,1]-inc,x[length(x[,1]),1]+inc), n = length(x[,1]), min.n = 2)
  axis(1,at=breaks,...)
  points(x[x[,3]<0.05,1:2,drop=FALSE],pch=19,col="red",cex=2)
}

"print.correlogrambi"<-function (x,...) {
  if (!inherits(x, "correlogrambi")) stop("Object must be of class 'correlogrambi'")
  cat(attributes(x)$Method,"\n")
  attributes(x)<-attributes(x)[1:2]
  print(x[,,drop=FALSE])
}
