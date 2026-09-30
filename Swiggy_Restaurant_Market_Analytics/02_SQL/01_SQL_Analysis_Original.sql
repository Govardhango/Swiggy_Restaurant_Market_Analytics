CREATE DATABASE swiggy_restaurant_analytics;
USE swiggy_restaurant_analytics;

CREATE TABLE swiggy_raw (
    restaurant_name VARCHAR(255),
    cuisine VARCHAR(500),
    rating VARCHAR(50),
    number_of_ratings VARCHAR(50),
    average_price VARCHAR(100),
    number_of_offers INT,
    offer_name TEXT,
    area VARCHAR(255),
    pure_veg VARCHAR(20),
    location VARCHAR(255)
);

SELECT COUNT(*) AS total_rows
FROM swiggy_raw;

DESCRIBE swiggy_raw;

SELECT * FROM swiggy_raw LIMIT 10;

-- Check NULL values
SELECT
    COUNT(*) AS total_rows,
    SUM(restaurant_name IS NULL) AS missing_restaurant_name,
    SUM(cuisine IS NULL) AS missing_cuisine,
    SUM(rating IS NULL) AS missing_rating,
    SUM(number_of_ratings IS NULL) AS missing_number_of_ratings,
    SUM(average_price IS NULL) AS missing_average_price,
    SUM(number_of_offers IS NULL) AS missing_number_of_offers,
    SUM(offer_name IS NULL) AS missing_offer_name,
    SUM(area IS NULL) AS missing_area,
    SUM(pure_veg IS NULL) AS missing_pure_veg,
    SUM(location IS NULL) AS missing_location
FROM swiggy_raw;

-- Check duplicate rows
SELECT
    restaurant_name,
    cuisine,
    rating,
    number_of_ratings,
    average_price,
    number_of_offers,
    offer_name,
    area,
    pure_veg,
    location,
    COUNT(*) AS duplicate_count
FROM swiggy_raw
GROUP BY
    restaurant_name,
    cuisine,
    rating,
    number_of_ratings,
    average_price,
    number_of_offers,
    offer_name,
    area,
    pure_veg,
    location
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Check distinct restaurants
SELECT
    COUNT(DISTINCT restaurant_name) AS unique_restaurants
FROM swiggy_raw;

-- Check cities/locations
SELECT
    COUNT(DISTINCT location) AS unique_locations
FROM swiggy_raw;

-- This will show us the locations with the most records.
SELECT
    location,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY location
ORDER BY record_count DESC
LIMIT 20;

-- Check cuisine values cuisine can contain combinations Pizzas-Pastas Chinese-Asian

SELECT
    cuisine,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY cuisine
ORDER BY record_count DESC
LIMIT 20;

-- Check Pure Veg values
SELECT
    pure_veg,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY pure_veg
ORDER BY record_count DESC;

-- Check Rating values
SELECT
    rating,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY rating
ORDER BY record_count DESC;

-- Check price values
SELECT
    average_price,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY average_price
ORDER BY record_count DESC
LIMIT 30;

-- calculates the actual number of extra duplicate rows.
SELECT
    SUM(duplicate_count - 1) AS extra_duplicate_rows
FROM (
    SELECT
        restaurant_name,
        cuisine,
        rating,
        number_of_ratings,
        average_price,
        number_of_offers,
        offer_name,
        area,
        pure_veg,
        location,
        COUNT(*) AS duplicate_count
    FROM swiggy_raw
    GROUP BY
        restaurant_name,
        cuisine,
        rating,
        number_of_ratings,
        average_price,
        number_of_offers,
        offer_name,
        area,
        pure_veg,
        location
    HAVING COUNT(*) > 1
) AS duplicate_groups;


-- investigate restaurant duplicates
SELECT
    restaurant_name,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY restaurant_name
HAVING COUNT(*) > 1
ORDER BY record_count DESC
LIMIT 20;

SELECT *
FROM swiggy_raw
WHERE restaurant_name = 'Kwality Walls Frozen Dessert And Ice Cream Shop';

-- number_of_ratings
SELECT
    number_of_ratings,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY number_of_ratings
ORDER BY record_count DESC
LIMIT 30;


-- let's check the area/location quality.
SELECT
    location,
    COUNT(*) AS record_count
FROM swiggy_raw
GROUP BY location
ORDER BY record_count DESC
LIMIT 30;

-- Create the cleaned table
CREATE TABLE swiggy_cleaned AS
SELECT *
FROM swiggy_raw
WHERE 1 = 0;

-- let's first check how MySQL will convert the rating values.
SELECT
    rating,
    CASE
        WHEN rating REGEXP '^[0-9]+(\\.[0-9]+)?$'
        THEN CAST(rating AS DECIMAL(2,1))
        ELSE NULL
    END AS rating_numeric
FROM swiggy_raw
LIMIT 30;

