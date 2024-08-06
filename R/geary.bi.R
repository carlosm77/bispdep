geary.bi <- function(varX, varY, listw, zero.policy=NULL,adjust.n=TRUE,alternative="greater") {
        if (is.null(zero.policy))
            zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
        stopifnot(is.logical(zero.policy))
        stopifnot(is.vector(varX))
        stopifnot(is.vector(varY))
  wc <- spweights.constants(listw, zero.policy = zero.policy, adjust.n = adjust.n)
  n <- wc$n
  n1 <- wc$n1
  S0 <- wc$S0
  n2 <- length(varX)
  res <- as.matrix(spatialreg::as_dgRMatrix_listw(listw))*(kronecker(matrix(varX,nrow=n2),t(rep(1,n2)))-
         t(kronecker(matrix(varY,nrow=n2),t(rep(1,n2)))))^2
	zx <- scale(varX, scale=FALSE)
	zzx <- sum(zx^2)
	Kx <- (n*sum(zx^4))/(zzx^2)
	zy <- scale(varY, scale=FALSE)
	zzy <- sum(zy^2)
	Ky <- (n*sum(zy^4))/(zzy^2)
	C <- (n1 / (2*S0)) * (sum(res) / zzx)
	res <- list(C=C, Kx=Kx, Ky=Ky)
	res
}
