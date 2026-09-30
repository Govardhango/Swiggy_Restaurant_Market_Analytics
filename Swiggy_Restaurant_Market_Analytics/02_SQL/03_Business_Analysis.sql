-- Swiggy Restaurant Market Analytics
-- Module 3: Business Analysis
-- Source: final project SQL provided for this portfolio project

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
