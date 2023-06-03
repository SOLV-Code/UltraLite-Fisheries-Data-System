# script to develop and run the time series plot function
# note: figures used in the report are generated there using the same function
# this generates pdf handouts with the same information






##############################
# plot testing


source("functions/Plotting_Functions.R")

x.df <- data.out %>% dplyr::filter(Project == "SalchaSurveys") %>% select(Year,Estimate,Lower, Upper)
y.df <- data.out %>% dplyr::filter(Project == "ChenaSurveys") %>% select(Year,Estimate,Lower, Upper)

test.lims <- c(0,max(x.df %>% select(-Year),y.df %>% select(-Year), na.rm=TRUE))

faded.scatterplot(X = x.df,
                  Y = y.df,
                  plot.label = "Test",
                  x.label = "Salcha Tower/Weir",
                  y.label = "Chena Surveys",
                  x.lim = test.lims ,
                  y.lim  = test.lims,
                  cex.pt = 1.4)












###########
# corr function testing

library(corrplot)
source("functions/Correlation_Functions.R")



proj.list <-  data.summary  %>% dplyr::filter(Stock == "Canada" | Project == "PilotStation") %>%
  dplyr::filter(NumEst > 5)  %>%
  select(Project) %>% unlist()



dat.feed <- data.out  %>% dplyr::filter(Project %in% proj.list, Year >= 2000)

tmp <- calcCorr(dat.feed  )

tmp$CorrMat
tmp$CorrTable
tmp$Data




plotCorr(tmp)




corr.cat(tmp$CorrTable$Corr)

corr.cols(tmp$CorrTable$Corr)










# Prep
library(tidyverse)
if(!dir.exists("_book/PLOTS")){dir.create("_book/PLOTS")}
source("functions/Plotting_Functions.R")


# TESTING THE PLOT FUNCTIONS
file.use <-  "data/Profiles/YkCk_AndreafskyWeir_Data.csv"


df.plot <- read.csv(file.use, comment.char = '#',
                    stringsAsFactors = FALSE, blank.lines.skip=TRUE) %>%
            mutate(Lower = Estimate - 2* SE, Upper = Estimate + 2* SE) #%>%
                #dplyr::filter(Project == "AnvikAerial")

#mutate(Lower = p10, Upper = p90)




ts_plot(X = df.plot,type = "bounds",
        probs = c(0.25,0.75),avggen = 5,
        yrs = c(1980,2020))

ts_plot(X = df.plot,type = "bounds",
        probs = c(0.25,0.75),avggen = 5,
        yrs = c(1980,2020))


ts_plot(X = df.plot,type = "percentiles",
        probs = c(0.25,0.75),avggen = 5,
        yrs = c(1980,2020))

ts_plot(X = df.plot,type = "percentiles",
        probs = c(0.25,0.75),avggen = 5,
        yrs = c(1980,2020),
        label = "Test 1" )

ts_plot(X = df.plot %>%  mutate(Estimate = log(Estimate)),type = "percentiles",
        probs = c(0.25,0.75),avggen = 5,
        yrs = c(1980,2020),
        label = "Test 3 LOG",
        min.ylim = 0)





source("functions/Plotting_Functions.R")
plot_report(X = df.plot,avggen = 5,label = "TEST")




# Generate pdf handout from master file

df.master <- read.csv("data/DerivedData/ProjectData_MainFile.csv",stringsAsFactors = FALSE)
source("functions/Plotting_Functions.R")

pdf("_book/PLOTS/TimeSeries_Overview.pdf",onefile=TRUE,width = 11, height = 8.5)


for(proj in sort(unique(df.master$Project))){
print("---------------------------------------------")
print(proj)
df.plot <- df.master %>% dplyr::filter(Project == proj)

# change any 0 to 1, otherwise the log plot crashes
df.plot$Estimate[df.plot$Estimate == 0] <- 1

plot_report(X = df.plot,avggen = 5,label = proj)

}


dev.off()







#########
#source("functions/Plotting_Functions.R")
#main.data.df <-  read.csv("data/DerivedData/ProjectData_MainFile.csv", stringsAsFactors = TRUE)
#ts_plot(X = main.data.df %>% dplyr::filter(Project == "HenshawWeir"),
#        axis.rescale = TRUE, label = proj,
#        type = "bounds", probs = c(0.25,0.75),avggen = 5, yrs = c(1960,2020))





