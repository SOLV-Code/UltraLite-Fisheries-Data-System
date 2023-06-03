###################################################
# CHANGING COMPOSITION (STACKED BARS) CUSTOM PLOT FUNCTION
# Created by Gottfried Pestal (Solv Consulting Ltd.)
# Created for GreyFish Project (http://www.solv.ca/GreyFish/index.html)
# Version 3 - July 2013
###################################################
# creates a stacked bar plot of 3 series using % composition

greyfish_sbplot <- function(y.mat,perc=TRUE, fig.lab=NULL, x.lab=NULL, y.lab=NULL,x.label.range=c(0,dim(y.mat)[2]-1),x.label.start=1950,panel.size=NULL, p.cex.leg=NULL, show.legend=TRUE){
# y.mat = matrix of values, with 3 rows and length(x) columns 
# perc = specify TRUE to convert 3 series into percentage values, FALSE to plot stacked totals
# x.lab and y.lab are axis labels for the plot (NEED TO INCLUDE A DEFAULT)
# need to clean up this function: x axis specs are unwieldy
	

#x.lim=x.label.range,
	
barcols<-c("dodgerblue","lightgrey","darkblue")

if(is.null(panel.size)){p.cex <- 1.3; p.cex.main <- 1; p.cex.lab <- 1; p.cex.axis <- 1; p.legend <-show.legend; p.cex.leg <- 1}	

if(!is.null(panel.size)){
	if(panel.size=="small"){p.cex <- 1.4; p.cex.main <- 1.8; p.cex.lab <- 1.5; p.cex.axis <-1.5; p.legend <- FALSE; p.cex.leg <- 1}	
	if(panel.size=="large"){p.cex <- 3; p.cex.main <- 3.2; p.cex.lab <- 2.5; p.cex.axis <- 2.1; p.legend <- show.legend; p.cex.leg <- 3}	
	}


if(perc){
	legend.specs<-list(bty="n", horiz=FALSE,x="right", xpd=TRUE,inset=-0.25,cex=p.cex.leg)
	y.mat<-prop.table(y.mat,2)
	print(y.mat)
	
	tmp<-barplot(y.mat,border=NA,space=0, axes=FALSE,legend=p.legend,args.legend=legend.specs,col=barcols,main=fig.lab,cex.main=p.cex.main,xaxt="n")
	axis(side=2,at=seq(0,1,by=0.2),labels=paste(seq(0,1,by=0.2)*100,"%",sep=""),cex.axis=p.cex.axis,xpd=TRUE)
	axis(side=1,at=pretty(x.label.range),labels=pretty(x.label.range)+x.label.start,cex.axis=p.cex.axis,xpd=TRUE)
		
	abline(h=seq(0.2,0.8,by=0.2),col="white",lwd=1.5)
} # end if perc=TRUE
	
# NEEDS TESTING	
if(!perc){
	y.scale<-pretty(colSums(y.mat))
	legend.specs<-list(bty="n", horiz=TRUE,x="top", inset=c(0,-0.12))
	barplot(y.mat,border=NA,space=0, axes=FALSE, ylim=c(min(y.scale),max(y.scale)),cex.main=p.cex.main,legend=p.legend,args.legend=legend.specs,col=barcols,main=fig.lab)  
		y.scale<-pretty(colSums(y.mat))
	axis(side=2,at=y.scale,,cex.axis=p.cex.axis,)
	abline(h=y.scale,col="white",lwd=1.5)
} # end if perc=FALSE
	
	
	
} # end of greyfish_sbplot	