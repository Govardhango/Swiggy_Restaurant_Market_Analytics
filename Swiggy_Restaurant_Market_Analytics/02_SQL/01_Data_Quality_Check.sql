-- Swiggy Restaurant Market Analytics
-- Module 1: Data Quality Checks
-- Source: final project SQL provided for this portfolio project

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
