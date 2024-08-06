assign("getis.cluster",
   function(x, listw, zero.policy = NULL, polygons, significant=TRUE, pleg, ...){
     if (is.null(zero.policy))
       zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
     stopifnot(is.logical(zero.policy))
get.dat <- localG(x, listw, zero.policy)

get.dat1<-data.frame(as.vector(get.dat))
names(get.dat1)<-c("Z.Gi")


get.dat1$cluster<-"UN"
get.dat1$cluster[get.dat1[,"Z.Gi"]>=qnorm(0.975,mean=0,sd=1)]<-"HH"     # both z scores are "high"
get.dat1$cluster[get.dat1[,"Z.Gi"]<=qnorm(0.025,mean=0,sd=1)]<-"LL"     # both z scores are "low"
get.dat1$cluster[is.na(get.dat1[,"Z.Gi"])]<-"NA"

cols<-c(brewer.pal(5, "RdBu"),"#BEBEBE")
get.dat1$col[get.dat1$cluster=="UN"]<-cols[3]
get.dat1$col[get.dat1$cluster=="HH"]<-cols[1]
get.dat1$col[get.dat1$cluster=="LL"]<-cols[5]
get.dat1$col[get.dat1$cluster=="NA"]<-cols[6]
get.dat1

dev.new()
opar <- par(pty="s",mar=c(0,0,0,0))
on.exit(par(opar))
P1 <- plot(polygons, col=get.dat1$col, ...)
legend(x = pleg, legend=c(paste("Not Significant  ",
      "(",length(get.dat1$cluster[get.dat1$cluster=="UN"]),")",sep="",collapse=""),
      paste("High-High  ","(",length(get.dat1$cluster[get.dat1$cluster=="HH"]),")",
      sep="",collapse=""),paste("Low-Low  ",  "(",length(get.dat1$cluster[get.dat1$cluster=="LL"]),
      ")",sep="", collapse=""), paste("Neighborless  ",
      "(",length(get.dat1$cluster[get.dat1$cluster=="NA"]),")",sep="",collapse="")),
      fill=c(cols[3],cols[1],cols[5],cols[6]),title = "Gi* Cluster Map", bty="n",
      cex=1.2, y.intersp=0.8)
par(mfrow=c(2,2))

if (significant) {
get.dat1$prob<-"UN"
get.dat1$prob[get.dat1[,"Z.Gi"]>=qnorm(0.975,mean=0,sd=1)|get.dat1[,"Z.Gi"]<=qnorm(0.025,mean=0,sd=1)]<-"5%"
get.dat1$prob[get.dat1[,"Z.Gi"]>=qnorm(0.995,mean=0,sd=1)|get.dat1[,"Z.Gi"]<=qnorm(0.005,mean=0,sd=1)]<-"1%"
get.dat1$prob[get.dat1[,"Z.Gi"]>=qnorm(0.9995,mean=0,sd=1)|get.dat1[,"Z.Gi"]<=qnorm(0.0005,mean=0,sd=1)]<-"0.1%"
get.dat1$prob[get.dat1[,"Z.Gi"]>=qnorm(0.99995,mean=0,sd=1)|get.dat1[,"Z.Gi"]<=qnorm(0.00005,mean=0,sd=1)]<-"0.01%"
get.dat1$prob[is.na(get.dat1[,"Z.Gi"])]<-"NA"

colsp<-c(brewer.pal(5, "Greens"),"#BEBEBE")
get.dat1$col1[get.dat1$prob=="UN"]<-colsp[1]
get.dat1$col1[get.dat1$prob=="5%"]<-colsp[2]
get.dat1$col1[get.dat1$prob=="1%"]<-colsp[3]
get.dat1$col1[get.dat1$prob=="0.1%"]<-colsp[4]
get.dat1$col1[get.dat1$prob=="0.01%"]<-colsp[5]
get.dat1$col1[is.na(get.dat1[,"Z.Gi"])]<-colsp[6]
get.dat1

dev.new()
opar <- par(pty="s",mar=c(0,0,0,0))
P2 <- plot(polygons, col=get.dat1$col1, ...)
legend(x=pleg, legend=c(paste("Not Significant  ", "(",
       length(get.dat1$prob[get.dat1$prob=="UN"]),")",sep="",collapse=""), paste("p=0.05  ",
       "(",length(get.dat1$prob[get.dat1$prob=="5%"]),")",sep="",collapse=""),
       paste("p=0.01  ",  "(",length(get.dat1$prob[get.dat1$prob=="1%"]),")",sep="",
       collapse=""), paste("p=0.001  ",  "(",length(get.dat1$prob[get.dat1$prob=="0.1%"]),
       ")",sep="",collapse=""), paste("p=0.0001  ",  "(",
       length(get.dat1$prob[get.dat1$prob=="0.01%"]),")",sep="",collapse=""),
       paste("Neighborless  ",   "(",length(get.dat1$cluster[get.dat1$cluster=="NA"]),")",
       sep="",collapse="")), bty="n", fill=colsp, title = "Gi* Significance Map", cex=1.2,
       y.intersp=0.8)
par(mfrow=c(2,2))
}
})
