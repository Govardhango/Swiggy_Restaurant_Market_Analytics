# Interview Guide --- Swiggy Restaurant Market Analytics

## 1. One-Minute Introduction

> "I built an end-to-end Swiggy Restaurant Market Analytics project
> using MySQL and Power BI. I used a publicly available Swiggy
> restaurant-listing dataset from Kaggle. The raw data had around
> 140,657 rows and contained restaurant names, cuisines, ratings,
> rating-count information, listed price, offers, area, pure-veg status
> and location.
>
> I first loaded the data into MySQL and performed data-quality checks
> for NULLs, duplicates and inconsistent formats. I found 1,336 extra
> exact duplicate rows. I cleaned rating values such as NEW and --,
> converted rating-count text such as 1K+ ratings into numeric
> lower-bound values, and converted price text such as ₹250 for two into
> numeric values.
>
> After cleaning, I had 139,321 rows. I then performed SQL analysis
> around locations, cuisines, ratings, prices, vegetarian status and
> offers.
>
> Finally, I connected the cleaned data to Power BI and built two pages:
> Market Overview and Restaurants & Customer Insights. The dashboard
> contains KPIs, filters, location and cuisine analysis, rating
> distribution, price analysis, offer analysis and business insights.
>
> One important limitation is that the dataset is public
> restaurant-listing data, not Swiggy's internal order or transaction
> database. Therefore, I focused on restaurant-market characteristics
> rather than revenue or customer transaction analysis."

------------------------------------------------------------------------

## 2. The Project in 30 Seconds

> "I analyzed a public Swiggy restaurant-listing dataset using MySQL and
> Power BI. I started with around 140,657 raw records, found 1,336 extra
> exact duplicate rows, cleaned ratings, rating-count bands and listed
> prices, and ended with 139,321 cleaned records. I then analyzed
> locations, cuisines, ratings, prices, pure-veg status and offers and
> built two interactive Power BI pages."

------------------------------------------------------------------------

## 3. Is This Official Swiggy Data?

Correct answer:

> "No. It is not official internal Swiggy data. It is publicly available
> data collected from Swiggy restaurant listings and published on
> Kaggle. I used it for analytical and portfolio purposes."

Never say:

> "I worked with Swiggy's internal database."

------------------------------------------------------------------------

## 4. What Was the Data Flow?

``` text
Raw CSV
 ↓
MySQL raw table
 ↓
Data quality checks
 ↓
Cleaning
 ↓
Cleaned table
 ↓
SQL business analysis
 ↓
Power BI
 ↓
Two dashboard pages
 ↓
Business insights
```

Say:

> "I first understood and validated the data, then cleaned it, analyzed
> it in SQL and finally visualized the results in Power BI."

------------------------------------------------------------------------

## 5. What Data Problems Did You Find?

> "There were no SQL NULL values, but there were exact duplicate rows
> and several fields stored in mixed formats. Ratings contained NEW and
> --, rating-count values included formats such as 1K+ ratings, and
> price was stored as text such as ₹250 for two."

The SQL source explicitly checks NULLs, duplicates, rating values and
price values. fileciteturn0file0L24-L36
fileciteturn0file0L104-L118

------------------------------------------------------------------------

## 6. How Many Duplicates?

> "There were 1,336 extra exact duplicate rows."

The SQL calculates this using duplicate count minus one for each
duplicate group. fileciteturn0file0L121-L150

------------------------------------------------------------------------

## 7. Why Didn't You Remove Duplicate Restaurant Names?

> "Because restaurant name is not a unique identifier. The same name can
> appear in different locations. I removed only exact duplicate records
> across all source fields."

------------------------------------------------------------------------

## 8. How Did You Clean Ratings?

> "I converted valid numeric ratings to DECIMAL and changed NEW and --
> to NULL so they would not affect numeric averages."

The conversion is explicitly tested in the SQL.
fileciteturn0file0L192-L200

------------------------------------------------------------------------

## 9. How Did You Handle Number of Ratings?

> "The source uses lower-bound formats such as 10+, 100+, 1K+ and 5K+. I
> converted these to numeric lower-bound values for grouping and
> analysis, but I did not treat them as exact review counts."

The SQL conversion logic is documented in the project file.
fileciteturn0file0L203-L218

------------------------------------------------------------------------

## 10. Why Not Call It Total Reviews?

> "Because 1K+ is not exactly 1,000. It represents a lower bound.
> Calling the sum an exact review total would be misleading."

------------------------------------------------------------------------

## 11. How Did You Clean Price?

> "The raw price was text such as ₹250 for two. I extracted the numeric
> portion and converted it to an integer."

The SQL performs this extraction before creating the cleaned data.
fileciteturn0file0L221-L232

------------------------------------------------------------------------

## 12. Why Did the Row Count Change?

> "The raw data had 140,657 rows. There were 1,336 extra exact duplicate
> rows. After removing those, the cleaned dataset had 139,321 rows."

``` text
140,657 - 1,336 = 139,321
```

The cleaned-table insert uses `SELECT DISTINCT`.
fileciteturn0file0L246-L296

------------------------------------------------------------------------

## 13. What Was the Price Outlier Issue?

> "While building the dashboard, an extreme price value appeared around
> ₹199,246. I investigated the source rather than immediately deleting
> it. There were also other high-price observations."

Then:

> "For selected average-price visuals I used a documented
> dashboard-level threshold of ₹1,000. I kept the source records in the
> cleaned dataset."