################
main.data.df <-  read.csv("data/DerivedData/ProjectData_MainFile.csv", stringsAsFactors = FALSE)
summary.df <-  read.csv("data/DerivedData/ProjectData_Summary.csv", stringsAsFactors = FALSE) %>%
                  left_join(read.csv("data/Profiles/ProjectInfo_Lookup.csv", stringsAsFactors = FALSE) %>%
                              dplyr::filter(DataStatus == "Incorporated") %>%
                              select(Project,ProjLabelFrench), by = "Project")



png(filename = "data/DataOverview_ALL.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)
par(mai=c(1,7,3,1))


yr.range <- c(1960,2020)

projects.df <- summary.df %>% dplyr::filter(!(Project %in% c("TBD","matrix")), Table == "Yes")



projects.df


n.project.all <- dim(projects.df)[1]
n.stk.all <- length(unique(projects.df$Stock))


plot(1:5,1:5,type="n",xlim = yr.range, ylim=c(n.project.all + n.stk.all + 1 ,0.7),xlab="",ylab="",axes=FALSE)
axis(3)
title(main = "Availability of Abundance Estimates",cex.main=1)

y.idx <- 1


text(par("usr")[2],par("usr")[4]+1,"n/x",xpd=NA,adj=0,cex=0.9,font=2)


for(stk.plot in c("All","Lower", "Middle", "Canada") ){


        summary.sub  <- projects.df %>% dplyr::filter(Stock == stk.plot) %>%
                arrange(ProjSeq)


        proj.list <-  summary.sub %>% select(Project) %>% unlist()

        n.proj <- length(proj.list)

        text(par("usr")[1]-2,y.idx-1.5,labels = stk.plot, font =2, adj=1,xpd =NA)
        axis(2,at=y.idx:(y.idx + n.proj - 1),labels = proj.list,las=2,cex.axis =0.8)

        abline(h=(y.idx:(y.idx + n.proj -1)),col="darkgrey")


        for(i in 1:n.proj){ #

                data.sub <- main.data.df %>% dplyr::filter(Project == as.vector(proj.list[i]))

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

        y.idx <- y.idx + n.proj +2

} # end looping through stocks

dev.off()


#############
# FRENCH VERSION FOR RES DOC


png(filename = "data/DataOverview_ALL_French.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)
par(mai=c(1,7,3,1))


yr.range <- c(1960,2020)

projects.df <- summary.df %>% dplyr::filter(!(Project %in% c("TBD","matrix")), Table == "Yes")



projects.df


n.project.all <- dim(projects.df)[1]
n.stk.all <- length(unique(projects.df$Stock))


plot(1:5,1:5,type="n",xlim = yr.range, ylim=c(n.project.all + n.stk.all + 1 ,0.7),xlab="",ylab="",axes=FALSE)
axis(3)
title(main = "Disponibilité des estimations de l’abondance",cex.main=1)

y.idx <- 1


text(par("usr")[2],par("usr")[4]+1,"n/x",xpd=NA,adj=0,cex=0.9,font=2)


for(stk.plot in c("All","Lower", "Middle", "Canada") ){

  if(stk.plot == "All"){stk.label <- "Tous"}
  if(stk.plot == "Lower"){stk.label <- "Cours inférieur"}
  if(stk.plot == "Middle"){stk.label <- "Cours moyen"}
  if(stk.plot == "Canada"){stk.label <- "Canada"}

  summary.sub  <- projects.df %>% dplyr::filter(Stock == stk.plot) %>%
    arrange(ProjSeq)


  proj.list <-  summary.sub %>% select(Project) %>% unlist()
  proj.list.f <- summary.sub %>% select(ProjLabelFrench) %>% unlist()

  n.proj <- length(proj.list)

  text(par("usr")[1]-2,y.idx-1.5,labels = stk.label, font =2, adj=1,xpd =NA)
  axis(2,at=y.idx:(y.idx + n.proj - 1),labels = proj.list.f,las=2,cex.axis =0.8)

  abline(h=(y.idx:(y.idx + n.proj -1)),col="darkgrey")


  for(i in 1:n.proj){ #

    data.sub <- main.data.df %>% dplyr::filter(Project == as.vector(proj.list[i]))

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

  y.idx <- y.idx + n.proj +2

} # end looping through stocks

dev.off()





# -------------------------------------------------------------------------------


main.data.df.rep <-  read.csv("data/DerivedData/ProjectData_MainFile.csv", stringsAsFactors = FALSE) %>%
                            dplyr::filter(ModelUse == "Yes", Year >= 1982)
summary.df.rep <-  read.csv("data/DerivedData/ProjectData_Summary.csv", stringsAsFactors = FALSE) %>%
    dplyr::filter(ModelUse == "Yes")



png(filename = "data/RdsForModel/DataOverview_ModelReport.png",
    width = 480*4, height = 480*5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)
par(mai=c(1,7,3,1))


yr.range <- c(1982,2020)

projects.df <- summary.df.rep %>% dplyr::filter(!(Project %in% c("","TBD","matrix")))



projects.df


n.project.all <- dim(projects.df)[1]
n.stk.all <- length(unique(projects.df$Stock))


plot(1:5,1:5,type="n",xlim = yr.range, ylim=c(n.project.all + n.stk.all + 1 ,0.7),xlab="",ylab="",axes=FALSE)
axis(3, at = seq(1985,2020,by=5))
title(main = "Availability of Abundance Estimates",cex.main=1)

y.idx <- 1


for(stk.plot in c("All","Lower", "Middle", "Canada") ){


    summary.sub  <- projects.df %>% dplyr::filter(Stock == stk.plot) %>%
        arrange(ProjSeq)


    proj.list <-  summary.sub %>% select(Project) %>% unlist()

    n.proj <- length(proj.list)

    text(par("usr")[1]-2,y.idx-1.5,labels = stk.plot, font =2, adj=1,xpd =NA)
    axis(2,at=y.idx:(y.idx + n.proj - 1),labels = proj.list,las=2,cex.axis =0.8)

    abline(h=(y.idx:(y.idx + n.proj -1)),col="darkgrey")


    for(i in 1:n.proj){ #

        data.sub <- main.data.df %>% dplyr::filter(Project == as.vector(proj.list[i]))

        data.yrs.f <- data.sub %>% dplyr::filter(!is.na(Estimate) & !is.na(Lower) & Use) %>% select(Year) %>% unlist()
        data.yrs.o <- data.sub %>% dplyr::filter(!is.na(Estimate) & is.na(Lower)  & Use) %>% select(Year) %>% unlist()
        data.yrs.x <- data.sub %>% dplyr::filter(!is.na(Estimate) & !Use)  %>% select(Year) %>% unlist()


        if(length(data.yrs.o)>0){points(data.yrs.o,rep(y.idx + i -1,length(data.yrs.o)),col="darkblue", pch=21,bg="lightblue",cex=1)}
        if(length(data.yrs.x)>0){points(data.yrs.x,rep(y.idx + i -1,length(data.yrs.x)),col="red", pch=4,cex=1,lwd=2)}
        if(length(data.yrs.f)>0){points(data.yrs.f,rep(y.idx+ i -1 ,length(data.yrs.f)),col="darkblue", pch=22,bg="darkblue",cex=1)}

        # add the start year

    } # end looping through projects

    y.idx <- y.idx + n.proj +2

} # end looping through stocks

dev.off()





#######################################
#



# vertical stack version
# add value to header
# censored obs with x
# x axis, or horisontal panel separator


png(filename = "data/DataSpark_ALL.png",
    width = 480*4, height = 480*4.5, units = "px", pointsize = 14*2.8, bg = "white",  res = NA)
par(mai=c(0,0,0,0))





projects.df <- summary.df %>% dplyr::filter(!(Project %in% c("TBD","matrix")), Table == "Yes",Stock !="All") %>%
                select(Stock, WSShort,Project,ProjLabel) %>% mutate(PlotGroup = paste(Stock,WSShort,sep="-")) %>%
                dplyr::filter(PlotGroup != "Canada-Mainstem")



projects.df


n.grps <- length(unique(projects.df$PlotGroup))
max.panels <- max(table(projects.df$PlotGroup))

layout(matrix(1:((n.grps+3)*(max.panels+1)),ncol=max.panels+1,byrow=TRUE),widths = c(1,rep(1,7)))
#layout.show(120)


plot.text <- function(x,big = FALSE){
    plot(1:5,1:5,type="n",axes=FALSE,xlab="",ylab="");
    if(!big){text(5,2.5,adj=1,label=x,xpd=NA)}
    if(big){text(1,2.5,adj=0,label=x,xpd=NA,cex=2,font=2,col="darkblue")}


}

plot.line <- function(span=25){plot(1:5,1:5,type="n",axes=FALSE,xlab="",ylab=""); lines(c(5-span,5),c(2.5,2.5),col="lightgrey",lwd=5,xpd=NA)}
plot.empty <- function(){plot(1:5,1:5,type="n",axes=FALSE,xlab="",ylab="")}
plot.spark <- function(X,yr.range = c(1960,2020)){

    plot(1:5,1:5, xlim = yr.range, ylim=range(X$Estimate,na.rm=TRUE)* c(0.9,1.3),type="n",axes=FALSE,xlab="",ylab="")

    ## pinstripe version
    #rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "lightgray")
    #abline(v=c(1970,1980,1990,2000,2010),col="white", lwd=2)

    # grey lines version
    #abline(v=c(1970,1980,1990,2000,2010),col="darkgrey", lwd=2)

    rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "lightgray")


    lines(X$Year,X$Estimate,type="o",col="darkblue",pch=19,cex=0.7)


    for(decade in c(1960,1970,1980,1990,2000,2010 )){

        decade.avg <- mean(X %>% dplyr::filter(Year >= decade, Year < decade+10) %>% select(Estimate) %>% unlist(),na.rm=TRUE)
        if(is.finite(decade.avg)){lines(c(decade,decade+9),rep(decade.avg,2),col="red",lwd=3,lend=2)}


    }






    abline(v=par("usr")[2],col="black",lwd=2)


    #abline(h = mean(X$Estimate,na.rm=TRUE),col="red",lwd=1)

    #abline(h=par("usr")[1],col="black",lwd=2)
    #abline(h=par("usr")[3],col="black",lwd=2)

}


yrs.plot <- c(1960,2020)

for(stk in c("Lower","Middle","Canada")){


stk.grps <-     unique(projects.df[projects.df$Stock == stk,"PlotGroup"])

plot.text(stk,big=TRUE)
for(i in 1:6){plot.empty()}
plot.line(30)

for(grp in stk.grps){
print("---------")
    print(grp)




plot.text(projects.df %>% dplyr::filter(PlotGroup == grp) %>% select(WSShort) %>% unique())


proj.grp <- projects.df %>% dplyr::filter(PlotGroup == grp) %>% select(Project) %>% unlist()

proj.labels <- projects.df %>% dplyr::filter(PlotGroup == grp) %>% select(ProjLabel) %>% unlist()

num.proj.grp <- length(proj.grp)


for(i in 1:7){

if(i <= num.proj.grp){


    tmp.plot.df <- data.frame(Year=  yrs.plot[1]:yrs.plot[2]) %>%
        left_join(main.data.df %>% dplyr::filter(Project == proj.grp[i]),by="Year")


    plot.spark(  tmp.plot.df  , yr.range = yrs.plot)

    title.mean <- mean(tmp.plot.df$Estimate/1000,na.rm= TRUE)
    if(title.mean >1){title.mean <- round(title.mean)}
    if(title.mean < 1){title.mean <- "<1"}


    title(main=paste0(proj.labels[i]," (",title.mean,")"),cex.main=0.85,col.main="black",line=-0.5,xpd=NA)

    # NOT WORKING
    # 2 color title
    # use this trick: https://blog.revolutionanalytics.com/2009/01/multicolor-text-in-r.html
    #title(expression(bquote(.(proj.labels[i])) * phantom(bquote(.(title.mean)))))
    #title(expression(proj.labels[i] * phantom(title.mean)),col.main="black")
    #title(expression(phantom(proj.labels[i]) * "title.mean"),col.main="red")




    box(col="lightgrey")
    }

if(i > num.proj.grp){plot.empty()}

} # end looping through panels






} # end looping through groups

} # end looping through stocks


dev.off()






