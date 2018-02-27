# Getting-and-Cleaning-Data
Final project for Getting and Cleaning Data

Rscript that downloads raw data and tidy it up to extract the mean and standard deviations of the  
variables. Labels are also added to give meaning to the variable.  The 2 relevant datasets are result1  
and result2.  
Note: Many variables are not renamed so as to maintain the technical precision. A description of the variables are recorded in the code book.

Minh Lam
02/26/2018

### The process (as documented in the code):
Downloads and unzips the zip file.   
Store activity labels into a data.frame.  

First, start with the test dataset.  
Store all txt files into variables subjectTest, xTest, yTest.  
Convert yTest values to more meaningful activity labels.  
Store all features into a data.frame, and keep only the ones that compute mean() and std().  
From xTest, select only the varaibles that are relevant(the mean() and std()). Then rename columns to reflect variables.  
Add to this table of variable values the case's subject and activity and rename the first 2 columns.  

Now, repeat the same process for the training dataset.  

Combine the 2 tables into a single result table.  

Finally, create a table with averages of each variable for each subject-activity combination.  
