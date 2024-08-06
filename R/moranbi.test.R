assign("moranbi.test",
  function(varX, varY, listw, randomisation=TRUE, zero.policy=NULL,
	alternative="greater", rank = FALSE, spChk=NULL,
	adjust.n=TRUE, drop.EI2=FALSE) {
	alternative <- match.arg(alternative, c("greater", "less", "two.sided"))
	if (!inherits(listw, "listw")) stop(paste(deparse(substitute(listw)),
		"is not a listw object"))
	if (!is.numeric(varX)) stop(paste(deparse(substitute(varX)),
		"is not a numeric vector"))
	if (!is.numeric(varY)) stop(paste(deparse(substitute(varY)),
		"is not a numeric vector"))
        if (is.null(zero.policy))
            zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
        stopifnot(is.logical(zero.policy))
	if (is.null(spChk)) spChk <- spdep::get.spChkOption()
  if (spChk && !chkIDs(varX, listw) && !chkIDs(varY, listw))
    stop("Check of data and weights ID integrity failed")

    xname <- deparse(substitute(varX))
    yname <- deparse(substitute(varY))
    wname <- deparse(substitute(listw))
    NAOK <- any((is.na(cbind(varX,varY))))
    na.act <- attr(na.omit(cbind(varX,varY)), "na.action")
    varX[na.act]<-NA
    varY[na.act]<-NA
    varX<-na.omit(varX)
    varY<-na.omit(varY)

    if (NAOK==TRUE | !is.null(na.act)) {
          subset <- !(1:length(listw$neighbours) %in% na.act)
          listw <- subset(listw, subset, zero.policy=zero.policy)
    }

	n <- length(listw$neighbours)
	wc <- spweights.constants(listw, zero.policy=zero.policy, adjust.n=adjust.n)

	res <- moran.bi(varX, varY, listw, zero.policy = zero.policy, NAOK=NAOK)
	Ixy <- res$I
	Kx <- res$Kx
	if (rank) Kx <- (3*(3*wc$n^2 -7))/(5*(wc$n^2 - 1))
  Xc <- varX-mean(varX)
  Yc <- varY-mean(varY)
  m2x <- sum(Xc^2)/wc$n
  m2y <- sum(Yc^2)/wc$n
	m2xy <- sum((Xc^2)*(Yc^2))/wc$n
	mxy <- sum(Xc*Yc)/wc$n
	W <- as.matrix(spatialreg::as_dgRMatrix_listw(listw))
	S0 <- t(rep(1,n))%*%(W)%*%rep(1,n)
	S02 <- S0^2
	S3 <- t(rep(1,n))%*%(W*t(W))%*%rep(1,n)
	S4 <- t(rep(1,n))%*%(W*W)%*%rep(1,n)
	S5 <- t(rep(1,n))%*%(W%*%W)%*%rep(1,n)
	S6 <- t(rep(1,n))%*%(t(W)%*%W+W%*%t(W))%*%rep(1,n)
	S1 <- S3+S4 # t(rep(1,wc$n))%*%(W*W+W*t(W))%*%rep(1,wc$n)
	S2 <- 2*S5+S6
	rxy <- cor(varX,varY)
	EIxy <- -rxy/(wc$n1)

	if(randomisation) {
	VIxy <- ((mxy^2/(m2x*m2y))*wc$n*(2*(S02-S2+S1)+(2*S3-2*S5)*wc$n3+S3*wc$n2*wc$n3)+
	           wc$n*((S02-S2+S1)+(2*S4-S6)*wc$n3+S4*wc$n2*wc$n3))
	tmp <- (m2xy/(m2x*m2y))*(6*(S02-S2+S1)+(4*S1-2*S2)*wc$n3+S1*wc$n2*wc$n3)
            if (tmp > VIxy) warning("Kurtosis overflow,\ndistribution of variable does not meet test assumptions")
	VIxy <- (VIxy - tmp) / (wc$n1*wc$n2*wc$n3*S02)
		        if (!drop.EI2) VIxy <- (VIxy - EIxy^2)
            if (VIxy < 0) warning("Negative variance,\ndistribution of variable does not meet test assumptions")
	} else {
		VIxy <- (wc$nn*wc$S1 - wc$n*wc$S2 + 3*S02) / (S02*(wc$nn - 1))
		            if (!drop.EI2) VIxy <- (VIxy - EIxy^2)
                if (VIxy < 0) warning("Negative variance,\ndistribution of variable does not meet test assumptions")
	}
	ZIxy <- (Ixy - EIxy) / sqrt(VIxy)
	statistic <- ZIxy
	names(statistic) <- "Bivariate Moran Z(I_{xy}) statistic"
        if (alternative == "two.sided")
		PrIxy <- 2 * pnorm(abs(ZIxy), lower.tail=FALSE)
        else if (alternative == "greater")
            PrIxy <- pnorm(ZIxy, lower.tail=FALSE)
        else PrIxy <- pnorm(ZIxy)
	if (!is.finite(PrIxy) || PrIxy < 0 || PrIxy > 1)
		warning("Out-of-range p-value: reconsider test arguments")
	vec <- c(Ixy, EIxy, VIxy)
	names(vec) <- c("Bivariate Moran I_{xy} statistic", "Expectation", "Variance")
	method <- paste("Bivariate Moran I_{xy} test under", ifelse(randomisation,
	    "randomisation", "normality"))
	data.name <- paste(xname, ifelse(rank,
		"using rank correction",""), "\nweights:",
		wname, ifelse(is.null(na.act), "", paste("\nomitted:",
	    paste(na.act, collapse=", "))),
		       ifelse(adjust.n && isTRUE(any(sum(card(listw$neighbours) == 0L))),
		       "n reduced by no-neighbour observations\n", ""),
		       ifelse(drop.EI2, "EI^2 term dropped in VI", ""), "\n")
	res <- list(statistic=statistic, p.value=PrIxy, estimate=vec,
	    alternative=alternative, method=method, data.name=data.name)
	if (!is.null(na.act)) attr(res, "na.action") <- na.act
	class(res) <- "htest"
	res
})

