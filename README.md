# UltraLite-Fisheries-Data-System

This is a worked example of a very robust data management approach for fisheries data. 

## Purpose

The approach is robust in terms of actual implementation for a very specific type of setting, specifically situations where a small number of people try to maintain an up-to-date data set of annual estimates for a group of stocks, with source data coming from many different assessment programs and agencies. The annual estimates typically have important context and annual caveats for interpretation, spread out over many different reports, spreadhseet notes, and e-maill exchanges, which needs to be compiled in some format that is easily accessible. 

The approach was originally developed for compiling and maintaining data for Yukon River Chinook salmon, which combines outputs from 31 main assessment surveys covering a basin of 850,000 km<sup>2</sup> ([Pestal et al. 2022](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf)). 33 people from 11 organizations contributed to the data compilation and review process.

*Important: This approach is not designed to track large amounts of raw data (e.g., individual records from genetic sampling or hydroacoustic tagging programs), but to facilitate and track the synthesis of these pieces into an overall picture of available information* 


*Important: This repository is just an illustration of the basic building blocks: data format, folder structure, and data processing code. The full implementation for Yukon Chinook includes extensive diagnostic plots and an automated summary report created with [csasdown](https://github.com/pbs-assess/csasdown).*


**The example files in this repository are a subset of the published information in [Pestal et al. 2022](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf)). THIS IS NOT A COMPLETE OR UP-TO-DATE DATASET FOR YUKON CHINOOK!** These files are used to illustrate the real-life level of detail that was compiled to document the context for each time series.


## Get Started

If you just want to have a look: keep reading and follow the links below for specific examples of file structure and code

If you just want a local copy of the key files: download zip

If familiar with RStudio and git, just clone this repository

## Key Features


Text

"bite-size csv files

code to merge/check/organize

- tracking changes with git / github (

Basic components of  a relational data base like MS Access (individual tables, linked through queries, except that the tables are individual csv files and the queries are R scripts. However, contributors 

clearmprocess around changes: -> commit messages -> example


## Structure




## Operational Details





- RStudio project



