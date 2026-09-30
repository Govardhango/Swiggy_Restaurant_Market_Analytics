# Swiggy Restaurant Market Analytics

## Project Overview

An end-to-end Data Analytics portfolio project using **MySQL, SQL, and Power BI** to analyze restaurant listing data collected from Swiggy and published on Kaggle.

The project analyzes **140,657 raw restaurant listings** and focuses on restaurant availability, locations, cuisines, ratings, listed prices, offers, and vegetarian options.

> **Important:** This is public restaurant-listing data. It is **not official Swiggy internal transaction data** and does not contain Swiggy orders, revenue, customer transactions, or delivery operations.

---

## Business Problem

The project answers practical restaurant-market questions:

* Which locations have the highest number of restaurant listings?
* Which cuisines are most commonly listed?
* What is the average restaurant rating by location?
* What is the average listed price for two?
* How does pricing vary across locations?
* What percentage of restaurants are pure vegetarian?
* How are restaurants distributed across rating ranges?
* Which restaurants have high rating counts?
* How are restaurants distributed across price segments?
* How do offers vary across restaurants?
* Is there a noticeable relationship between offers, ratings, and prices?
* Which cuisine categories have higher average ratings or prices?

---

## End-to-End Workflow

**Raw Data → Data Quality → Data Cleaning → MySQL → SQL Analysis → Power BI → DAX → Dashboard → Business Insights**

---

## Tools

* MySQL
* SQL
* Power BI
* DAX
* Excel / CSV
* GitHub

---

## Project Structure

```text
Swiggy_Restaurant_Market_Analytics/

├── 01_Raw_Data/
│   └── Swiggy_Restaurant_Data.csv
│
├── 02_SQL/
│   ├── 01_Data_Quality_Check.sql
│   ├── 02_Data_Cleaning.sql
│   ├── 03_Business_Analysis.sql
│   └── 01_SQL_Analysis_Original.sql
│
├── 03_Cleaned_Data/
│   └── Swiggy_Restaurant_Cleaned.csv
│
├── 04_PowerBI/
│   └── Swiggy_Restaurant_Market_Analytics.pbix
│
├── 05_Dashboard/
│
├── 06_Documentation/
│   ├── BUSINESS_REQUIREMENTS.md
│   └── INTERVIEW_GUIDE.md
│
└──  README.md
   
```

---

# 1. Dataset

The raw dataset contains **140,657 restaurant listings** and **10 columns**.

Main columns include:

* `restaurant_name`
* `cuisine`
* `rating`
* `number_of_ratings`
* `average_price`
* `number_of_offers`
* `offer_name`
* `area`
* `pure_veg`
* `location`

The dataset represents restaurant-listing information collected from Swiggy and published publicly on Kaggle.

---

# 2. Data Quality

Before analysis, the raw dataset was checked for common data-quality problems.

## NULL Check

All 10 columns were checked for SQL `NULL` values.

Result:

* **0 SQL NULL values**

However, some fields contained text values such as:

* `NEW`
* `--`
* `Too Few Ratings`

These were handled separately during cleaning because they are not SQL `NULL` values.

---

## Duplicate Check

Exact duplicate rows were identified using a duplicate-count calculation.

Result:

* **1,336 extra duplicate rows**

These exact duplicate records were removed during the cleaning process.

---

## Repeated Restaurant Names

Repeated restaurant names were **not automatically treated as duplicates**.

For example, the same restaurant name can appear in different locations.

Therefore, the project removes **exact duplicate rows**, rather than removing restaurants based only on their name.

---

# 3. Data Cleaning

The raw data contains several fields that require conversion before analysis.

The main cleaning activities were:

* Converted valid ratings into numeric values
* Handled `NEW` and `--` rating values
* Converted rating-count text into numeric lower-bound values
* Converted listed prices into numeric values
* Removed exact duplicate rows
* Validated the cleaned dataset

---

## Rating Cleaning

The `rating` column contains both numeric values and text values such as:

```text
4.5
4.2
NEW
--
```

Valid numeric ratings were converted into a numeric format.

Non-numeric values such as `NEW` and `--` were converted to `NULL` for analysis.

---

## Number of Ratings Cleaning

