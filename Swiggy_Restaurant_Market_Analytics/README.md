# Swiggy Restaurant Market Analytics

## Project Overview

This project analyzes a publicly available Swiggy restaurant-listing
dataset using **MySQL/SQL and Power BI**.

The project follows a complete Data Analyst workflow:

**Raw Data → Data Quality → Cleaning → SQL Analysis → Power BI →
Business Insights**

### Important data-source limitation

This is **not official Swiggy internal transaction data**. It is public
restaurant-listing data collected from Swiggy and published on Kaggle.

Therefore, the project focuses on:

-   Restaurant listings
-   Location
-   Cuisine
-   Ratings
-   Listed price for two
-   Rating-count bands
-   Offers
-   Pure-vegetarian status

It does not claim to analyze Swiggy's internal orders, revenue, customer
transactions or delivery operations.

------------------------------------------------------------------------

## Dataset

Raw table:

-   140,657 rows
-   10 columns

Main columns:

`restaurant_name`, `cuisine`, `rating`, `number_of_ratings`,
`average_price`, `number_of_offers`, `offer_name`, `area`, `pure_veg`,
`location`

The SQL source confirms the raw table structure and quality checks.
fileciteturn0file0L4-L14

------------------------------------------------------------------------

## Data Quality

### NULL check

The project checked all 10 columns for SQL NULL values.
fileciteturn0file0L24-L36

Result: **0 SQL NULL values**.

Special text values such as `NEW`, `--` and `Too Few Ratings` were
handled separately because they are not SQL NULLs.

### Exact duplicates

The project calculated extra duplicate rows using:

`duplicate_count - 1`

The SQL explicitly performs this calculation.
fileciteturn0file0L121-L150

Result:

**1,336 extra duplicate rows**

Exact duplicate rows were removed during cleaning.

### Repeated restaurant names

Repeated restaurant names were **not** treated as duplicates
automatically.

The same restaurant name can legitimately appear in different locations,
so the cleaning logic removes exact duplicate rows rather than unique
names.

------------------------------------------------------------------------

## Data Cleaning

### Rating

The raw rating field contained numeric values plus values such as `NEW`
and `--`.

Valid numeric values were converted to `DECIMAL(2,1)` and non-numeric
values became NULL. The SQL tests this conversion before inserting the
cleaned data. fileciteturn0file0L192-L200

### Number of ratings

Values such as:

-   `3 ratings`
-   `10+ ratings`
-   `100+ ratings`
-   `1K+ ratings`
-   `5K+ ratings`
-   `Too Few Ratings`

were converted into numeric lower-bound values where possible.
fileciteturn0file0L203-L218

Important limitation: these values are **not exact review counts**. For
example, `1K+ ratings` is treated as a lower-bound/band value of 1000
for analysis.

### Average price

Text such as `₹250 for two` was converted into the numeric value `250`.
The SQL extracts the digits before `for two`.
fileciteturn0file0L221-L232

This represents **listed price for two**, not actual customer spending.

### Cleaned row count

The SQL uses `SELECT DISTINCT` while converting the three fields, which
removes exact duplicate rows. fileciteturn0file0L236-L296

Final cleaned dataset:

**139,321 rows**

The project then validates total rows, valid ratings, valid rating
counts and valid prices. fileciteturn0file0L299-L307

------------------------------------------------------------------------

## Business Analysis

The SQL analysis covers:

-   Top locations by listing count
-   Top cuisine categories
-   Average rating by location
-   Average listed price by location
-   Pure Veg vs Non-Veg
-   Rating distribution
-   Location-level rating vs price
-   High rating-count listings
-   Rating-count bands
-   Offer bands
-   Offers vs average rating/price
-   Cuisine rating and price performance

These business questions are directly represented in the SQL file.
fileciteturn0file0L328-L405 fileciteturn0file0L407-L520

------------------------------------------------------------------------

## Power BI

The PBIX contains two completed report pages:

1.  **Market Overview**
2.  **Restaurants & Customer Insights**

The report uses Power BI measures and calculated fields for:

-   Total listings
-   Average rating
-   Average listed price
-   Highly rated listings
-   5-star listings
-   Offer-based metrics
-   Price segments
-   Rating ranges

### Page 1 --- Market Overview

Focus:

-   Listing distribution
-   Location distribution
-   Cuisine distribution
-   Rating distribution
-   Pure Veg vs Non-Veg
-   Average listed price by city

### Page 2 --- Restaurants & Customer Insights

Focus:

-   Average price by cuisine
-   Location-level rating vs price
-   Offers vs rating
-   Restaurant listings by price segment
-   Cuisine price/rating comparison

------------------------------------------------------------------------

## Important analytical decisions

### Why repeated restaurant names were kept

A restaurant name is not a unique key. The same name can occur in
multiple locations.

### Why a monthly trend was not used

The dataset does not provide a reliable listing-date field, so a monthly
trend would require unsupported assumptions.

### Why location-level scatter analysis was used

Restaurant-level scatter plots become extremely dense with a dataset of
more than 139,000 listings. Location-level averages provide a clearer
business comparison.

### Price outliers

During dashboard development, extreme price values were identified. The
project keeps the source records but uses a documented dashboard-level
threshold for selected average-price visuals so that extreme values do
not dominate the comparison.

This is an analytical treatment, not a claim that every price above the
threshold is invalid.

------------------------------------------------------------------------

## Key findings used in the dashboard

-   Kanpur has 2,000 restaurant listings in the displayed dataset.
-   North Indian, Chinese has 6,589 listings and is the most represented
    cuisine category.
-   Pure-veg listings represent 41.99% of the cleaned dataset.
-   The ₹150--₹249 segment is the largest price segment in the
    dashboard.
-   Offer-level average ratings are close to one another in the
    displayed analysis.
-   The Page 2 cuisine table contains high-price/high-rating examples
    such as Grill, Greek; these should be described as results among the
    displayed/filter-selected rows, not as a universal ranking of all
    cuisines.

------------------------------------------------------------------------

## Limitations

1.  Public restaurant-listing data, not internal Swiggy transaction
    data.
2.  No order or revenue information.
3.  Rating-count values are lower-bound/band values, not exact review
    totals.
4.  No reliable listing date for monthly trend analysis.
5.  Some extreme price observations exist.
6.  Listing counts may reflect source collection limits.
7.  Cuisine combinations are retained as source categories.
8.  Offers and ratings are analyzed descriptively; the project does not
    establish causation.

------------------------------------------------------------------------

## Project structure

``` text
Swiggy_Restaurant_Market_Analytics/
├── 01_Raw_Data/
├── 02_SQL/
│   ├── 01_Data_Quality_Check.sql
│   ├── 02_Data_Cleaning.sql
│   ├── 03_Business_Analysis.sql
│   └── 01_SQL_Analysis_Original.sql
├── 03_Cleaned_Data/
├── 04_PowerBI/
│   └── Swiggy_Restaurant_Market_Analytics.pbix
├── 05_Dashboard/
├── 06_Documentation/
│   ├── README.md
│   ├── BUSINESS_REQUIREMENTS.md
│   └── INTERVIEW_GUIDE.md
└── 07_Insights/
    └── BUSINESS_INSIGHTS.md
```

The raw CSV and cleaned CSV are not included in this package because
they were not among the files supplied for this verification pass. Add
the actual files before publishing the repository if you want the GitHub
project to contain the data.
