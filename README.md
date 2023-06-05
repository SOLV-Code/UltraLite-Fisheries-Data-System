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



## Key Features


### File Formats

"bite-size csv files"  shareable, little memory, no version/OS issues  -> these individual files are convenient for *people* in a process, and then use R code to generate a file that's convenient for the *computer* to manage and summarize the data.   "people-friendly" , software issues, learning curve, context. not dealing with large data sets, just diverse sources.  email firewalls, low bandwith in field. Parts maintained by different people -> single file quickly becomes difficult to manage.


### R Code

code to merge/check/organize

MERGE CODE
summary code

### Tracking Changes


- tracking changes with git / github (

clear process around changes: -> commit messages, branches -> example  -> van see whole history of a changes for a specific file.


SHOW EXAMPLE

### Automated Reports


[simple example of automated report in Word](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/raw/main/Sample_Report_Source.docx)


[basic word report](https://rmarkdown.rstudio.com/articles_docx.html)

[in-depth description of markdown reports (pdf, html, word, powerpoint](https://epirhandbook.com/en/reports-with-r-markdown.html)


For a properly formatted technical report, consider the very versatile [bookdown package](https://bookdown.org/yihui/rmarkdown/) or the  [csasdown extension ](https://github.com/pbs-assess/csasdown)specifically for DFO technical reports and research documents.


## Pro/Con


Basic components of  a relational data base like MS Access (individual tables, linked through queries, except that the tables are individual csv files and the queries are R scripts. However, contributors   can use components more easily. Also: with markdown can set up automated reports/presentations with much more formatting control than in Access. For analysts already using R, this approach has one additiona; benefit: it keeps the full sequence of work, from source data to final report, in the same programming language (no need to switch between R and VisualBasic and Access queries)

But: does not enforce record integrity the same way a a properly designed database with input templates. 

Advantages over the still-common "data management by spreadsheet" approach. _> add more years of data, or add more projects, or change the layout for diagnostic plots -> all of these are major headaches that can be automated.