The `number_of_ratings` column contains values such as:

```text
3 ratings
10+ ratings
100+ ratings
1K+ ratings
5K+ ratings
Too Few Ratings
```

These values were converted into numeric lower-bound values where possible.

For example:

```text
3 ratings   → 3
10+ ratings → 10
100+ ratings → 100
1K+ ratings → 1000
5K+ ratings → 5000
```

### Important Limitation

These values are **not exact review counts**.

For example:

`1K+ ratings` means at least approximately 1,000 ratings, not exactly 1,000.

Therefore, the cleaned field should be interpreted as a **rating-count band/lower bound**.

---

## Average Price Cleaning

The raw price field contains text such as:

```text
₹250 for two
₹500 for two
₹800 for two
```

The numeric price was extracted from the text.

Example:

```text
₹250 for two → 250
```

This represents the **listed price for two people**, not actual customer spending.

---

# 4. Cleaned Dataset

The cleaning process uses `SELECT DISTINCT` while converting the required fields.

This removes exact duplicate records.

Final cleaned dataset:

**139,321 rows**

The cleaned dataset was then validated for:

* Total rows
* Valid ratings
* Valid rating counts
* Valid prices

---

# 5. MySQL

The cleaned restaurant data is analyzed using MySQL.

The SQL workflow is divided into three main stages:

### Data Quality

```text
01_Data_Quality_Check.sql
```

Used to check:

* NULL values
* Duplicate records
* Column quality
* Data consistency

### Data Cleaning

```text
02_Data_Cleaning.sql
```

Used to:

* Clean ratings
* Convert rating counts
* Convert prices
* Remove exact duplicates
* Create the cleaned dataset

### Business Analysis

```text
03_Business_Analysis.sql
```

Used to answer business questions using SQL.

---

# 6. SQL Analysis

The SQL analysis covers the following business questions:

1. Total restaurant listings
2. Restaurant listings by location
3. Top locations by listing count
4. Top cuisine categories
5. Average rating by location
6. Average listed price by location
7. Pure Veg vs Non-Veg restaurants
8. Rating distribution
9. Rating vs price by location
10. High rating-count restaurants
11. Rating-count bands
12. Offer distribution
13. Offers vs average rating
14. Offers vs average price
15. Cuisine rating performance
16. Cuisine price performance
17. Restaurant price segments
18. Location-level restaurant comparison

The SQL scripts are available in:

```text
02_SQL/
```

---

# 7. Power BI Dashboard

The Power BI report contains **two dashboard pages**.

---

## Page 1 — Market Overview

This page provides an overall view of the restaurant market.

### KPIs

* Total Restaurant Listings
* Average Rating
* Average Listed Price
* Highly Rated Listings
* 5-Star Listings
* Pure Veg Percentage

### Visuals

The page includes analysis of:

* Restaurant listings by location
* Restaurant listings by cuisine
* Rating distribution
* Pure Veg vs Non-Veg
* Average listed price by location
* Restaurant market distribution

---

## Page 2 — Restaurants & Customer Insights

This page focuses on restaurant pricing, cuisines, ratings, and offers.

### Analysis Includes

* Average price by cuisine
* Rating vs price by location
* Offers vs average rating
* Restaurants by price segment
* Cuisine price comparison
* Cuisine rating comparison
* Rating-count analysis

The page helps identify differences between restaurant categories and locations.

---

# 8. Important DAX Measures

Power BI measures are used to calculate important business KPIs.

Example:

```dax
Total Listings =
COUNTROWS('Swiggy_Restaurant')
```

Example:

```dax
Average Rating =
AVERAGE('Swiggy_Restaurant'[rating])
```

Example:

```dax
Average Listed Price =
AVERAGE('Swiggy_Restaurant'[average_price])
```

Example:

```dax
Highly Rated Listings =
CALCULATE(
    COUNTROWS('Swiggy_Restaurant'),
    'Swiggy_Restaurant'[rating] >= 4
)
```

These measures allow the dashboard to dynamically respond to filters.

---

# 9. Key Findings

The dashboard identified several notable patterns in the restaurant-listing dataset:

