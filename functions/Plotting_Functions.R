ts_plot <- function(X,type = "series",probs = c(0.25,0.75),
                    avggen = NA,yrs = NULL, label = "Title",min.ylim = 0, max.ylim = NA,axis.rescale = FALSE,
                    use.flag = TRUE){
# X data frame with columns "Year" and "Estimate", and optionally "Lower" and "Upper"
# type = either "series", "bounds", "percentiles"
# probs = vector with 2 percentile levels to be plotted
# avggen = if value provided, plot running average of duration avggen
# yrs = year range to plot
# use.flag = if TRUE, mark any obs where Use = FALSE with a red x


if(sum(!is.na(X$Estimate))>0){ # do plot if have data

if(is.null(yrs)){yrs <- range(X$Year,na.rm=TRUE); yrs[2] <- yrs[2]+5}
#print(yrs)

  y.lab.use <- "Estimate"


  if(max(X %>% select(Estimate,Lower, Upper),na.rm=TRUE)>1000 & axis.rescale){
    #print("test")
    X[,c("Estimate","Lower","Upper")] <- X[,c("Estimate","Lower","Upper")]/1000
	max.ylim <- max.ylim/1000
    y.lab.use <- "Estimate (1000s)"
     }

# fill in missing years with NA
yrs.seq <- min(X$Year,na.rm = TRUE) : max(X$Year,na.rm = TRUE)
yrs.missing <-  yrs.seq[!yrs.seq %in% X$Year]
#print(yrs.missing)
X <- bind_rows(X,data.frame(Year = yrs.missing)) %>% arrange(Year)

#print(X[,1:3])





# create the canvas and axes
if(type %in% c("bounds", "percentiles")){ y.lim <- c(min.ylim,max(X$Estimate,na.rm=TRUE)) }

if(type %in% "bounds"){
          if(sum(!is.na(X$Upper))>0){y.lim <- c(min.ylim,max(X$Upper,max.ylim,na.rm = TRUE)) }
          if(sum(!is.na(X$Upper)) == 0){y.lim <- c(min.ylim,max(X$Estimate,max.ylim,na.rm = TRUE)) }
          }




plot(X$Year,X$Upper,type="n",xlim= yrs,ylim = y.lim, bty="n",
     las = 1, xlab = "Year", ylab=y.lab.use)


if(type == "bounds"){

  ############################################
  # from https://stackoverflow.com/questions/33372389/how-to-draw-a-polygon-around-na-values-in-r
  enc <- rle(!is.na(X$Lower))
  endIdxs <- cumsum(enc$lengths)
  for(i in 1:length(enc$lengths)){
    if(enc$values[i]){
      endIdx <- endIdxs[i]
      startIdx <- endIdx - enc$lengths[i] + 1

      yrs <- X$Year[startIdx:endIdx]
      lower <- X$Lower[startIdx:endIdx]
      upper <- X$Upper[startIdx:endIdx]

      x <- c(yrs, rev(yrs))
      y <- c(lower, rev(upper))

      polygon(x = x, y = y, border = "lightblue",col = "lightblue")
    }
  }


segments(X$Year,X$Lower,X$Year,X$Upper,col="lightblue",lwd=5)


quarts <- quantile(X$Estimate,probs = c(0.25,0.75),na.rm = TRUE)
abline(h= quarts, col="darkgrey", lty=2)
text(par("usr")[2],quarts,c("p25","p75"),col="darkgrey",cex=0.8,adj=c(1,-0.2))

med <- median(X$Estimate,na.rm = TRUE)
abline(h= med, col="darkgrey", lty=1,lwd=1)
text(par("usr")[2],med,"Median",col="darkgrey",cex=0.8,font=2,adj=c(1,-0.2))


    }

if(type == "percentiles"){

  quarts <- quantile(X$Estimate,probs = probs,na.rm = TRUE)

  rect(yrs[1],quarts[1],yrs[2],quarts[2],col="lightblue", border = "lightblue")

}

if(!is.na(avggen) & dim(X)[1] > avggen){
    lines(X$Year, stats::filter(X$Estimate,rep(1/avggen,avggen),sides = 1),col="red",lwd=2)
    }


lines(X$Year,X$Estimate,lwd = 1, col="darkblue",type="o",pch=19)



if(use.flag){

flag.idx <- !X$Use
flag.idx[is.na(flag.idx)] <- FALSE

points(X$Year[flag.idx],X$Estimate[flag.idx],lwd = 1, col="white",pch=21,bg="white")
points(X$Year[flag.idx],X$Estimate[flag.idx],lwd = 2, col="red",pch=4,cex=0.8)


}



title(main = label)

} # end do plot if have data


  if(sum(!is.na(X$Estimate))==0){ # do empty plot if have no data

    plot(1:5,1:5,type="n",bty="n", xlab = "", ylab="",axes = FALSE,main= label)


  }


}



