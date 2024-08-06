gearybi.test <- function(varX, varY, listw, randomisation=TRUE, zero.policy=NULL,
    alternative="greater", spChk=NULL, adjust.n=TRUE) {
        if (is.null(zero.policy))
            zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE)) #get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE)
        stopifnot(is.logical(zero.policy))
	alternative <- match.arg(alternative, c("less", "greater", "two.sided"))
	if(!inherits(listw, "listw")) stop(paste(deparse(substitute(listw)),
		"is not a listw object"))
	if(!is.numeric(varX)) stop(paste(deparse(substitute(varX)),
		"is not a numeric vector"))
	if(!is.numeric(varY)) stop(paste(deparse(substitute(varY)),
	  "is not a numeric vector"))
	if (any(is.na(varX))) stop("NA in varX")
	if (any(is.na(varY))) stop("NA in varY")
	n <- length(listw$neighbours)
	if (n != length(varX)) stop("objects of different length")
	if (n != length(varY)) stop("objects of different length")
	if (is.null(spChk)) spChk <- spdep::get.spChkOption()
	if (spChk && !chkIDs(varX, listw))
		stop("Check of data of the variable X and weights ID integrity failed")
	if (spChk && !chkIDs(varY, listw))
	  stop("Check of data of the variable y and weights ID integrity failed")

	wc <- spweights.constants(listw, zero.policy, adjust.n=adjust.n)
	S02 <- wc$S0*wc$S0
	res <- geary.bi(varX, varY, listw, zero.policy,adjust.n)
	C <- res$C
	if (is.na(C)) stop("NAs generated in geary - check zero.policy")
	Kx <- res$Kx
	EC <- 1
	if(randomisation) {
		VC <- (wc$n1*wc$S1*(wc$nn - 3*n + 3 - Kx*wc$n1))
		VC <- VC - ((1/4) * (wc$n1*wc$S2*(wc$nn + 3*n - 6 -
			Kx*(wc$nn - n + 2))))
		VC <- VC + (S02*(wc$nn - 3 - Kx*(wc$n1^2)))
		VC <- VC / (n*wc$n2*wc$n3*S02)
	} else {
		VC <- ((2*wc$S1 + wc$S2)*wc$n1 - 4*S02) / (2*(n + 1)*S02)
	}
#	ZC <- (C - EC) / sqrt(VC)
	ZC <- (EC - C) / sqrt(VC)
	statistic <- ZC
	names(statistic) <- "Zc_{xy} Statistics of Geary's C_{xy}"
	PrC <- NA
	if (is.finite(ZC)) {
        	if (alternative == "two.sided") PrC <- 2 * pnorm(abs(ZC),
			lower.tail=FALSE)
        	else if (alternative == "greater")
            	PrC <- pnorm(ZC, lower.tail=FALSE)
        	else PrC <- pnorm(ZC)
		if (!is.finite(PrC) || PrC < 0 || PrC > 1)
		    warning("Out-of-range p-value: reconsider test arguments")
	}
	vec <- c(C, EC, VC)
	names(vec) <- c("Geary C_{xy} statistic", "Expectation", "Variance")
	method <- paste("Geary C_{xy} test under", ifelse(randomisation,
	    "randomisation", "normality"))
	data.name <- paste(deparse(substitute(varX)), "\nweights:",
	    deparse(substitute(listw)), "\n")
	res <- list(statistic=statistic, p.value=PrC, estimate=vec,
	    alternative=ifelse(alternative == "two.sided", alternative,
	    paste("Expectation", alternative, "than statistic")),
	    method=method, data.name=data.name)
	class(res) <- "htest"
	res
}


