
calcCorr <- function(X){
# reorganize a dataframe, calculate pairwise correlations
# two outputs: corr matrix, summary table
# X is a subset of the main data file


X.wide <-   pivot_wider(X,id_cols = Year, names_from = Project, values_from = Estimate)



corr.mat <- cor(X.wide  %>% select(-Year) ,use = "pairwise.complete.obs") %>% round(2)# for each pair, use all available data
corr.mat[corr.mat %in% c(-1,1)] <- NA # remove cases based on 2 obs (+1 or -1)


corr.tbl <- as.data.frame(corr.mat) %>% rownames_to_column(var="Project1") %>% pivot_longer(cols= - Project1) %>%
  rename(Project2 = name, Corr = value) %>% mutate(Project2 = gsub("CorrMat.","",Project2)) %>%
  dplyr::filter(Project1 != Project2 ) %>% arrange(Project1, Project2) %>%
  group_by(grp = paste(pmax(Project1,Project2), pmin(Project1,Project2), sep = "_")) %>%
  slice(1) %>% ungroup() %>%   select(-grp)
# using first example from https://stackoverflow.com/a/56193682

X.counts <- X  %>%  sharedcount.loop() %>% rename(Obs1 = Obs)
X.counts.rev <- X.counts %>% dplyr::rename(Project1 = Project2, Project2 = Project1, Obs2 = Obs1)

corr.tbl <- corr.tbl %>%
  left_join(X.counts ,by=c("Project1", "Project2")) %>%
  left_join(X.counts.rev ,by=c("Project1", "Project2")) %>%
  mutate(Obs = pmax(Obs1,Obs2, na.rm=TRUE)) %>%
  select(-Obs1,-Obs2) %>%
  arrange(Project1,Project2) %>%
  as.data.frame()










out.list <- list(CorrMat = corr.mat,CorrTable = corr.tbl,Data = X.wide)
return(out.list)

}


# not giving all the pairs!
sharedcount2 <- function(x,stringsAsFactors=FALSE,...){
#from https://stackoverflow.com/a/9416907
  counts <- crossprod(!is.na(x))
  id <- lower.tri(counts)
  count <- counts[id]
  X1 <- colnames(counts)[col(counts)[id]]
  X2 <- rownames(counts)[row(counts)[id]]
  data.frame(X1,X2,count)
}



sharedcount.loop <- function(X){
# X data frame with Project and Estimate

pairs.do <- combn(unique(X$Project),2) %>% t() %>% as.data.frame() %>% mutate(Obs = NA) %>%
             rename(Project1 = V1, Project2 = V2)

#print(pairs.do)

for(i in 1:dim(pairs.do)[1]){

#print(pairs.do[i,])

proj1.yrs <- X %>% dplyr::filter(Project == pairs.do[i,1],!is.na(Estimate)) %>% select(Year) %>% unlist()
proj2.yrs <- X %>% dplyr::filter(Project == pairs.do[i,2],!is.na(Estimate)) %>% select(Year) %>% unlist()

#print(proj1.yrs)
#print(proj2.yrs)

pairs.do[i, "Obs"] <- length(intersect(proj1.yrs, proj2.yrs))


}

#print(pairs.do)
return(pairs.do)

}


plotCorr <- function(X,plot.label  = "Plot Title"){
# X is output from calcCorr()

# for plotting options, see
# https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html

  # not working
  #corrplot.mixed(cor.out, lower.col = "black", number.cex = .7)

corrplot(X$CorrMat, type= "upper",diag = FALSE, method = "color", addCoef.col = "black",number.cex = 0.8,
         order = "alphabet", mar =  c(3, 3, 5, 1))

title(main=plot.label)


}



corr.cat <- function(x,trigger = 0.4){
  cat.out <- x
  cat.out[x <= -trigger] <- "Neg"
  cat.out[x >=  trigger] <- "Pos"
  cat.out[x > -trigger & x < trigger] <- "No"

  return(cat.out)

}



corr.cols <-   function(x,trigger = 0.4){

x[is.na(x)]  <- 0

x.cat <- corr.cat(x, trigger)


x.cat <- gsub("Pos", "cyan", x.cat )
x.cat <- gsub("Neg","orange", x.cat )
x.cat <- gsub("No","white", x.cat )

#print(x.cat)

return(x.cat)

}