-- Check number_of_ratings we'll convert values 100+ ratings → 100,1K+ ratings → 1000
SELECT
    number_of_ratings,
    CASE
        WHEN number_of_ratings REGEXP '^[0-9]+ ratings$'
            THEN CAST(REPLACE(number_of_ratings, ' ratings', '') AS UNSIGNED)

        WHEN number_of_ratings REGEXP '^[0-9]+K\\+ ratings$'
            THEN CAST(REPLACE(REPLACE(number_of_ratings, 'K+ ratings', ''), ' ', '') AS UNSIGNED) * 1000

        WHEN number_of_ratings REGEXP '^[0-9]+\\+ ratings$'
            THEN CAST(REPLACE(REPLACE(number_of_ratings, '+ ratings', ''), ' ', '') AS UNSIGNED)

        ELSE NULL
    END AS number_of_ratings_numeric
FROM swiggy_raw
LIMIT 30;

-- Check average_price we'll convert values  ₹250 for two → 250,₹1,000 for two → 1000
-- Since the price always contains the numeric value before " for two", we can extract the digits only and avoid the rupee-symbol problem completely.
SELECT
    average_price,
    CAST(
        REGEXP_REPLACE(
            SUBSTRING_INDEX(average_price, ' for two', 1),
            '[^0-9]',
            ''
        ) AS UNSIGNED
    ) AS average_price_numeric
FROM swiggy_raw
LIMIT 30;

/*
Next step: actually create the cleaned data

We will now populate swiggy_cleaned while:

removing the 1,336 exact duplicate rows
converting the three fields
keeping all other columns unchanged

This is the first actual cleaning operation.
*/
INSERT INTO swiggy_cleaned
SELECT DISTINCT
    restaurant_name,
    cuisine,

    CASE
        WHEN rating REGEXP '^[0-9]+(\\.[0-9]+)?$'
        THEN CAST(rating AS DECIMAL(2,1))
        ELSE NULL
    END AS rating,

    CASE
        WHEN number_of_ratings REGEXP '^[0-9]+ ratings$'
            THEN CAST(REPLACE(number_of_ratings, ' ratings', '') AS UNSIGNED)

        WHEN number_of_ratings REGEXP '^[0-9]+K\\+ ratings$'
            THEN CAST(
                REPLACE(
                    REPLACE(number_of_ratings, 'K+ ratings', ''),
                    ' ',
                    ''
                ) AS UNSIGNED
            ) * 1000

        WHEN number_of_ratings REGEXP '^[0-9]+\\+ ratings$'
            THEN CAST(
                REPLACE(
                    REPLACE(number_of_ratings, '+ ratings', ''),
                    ' ',
                    ''
                ) AS UNSIGNED
            )

        ELSE NULL
    END AS number_of_ratings,

    CAST(
        REGEXP_REPLACE(
            SUBSTRING_INDEX(average_price, ' for two', 1),
            '[^0-9]',
            ''
        ) AS UNSIGNED
    ) AS average_price,

    number_of_offers,
    offer_name,
    area,
    pure_veg,
    location

FROM swiggy_raw;


SELECT COUNT(*) AS cleaned_rows
FROM swiggy_cleaned;

-- Verify the cleaned table: Before moving forward, let's make sure the important fields were actually cleaned.
SELECT
    COUNT(*) AS total_rows,
    COUNT(rating) AS valid_ratings,
    COUNT(number_of_ratings) AS valid_rating_counts,
    COUNT(average_price) AS valid_prices
FROM swiggy_cleaned;

-- Final cleaning verification : Now let's make sure there are zero exact duplicates remaining in the cleaned table.
SELECT
    COUNT(*) - COUNT(DISTINCT
        CONCAT_WS('|',
            restaurant_name,
            cuisine,
            rating,
            number_of_ratings,
            average_price,
            number_of_offers,
            offer_name,
            area,
            pure_veg,
            location
        )
    ) AS remaining_duplicate_rows
FROM swiggy_cleaned;

-- Business Analysis SQL
-- Business Question 1: Which cities have the most restaurants?
SELECT
    location,
    COUNT(*) AS restaurant_count
FROM swiggy_cleaned
GROUP BY location
ORDER BY restaurant_count DESC
LIMIT 10;

-- Business Question 2 — Which cuisines have the most listings?
SELECT
    cuisine,
    COUNT(*) AS listing_count
FROM swiggy_cleaned
GROUP BY cuisine
ORDER BY listing_count DESC
LIMIT 10;

-- Business Question 3 — Average rating by location
-- Which locations have the highest average restaurant rating among locations with at least 100 rated listings?
SELECT
    location,
    COUNT(*) AS rated_listings,
    ROUND(AVG(rating), 2) AS average_rating
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY location
HAVING COUNT(*) >= 100
ORDER BY average_rating DESC
LIMIT 10;

-- Business Question 4 — Average price by location
SELECT
    location,
    COUNT(*) AS listing_count,
    ROUND(AVG(average_price), 0) AS avg_price
FROM swiggy_cleaned
GROUP BY location
HAVING COUNT(*) >= 100
ORDER BY avg_price DESC
LIMIT 10;

-- Business Question 5 — Pure Veg vs Non-Veg
SELECT
    pure_veg,
    COUNT(*) AS listing_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM swiggy_cleaned),
        2
    ) AS percentage
