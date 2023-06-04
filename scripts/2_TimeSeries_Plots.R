# script to apply the  time series plot function to each series in the data set.
# plots are donw twice, once as individual png files, once as a single pdf with all the figures
# the png files are used for the automated report.


# Prep
library(tidyverse)
if(!dir.exists("PLOTS")){dir.create("PLOTS")}
if(!dir.exists("PLOTS/IndividualDashboards")){dir.create("PLOTS/IndividualDashboards")}

source("functions/Plotting_Functions.R")



df.master <- read.csv("data/DerivedData/ProjectData_MainFile.csv",stringsAsFactors = FALSE)
source("functions/Plotting_Functions.R")

# LOOP THROUGH PLOT VERSIONS AND PROJECTS

for(plot.type in c("pdf","png")){


if(plot.type == "pdf"){pdf("PLOTS/TimeSeries_Overview.pdf",onefile=TRUE,width = 11, height = 8.5) }


for(proj in sort(unique(df.master$Project))){
print("---------------------------------------------")
print(proj)
df.plot <- df.master %>% dplyr::filter(Project == proj)

if(plot.type == "png"){png(filename = paste0("PLOTS/IndividualDashboards/TimeSeries_",proj,".png"),
                           width = 480*4, height = 480*3, units = "px", pointsize = 14*3.4, bg = "white",  res = NA)
  par(mai=c(3.5,3.5,3,2))}


# change any 0 to 1, otherwise the log plot crashes
df.plot$Estimate[df.plot$Estimate == 0] <- 1

plot_report(X = df.plot,avggen = 5,label = proj)

if(plot.type == "png"){dev.off()}

} # end looping through projects

  
if(plot.type == "pdf"){dev.off()}


} # end looping through plot types









