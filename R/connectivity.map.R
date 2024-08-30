assign("connectivity.map",
       function(nb, polygons, var.label, obs=NULL, col, cex, ...){
       plot(st_geometry(polygons))
if (is.null(obs)) {
       p <- locator(1)
       p1 <- st_point(c(p$x,p$y))
       p1 <- st_sfc(p1)
       st_crs(p1) <- st_crs(polygons)
       polcontain <- st_within(p1,polygons)
       myPol <- which(as.matrix(polcontain))
       myPol
}
else if (is.null(obs)==FALSE) {
       myPol <- obs
       myPol
}
       result <- st_geometry(polygons)[myPol, ]
       centroidsp <- st_geometry(st_centroid(result))
       text(st_coordinates(centroidsp)[,1],st_coordinates(centroidsp)[,2],eval(parse(text = paste("result",var.label, sep="$"))),cex=cex)
       neighbors.pol <- polygons[nb[[myPol]],]
       plot(st_geometry(neighbors.pol), col = col, add = TRUE)
       centroidsn <- st_geometry(st_centroid(neighbors.pol))
       text(st_coordinates(centroidsn)[,1],st_coordinates(centroidsn)[,2],eval(parse(text = paste("neighbors.pol",var.label, sep="$"))),cex=cex)
       }
)
