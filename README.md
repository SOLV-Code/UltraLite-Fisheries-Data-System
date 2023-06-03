# UltraLite-Fisheries-Data-System

This is a worked example of a very robust data management approach for fisheries data. 

## Purpose

The approach is robust in terms of actual implementation for a very specific type of setting, specifically situations where a small number of people try to maintain an up-to-date data set of annual estimates for a group of stocks, with source data coming from many different assessment programs and agencies. The annual estimates typically have important context and annual caveats for interpretation, spread out over many different reports, spreadsheet notes, and e-mail exchanges, which needs to be compiled in some format that is easily accessible. 

The approach was originally developed for compiling and maintaining data for Yukon River Chinook salmon, which combines outputs from 31 main assessment surveys covering a basin of 850,000 km<sup>2</sup> ([Pestal et al. 2022](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf)). 33 people from 11 organizations contributed to the data compilation and review process. Data summaries and model input files had to be constantly updated as data review and model development progressed.

*Important: This approach is not designed to track large amounts of raw data (e.g., individual records from genetic sampling or hydroacoustic tagging programs), but to facilitate and track the synthesis of these pieces into an overall picture of available information* 


*Important: This repository is just an illustration of the basic building blocks: data format, folder structure, and data processing code. The full implementation for Yukon Chinook includes extensive diagnostic plots and an automated summary report created with [csasdown](https://github.com/pbs-assess/csasdown). In the case of Yukon Chinook, the run reconstruction step was done by a separate model in a separate repository, but the data processing and run reconstruction steps could be integrated within a single repository.*


**The example files in this repository are a subset of the published information in [Pestal et al. (2022)](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf). THIS IS NOT A COMPLETE OR UP-TO-DATE DATASET FOR YUKON CHINOOK!** These files are used to illustrate the real-life level of detail that was compiled to document the context for each time series.

## Feedback

If you have any questions, comments, or ideas for extensions, you can leave a note on the
[issues page](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/issues) by clicking
on *New Issue*.


## Get Started

If you just want to have a look: keep reading and follow the links below for specific examples of file structure and code

If you just want a local copy of the key files: download zip

If familiar with RStudio and git, just clone this repository

## Key Features


Text

"bite-size csv files"  shareable, little memory, no version/OS issues  -> these individual files are convenient for *people* in a process, and then use R code to generate a file that's convenient for the *computer* to manage and summarize the data. 

code to merge/check/organize

- tracking changes with git / github (

Basic components of  a relational data base like MS Access (individual tables, linked through queries, except that the tables are individual csv files and the queries are R scripts. However, contributors   

Advantages over the still-common "data management by spreadsheet" approach. _> add more years of data, or add more projects, or change the layout for diagnostic plots -> all of these are major headaches that can be automated.

clear process around changes: -> commit messages, branches -> example


MERGE CODE
summary code

simple example of automated report (to word doc)


## Structure




## Operational Details





- RStudio project