#############################

# function for multipanel report plot

plot_report <- function(X,avggen,label = "Title"){




# layout(matrix(c(1,1,2,2),byrow=TRUE,ncol=2))



  ts_plot(X = X,type = "bounds", axis.rescale = TRUE,
        probs = c(0.25,0.75),avggen = avggen,
        yrs = c(1960,2025),
        label = label)




# change any 0 to 1, otherwise the log plot crashes
#X.mod  <- X
#X.mod$Estimate[X.mod$Estimate == 0] <- 1

#X.log <-  X.mod %>%  mutate_at(all_of(c("Estimate","Lower","Upper")),log)

#ts_plot(X = X.log ,type = "bounds", axis.rescale = FALSE,
#        probs = c(0.25,0.75),avggen = avggen,
#        yrs = c(1960,2020),
#        label = "Ln(Abundance)",
#        min.ylim =min(X.log$Estimate,na.rm=TRUE))



}


############################################################
# SPARK LINE PLOTS


spark.line <- function(X,avg = 4,x.lim = NULL,y.lim = NULL,ref.line = NA){
# X is a data frame with 2 columns: Year and some value
# avg: if not NULL, plot a running average
# x.lim: if not NULL apply user-specified xlim
# ref.line: if not NULL, then include of horizontal line

n.vals <- sum(!is.na(X[,2]))

if(n.vals >0){ #plot only if have data


if(is.null(x.lim)){x.lim <- range(X[,1],na.rm=TRUE)}
if(is.null(y.lim)){
            if(sum(!is.na(X[,2]))>0){y.lim <- range(X[,2],na.rm=TRUE)}
            if(sum(!is.na(X[,2]))==0){y.lim <- c(0,5)}
            }


plot(X[,1],X[,2],axes=FALSE,bty="n",type="o",pch=19,col="darkblue",
     xlim = x.lim,ylim=y.lim, xlab="",ylab="",cex=0.8)

if(!is.null(ref.line)){abline(h=ref.line,col="darkgrey",lwd=2,lty=2)}

if(!is.null(avg)){
  if(n.vals >avg){
  avg.vals <- stats::filter(X[,2],filter = rep(1/avg,avg),sides = 1)
                  lines(X[,1],avg.vals,col="red",lwd=3)
  }}

} # end if doing plot


if(n.vals == 0){ # empty plot
  plot(1:5,1:5,axes=FALSE,bty="n",type="n",xlab="",ylab="")
}


} # end spark.line



spark.band <- function(X,avg = 4,x.lim = NULL,y.lim = NULL,ref.line = NULL){
  # X is a data frame with 4 columns: Year and 3 value cols: lower,mid,upper
  # x.lim,y.lim: if not NULL apply user-specified  plot lim


  n.vals <- sum(!is.na(X[,2]))

  if(n.vals >0){ # only do plot if have data

  if(is.null(x.lim)){x.lim <- range(X[,1],na.rm=TRUE)}
  if(is.null(y.lim)){
    if(sum(!is.na(X[,2]))>0){y.lim <- range(X[,2:4],na.rm=TRUE)}
    if(sum(!is.na(X[,2]))==0){y.lim <- c(0,5)}
  }

  plot(X[,1],X[,3],axes=FALSE,bty="n",type="l",col="darkblue",
       xlim = x.lim,ylim=y.lim, xlab="",ylab="")


  polygon(c(X[,1],rev(X[,1])),
          c(X[,4],rev(X[,2])),
          col="lightgrey",border=NA)

  if(!is.null(ref.line)){abline(h=ref.line,col="darkgrey",lwd=2,lty=2)}


  lines(X[,1],X[,3],type="l",lwd=4,col="darkblue")
  } # end if doing plot

  if(n.vals == 0){ # empty plot
    plot(1:5,1:5,axes=FALSE,bty="n",type="n",xlab="",ylab="")
  }


}


