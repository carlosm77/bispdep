
moranbi.mc <- function(varX, varY, listw, nsim, zero.policy=NULL,
	alternative="greater", na.action=na.fail, spChk=NULL,
        return_boot=FALSE, adjust.n=TRUE, parallel="no",ncpus=getOption("boot.ncpus", 1L),cl=NULL) {
	alternative <- match.arg(alternative, c("greater", "less", "two.sided"))
	if(!inherits(listw, "listw")) stop(paste(deparse(substitute(listw)),
		"is not a listw object"))
	if(!is.numeric(varX)) stop(paste(deparse(substitute(varX)),
		"is not a numeric vector"))
	if(!is.numeric(varY)) stop(paste(deparse(substitute(varY)),
	  "is not a numeric vector"))
        if (is.null(zero.policy))
            zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
        stopifnot(is.logical(zero.policy))
	if(missing(nsim)) stop("nsim must be given")
	if (is.null(spChk)) spChk <- spdep::get.spChkOption()
	if (spChk && !chkIDs(varX, listw))
		stop("Check of data of variable X and weights ID integrity failed")
  if (spChk && !chkIDs(varY, listw))
    stop("Check of data of variable X and weights ID integrity failed")

	cards <- card(listw$neighbours)
	if (!zero.policy && any(cards == 0))
		stop("regions with no neighbours found")
#	if (any(is.na(x))) stop("NA in X")
	xname <- deparse(substitute(varX))
	wname <- deparse(substitute(listw))
	if (deparse(substitute(na.action)) == "na.pass")
	    stop("na.pass not permitted")
	varX <- na.action(varX)
	nax.act <- attr(varX, "na.action")
	if (!is.null(nax.act)) {
	    subsetx <- !(1:length(listw$neighbours) %in% nax.act)
	    listw <- subset(listw, subsetx, zero.policy=zero.policy)
	}
	varY <- na.action(varY)
	nay.act <- attr(varY, "na.action")
	if (!is.null(nay.act)) {
	  subsety <- !(1:length(listw$neighbours) %in% nay.act)
	  listw <- subset(listw, subsety, zero.policy=zero.policy)
	}
	n <- length(listw$neighbours)
	if (n != length(varX)) stop("objects of different length")
        gamres <- suppressWarnings(nsim > gamma(n + 1))
        if (gamres) stop("nsim too large for this number of observations")
	if (nsim < 1) stop("nsim too small")
        if (adjust.n) n <- n - sum(cards == 0L)

	S0 <- Szero(listw)
        if (return_boot) {
            moran_boot <- function(varx, vary, i, ...) {
                varx <- varx[i]
                vary <- vary[i]
                return(moran.bi(varX=varx, varY=vary, ...)$I)
            }
            res <- boot(varX, statistic=moran_boot, R=nsim,
                sim="permutation", listw=listw,
                zero.policy=zero.policy, parallel=parallel, ncpus=ncpus, cl = cl)
            return(res)
        }
	res <- numeric(length=nsim+1)
	for (i in 1:nsim) res[i] <- moran.bi(sample(varX), sample(varY), listw,
	    zero.policy=zero.policy)$I
	res[nsim+1] <- moran.bi(varX, varY, listw, zero.policy=zero.policy)$I
	rankres <- rank(res)
	xrank <- rankres[length(res)]
	diff <- nsim - xrank
	diff <- ifelse(diff > 0, diff, 0)
	if (alternative == "less")
        	pval <- punif((diff + 1)/(nsim + 1), lower.tail=FALSE)
    	else if (alternative == "greater")
        	pval <- punif((diff + 1)/(nsim + 1))
        else pval <- punif(abs(xrank - (nsim+1)/2)/(nsim + 1), 0, 0.5,
                lower.tail=FALSE)
	if (!is.finite(pval) || pval < 0 || pval > 1)
		warning("Out-of-range p-value: reconsider test arguments")
	statistic <- res[nsim+1]
	names(statistic) <- "statistic"
	parameter <- xrank
	names(parameter) <- "observed rank"
	method <- "Monte-Carlo simulation of Bivariate Moran I"
	data.name <- paste(xname, "\nweights:",
	    wname, ifelse(is.null(nax.act), "", paste("\nomitted:",
	    paste(nax.act, collapse=", "))), "\nnumber of simulations + 1:",
	    nsim+1, "\n")
	lres <- list(statistic=statistic, parameter=parameter,
	    p.value=pval, alternative=alternative, method=method,
	    data.name=data.name, res=res)
	if (!is.null(nax.act)) attr(lres, "na.action") <- nax.act
	class(lres) <- c("htest", "mc.sim")
	lres
}
