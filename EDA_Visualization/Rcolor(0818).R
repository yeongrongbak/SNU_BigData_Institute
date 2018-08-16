## R color
plot(1:20, y=rep(0,20), col = 1:20, cex = 2, pch = 20 )
head(colors())
tail(colors())

mycol = colors()
plot(1:80, y=rep(1,80), col = mycol[1:80], cex = 2, pch = 20, 
     ylim = c(0,1) )
points(1:80, y=rep(0.5,80), col = mycol[81:160], cex = 2, pch = 20 )
points(1:80, y=rep(0,80), col = mycol[161:240], cex = 2, pch = 20 )
image(matrix(1:25^2,25,25), col = mycol)

# RGB
rgb(10, 4, 23, maxColorValue = 255, alpha = 10)
rgb(10, 4, 23, maxColorValue = 25, alpha = 10)
col2rgb('lightblue')

hsv(0.3, 0.5, 0.1, alpha = 0.4)
hcl(h = 0, c = 35, l = 85, alpha = 0.1)

par(mfrow=c(1,1))
mycol = heat.colors(20, alpha = 1)
plot(1:20, y=rep(0,20), col = mycol, cex = 2, pch = 20 )
mycol = topo.colors(20, alpha = 1)
plot(1:20, y=rep(0,20), col = mycol, cex = 2, pch = 20 )

x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = heat.colors(20, alpha = 1), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = 'white')

x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = topo.colors(20, alpha = 1), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = 'white')

rainbow(5, s = 0.4, v = 0.3, start = 0, end = 0.05, alpha = 1)

install.packages("colorspace")

library(colorspace)
mycol = diverge_hcl(40, h = c(246, 40), c = 96, l = c(65, 90))
image(x, y, volcano, col = mycol, axes = FALSE)


library(colorspace)
pal = choose_palette()
mycol <- pal(20, alpha = 1)
image(x, y, volcano, col = mycol, axes = FALSE) 