spark.text<- function(X,pos=c(5,5),adj=0.5,cex =1,font = 1,col="black"){
# X is a text string
# pos specifies text position on a 10x10 grid
# cex,adj =  as per text()
plot(1:10,1:10,bty="n",axes=FALSE,bty="n",type="n",xlab="",ylab="")
text(pos[1],pos[2],labels=X,cex=cex,adj=adj,xpd=NA,font=font,col=col)
}


spark.sep <- function(col="lightblue",lty=1,lwd=2){
# plots a user-specified line in the middle of the panel
    plot(1:10,1:10,bty="n",axes=FALSE,bty="n",type="n",xlab="",ylab="")
  abline(h=5,col=col,lty=lty,lwd=lwd)

}



###############################################################
# RANKING PLOT

# RANKING PLOT FUNCTION
# Created by Gottfried Pestal (Solv Consulting Ltd.)
# Original function created for the SPATFunctions Package
# (https://github.com/SOLV-Code/SPATFunctions-Package)
# Adapted here to customize formatting for report figures
##################################################



plotRanked <- function (data.df, trim = 25,
maxvars = NULL, xlim = NULL, flag = NULL,mean.pt=FALSE){
    options(scipen = 100000)
    if (length(data.df) == 1) {
        plot(1:5, 1:5, type = "n", xlab = "", ylab = "",
            axes = FALSE)
        text(2.5, 2.5, "Need to select at least 2 series for this plot")
    }
    if (length(data.df) > 1) {
        data.summary <- as.data.frame(t(apply(data.df, MARGIN = 2,
            FUN = quantile, probs = seq(0, 1, by = 0.01), na.rm = TRUE)))


		data.summary <- data.summary[, c(paste0(trim, "%"),
            "50%", paste0(100 - trim, "%"))]

		if(mean.pt){data.summary[,"50%"] <- colMeans(data.df,na.rm=TRUE)}

		data.summary <- data.summary[order(data.summary[, "50%"],
            decreasing = TRUE), ]

		if (is.null(xlim)) {
            xlim <- range(data.summary,na.rm=TRUE)
        }
        if (!is.null(maxvars)) {
            num.units <- maxvars
        }
        if (is.null(maxvars)) {
            num.units <- length(data.df)
        }
        tick.loc <- num.units:(num.units - length(data.df) +
            1)
    }

    plot(1:10, 1:10, xlim = xlim, ylim = c(1, num.units), cex.main = 0.8,
        type = "n", bty = "n", axes = FALSE, xlab = "",
        ylab = "", cex.lab = 1.5)
    axis(2, at = tick.loc, labels = dimnames(data.summary)[[1]],
        las = 1, lwd = 1, line = 1,cex.axis=1.1)
    x.ticks <- pretty(xlim, n = 5)
    x.ticks <- x.ticks[x.ticks < xlim[2] & x.ticks > xlim[1]]
    if (max(x.ticks) <= 10^3) {
        x.ticks.labels <- x.ticks
    }
    if (max(x.ticks) > 10^3) {
        x.ticks.labels <- paste(x.ticks/10^3, "k", sep = "")
    }
    if (max(x.ticks) > 10^4) {
        x.ticks.labels <- paste(x.ticks/10^4, "*10k", sep = "")
    }
    if (max(x.ticks) > 10^5) {
        x.ticks.labels <- paste(x.ticks/10^5, "*100k",
            sep = "")
    }
    if (max(x.ticks) > 10^6) {
        x.ticks.labels <- paste(x.ticks/10^6, "M", sep = "")
    }
    axis(3, at = x.ticks, labels = x.ticks.labels)
    if (!is.null(flag)) {
        flag.idx <- names(data.df) == flag
        abline(h = c(tick.loc[flag.idx] + 0.5, tick.loc[flag.idx] -
            0.5), col = "tomato", lty = 2, xpd = TRUE)
    }
    lines(data.summary[, "50%"], tick.loc, type = "b",
        pch = 19, cex = 1.6, col = "darkblue", xpd = NA)
    segments(data.summary[, paste0(trim, "%")], tick.loc,
        data.summary[, paste0(100 - trim, "%")], tick.loc,
        col = "darkblue")
    return(data.summary)
}


