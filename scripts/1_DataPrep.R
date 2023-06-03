# Script to generate a master file of data from the individual sources
# at the end, generate summary of notes files


library(tidyverse)
source.folder <- "data/Profiles"

data.files.list <- list.files(source.folder,pattern = "Data.csv")
data.files.list



# lookup file
proj.info <- read.csv(paste(source.folder,"ProjectInfo_Lookup.csv",sep="/"),
                      comment.char = '#',
                      stringsAsFactors = FALSE)



# start output object
data.out <- data.frame(Project = NA, Year = NA,	Estimate= NA,
                       SE= NA, p10= NA, p90= NA, Use = NA, UseNotes = NA)

for(file.do in data.files.list){
print("--------------------")
print(file.do)

file.in <- read.csv(paste(source.folder,file.do,sep="/"), comment.char = '#',
                      stringsAsFactors = FALSE, blank.lines.skip=TRUE) %>%
                      dplyr::filter(!is.na(Estimate))
#print(names(file.in))

if(!("Project" %in% names(file.in))){
        file.in <- file.in %>% mutate(Project = gsub("_Data.csv","",gsub("YkCk_","",file.do))) %>%
          select(Project,everything())
        }

if(!("Type" %in% names(file.in))){

  proj.type <-  proj.info[proj.info$Project == gsub("_Data.csv","",gsub("YkCk_","",file.do)), "SurveyType"]

  file.in <- file.in %>% mutate(Type = proj.type ) %>%  select(Project,Type,everything())
}



#print(head(file.in))
print(sort(unique(file.in$Project)))


data.out <- bind_rows(data.out, file.in %>% select(Project,Type, Year, Estimate,SE,Use, UseNotes))


}


# Calculate additional columns and remove empty first row
data.out <- data.out %>% mutate(CV = SE/Estimate, Lower = round(Estimate - 2* SE), Upper = round(Estimate + 2* SE)) %>%
              dplyr::filter(!is.na(Project)) %>%
            left_join(proj.info %>% select(-DataStatus),by="Project")


names(data.out)
sort(unique(data.out$Project))


write.csv(data.out,"data/DerivedData/ProjectData_MainFile.csv",row.names = FALSE)

# look for any duplicate entries (multiple estimates for same year on a project)
data.check <- as.data.frame.matrix(table(data.out %>% select(Project,Year) ))
#view(data.check)

write.csv(data.check,"data/TrackingFiles/CheckingForDuplicateRecords.csv")

# PRINT WARNING IF ANY DUPLICATE RECORDS (MULTIPLE VALUES FOR SAME YEAR AND PROJECT)
if(max(data.check)>1){warning("DUPLICATE RECORDS DETECTED. CHECK data/TrackingFiles/CheckingForDuplicateRecords.csv,THEN FIX THE SOURCE FILES.")
                      stop()}






# --------------------------------------------------------------------------------------------
# generate "wide" file with only the estimates
data.wide <- data.out %>% select(Project,Year,Estimate) %>%
                pivot_wider(id_cols = Year,names_from = Project,
                            values_from = Estimate) %>%
            arrange(Year)



write.csv(data.wide,"data/DerivedData/ProjectData_EstOnly_Wide.csv",row.names = FALSE)


# --------------------------------------------------------------------------------------------
# generate summary file



data.summary <- data.out %>% group_by(Project) %>%
                    summarize(NumEst = sum(!is.na(Estimate)),
                              NumCV = sum(!is.na(Lower)),
                              FirstYr = min(Year),
                              LastYr = max(Year),
                              .groups = "drop") %>%
                    left_join(proj.info,by="Project") %>%
                    bind_rows(proj.info %>% dplyr::filter(!(Project %in% data.out$Project))) %>%
                    arrange(ProjSeq) %>%
                    select(Stock,Watershed,SurveyType,Project,everything())

head(data.summary)

write.csv(data.summary,"data/DerivedData/ProjectData_Summary.csv",row.names = FALSE)


#-----------------------------------------------------------------------------------------
# Repeat for Timeline Files

timeline.files.list <- list.files(source.folder,pattern = "OperationalChanges.csv")
timeline.files.list

timeline.out <- data.frame(Years = NA,	Component = NA,	Change_Event = NA)

for(file.do in timeline.files.list){
  print("---------------")
  print(file.do)

  file.in <- read.csv(paste(source.folder,file.do,sep="/"), comment.char = '#',
                      stringsAsFactors = FALSE, blank.lines.skip=TRUE) %>%
    mutate(Years = as.character(Years))
  print(names(file.in))

  if(!("Project" %in% names(file.in))){
    file.in <- file.in %>% mutate(Project = gsub("_OperationalChanges.csv","",gsub("YkCk_","",file.do))) %>%
      select(Project,everything())
  }


  #print(head(file.in))



  timeline.out <- bind_rows(timeline.out, file.in %>% select(Project, Years,	Component ,Change_Event))


}


# remove empty first row
timeline.out <- timeline.out %>%  dplyr::filter(!is.na(Project)) %>%
                left_join(proj.info %>% select(Stock,Coverage,SurveyType,Watershed, Project),by="Project") %>%
                select(Stock,Coverage,SurveyType,Watershed, Project,everything())

write.csv(timeline.out,"data/DerivedData/ProjectOperationalChanges_MainFile.csv",row.names = FALSE)








#-----------------------------------------------------------------------------------------
# Repeat for DataConcerns Files

concerns.files.list <- list.files(source.folder,pattern = "DataConcerns.csv")
concerns.files.list


concerns.out <- data.frame(Years_Affected = NA,	Potential_Issue = NA)

for(file.do in concerns.files.list){

  print(file.do)

  file.in <- read.csv(paste(source.folder,file.do,sep="/"), comment.char = '#',
                      stringsAsFactors = FALSE, blank.lines.skip=TRUE)  %>%
                      mutate(Years_Affected = as.character(Years_Affected))
  print(names(file.in))

  if(!("Project" %in% names(file.in))){
    file.in <- file.in %>% mutate(Project = gsub("_DataConcerns.csv","",gsub("YkCk_","",file.do))) %>%
      select(Project,everything())
  }


  print(head(file.in))



  concerns.out <- bind_rows(concerns.out, file.in %>% select(Project,Years_Affected ,	Potential_Issue))


}


# remove empty first row
concerns.out <- concerns.out %>%  dplyr::filter(!is.na(Project)) %>%
  left_join(proj.info %>% select(Stock,Coverage,SurveyType,Watershed, Project),by="Project") %>%
  select(Stock,Coverage,SurveyType,Watershed, Project,everything())

write.csv(concerns.out,"data/DerivedData/ProjectDataConcerns_MainFile.csv",row.names = FALSE)