------------------------------------------------------------------------

## 14. Why Investigate Instead of Delete?

> "An unusual value is not automatically an error. I wanted to
> understand the value before changing the data."

------------------------------------------------------------------------

## 15. Explain Page 1

> "Page 1 is the Market Overview. It gives a quick summary of restaurant
> listings, locations, cuisines, ratings, pure-veg share and listed
> prices. Filters allow the user to focus on a specific location,
> cuisine, veg status or price segment."

------------------------------------------------------------------------

## 16. Explain Page 2

> "Page 2 goes deeper into pricing, ratings, offers and cuisine
> performance. It includes average price by cuisine, location-level
> rating versus price, offers versus rating, price-segment distribution
> and a cuisine price/rating table."

------------------------------------------------------------------------

## 17. Why Two Pages?

> "The first page answers high-level market questions. The second page
> focuses on deeper analytical patterns. This keeps the dashboard
> focused rather than overcrowded."

------------------------------------------------------------------------

## 18. Why Did You Not Build a Monthly Trend?

> "The dataset does not contain a reliable listing-date field. I did not
> create a fake January-to-December trend because that would require
> unsupported assumptions."

------------------------------------------------------------------------

## 19. Why Did the Scatter Plot Need to Change?

> "The first restaurant-level scatter plot was too dense because the
> dataset has more than 139,000 listings. I changed the analysis to
> location-level averages, which made the comparison more readable."

------------------------------------------------------------------------

## 20. What Does Rating vs Price Show?

> "It compares average listed price for two with average rating at the
> location level. It is descriptive; it does not prove that higher
> prices cause higher ratings."

------------------------------------------------------------------------

## 21. What Does Offers vs Rating Show?

> "It compares average rating across offer levels. The displayed average
> ratings are close to one another, around 4.01 to 4.06, so I describe
> the differences as small rather than claiming that offers improve
> ratings."

------------------------------------------------------------------------

## 22. Measure vs Calculated Column

### Calculated column

> "A calculated column is calculated row by row and becomes part of the
> table."

Example:

**Price Segment**

### Measure

> "A measure is calculated dynamically based on the current filter
> context."

Example:

**Average Rating**

------------------------------------------------------------------------

## 23. Why Create Price Segment?

> "There are many different raw price values. Grouping them into Under
> ₹150, ₹150--₹249, ₹250--₹349, ₹350--₹499 and ₹500+ makes the
> distribution easier to understand."

------------------------------------------------------------------------

## 24. Why Create Rating Range?

> "The raw ratings were grouped into readable ranges so the rating
> distribution would be easier to interpret."

------------------------------------------------------------------------

## 25. Explain Filter Context

> "Power BI measures are recalculated according to the current filter
> context. If I select Pure Veg = Yes, the visuals use only the selected
> listings."

If a percentage becomes 100% after selecting Yes:

> "That is expected because the selected dataset contains only Pure Veg
> = Yes records."

------------------------------------------------------------------------

## 26. Main Insights

Use wording such as:

> "Kanpur has 2,000 restaurant listings in the displayed dataset."

> "North Indian, Chinese has 6,589 listings and is the most represented
> cuisine category."

> "The ₹150--₹249 segment contains the largest number of listings."

> "Offer-level average ratings are close to one another in the displayed
> analysis."

For a cuisine table:

> "Grill, Greek is one of the high-rating/high-price examples shown in
> the selected table."

Avoid turning a filtered/top-N visual into a claim about every cuisine
in the dataset.

------------------------------------------------------------------------

## 27. Dataset Limitations

> "The dataset is public restaurant-listing data, not Swiggy's internal
> transactional data. Therefore I cannot calculate actual revenue,
> orders, customer lifetime value, delivery performance or actual
> customer spending."

Also mention:

-   rating-count values are approximate lower bounds
-   no reliable listing date
-   some extreme price observations
-   listing counts may reflect collection limits
-   cuisine combinations are retained as source categories

------------------------------------------------------------------------

## 28. What Would You Do With More Data?

> "If I had order-level and customer-level data, I would analyze
> revenue, order trends, repeat customers, customer value,
> cancellations, delivery time and retention. With reliable dates I
> would also build time-based analysis."

------------------------------------------------------------------------

## 29. SQL Questions

### How did you find duplicates?

> "I grouped by all source columns, filtered groups with COUNT greater
> than 1 and calculated extra rows as COUNT minus one."

### Why not GROUP BY restaurant_name?

> "Because restaurant name is not unique."

### Why use DECIMAL for rating?

> "Ratings contain decimal values such as 4.5."

### Why use INT for price?

> "After cleaning, the listed price is a whole-number value."

### Why use SELECT DISTINCT?

> "To remove exact duplicate records while retaining legitimate repeated
> restaurant names."

------------------------------------------------------------------------

## 30. Strong Closing Statement

> "This project demonstrates the complete Data Analyst workflow. I
> started with raw marketplace data, identified quality problems, made
> cleaning decisions, validated the cleaned data, performed business
> analysis in SQL, created Power BI measures and dashboards, and
> converted the results into business-friendly insights. My main focus
> was making sure that every insight was supported by the available data
> and that limitations were clearly documented."

------------------------------------------------------------------------

## 31. Presentation Order

Use this order in an interview:

``` text
1. Business Problem
2. Dataset
3. Data Quality Problems
4. Cleaning Approach
5. SQL Analysis
6. Power BI Dashboard
7. Key Insights
8. Limitations
9. Future Improvements
```