#################################################
# COLOR-FADED SCATTERPLOT



faded.scatterplot <- function(X,Y, plot.label,x.label, y.label,x.lim,y.lim,cex.pt = 1.4){
# X is a data frame with 4 columns: Year, Estimate, Lower, Upper
# y is a data frame with 4 columns: Year, Estimate, Lower, Upper
# plot.label is the plot title

  # color fade
  n.obs <- dim(X)[1]
  n.max <- 80
  bg.fade <- c(rep(0,n.max-40),seq(0.025,1, length.out=40))
  bg.col <- rgb(1, 0, 0,bg.fade)
  bg.col <- tail(bg.col,n.obs)

  yrs.plot.df <-  data.frame(Year = sort(intersect(X[!is.na(X$Estimate),"Year"],Y[!is.na(Y$Estimate),"Year"])))

  #print(yrs.plot.df)

  points.df <- left_join(yrs.plot.df, X %>% select(Year,Estimate))  %>%
					rename(x.est = Estimate) %>%
					left_join(Y %>% select(Year,Estimate))

 names(points.df) <-  	c("Year", x.label,y.label)
 #print(points.df)

  plot(points.df[,2],points.df[,3],xlab = x.label,ylab = y.label,
       type = "p", pch=21,col="darkblue",bg = "white",cex = cex.pt,bty="n",
       main = plot.label, cex.main = 1.1,col.main="darkblue",
       xlim = x.lim,
       #ylim = c(-1,6) # OR
       ylim = y.lim
        )

 # add regression line
   reg.fit  <- lm(points.df[,3] ~ points.df[,2])
   abline(reg.fit,col="red",lwd=3,lty=1)
   text(par("usr")[1],par("usr")[4],
		#expression(Adj~R^2==round(summary(reg.fit)$adj.r.squared,2)),
		# above didn't work, below is from https://stackoverflow.com/questions/20532136/expression-variable-value-normal-text-in-plot-maintitle/20533370
		bquote(Adj ~ R^2 == .(round(summary(reg.fit)$adj.r.squared,2))),
		adj = c(0,1),xpd=NA, cex = 1.3)

		text(par("usr")[1],par("usr")[4],
		bquote(Corr == .(round(cor(points.df[,2],points.df[,3]),2))),
		adj = c(0,3),xpd=NA, cex = 1.3)

	text(par("usr")[1],par("usr")[4],
		bquote(n == .(dim(yrs.plot.df)[1])),
		adj = c(0,4.5),xpd=NA, cex = 1.3)


	text(par("usr")[1],par("usr")[4],
		bquote(Last~Yr == .(max(yrs.plot.df$Year))),
		adj = c(0,6.5),xpd=NA, cex = 1.3)


	# add the whiskers

	whisk.df <- left_join(yrs.plot.df, X %>% select(Year,Lower,Upper))  %>%
					rename(x.lower = Lower, x.upper = Upper) %>%
					left_join(Y %>% select(Year,Lower,Upper) %>% rename(y.lower = Lower, y.upper = Upper) )

	#print(whisk.df)

	segments(whisk.df$x.lower,points.df[,y.label],whisk.df$x.upper,points.df[,y.label],col="darkblue")
	segments(points.df[,x.label], whisk.df$y.lower,points.df[,x.label],whisk.df$y.upper,col="darkblue")


  # cover the lines inside the points, then add the faded colour
  points(points.df[,2],points.df[,3],type = "p", pch=21,col="darkblue",bg="white",cex=cex.pt)
  points(points.df[,2],points.df[,3],type = "p", pch=21,col="darkblue",bg=bg.col,cex=cex.pt)







}


