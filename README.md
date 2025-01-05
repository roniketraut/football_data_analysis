# football_data_analysis

Project Overview
This project focuses on analyzing a multi-season dataset obtained from Kaggle. The dataset spans five seasons and was processed through several key stages to derive actionable insights:

Python (https://github.com/roniketraut/football_data_analysis/blob/main/football.ipynb)

Data Acquisition and Cleaning
The raw dataset was acquired from Kaggle and pre-processed using Python's pandas library. During this phase, I ensured data consistency by:

Handling missing or inconsistent values
Removing outliers and duplicates
Standardizing column names and formats
The data was optimized for efficient querying and analysis in subsequent stages.

SQL 

Database Integration
Once the dataset was cleaned, I imported it into a PostgreSQL database. This involved:

Designing the database schema for efficient storage (https://github.com/roniketraut/football_data_analysis/blob/main/football%20tables.sql, https://github.com/roniketraut/football_data_analysis/blob/main/football%20data%20insertion.sql)

Writing SQL scripts to create tables and relationships
Ensuring data integrity during the import process

Data Analysis (https://github.com/roniketraut/football_data_analysis/blob/main/queries.sql)

In-depth analysis was conducted using advanced SQL queries within the PostgreSQL environment. Key tasks included:

Writing complex queries to extract insights and identify patterns in the data
Using SQL aggregation, joins, and subqueries to derive key metrics and trends
Optimizing queries for performance by indexing frequently accessed columns
This stage was critical in uncovering meaningful insights from the raw data, focusing on data relationships and trends over the seasons.

Visualization and Reporting(https://github.com/roniketraut/football_data_analysis/blob/main/football.pbix)

The final stage of the project involved creating interactive visualizations and reports using Power BI. Here, I focused on the following:

Power Query Editor: I utilized Power BI's Query Editor to clean, transform, and prepare the data for visualization. This included merging, filtering, and reshaping data from multiple tables.
DAX (Data Analysis Expressions): I applied DAX formulas to create calculated columns and measures, allowing for dynamic, on-the-fly calculations and time-based analysis.
Interactive Dashboards: The dashboard offers a comprehensive view of key metrics, such as team statistics, and match outcomes across seasons and leagues. Visualizations were designed for clarity and ease of use, providing actionable insights.
