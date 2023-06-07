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

You have three options for browsing through this repository:

* If you just want to have a quick look, keep reading and follow the links below for specific examples of file structure and code.

* If you want a local copy of the key files, click on the green *"<> Code"* button neaer the top of this page, and select *"Download Zip"*.

* If you really want to dig into the details and are familiar with RStudio and git, just clone this repository, then open the RStudio project file *UltraLite-Fisheries-Data-System.Rproj*

There are lots of tutorials to help you get started with R/RStudio and Git/Github (e.g., [here](https://www.dataquest.io/blog/tutorial-getting-started-with-r-and-rstudio/), 
[here](https://sites.northwestern.edu/researchcomputing/resources/using-git-and-github-with-r-rstudio/),   [here](https://happygitwithr.com/rstudio-git-github.html), and [here](https://resources.github.com/github-and-rstudio/))


## Structure

Each folder has a *README.md* file that explains the files. Github displays the README contents below the list of files. If there are a lot of files, you may have to scroll to the bottom to see the README.

The key folders are:

* [*data*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data): Source data, derived data, and tracking files. Details below.
* [*functions*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/functions): a folder with R functions that automate key steps (e.g., standard diagnostic plots)
* [*scripts*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/scripts): R code that needs to be run in sequence to first process the raw data, then generate summaries.

The main folder also has the source, formatting template, and output for an illustration of automated reports using markdown (*Sample_Report_Source.Rmd*,*word-styles-reference-01.docx*,*Sample_Report_Source.docx*).

## Key Features


### Format of Source Files

All the source data are packaged as"bite-size" csv files for each project in the [*data/Profiles folder*](
https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data/Profiles). This *de-centralized* and *people-friendly* structure avoids many of the practical hurdles encountered when parts of the source data are maintained by many different people across multiple fisheries organizations 

csv files are plain text files with comma-separated values, which are widely used for [moving tabular data between programs](https://en.wikipedia.org/wiki/Comma-separated_values#Data_exchange). They are easily shareable among contributors, require very little memory, can be opened with most analytical software and text editors, and don't run into issues with software versions, operating systems, firewall blocks of e-mail attachments. Small csv files also don't cause problems when contributors are in the field and have low bandwidth on their internet connection.

Keeping the data in individual files is convenient for *people* in the data compilation and review process, because not every contributor needs the full set of data during each exchange and update. Each data set is typically small in terms of modern data management, with most time series covering less than 60 annual estimates. If all the data sets were maintained in a single file, it would quickly become difficult to track and manage updates. For example, imagine sending the full data set covering 31 Yukon Chinook data sets to all 33 contributors, then some of them then send it back with revisions, and you have to cross-check/merge all the revisions. In a full database application, the solution would be to set up a data entry portal with data templates, requiring substantial software development and raising substantial practical hurdles (software requirements, learning curve). In this ultralite approach, all you need to do is replace the individual project csv files in the [*data/Profiles folder*](
https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data/Profiles)with the updated versions, and let Git/Github handle the tracking of changes (see details [here](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System#tracking-changes)).

Then a short R script merges the individual source files into a *computer-friendly* version of the full data set as the very last step.

### Structure of Source Files

The project inventory in [data/Profiles/ProjectInfo_Lookup.csv](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/Profiles/ProjectInfo_Lookup.csv)  matches individual assessment projects to stocks, watersheds, plot labels, etc.

For each project, there are up to 3 csv files: 

* *ProjectLabel_Data*(required): lists annual estimates, with error bounds where available, and includes a header with some clarification information. Header lines start with *#*. In *R*, the header information is stripped out by using the argument ```comment.char = "#"``` when reading in the files with ```read.csv()```.
* *ProjectLabel_DataConcerns*(optional): lists any potential data issues, in 2 columns (*Years_Affected*, *Potential_Issue*).
* *ProjectLabel_OperationalChanges*(optional): lists any major modifications to the survey program, in 3 columns (*Years*, *Component*, *Change_Event*).

Compiling short notes on data concerns and operational changes in *csv* format makes it possible to generate compact summary tables inan automated report (see examples at the end of [Report_Source.docx](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/raw/main/Sample_Report_Source.docx)).  


### R Code

code to merge/check/organize

MERGE CODE
summary code

### Tracking Changes


- tracking changes with git / github (

clear process around changes: -> commit messages, branches -> example  -> van see whole history of a changes for a specific file.


SHOW EXAMPLE

### Automated Reports


An example of an automated report in Word is included: [Report_Source.docx](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/raw/main/Sample_Report_Source.docx)

This is a very basic illustration of the kind of automated reports you can generate with R markdown. In this set-up, you have limited options for formatting (e.g., page breaks or figure captions require workarounds), but it shows the key benefit: every time you source data is updated you can quickly generate an updated report with all the  updated figures and tables. 

This document was generated following the steps from this [worked example](https://rmarkdown.rstudio.com/articles_docx.html). For an in-depth description of many possibilities for markdown reports (pdf, html, word, powerpoint), start with [this guide](https://epirhandbook.com/en/reports-with-r-markdown.html). For a properly formatted technical report, consider the versatile [bookdown package](https://bookdown.org/yihui/rmarkdown/) or the  [csasdown extension ](https://github.com/pbs-assess/csasdown) specifically for DFO technical reports and research documents.

*Important*: It is easy to get lost in the beautiful intricacies of generating perfectly-formatted reports using these more powerful tools for generating reports from markdown. However, the real bottleneck is getting a streamlined workflow up and running, from the individual data contributors to a basic summary of available information. Until that step works smoothly, a very basic report like this example should be sufficient. All the packages you need are already part of your RStudio install, so no additional setup is required.  *Don't procrastinate on the hard part by spending your time on the flashy stuff!*


## Pro/Con


Basic components of  a relational data base like MS Access (individual tables, linked through queries, except that the tables are individual csv files and the queries are R scripts. However, contributors   can use components more easily. Also: with markdown can set up automated reports/presentations with much more formatting control than in Access. For analysts already using R, this approach has one additiona; benefit: it keeps the full sequence of work, from source data to final report, in the same programming language (no need to switch between R and VisualBasic and Access queries)

But: does not enforce record integrity the same way a a properly designed database with input templates. 

Advantages over the still-common "data management by spreadsheet" approach. _> add more years of data, or add more projects, or change the layout for diagnostic plots -> all of these are major headaches that can be automated.






