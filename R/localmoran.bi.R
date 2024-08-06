assign("localmoran.bi",
function (varX, varY, listw, zero.policy = NULL, na.action = na.fail,
          conditional = TRUE, alternative ="two.sided", mlvar = TRUE,
          spChk = NULL, adjust.x = FALSE)
{
    stopifnot(is.vector(varX))
    stopifnot(is.vector(varY))
    if (!inherits(listw, "listw"))
        stop(paste(deparse(substitute(listw)), "is not a listw object"))
    if (is.null(zero.policy))
        zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
    stopifnot(is.logical(zero.policy))
    if (!is.null(attr(listw$neighbours, "self.included")) &&
        attr(listw$neighbours, "self.included"))
        stop("Self included among neighbours")
    if (is.null(spChk))
        spChk <- spdep::get.spChkOption()
    if (spChk && !chkIDs(varY, listw))
        stop("Check of Y variable data and weights ID integrity failed")
    if (spChk && !chkIDs(varX, listw))
      stop("Check of X variable data and weights ID integrity failed")
    if (!is.numeric(varX))
        stop(paste(deparse(substitute(x)), "is not a numeric vector"))
    if (!is.numeric(varY))
        stop(paste(deparse(substitute(y)), "is not a numeric vector"))
    NAOK <- deparse(substitute(na.action)) == "na.pass"
    varX <- na.action(varX)
    na.act <- attr(varX, "na.action")
    varY <- na.action(varY)
    na.act1 <- attr(varY, "na.action")
    rn <- attr(listw, "region.id")
    if (!is.null(na.act)) {
        subset <- !(1:length(listw$neighbours) %in% na.act)
        listw <- subset(listw, subset, zero.policy = zero.policy)
        excl <- class(na.act) == "exclude"
    }
    n <- length(listw$neighbours)
    if (n != length(varY))
        stop("Different numbers of observations")
    res <- matrix(nrow = n, ncol = 5)
    if (alternative == "two.sided")
        Prname <- "Pr(z != 0)"
    else if (alternative == "greater")
        Prname <- "Pr(z > 0)"
    else Prname <- "Pr(z < 0)"
    colnames(res) <- c("Ixyi", "E.Ixyi", "Var.Ixyi", "Z.Ixyi", Prname)
    if (adjust.x) {
        nc <- card(listw$neighbours) > 0L
        xx <- mean(varX[nc], na.rm = NAOK)
    }
    else {
        xx <- mean(varX, na.rm = NAOK)
    }
    z <- varX-xx
    yz <- varY-mean(varY, na.rm = NAOK)
    lyz <- lag.listw(listw, yz, zero.policy = zero.policy, NAOK = NAOK)
    if (mlvar) {
        sx2 <- sum(z^2, na.rm = NAOK)/n
        if (adjust.x) {
            sx2 <- sum(z[nc]^2, na.rm = NAOK)/sum(nc)
        }
        else {
            sx2 <- sum(z^2, na.rm = NAOK)/n
        }
    }
    else {
        sx2 <- sum(z^2, na.rm = NAOK)/(n - 1)
        if (adjust.x) {
            sx2 <- sum(z[nc]^2, na.rm = NAOK)/(sum(nc) - 1)
        }
        else {
            sx2 <- sum(z^2, na.rm = NAOK)/(n - 1)
        }
    }
    res[, 1] <- (z/sx2)*lyz
    Wi <- sapply(listw$weights, sum)
    if (conditional) {
      m2 <- sum(z * z)/n
      res[, 2] <- -(z^2*Wi*cor(varX,varY))/((n - 1) * m2)
    }
    if (mlvar) {
        if (adjust.x) {
            b2 <- (sum((z[nc]^4), na.rm = NAOK)/sum(nc))/(sx2^2)
        }
        else {
            b2 <- (sum((z^4), na.rm = NAOK)/n)/(sx2^2)
        }
    }
    else {
        if (adjust.x) {
            b2 <- (sum((z[nc]^4), na.rm = NAOK)/(sum(nc) - 1))/(sx2^2)
        }
        else {
            b2 <- (sum((z^4), na.rm = NAOK)/(n - 1))/(sx2^2)
        }
    }
    Wi2 <- sapply(listw$weights, function(x) sum(x^2))
    A <- (n - b2)/(n - 1)
    B <- (2 * b2 - n)/((n - 1) * (n - 2))
    if (conditional) {
      res[, 3] <- ((z/m2)^2 * (n/(n - 2)) * (Wi2 - (Wi^2/(n -
                                                            1))) * (m2 - (z^2/(n - 1))))
    }
    else {
      res[, 3] <- A * Wi2 + B * (Wi^2 - Wi2) - res[, 2]^2
    }
    res[, 4] <- (res[, 1] - res[, 2])/sqrt(res[, 3])
    if (alternative == "two.sided") {
      pv <- 2 * pnorm(abs(res[, 4]), lower.tail = FALSE)
    }
    else if (alternative == "greater") {
      pv <- pnorm(res[, 4], lower.tail = FALSE)
    }
    else {
      pv <- pnorm(res[, 4])
    }
    res[, 5] <- pv
    if (!is.null(na.act) && excl) {
        res <- naresid(na.act, res)
    }
    if (!is.null(rn))
        rownames(res) <- rn
    attr(res, "call") <- match.call()
    if (!is.null(na.act))
        attr(res, "na.action") <- na.act
    class(res) <- c("localmoran.bi", class(res))
    res
}
)
