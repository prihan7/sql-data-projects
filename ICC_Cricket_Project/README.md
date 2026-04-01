# ICC Cricket SQL Project

## 📌 Objective

Analyze cricket player performance data using SQL.

## 📊 Key Analysis Performed

* Cleaned dataset by removing unnecessary columns
* Extracted player names and country from raw data
* Derived start and end year from span column
* Separated highest score and not-out status
* Identified top players based on average and centuries
* Created views for South African players

## 🧠 SQL Concepts Used

* String functions (SUBSTR, POSITION)
* CASE statements
* Aggregations
* Views

## 📂 Files Included

* icc_cricket_analysis.sql → Main analysis queries
* ICC Test Batting Figures.csv → Dataset

## 🚀 Outcome

Performed structured data cleaning and player performance analysis using SQL

## 🚀 How to Run

1. Open MySQL Workbench (or any SQL tool)

2. Create a new database:
   CREATE DATABASE icc_cricket;
   USE icc_cricket;

3. Import the dataset:

   * Load the file: ICC Test Batting Figures.csv
   * Import it into a table named: icc_test_batting_figures

4. Open and run the SQL file:

   * icc_cricket_analysis.sql

5. Execute the queries step by step to:

   * Clean and transform the data
   * Extract player and country information
   * Analyze player performance
   * Generate insights


