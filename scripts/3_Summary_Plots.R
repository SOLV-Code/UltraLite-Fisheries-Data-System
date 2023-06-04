# script to generate various summary plots across multiple projects

# Prep
library(tidyverse)
source("functions/Plotting_Functions.R")


# Generate the ranking plot


df.wide <- read.csv("data/DerivedData/ProjectData_EstOnly_Wide.csv",stringsAsFactors = FALSE)

# change any 0 to 1, otherwise the log plot crashes
df.wide[df.wide == 0] <- 1

png(filename = "PLOTS/RankingPlot_ALL.png",
    width = 480*5, height = 480*3.5, units = "px", pointsize = 14*3, bg = "white",  res = NA)


layout(matrix(1:2,ncol=2,byrow=TRUE))

par(mai = c(1,8,4,1))

plotRanked(data.df = df.wide %>% select(-Year),
           trim = 0, maxvars = 15, xlim = NULL, flag = NULL,
           mean.pt = TRUE)
title(main="All Available Years")



plotRanked(data.df = df.wide %>% select(-Year) %>%
             mutate_all(function(x){log(x)}),
           trim = 0, maxvars = 15, xlim = NULL, flag = NULL,
           mean.pt = TRUE)
title(main="All Available Years (Log)")

title(main = "Magnitude of Survey Estimates (Min/Mean/Max)", outer = TRUE,line=-1.5)

dev.off()



# GENERATE THE TIMELINE PLOT




summary.df <-  read.csv("data/DerivedData/ProjectData_Summary.csv", stringsAsFactors = FALSE) 
 
summary.df


png(filename = "PLOTS/DataOverview_ALL.png",
    width = 480*4, height = 480*4.5, units = "px", pointsize = 14*3.3, bg = "white",  res = NA)

par(mai=c(3,6.5,4,2))

yr.range <- c(1960,2020)


n.project.all <- dim(summary.df)[1]
n.stk.all <- length(unique(summary.df$Stock))


plot(1:5,1:5,type="n",xlim = yr.range, ylim=c(n.project.all + n.stk.all + 1 ,0.7),xlab="",ylab="",axes=FALSE)
axis(3)
title(main = "Availability of Abundance Estimates",cex.main=1)

y.idx <- 1


text(par("usr")[2],par("usr")[4],"n/x",xpd=NA,adj=0,cex=0.9,font=2)


for(stk.plot in c("All","Lower", "Middle", "Canada") ){
  
  
  summary.sub  <- summary.df %>% dplyr::filter(Stock == stk.plot) %>%
    arrange(ProjSeq)
  
  
  proj.list <-  summary.sub %>% select(Project) %>% unlist()
  
  n.proj <- length(proj.list)
  
  text(par("usr")[1]-2,y.idx-0.5,labels = stk.plot, font =2, adj=1,xpd =NA)
  axis(2,at=y.idx:(y.idx + n.proj - 1),labels = proj.list,las=2,cex.axis =0.8)
  
  abline(h=(y.idx:(y.idx + n.proj -1)),col="darkgrey")
  
  
  for(i in 1:n.proj){ #
    
    data.sub <- main.data.df %>% dplyr::filter(Project == as.vector(proj.list[i]))
    
    print(data.sub)
    
    data.yrs.f <- data.sub %>% dplyr::filter(!is.na(Estimate) & !is.na(Lower) & Use) %>% select(Year) %>% unlist()
    data.yrs.o <- data.sub %>% dplyr::filter(!is.na(Estimate) & is.na(Lower)  & Use) %>% select(Year) %>% unlist()
    data.yrs.x <- data.sub %>% dplyr::filter(!is.na(Estimate) & !Use)  %>% select(Year) %>% unlist()
    
    text(par("usr")[2],y.idx + i -1,
         paste0(length(c(data.yrs.f,data.yrs.o)),"/",length(data.yrs.x)),xpd=NA,adj=0,cex=0.7)
    
    
    
    if(length(data.yrs.o)>0){points(data.yrs.o,rep(y.idx + i -1,length(data.yrs.o)),col="darkblue", pch=21,bg="lightblue",cex=1)}
    if(length(data.yrs.x)>0){points(data.yrs.x,rep(y.idx + i -1,length(data.yrs.x)),col="red", pch=4,cex=1,lwd=2)}
    if(length(data.yrs.f)>0){points(data.yrs.f,rep(y.idx+ i -1 ,length(data.yrs.f)),col="darkblue", pch=22,bg="darkblue",cex=1)}
    
    # add the start year
    
  } # end looping through projects
  
  y.idx <- y.idx + n.proj +1.5
  
} # end looping through stocks


legend("bottom", col=c("darkblue","darkblue","red") ,pt.bg = c("darkblue","lightblue","NA"),pch=c(22,21,4),
       legend = c("Est and CV","Est Only","Filtered") , ncol=3, bty="n")

dev.off()