FROM swiggy_cleaned
GROUP BY pure_veg
ORDER BY listing_count DESC;

-- Business Question 6 — Rating distribution
SELECT
    rating,
    COUNT(*) AS listing_count
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;

-- Business Question 7 — Average rating vs average price
-- see whether locations with higher average prices also have higher average ratings.
SELECT
    location,
    COUNT(*) AS rated_listings,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(average_price), 0) AS avg_price
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY location
HAVING COUNT(*) >= 100
ORDER BY avg_rating DESC
LIMIT 20;

-- Business Question 8 — Which restaurants have the highest customer engagement?
SELECT
    restaurant_name,
    location,
    rating,
    number_of_ratings,
    average_price
FROM swiggy_cleaned
WHERE number_of_ratings IS NOT NULL
ORDER BY number_of_ratings DESC
LIMIT 20;

ALTER TABLE swiggy_cleaned MODIFY rating DECIMAL(2,1);

ALTER TABLE swiggy_cleaned MODIFY number_of_ratings INT;

ALTER TABLE swiggy_cleaned MODIFY average_price INT;

DESCRIBE swiggy_cleaned;

-- Rather than showing 20 restaurants all tied at 10,000, let's find restaurants with the highest rating-count bands and their ratings/prices.
SELECT
    restaurant_name,
    location,
    rating,
    number_of_ratings,
    average_price
FROM swiggy_cleaned
WHERE number_of_ratings >= 5000
ORDER BY number_of_ratings DESC, rating DESC
LIMIT 20;

-- Business Question 9 — Rating-count bands Let's calculate them directly from the cleaned numeric field.
SELECT
    CASE
        WHEN number_of_ratings >= 10000 THEN '10K+'
        WHEN number_of_ratings >= 5000 THEN '5K+'
        WHEN number_of_ratings >= 1000 THEN '1K+'
        WHEN number_of_ratings >= 500 THEN '500+'
        WHEN number_of_ratings >= 100 THEN '100+'
        WHEN number_of_ratings >= 50 THEN '50+'
        WHEN number_of_ratings >= 20 THEN '20+'
        WHEN number_of_ratings >= 10 THEN '10+'
        ELSE 'Below 10'
    END AS rating_band,
    COUNT(*) AS listing_count
FROM swiggy_cleaned
WHERE number_of_ratings IS NOT NULL
GROUP BY rating_band
ORDER BY
    CASE rating_band
        WHEN '10K+' THEN 1
        WHEN '5K+' THEN 2
        WHEN '1K+' THEN 3
        WHEN '500+' THEN 4
        WHEN '100+' THEN 5
        WHEN '50+' THEN 6
        WHEN '20+' THEN 7
        WHEN '10+' THEN 8
        WHEN 'Below 10' THEN 9
    END;
    
-- business question — offers Your dataset has number_of_offers, so let's see whether restaurants commonly have offers.
    SELECT
    CASE
        WHEN number_of_offers = 0 THEN 'No Offers'
        WHEN number_of_offers = 1 THEN '1 Offer'
        WHEN number_of_offers BETWEEN 2 AND 3 THEN '2-3 Offers'
        WHEN number_of_offers >= 4 THEN '4+ Offers'
    END AS offer_band,
    COUNT(*) AS listing_count
FROM swiggy_cleaned
GROUP BY offer_band
ORDER BY
    CASE offer_band
        WHEN 'No Offers' THEN 1
        WHEN '1 Offer' THEN 2
        WHEN '2-3 Offers' THEN 3
        WHEN '4+ Offers' THEN 4
    END;
    
-- Business Question 10 — Do restaurants with more offers have higher ratings?
    SELECT
    CASE
        WHEN number_of_offers = 0 THEN 'No Offers'
        WHEN number_of_offers = 1 THEN '1 Offer'
        WHEN number_of_offers BETWEEN 2 AND 3 THEN '2-3 Offers'
        WHEN number_of_offers >= 4 THEN '4+ Offers'
    END AS offer_band,
    COUNT(rating) AS rated_listings,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(AVG(average_price), 0) AS average_price
FROM swiggy_cleaned
GROUP BY offer_band
ORDER BY
    CASE offer_band
        WHEN 'No Offers' THEN 1
        WHEN '1 Offer' THEN 2
        WHEN '2-3 Offers' THEN 3
        WHEN '4+ Offers' THEN 4
    END;
    
-- One more important analysis: cuisine + rating
-- Let's find which cuisine categories have the highest average ratings, while requiring enough listings to avoid tiny samples.
SELECT
    cuisine,
    COUNT(rating) AS rated_listings,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(AVG(average_price), 0) AS average_price
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY cuisine
HAVING COUNT(rating) >= 100
ORDER BY average_rating DESC
LIMIT 15;

-- query for the Rating vs Price analysis using the full location-level dataset rather than only the top 20 locations.
SELECT
    location,
    COUNT(rating) AS rated_listings,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(AVG(average_price), 0) AS average_price
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY location
HAVING COUNT(rating) >= 100
ORDER BY location;