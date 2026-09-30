-- Swiggy Restaurant Market Analytics
-- Module 2: Data Cleaning
-- Source: final project SQL provided for this portfolio project

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