* **139,321 cleaned restaurant listings** were available for analysis.
* **Kanpur has 2,000 restaurant listings** in the displayed dataset.
* **North Indian, Chinese** is the most represented cuisine category with **6,589 listings**.
* **41.99% of the cleaned listings are pure vegetarian**.
* The **₹150–₹249** price segment is the largest price segment in the dashboard.
* Average ratings across different offer levels are relatively close in the displayed analysis.
* Some cuisine categories, such as **Grill, Greek**, appear among the higher-price/higher-rating examples in the displayed analysis.

> These findings describe the analyzed dataset. They should not be interpreted as representing Swiggy's entire restaurant ecosystem.

---

# 10. Important Analytical Decisions

## Why were repeated restaurant names kept?

Restaurant names are not unique identifiers.

The same restaurant name can exist in multiple locations.

Therefore, the project removes only exact duplicate records.

---

## Why was monthly trend analysis not performed?

The dataset does not contain a reliable restaurant-listing date.

Creating a monthly trend would require making assumptions about when each listing was collected.

Therefore, no unsupported monthly trend was included.

---

## Why was location-level analysis used?

The dataset contains more than **139,000 listings**.

A restaurant-level scatter plot would become extremely crowded and difficult to interpret.

Therefore, selected scatter analysis uses **location-level averages** to provide a clearer comparison.

---

## How were price outliers handled?

Some extreme price values were identified during dashboard development.

The original records were retained.

For selected dashboard visuals, a documented threshold was used so that extreme values would not dominate the comparison.

This is an **analytical visualization decision**, not a claim that every price above the threshold is invalid.

---

# 11. Limitations

This project has several important limitations.

1. The dataset is public restaurant-listing data, not Swiggy internal data.
2. No order or transaction data is available.
3. Revenue cannot be calculated.
4. Customer spending cannot be calculated.
5. Rating-count values are lower-bound/band values rather than exact counts.
6. The dataset does not contain a reliable listing date.
7. Some extreme price observations exist.
8. Listing counts may be affected by the original data-collection process.
9. Cuisine combinations are retained as provided in the source data.
10. The analysis describes relationships but does not establish causation.
11. Offers cannot be assumed to cause higher or lower ratings.
12. Listed price for two does not represent actual customer spending.

---

# 12. Business Value

This dashboard helps users understand the restaurant market using publicly available listing data.

A business user can quickly analyze:

* Restaurant concentration by location
* Popular cuisine categories
* Price differences
* Rating patterns
* Vegetarian restaurant availability
* Offer distribution
* Rating-count patterns
* Location-level market differences

Instead of manually analyzing more than 139,000 records, users can interact with the Power BI dashboard and filter the market by relevant dimensions.

---

# 13. How to Run the Project

### Step 1 — Review the Raw Data

Open the dataset in:

```text
01_Raw_Data/
```

Review the available restaurant fields.

### Step 2 — Run Data Quality Checks

Open:

```text
02_SQL/01_Data_Quality_Check.sql
```

Run the queries in MySQL.

### Step 3 — Run Data Cleaning

Open:

```text
02_SQL/02_Data_Cleaning.sql
```

Run the cleaning queries.

### Step 4 — Validate the Cleaned Data

Confirm the cleaned dataset contains approximately:

```text
139,321 rows
```

### Step 5 — Run SQL Business Analysis

Open:

```text
02_SQL/03_Business_Analysis.sql
```

Run the business-analysis queries.

### Step 6 — Open Power BI

Open:

```text
04_PowerBI/Swiggy_Restaurant_Market_Analytics.pbix
```

Refresh the data connection if required.

### Step 7 — Explore the Dashboard

Use the filters and visuals to explore restaurant listings, locations, cuisines, prices, ratings, and offers.

---

# 14. Portfolio Note

This project demonstrates an end-to-end **Data Analyst workflow**:

**Raw Data → Data Quality → SQL Cleaning → SQL Analysis → Power BI → DAX → Dashboard → Business Insights**

The project demonstrates practical skills in:

* Data cleaning
* SQL
* MySQL
* Data validation
* Business analysis
* Power BI
* DAX
* Dashboard development
* Data storytelling
* Communicating analytical limitations

The project uses **public restaurant-listing data** and does not claim access to Swiggy's internal business or transaction data.
