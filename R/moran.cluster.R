assign("moran.cluster",
   function(x, listw, zero.policy = NULL, polygons, conditional=TRUE,
            significant=TRUE, alternative="two.sided", pleg, ...){
     if (is.null(zero.policy))
       zero.policy <- get("zeroPolicy", envir = get('.spdepOptions', envir = asNamespace('spdep'), inherits = FALSE))
     stopifnot(is.logical(zero.policy))
mor.dat <- localmoran(x, listw, zero.policy=zero.policy, conditional=conditional, alternative=alternative)
wx<-lag.listw(listw, x)
lag.z<-scale(wx, center=T, scale=T)
dat.z<-scale(x, center=T, scale=T)

mor.dat1<-data.frame(mor.dat,lag.z,dat.z)
names(mor.dat1)<-c("Ii","E.Ii","Var.Ii","Z.Ii","Pr.Zi","WY","Y")

mor.dat1$cluster<-"UN"
# both z scores are "high"
mor.dat1$cluster[mor.dat1[,"Z.Ii"]>=qnorm(0.975,mean=0,sd=1)&mor.dat1[,"Y"]>0&mor.dat1[,"WY"]>0]<-"HH"
# both z scores are "low"
mor.dat1$cluster[mor.dat1[,"Z.Ii"]>=qnorm(0.975,mean=0,sd=1)&mor.dat1[,"Y"]<0&mor.dat1[,"WY"]<0]<-"LL"
# one z score "high", the other "low"
mor.dat1$cluster[mor.dat1[,"Z.Ii"]<=qnorm(0.025,mean=0,sd=1)&mor.dat1[,"Y"]>0&mor.dat1[,"WY"]<0]<-"HL"
# one z score "low", the other "high"
mor.dat1$cluster[mor.dat1[,"Z.Ii"]<=qnorm(0.025,mean=0,sd=1)&mor.dat1[,"Y"]<0&mor.dat1[,"WY"]>0]<-"LH"
mor.dat1$cluster[is.na(mor.dat1[,"Z.Ii"])]<-"NA"

cols<-c(brewer.pal(5, "RdBu"),"#BEBEBE")
mor.dat1$col[mor.dat1$cluster=="UN"]<-cols[3]
mor.dat1$col[mor.dat1$cluster=="HH"]<-cols[1]
mor.dat1$col[mor.dat1$cluster=="LL"]<-cols[5]
mor.dat1$col[mor.dat1$cluster=="HL"]<-cols[2]
mor.dat1$col[mor.dat1$cluster=="LH"]<-cols[4]
mor.dat1$col[mor.dat1$cluster=="NA"]<-cols[6]
mor.dat1

dev.new()
opar <- par(pty="s",mar=c(0,0,0,0))
on.exit(par(oldpar))
P1 <- plot(polygons, col=mor.dat1$col, ...)
if (significant&alternative=="greater") {
legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="UN"]),")",sep="",collapse=""), paste("High-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HH"]),")",sep="",collapse=""), paste("Low-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LL"]),")",sep="",collapse=""),
paste("Low-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LH"]),")",sep="",collapse=""), paste("High-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HL"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), fill=c(cols[3],cols[1],cols[5],cols[4],cols[2],cols[6]), title = expression(paste("LISA Cluster Map, ","H"["a"]:rho>0)), bty="n", cex=1.2, y.intersp=0.8)
}

if (significant&alternative=="less") {
  legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="UN"]),")",sep="",collapse=""), paste("High-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HH"]),")",sep="",collapse=""), paste("Low-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LL"]),")",sep="",collapse=""),
                              paste("Low-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LH"]),")",sep="",collapse=""), paste("High-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HL"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), fill=c(cols[3],cols[1],cols[5],cols[4],cols[2],cols[6]), title = expression(paste("LISA Cluster Map, ","H"["a"]:rho<0)), bty="n", cex=1.2, y.intersp=0.8)
}

if (significant&alternative=="two.sided") {
  legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="UN"]),")",sep="",collapse=""), paste("High-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HH"]),")",sep="",collapse=""), paste("Low-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LL"]),")",sep="",collapse=""),
                              paste("Low-High  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="LH"]),")",sep="",collapse=""), paste("High-Low  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="HL"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), fill=c(cols[3],cols[1],cols[5],cols[4],cols[2],cols[6]), title = expression(paste("LISA Cluster Map, ","H"["a"]:rho!=0)), bty="n", cex=1.2, y.intersp=0.8)
}
par(mfrow=c(2,2))

