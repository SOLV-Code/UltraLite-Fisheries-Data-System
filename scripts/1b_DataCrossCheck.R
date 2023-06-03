# Check prepared data files against 2 Hamachan files:
#   Current input into the draft model is Yukon_Chinook_2019.dat
#   File provided by Hamachan: Canadian_Model_Data_2019.csv



# get the 2019 input file (using HH function)
source("functions/FUNCTIONS_admb_helperfunctions.R")
hh2019.df <- datatoR("data/SOURCES/Hamachan Files/Hamazaki Model Download/Yukon_Chinook_2019.dat")
names(hh2019.df)
hh2019.df


# get the HH source file
hh.src.df <- read.csv("data/SOURCES/Hamachan Files/Hamazaki Data Mail 2020-11-10/Canadian_Model_Data_2019.csv",stringsAsFactors = FALSE)
names(hh.src.df)
hh.src.df


# get CB file with tributary CVs
trib.cv.df <- read.csv("data/SOURCES/Catherine Files/Yukon_Chinook_2019_tribCv_GPMod.csv",stringsAsFactors = FALSE)
names(trib.cv.df)




# get the generated data file from Script 1
prep.data.df <- read.csv("data/DerivedData/ProjectData_MainFile.csv",stringsAsFactors = FALSE)
names(prep.data.df)
sort(unique(prep.data.df$Project))
sort(unique(prep.data.df$ModelVar))
head(prep.data.df)




# Merge check

var.vec <- sort(unique(c(gsub("_sd","",names(hh2019.df)),
                         gsub("_sd","",gsub("_cv","",names(trib.cv.df))))))


var.check.df <- data.frame(ModelVar = var.vec,
                           HHFile = var.vec %in% gsub("_sd","",names(hh2019.df)) ) %>%
                left_join(proj.info %>% select(ModelVar,Project,ModelUse,DataStatus,ModelDropYr,ModelVarCheck),by="ModelVar") %>%
                bind_rows( prep.data.df %>% select(ModelVar,Project,ModelUse,ModelDropYr,ModelVarCheck) %>%  unique() %>%
              dplyr::filter(!(ModelVar %in% var.vec)) ) %>%
                select(ModelUse, everything()) %>% arrange(ModelUse)


write.csv(var.check.df,"data/TrackingFiles/Variable_CrossCheck.csv",row.names = FALSE)


#####################################
# Check US harvest data
library(tidyverse)


us.ct.main <- read.csv("data/ProfilesHarvestData/YkCk_Harvest_US_Data.csv",
                      comment = '#',
                      stringsAsFactors = FALSE)
names(us.ct.main)

us.ct.split <- read.csv("data/ProfilesHarvestData/YkCk_Harvest_byDistrTypeStockAge.csv",
                        comment.char = '#',
                        stringsAsFactors = FALSE) %>% dplyr::filter(District != 7)  #
names(us.ct.split)

us.ct.tmp2 <- us.ct.split %>% group_by(Year, Fishery) %>% summarize(Total = sum(Total)) %>%
              pivot_wider(id_cols = Year, names_from = Fishery,values_from = Total)  %>%
              arrange(Year)

us.ct.tmp1 <- us.ct.main %>%
  pivot_wider(id_cols = Year, names_from = Type,values_from = Estimate) %>%
  arrange(Year)


par(mfrow = c(2,2))
for(type.plot in c("US_Comm","US_Subsistence","US_Sport")){


plot(us.ct.tmp1$Year,us.ct.tmp1[[type.plot]],bty="n",xlab="Year",ylab="Harvest",
      type="o",col="darkblue",pch=19, main = type.plot)
points(us.ct.tmp2$Year,us.ct.tmp2[[type.plot]],bty="n",xlab="Year",ylab="Harvest",
     type="p",col="red",pch=4, main = type.plot)

}


plot(1:5,1:5, type="n",axes = "FALSE",xlab="",ylab="")
legend("top",legend=c("Main","Sum of Split"), col = c("darkblue","red"),
       pch=c(19,4),bty="n")


ct.type <- "CA_Porcupine"
X <- ct.data.main %>% dplyr::filter(Type == ct.type) %>% select(Year, percTotal, percTotalUS)

plot(X$Year,X[[2]],type= "o",ylim=c(0,100))
lines(X$Year,X[[3]],type= "o")


#----------------------------------







