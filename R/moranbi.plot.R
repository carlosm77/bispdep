assign("moranbi.plot",
  function(varY, varX, listw, zero.policy=NULL, spChk=NULL, labels=NULL,
           xlab=NULL, ylab=NULL, quiet=NULL, plot=TRUE, return_df=TRUE, ...){
  if (!inherits(listw, "listw"))
      stop(paste(deparse(substitute(listw)), "is not a listw object"))
  if (is.null(quiet))
      quiet <- !get("verbose", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
  stopifnot(is.vector(varY))
  stopifnot(is.vector(varX))
  stopifnot(is.logical(quiet))
  if (is.null(zero.policy))
      zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
  stopifnot(is.logical(zero.policy))
  xname <- deparse(substitute(varY))
  yname <- deparse(substitute(varX))
  if (!is.numeric(varY))
    stop(paste(xname, "is not a numeric vector"))
  if (any(is.na(varY)))
    stop("NA in varY")
  if (!is.numeric(varY))
    stop(paste(yname, "is not a numeric vector"))
  if (any(is.na(varX)))
    stop("NA in varX")
  n <- length(listw$neighbours)
  if (n != length(varY))
    stop("objects of different length")
  if (is.null(spChk))
    spChk <- get.spChkOption()
  if (spChk && !chkIDs(varX, listw))
    stop("Check of data of varX and weights ID integrity failed")
  if (spChk && !chkIDs(varY, listw))
    stop("Check of data of varY and weights ID integrity failed")
  labs <- TRUE
  if (is.logical(labels) && !labels)
    labs <- FALSE
  if (is.null(labels) || length(labels) != n)
    labels <- as.character(attr(listw, "region.id"))
  wx <- lag.listw(listw, varX, zero.policy = zero.policy)
  if (is.null(xlab))
    xlab <- xname
  if (is.null(ylab))
    ylab <- paste("spatially lagged", yname)
  plot(varY, wx, xlab = xlab, ylab = ylab, ...)
  if (zero.policy) {
  n0 <- wx == 0
  if (any(n0)) {
  symbols(varY[n0], wx[n0], inches = FALSE, circles = rep(diff(range(varY))/50,
                                                           length(which(n0))), bg = "grey", add = TRUE)
    }
  }
  ywx.lm <- lm(wx ~ varY)
  if (plot) abline(ywx.lm)
  if (plot) abline(h=mean(wx), lty=2)
  if (plot) abline(v=mean(varX), lty=2)
  infl.ywx <- influence.measures(ywx.lm)
  is.inf <- apply(infl.ywx$is.inf, 1, any)
  if (plot) points(varY[is.inf], wx[is.inf], pch=9, cex=1.2)
  if (plot && labs)
      text(varY[is.inf], wx[is.inf], labels=labels[is.inf], pos=2, cex=0.7)
  rownames(infl.ywx$infmat) <- labels
  if (!quiet) summary(infl.ywx)
  if (return_df) {
    res <- data.frame(varY=varY, wx=wx, is_inf=is.inf, labels=labels)
    res <- cbind(res, as.data.frame(infl.ywx$infmat))
    attr(res, "xname") <- xname
  } else {
    res <- infl.ywx
  }
  invisible(res)

})
