# Business Requirements --- Swiggy Restaurant Market Analytics

## 1. Business Objective

Build an interactive restaurant-market analytics solution using public
Swiggy restaurant-listing data.

The solution should help a user understand:

-   where restaurant listings are concentrated
-   which cuisines are most represented
-   how listed prices vary
-   how ratings are distributed
-   pure-veg representation
-   offer patterns
-   location-level price/rating patterns
-   cuisine-level price/rating performance

This is descriptive market analysis, not internal Swiggy transaction
analysis.

------------------------------------------------------------------------

## 2. Source Data Requirements

The raw table contains:

  Field               Business use
  ------------------- -------------------------------
  restaurant_name     Identify listings
  cuisine             Cuisine analysis
  rating              Rating analysis
  number_of_ratings   Rating-count/engagement bands
  average_price       Listed price analysis
  number_of_offers    Offer analysis
  offer_name          Offer context
  area                Locality analysis
  pure_veg            Veg/non-veg analysis
  location            Location analysis

The SQL source creates this exact raw structure.
fileciteturn0file0L4-L14

------------------------------------------------------------------------

## 3. Data Quality Requirements

### NULL requirement

Check every source field for SQL NULL values.

Result:

**0 SQL NULL values.**

The SQL checks each field individually. fileciteturn0file0L24-L36

### Duplicate requirement

Identify exact duplicate records across all source columns.

Result:

**1,336 extra duplicate rows.**

The project calculates extra rows as `COUNT(*) - 1` for each duplicate
group. fileciteturn0file0L121-L150

### Duplicate-name requirement

Do not delete repeated restaurant names automatically because names are
not unique identifiers.

### Rating requirement

Convert valid numeric ratings to DECIMAL and exclude non-numeric labels
from numeric calculations.

### Rating-count requirement

Convert source bands to numeric lower-bound values where possible, while
documenting that they are not exact review totals.

### Price requirement

Extract numeric listed price from text such as `₹250 for two`.

------------------------------------------------------------------------

## 4. Cleaning Requirement

The cleaned table should:

1.  Remove exact duplicate rows.
2.  Keep legitimate repeated restaurant names.
3.  Convert ratings to numeric.
4.  Convert rating-count values to numeric lower bounds where possible.
5.  Convert listed price to numeric.
6.  Keep offers.
7.  Keep locations and areas.
8.  Keep pure-veg status.
9.  Keep original cuisine combinations.

The SQL implements these operations in the cleaned-table insert.
fileciteturn0file0L246-L296

Final cleaned row count:

**139,321**

------------------------------------------------------------------------

## 5. Business Questions

### Location

-   Which locations have the highest listing counts?
-   Which locations have higher average ratings?
-   Which locations have higher average listed prices?
-   How do average price and rating compare by location?

### Cuisine

-   Which cuisine categories have the most listings?
-   Which cuisines have higher average prices?
-   Which cuisines have higher average ratings?

### Rating

-   What is the average rating?
-   What is the rating distribution?
-   How many listings have rating \>= 4?
-   How many listings have rating = 5?

### Price

-   What is the average listed price for two?
-   Which price segment contains the most listings?
-   Which locations have higher average listed prices?
-   Which cuisines have higher average listed prices?

### Offers

-   How common are offers?
-   How does average rating vary by offer count?
-   How does average price vary by offer count?

The SQL contains the corresponding location, rating, price, offer and
cuisine analyses. fileciteturn0file0L328-L405
fileciteturn0file0L439-L520

------------------------------------------------------------------------

## 6. Page 1 Requirements --- Market Overview

### KPIs

-   Total Restaurant Listings
-   Total Locations
-   Average Rating
-   Average Listed Price
-   Total Cuisine Categories
-   Pure Veg %

### Filters

-   City/Location
-   Cuisine
-   Veg/Non-Veg
-   Price Segment

### Visuals

-   Top locations by restaurant listings
-   Top cuisines by restaurant listings
-   Rating distribution
-   Veg vs Non-Veg
-   Average price by city
-   Key insights

Purpose:

> Give the user a fast overview of the restaurant marketplace
> represented by the dataset.

------------------------------------------------------------------------

## 7. Page 2 Requirements --- Restaurants & Customer Insights

### KPIs

-   Average Rating
-   Rated Listings
-   Highly Rated Listings
-   Average Listed Price
-   5-Star Listings
-   Restaurants More Than 4 Offers

### Visuals

-   Average Price by Cuisine
-   Rating vs Average Price by Location
-   Offers vs Rating
-   Restaurant Listings by Price Segment
-   Top Cuisine table containing average price and average rating
-   Key insights

Purpose:

> Move from market overview into deeper pricing, rating, offer and
> cuisine analysis.

------------------------------------------------------------------------

## 8. Price Segment Requirement

Use business-friendly categories:

``` text
Under ₹150
₹150 - ₹249
₹250 - ₹349
₹350 - ₹499
₹500+
```

Reason:

A continuous price field contains many values. Segments make comparisons
easier.

------------------------------------------------------------------------

## 9. Rating Range Requirement

Use:

``` text
Below 2
2 - 2.9
3 - 3.9
4 - 4.4
4.5 - 5
Unknown
```

Reason:

Grouped ranges make the rating distribution easier to read.

------------------------------------------------------------------------

## 10. Offer Group Requirement

Use:

``` text
No Offers
1 Offer
2-3 Offers
4+ Offers
```

Reason:

Business users can understand offer intensity more easily than a long
list of individual offer counts.

------------------------------------------------------------------------

## 11. Outlier Requirement

During dashboard development, extreme price values were found.

The requirement is:

> Do not silently delete unusual values. Investigate them and document
> the treatment.

For selected dashboard average-price visuals, a threshold of
`average_price <= 1000` was used to prevent extreme values from
dominating the visualization.

The underlying cleaned records remain available.

------------------------------------------------------------------------

## 12. Integrity Rules

The dashboard must not:

-   claim listing count equals the complete number of restaurants in a
    city
-   call rating-count bands exact review counts
-   call listed price actual customer spending
-   claim offers cause ratings to increase
-   create a monthly trend without a date field
-   present an extreme-value threshold as proof that higher prices are
    invalid

------------------------------------------------------------------------

## 13. Success Criteria

The project is complete when:

-   Raw data is loaded.
-   Quality checks are documented.
-   Duplicate logic is documented.
-   Cleaning is reproducible.
-   Cleaned row count is validated.
-   SQL business analysis is available.
-   Power BI has two focused pages.
-   Filters work.
-   KPIs are understandable.
-   Business insights are supported by actual data.
-   Limitations are clearly documented.
