# UltraLite-Fisheries-Data-System

This is a worked example of a very robust, [human-centered](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/wiki/Background:-Human-centered-design) approach for a compiling and managing a common type of fisheries data. 



## Purpose

The approach is robust in terms of actual implementation for a very specific type of setting, specifically situations where a small number of people try to maintain an up-to-date data set of annual estimates for a group of stocks, with source data coming from many different assessment programs and agencies. The annual estimates typically have important context and annual caveats for interpretation, spread out over many different reports, spreadsheet notes, and e-mail exchanges, which needs to be compiled in some format that is easily accessible. 

Too often, data management systems are designed for some hypothetical setting where all contributors have the time and resources to do exactly what the database designers think they should be doing. [Human-centered design](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/wiki/Background:-Human-centered-design) starts by looking at all the actual people that need to contribute to a specific product (e.g., a summary of all relevant stock assessment surveys), and asks how this additional request can best fit into the existing multitude of tasks these contributors are already doing.


The approach was originally developed for compiling and maintaining data for Yukon River Chinook salmon, which combines outputs from 31 main assessment surveys covering a basin of 850,000 km<sup>2</sup> ([Pestal et al. 2022](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf)). 33 people from 11 organizations contributed to the data compilation and review process. Data summaries and model input files had to be constantly updated as data review and model development progressed concurrently.

Conceptually, the approach focuses on documenting estimates, major changes in the assessment project, and potential issues with individual records. 

Computationally, the approach replicates the basic components of relational data bases like MS Access, which store data in individual tables that are linked through queries, except that the tables here are *people-friendly* individual csv files and the queries are R scripts that merge and summarize the source files into a *computer-friendly* version of the full data set. 

*Important: This approach is not designed to track large amounts of raw data (e.g., individual records from genetic sampling or hydroacoustic tagging programs), but to facilitate and track the synthesis of these pieces into an overall picture of available information.* 


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


## Structure

Each folder has a *README.md* file that explains the files. Github displays the README contents below the list of files. If there are a lot of files, you may have to scroll to the bottom to see the README.

The key folders are:

* [*data*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data): Source data, derived data, and tracking files. Details below.
* [*functions*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/functions): a folder with R functions that automate key steps (e.g., standard diagnostic plots)
* [*scripts*](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/scripts): R code that needs to be run in sequence to first process the raw data, then generate summaries.

The main folder also has the source, formatting template, and output for an illustration of automated reports using markdown (*Sample_Report_Source.Rmd*, *word-styles-reference-01.docx*, *Sample_Report_Source.docx*).

## Key Features


### File Format

All the source data are packaged as"bite-size" csv files for each project in the [*data/Profiles folder*](
https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data/Profiles). This **de-centralized and people-friendly** structure avoids many of the practical hurdles encountered when parts of the source data are maintained by many different people across multiple fisheries organizations.