if (significant&alternative=="less"|significant&alternative=="greater"){
mor.dat1$prob<-"UN"
mor.dat1$prob[2*mor.dat1[,"Pr.Zi"]<=0.05&2*mor.dat1[,"Pr.Zi"]>0.01]<-"5%"
mor.dat1$prob[2*mor.dat1[,"Pr.Zi"]<=0.01&2*mor.dat1[,"Pr.Zi"]>0.001]<-"1%"
mor.dat1$prob[2*mor.dat1[,"Pr.Zi"]<=0.001&2*mor.dat1[,"Pr.Zi"]>0.0001]<-"0.1%"
mor.dat1$prob[2*mor.dat1[,"Pr.Zi"]<=0.0001&2*mor.dat1[,"Pr.Zi"]>=0]<-"0.01%"
mor.dat1$prob[is.na(mor.dat1[,"Z.Ii"])]<-"NA"


colsp<-c(brewer.pal(5, "Greens"),"#BEBEBE")
mor.dat1$col1[mor.dat1$prob=="UN"]<-colsp[1]
mor.dat1$col1[mor.dat1$prob=="5%"]<-colsp[2]
mor.dat1$col1[mor.dat1$prob=="1%"]<-colsp[3]
mor.dat1$col1[mor.dat1$prob=="0.1%"]<-colsp[4]
mor.dat1$col1[mor.dat1$prob=="0.01%"]<-colsp[5]
mor.dat1$col1[is.na(mor.dat1[,"Z.Ii"])]<-colsp[6]
mor.dat1

dev.new()
oldpar <- par(pty="s",mar=c(0,0,0,0))
on.exit(par(oldpar))
P2 <- plot(polygons, col=mor.dat1$col1, ...)
if (significant&alternative=="greater") {
legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$prob[mor.dat1$prob=="UN"]),")",sep="",collapse=""), paste("p=0.05  ","(",length(mor.dat1$prob[mor.dat1$prob=="5%"]),")",sep="",collapse=""), paste("p=0.01 ","(",length(mor.dat1$prob[mor.dat1$prob=="1%"]),")",sep="",collapse=""),
paste("p=0.001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.1%"]),")",sep="",collapse=""), paste("p=0.0001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.01%"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), bty="n", fill=colsp, title = expression(paste("LISA Significance Map, ","H"["a"]:rho>0)), cex=1.2, y.intersp=0.8)
}

if (significant&alternative=="less"){
legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$prob[mor.dat1$prob=="UN"]),")",sep="",collapse=""), paste("p=0.05  ","(",length(mor.dat1$prob[mor.dat1$prob=="5%"]),")",sep="",collapse=""), paste("p=0.01 ","(",length(mor.dat1$prob[mor.dat1$prob=="1%"]),")",sep="",collapse=""),
paste("p=0.001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.1%"]),")",sep="",collapse=""), paste("p=0.0001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.01%"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), bty="n", fill=colsp, title = expression(paste("LISA Significance Map, ","H"["a"]:rho<0)), cex=1.2, y.intersp=0.8)
}
par(mfrow=c(2,2))
}

if (significant & alternative=="two.sided"){
mor.dat1$prob<-"UN"
mor.dat1$prob[mor.dat1[,"Pr.Zi"]<=0.05&mor.dat1[,"Pr.Zi"]>0.01]<-"5%"
mor.dat1$prob[mor.dat1[,"Pr.Zi"]<=0.01&mor.dat1[,"Pr.Zi"]>0.001]<-"1%"
mor.dat1$prob[mor.dat1[,"Pr.Zi"]<=0.001&mor.dat1[,"Pr.Zi"]>0.0001]<-"0.1%"
mor.dat1$prob[mor.dat1[,"Pr.Zi"]<=0.0001&mor.dat1[,"Pr.Zi"]>=0]<-"0.01%"
mor.dat1$prob[is.na(mor.dat1[,"Z.Ii"])]<-"NA"


colsp<-c(brewer.pal(5, "Greens"),"#BEBEBE")
mor.dat1$col1[mor.dat1$prob=="UN"]<-colsp[1]
mor.dat1$col1[mor.dat1$prob=="5%"]<-colsp[2]
mor.dat1$col1[mor.dat1$prob=="1%"]<-colsp[3]
mor.dat1$col1[mor.dat1$prob=="0.1%"]<-colsp[4]
mor.dat1$col1[mor.dat1$prob=="0.01%"]<-colsp[5]
mor.dat1$col1[is.na(mor.dat1[,"Z.Ii"])]<-colsp[6]
mor.dat1

dev.new()
oldpar <- par(pty="s",mar=c(0,0,0,0))
on.exit(par(oldpar))
P2 <- plot(polygons, col=mor.dat1$col1, ...)
legend(x=pleg, legend=c(paste("Not Significant  ","(",length(mor.dat1$prob[mor.dat1$prob=="UN"]),")",sep="",collapse=""), paste("p=0.05  ","(",length(mor.dat1$prob[mor.dat1$prob=="5%"]),")",sep="",collapse=""), paste("p=0.01 ","(",length(mor.dat1$prob[mor.dat1$prob=="1%"]),")",sep="",collapse=""),
paste("p=0.001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.1%"]),")",sep="",collapse=""), paste("p=0.0001  ","(",length(mor.dat1$prob[mor.dat1$prob=="0.01%"]),")",sep="",collapse=""), paste("Neighborless  ","(",length(mor.dat1$cluster[mor.dat1$cluster=="NA"]),")",sep="",collapse="")), bty="n", fill=colsp, title = expression(atop("LISA Significance Map",'H'['a']:rho!=0)), cex=1.2, y.intersp=0.8)
par(mfrow=c(2,2))
}
})
