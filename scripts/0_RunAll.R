# Script to run all the other scripts

library(tidyverse)

source("scripts/1_DataPrep.R")
source("scripts/1b_DataCrossCheck.R")
source("scripts/2_TimeSeries_Plots.R")
source("scripts/3_Summary_Plots.R")