csv files are plain text files with comma-separated values, which are widely used for [moving tabular data between programs](https://en.wikipedia.org/wiki/Comma-separated_values#Data_exchange). They are easily shareable among contributors, require very little memory, can be opened with most analytical software and text editors, and don't run into issues with software versions, operating systems, or firewall blocks of e-mail attachments. Small csv files also don't cause problems when contributors are in the field and have low bandwidth on their internet connection.

Keeping the data in individual files is convenient for *people* in the data compilation and review process, because not every contributor needs the full set of data during each exchange and update. Each data set is typically small in terms of modern data management, with most time series covering less than 60 annual estimates. If all the data sets were maintained in a single file, it would quickly become difficult to track and manage concurrent updates from multiple projects. 

For example, imagine sending the full data set covering 31 Yukon Chinook data sets to all 33 contributors, then some of them then send it back with revisions, and you have to cross-check/merge all the revisions. In a full database application, the solution would be to set up a data entry portal with data templates, requiring substantial software development and raising substantial practical hurdles (software requirements, learning curve). In this ultralite approach, all you need to do is replace the individual project csv files in the [*data/Profiles folder*](
https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data/Profiles) with the updated versions, and let Git/Github handle the tracking of changes (see details [here](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System#tracking-changes)).

Then a short R script merges the individual source files into a **computer-friendly** version of the full data set as the very last step.

### Structure of Source Files

The project inventory in [data/Profiles/ProjectInfo_Lookup.csv](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/Profiles/ProjectInfo_Lookup.csv)  matches individual assessment projects to stocks, watersheds, plot labels, etc.

For each project, there are up to 3 csv files: 

* *ProjectLabel_Data* (required): lists annual estimates, with error bounds where available, and includes a header with some clarification information. Header lines start with *#*. In *R*, the header information is stripped out by using the argument ```comment.char = "#"``` when reading in the files with ```read.csv()```. See [this example](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/Profiles/YkCk_BorderMR_Data.csv).
* *ProjectLabel_DataConcerns* (optional): lists any potential data issues, in 2 columns (*Years_Affected*, *Potential_Issue*). See [this example](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/Profiles/YkCk_BorderMR_DataConcerns.csv).
* *ProjectLabel_OperationalChanges* (optional): lists any major modifications to the survey program, in 3 columns (*Years*, *Component*, *Change_Event*). See [this example](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/Profiles/YkCk_AndreafskyWeir_OperationalChanges.csv).

Compiling short notes on data concerns and operational changes in *csv* format makes it possible to generate compact summary tables in an automated report (see examples at the end of [Report_Source.docx](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/raw/main/Sample_Report_Source.docx)) and the detailed documentation in the appendices of [Pestal et al. 2022](https://www.psc.org/download/33/psc-technical-reports/14359/psc-technical-report-no-48.pdf)).


### R Code

Given this file structure, the R code to merge, cross-check, and summarize the data across projects is relatively simple.

* [scripts/1_DataPrep.R](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/scripts/1_DataPrep.R) generates a list of project files in the [*data/Profiles folder*](
https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/data/Profiles), then loops through all the files to generate a merged main data file as well as reorganized data sets (e.g., ["wide" file](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/DerivedData/ProjectData_EstOnly_Wide.csv) with the values for each project in a column, which is a convenient source for some plotting functions). Also generates a [project summary](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/data/DerivedData/ProjectData_Summary.csv) which tabulates the available data for each project.

* [scripts/2_TimeSeries_Plots.R](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/scripts/2_TimeSeries_Plots.R) and [scripts/3_Summary_Plots.R](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/scripts/3_Summary_Plots.R) 
generate various [plots](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/tree/main/PLOTS).

* [scripts/0_RunAll.R](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/scripts/0_RunAll.R) runs all the other scripts. 

Once you've set up and tested everything, subsequent updates require only 3 steps by the maintainer of the overall data set:

* Replace the project profile csv files with the latest version
* Open RStudio, open [scripts/0_RunAll.R](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/scripts/0_RunAll.R), press Ctrl-a to highlight the whole script, and click "Run". This runs the merge, summary, and plotting steps.
* Open [Sample_Report_Source.Rmd](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/Sample_Report_Source.Rmd) and click "Knit". The data report with all the updated figures and tables will be generated.

The individual contributors never have to interact with anything other than the individual csv files for their projects, and the overall summaries of available data for review. 

### Tracking Changes

Git and Github are powerful tools for tracking changes in your data and code. But with this power comes a bit of a learning curve.  There are lots of tutorials to help you get started with R/RStudio and Git/Github (e.g., [here](https://www.dataquest.io/blog/tutorial-getting-started-with-r-and-rstudio/), 
[here](https://sites.northwestern.edu/researchcomputing/resources/using-git-and-github-with-r-rstudio/),   [here](https://happygitwithr.com/rstudio-git-github.html), and [here](https://resources.github.com/github-and-rstudio/))

There are a few important things to remember:

* git is designed for tracking changes in text, such as code or plain-text data files. In those cases, it keeps a very efficient inventory of changes. However, if you have files like xlsx, pdf, docx, or png in your repository, it will keep a full copy of every single version, leading to potential memory problems in the long run.
You can exclude individual files, file types, or whole subfolders from tracking in the [.gitignore file](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/blob/main/.gitignore). For details on *.gitignore*, you can start [here](https://www.atlassian.com/git/tutorials/saving-changes/gitignore).
* The full power of these change tracking tools can only be realized when there is clear process around changes followed by maintainers for each major change. This includes:
   * issues inventory
   * frequent commits (e.g., after each file update for an individual project, after every chunk of code)
   * detailed commit messages

For an example, check out the following:

* [this issue](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/issues/11) identifying a problem with one of the data sets and the subsequent comments
* [this summary of the changes](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/commit/96b41001f9502183c00b162859ff713067ace85c) which shows the commit message, and before/after for each changed file. (The BorderMR data changes are near the bottom). You can get to this summary in several different ways: 
   * if you know when the change was made, go to *Insights> Network* then click on the relevant node.
   * if you remember a key word, go to *Issues*, then clear the search bar (remove is:issue and is:open), enter the key word in the search bar (e.g., BorderMR), and all relevant issues and commits will be listed.
   * if you know the specific file, you can go to that file in github,  then click on the *History* button on the top right. It will then display a complete [history of previous versions](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/commits/main/data/Profiles/YkCk_BorderMR_Data.csv). You can then click on a specific version to see the specific changes compared to the previous version.


### Automated Reports


An example of an automated report in Word is included: [Report_Source.docx](https://github.com/SOLV-Code/UltraLite-Fisheries-Data-System/raw/main/Sample_Report_Source.docx)

This is a very basic illustration of the kind of automated reports you can generate with R markdown. In this set-up, you have limited options for formatting (e.g., page breaks or figure captions require workarounds), but it shows the key benefit: every time your source data is updated you can quickly generate an updated report with all the updated figures and tables. 

This document was generated following the steps from this [worked example](https://rmarkdown.rstudio.com/articles_docx.html). For an in-depth description of many possibilities for markdown reports (pdf, html, word, powerpoint), start with [this guide](https://epirhandbook.com/en/reports-with-r-markdown.html). For a properly formatted technical report, consider the versatile [bookdown package](https://bookdown.org/yihui/rmarkdown/) or the  [csasdown extension ](https://github.com/pbs-assess/csasdown) specifically for DFO technical reports and research documents.

*Important*: It is easy to get lost in the beautiful intricacies of generating perfectly-formatted reports using these more powerful tools for generating reports from markdown. However, the real bottleneck is getting a streamlined workflow up and running, from the individual data contributors to a basic summary of available information. Until that step works smoothly, a very basic report like this example should be sufficient. All the packages you need are already part of your RStudio install, so no additional setup is required.  *Don't procrastinate on the hard part by spending your time on the flashy stuff!*


## Discussion

This ultralite approach has clear advantages over the still-common "data management by spreadsheet" approach. In fisheries analysis we often encounter xls workbooks used to compile data and implement some basic data processing and calculations. These have typically grown over years or even decades, have dozens of interconnected tabs, and include important information in text boxes and pop-up comments. These are large files, making them cumbersome for e-mailing around, it is difficult to coordinate changes for multiple contributors, and it can be a massive task to add additional years of data or additional time series. If they contain a large number of diagnostic plots (e.g., a time series plot for each assessment project), then any simple formatting change will have to be replicated for every single plot (e.g., axis label revision).

This ultralite approach replicates the basic components of relational data base like MS Access, which store data in individual tables that are linked through queries, except that the tables here are individual csv files and the queries are R scripts. While the components are analogous,  contributors can review and update them more easily if they  are in individual plain text files.  

One drawback is that the individual csv files do not enforce record integrity the same way as a properly designed database with input templates. In practice, this can be remedied through a bit of coordination among contributors.

With RStudio and markdown we can set up automated reports or presentations with much more formatting control than in Access. 

For analysts already using R, this ultralite approach has one additional benefit: it keeps the full sequence of work, from source data to final report, in the same programming language (no need to learn or try to remember Excel formulae, VisualBasic code , or Access queries).







