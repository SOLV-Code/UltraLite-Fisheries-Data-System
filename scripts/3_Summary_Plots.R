# script to develop and run the time series plot function




# Prep
library(tidyverse)
if(!dir.exists("_book/PLOTS")){dir.create("_book/PLOTS")}
source("functions/Plotting_Functions.R")


# Generate the ranking plot


df.wide <- read.csv("data/DerivedData/ProjectData_EstOnly_Wide.csv",stringsAsFactors = FALSE)

# change any 0 to 1, otherwise the log plot crashes
df.wide[df.wide == 0] <- 1

png(filename = "_book/PLOTS/RankingPlot_ALL.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.5, bg = "white",  res = NA)


layout(matrix(1:2,ncol=2,byrow=TRUE))

par(mai = c(1,5.2,3,1))

plotRanked(data.df = df.wide %>% select(-Year),
           trim = 0, maxvars = 25, xlim = NULL, flag = NULL,
           mean.pt = TRUE)
title(main="All Estimates")



plotRanked(data.df = df.wide %>% select(-Year) %>%
             mutate_all(function(x){log(x)}),
           trim = 0, maxvars = 25, xlim = NULL, flag = NULL,
           mean.pt = TRUE)
title(main="All Estimates (Log)")



dev.off()



# sparkline plot



df.master <- read.csv("data/DerivedData/ProjectData_MainFile.csv",stringsAsFactors = FALSE)

yr.range <- range(df.master %>% dplyr::filter(!is.na(Estimate))  %>%
                                                select(Year))




png(filename = "_book/PLOTS/TrendOverview.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)


layout(matrix(1:12,ncol=3,byrow=TRUE))



for(proj in sort(unique(df.master$Project))){

  print(proj)

  df.plot <- df.master %>% dplyr::filter(Project == proj) %>%
              select(Year,Estimate)#,Lower,Upper)

  spark.line(df.plot,
             x.lim=yr.range,y.lim=NULL,ref.line = median(df.plot$Estimate,na.rm=TRUE))

  title(main=proj)

  }


title(main = "Trends",outer = TRUE,line=-1,col.main="darkblue", cex.main=1.5)

dev.off()




png(filename = "_book/PLOTS/TrendOverview_Log.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)


layout(matrix(1:12,ncol=3,byrow=TRUE))


# change any 0 to 1, otherwise the log plot crashes
df.master$Estimate[df.master$Estimate == 0] <- 1


for(proj in sort(unique(df.master$Project))){



  df.plot <- df.master %>% dplyr::filter(Project == proj) %>%
    select(Year,Estimate) %>% #,Lower,Upper)
    mutate(Estimate = log(Estimate))

  spark.line(df.plot,
             x.lim=yr.range,y.lim=NULL,ref.line = median(df.plot$Estimate,na.rm=TRUE))

  title(main=proj)

}


title(main = "Trends (Log)",outer = TRUE,line=-1,col.main="darkblue",
      cex.main=1.5)

dev.off()



