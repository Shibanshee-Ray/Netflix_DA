# Netflix ELT Project

## Overview

This project demonstrates an end-to-end ELT (Extract, Load, Transform) pipeline using the Netflix dataset. The goal is to clean, transform, and analyze Netflix titles data using both SQL and Python, applying best practices for ELT pipelines. 

### Key Steps:
1. **Extract**: Netflix titles data is extracted from a CSV file.
2. **Load**: The data is loaded into a SQL database using SQLAlchemy for efficient querying and analysis.
3. **Transform**: Data cleaning, transformation, and analysis are performed using SQL queries and Python for further insights.

### Technologies Used:
- **Python**: For extracting and initial loading of the dataset.
- **Pandas**: To manipulate and inspect the data.
- **SQLAlchemy**: To connect and interact with a SQL database.
- **SQL Server**: For data storage and transformations using SQL.
- **Jupyter Notebook (optional)**: For running and documenting Python scripts interactively.

## Dataset
We use the Netflix titles dataset, which includes information about various movies and TV shows available on Netflix, such as titles, release year, genre, and description.

## ELT Process

### 1. Extract:
- The Netflix dataset is extracted from a CSV file (`netflix_titles.csv`).

### 2. Load:
- The extracted data is loaded into a SQL Server database table named `netflix_raw` using SQLAlchemy.

### 3. Transform:
- Data is cleaned and transformed using SQL queries. Some operations include:
  - Removing duplicates.
  - Handling missing values.
  - Splitting genres into separate entries.
  - Analyzing data like average movie duration, top directors, and genre distribution.
 

## Example Analysis

For each director, count the number of movies and TV shows they’ve worked on.
Find the country with the most comedy movies.
Identify the average duration of movies by genre.

##Future Enhancements
Automating the ELT process for continuous data integration.
Adding visualization tools to represent insights.
