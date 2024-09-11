#MONDAY
#09 September 2024

#Project 1
# Zomato Data Analysis

-- In this Zomato data analysis project, we aim to explore and 
-- derive insights from a dataset comprising restaurant information, 
-- including details such as location, cuisine, pricing, 
-- and customer reviews. We will examine factors influencing 
-- restaurant popularity, assess the relationship between 
-- price and customer ratings, and investigate the prevalence 
-- of services like online delivery and table booking. 
--  The project seeks to provide valuable insights into the restaurant 
--  industry and enhance decision-making for both customers and 
--  restaurateurs






-- task-1 import data

CREATE DATABASE project1;
USE project1;

SHOW tables;

DESC rest_data;
DESC country_data;

--  Description of the dataset:

-- RestaurantID: A unique identifier for each restaurant in the dataset.

-- RestaurantName: The name of the restaurant.

-- CountryCode: A code indicating the country where the restaurant 
-- is located.

-- City: The city in which the restaurant is situated.

-- Address: The specific address of the restaurant.

-- Locality: The locality (neighborhood or district) where the restaurant 
-- is located.

-- LocalityVerbose: A more detailed description or name of the locality.

-- Longitude: The geographical longitude coordinate of the restaurant's 
-- location.

-- Latitude: The geographical latitude coordinate of the restaurant's 
-- location.

-- Cuisines: The types of cuisines or food offerings available at the 
-- restaurant. This may include multiple cuisines separated by commas.

-- Currency: The currency used for pricing in the restaurant.

-- Has_Table_booking: A binary indicator (0 or 1) that shows whether 
-- the restaurant offers table booking.

-- Has_Online_delivery: A binary indicator (0 or 1) that shows 
-- whether the restaurant provides online delivery services.

-- Is_delivering_now: A binary indicator (0 or 1) that indicates 
-- whether the restaurant is currently delivering food.

-- Switch_to_order_menu: A field that might suggest whether customers 
-- can switch to an online menu to place orders.

-- Price_range: A rating or category that indicates the price 
-- range of the restaurant's offerings (e.g., low, medium, high).

-- Votes: The number of votes or reviews that the restaurant has received.

-- Average_Cost_for_two: The average cost for two people to dine 
-- at the restaurant, often used as a measure of affordability.

-- Rating: The rating of the restaurant, possibly on a scale 
-- from 0 to 5 or a similar rating system.

-- Datekey_Opening: The date or key representing the restaurant's 
-- opening date.

SELECT * FROM rest_data;
SELECT * FROM country_data;






-- task-2 Data Cleaning

-- Country_data>>>Country_name>>>Country_name

SELECT `country name` FROM country_data;

ALTER TABLE country_data
CHANGE COLUMN `country name` countryname TEXT;

DESC country_data;

-- datekey_opening
SELECT datekey_opening FROM rest_data;

SET SQL_SAFE_UPDATES =0;

UPDATE rest_data SET datekey_opening=replace(Datekey_opening,"_","/");
SELECT Datekey_opening FROM rest_data;

ALTER TABLE rest_data
MODIFY COLUMN Datekey_opening DATE;

SET SQL_SAFE_UPDATES =1;





-- Task-3
-- check unique value from categorical column

SELECT DISTINCT countrycode FROM rest_data;
SELECT DISTINCT Has_Table_booking FROM rest_data;
SELECT DISTINCT Has_Online_delivery FROM rest_data;
SELECT DISTINCT price_range FROM rest_data;
SELECT DISTINCT Rating FROM rest_data;
SELECT DISTINCT Is_delivering_now FROM rest_data;




-- Task-4 number of restaurent

SELECT count(RestaurantID) FROM rest_data;
#total data available for 9552 restaurants


#Tuesday
#10 September 2024
USE project1;

-- task-5 country count

SELECT count(DISTINCT countrycode) FROM rest_data;

#total 15 countries data available



-- Task-6 country name
SELECT countryname FROM country_data;

SELECT DISTINCT c1.countryname
FROM rest_data r1 INNER JOIN country_data c1
ON r1.countrycode = c1.countryID;



-- Task-7 countrywise count of restaurents(percentage)
SELECT c1.countryname,count(*)/(SELECT count(*) FROM rest_data)*100 total_count
FROM rest_data r1 INNER JOIN country_data c1
ON r1.countrycode = c1.countryID
GROUP BY c1.countryname
ORDER BY total_count DESC; 

-- 90 % of restaurents are from india

SELECT * FROM rest_data;
SELECT * FROM country_data;



-- Task-8 Percentage of Restaurents based on "Has_Online_delivery"

SELECT Has_online_delivery,count(*)/(SELECT count(*) FROM rest_data)*100 total
FROM rest_data
GROUP BY Has_online_delivery;

# 74% restaurents has no online delivery option 



-- Task-9 Percentage of Restaurents based on "Has_Table_booking"

SELECT Has_Table_booking,count(*)/(SELECT count(*) FROM rest_data)*100 total
FROM rest_data
GROUP BY Has_Table_booking;

# 87%  restaurents has no table booking option
#just 13% restaurents has table booking system



-- Task-10 Top 5 restaurents who has more number of votes

SELECT RestaurantName,votes
FROM rest_data
ORDER BY votes DESC
limit 5;

SELECT DISTINCT r1.restaurantname,c1.countryname,r1.votes
FROM rest_data r1 INNER JOIN country_data c1
ON r1.countrycode = c1.countryID
ORDER by r1.votes DESC
LIMIT 5;



-- Task-11 Top 5 restaurents who has more number of votes in India

SELECT DISTINCT r1.restaurantname,c1.countryname,r1.votes
FROM rest_data r1 INNER JOIN country_data c1
ON r1.countrycode = c1.countryID
WHERE c1.countryname ="India"
ORDER by r1.votes DESC
LIMIT 5;


-- Task-12 find most common cuisines in dataset


SELECT cuisines,count(*) total
FROM rest_data
GROUP BY cuisines
ORDER BY total DESC;

# North Indian is common cuisines in dataset



-- Task-13 number of restaurent opening based on Year,Month,Quarter

-- year
SELECT year(datekey_opening)year,count(*) total
FROM rest_data
GROUP BY year(datekey_opening)
ORDER BY year ASC;

SELECT monthname(datekey_opening)monthname,count(*) total
FROM rest_data
GROUP BY monthname(datekey_opening),month(datekey_opening)
ORDER BY month(datekey_opening);

SELECT monthname(datekey_opening)monthname,count(*) total
FROM rest_data
WHERE year(datekey_opening)="2018"
GROUP BY monthname(datekey_opening),month(datekey_opening)
ORDER BY month(datekey_opening);

SELECT concat("Q",quarter(datekey_opening))myQuarter,count(*) total
FROM rest_data
GROUP BY concat("Q",quarter(datekey_opening))
ORDER BY total DESC;

# Most Of The Restaurants opened in 2018


-- Task-14 Find The city with highest average cost for two peoples in india (expensive)

SELECT r1.city,avg(average_cost_for_two) avg
FROM rest_data r1
INNER JOIN country_data c1
on r1.countrycode = c1.countryid
WHERE C1.countryname="India"
GROUP BY r1.city
ORDER BY avg DESC
LIMIT 3;

-- panchkula
-- hyderabad
-- pune

-- Task-15 highest voting restaurents in each country
-- window function

#WEDNESDAY
#11 September 2024

WITH cte1 AS (SELECT c1.countryname,r1.restaurantname,r1.votes,
ROW_NUMBER() OVER (partition by c1.countryname order by r1.votes DESC) rn
FROM
rest_data r1 INNER JOIN country_data c1
ON r1.countrycode=c1.countryid)
SELECT * FROM cte1 WHERE rn=1;

SELECT * FROM rest_data;
SELECT * FROM country_data;


-- Task-16 meaning of price range category

SELECT DISTINCT price_range FROM rest_data;

SELECT price_range,min(average_cost_for_two)MIN,max(average_cost_for_two)MAX
FROM rest_data
group by price_range;

-- 1  0    450 >> cheap D
-- 2 15   70000 >> Expensive B
-- 3 30   800000 >> most expensive A
-- 4 50   000 >> moderate C


ALTER TABLE rest_data
ADD COLUMN status VARCHAR(40);

SELECT * FROM rest_data;

SET SQL_SAFE_UPDATES=0;

UPDATE rest_data SET status =
case when price_range=3 then "Most Expensive"
WHEN price_range=2 then "expensive"
WHEN price_range=1 then "Cheap"
WHEN price_range=4 then "Moderate"
END;

SET SQL_SAFE_UPDATES=1;

SELECT * FROM rest_data;



-- Task-17  Find count of restaurants by the countries where the majority of restaurents 
-- offer online delivery and table booking.

SELECT c1.countryname,count(*) total
FROM
rest_data r1 INNER JOIN country_data c1
ON r1.countrycode = c1.countryid
WHERE r1.Has_Online_delivery='YES' AND r1.Has_Table_booking='YES'
group by c1.countryname;


-- Task-18 fetch rest where name of character >> 15 character

SELECT RestaurantName,length(RestaurantName)
FROM rest_data
WHERE length(RestaurantName)>15;

-- Task-19 avg_cost >1000 'GOOD' otherwise 'BAD'

SELECT Average_cost_for_two ,if(Average_cost_for_two>1000,'GOOD','BAD')
FROM rest_data;



-- Task-20  Find restaurent that are currently delivering 

SELECT RestaurantName,city,is_delivering_now
FROM rest_data
WHERE is_delivering_now='yes';



-- Task-21 highest rating restaurent in each country

SELECT * FROM rest_data;
SELECT * FROM country_data;


WITH cte1 AS (SELECT c1.countryname,r1.restaurantname,r1.Rating,
ROW_NUMBER() OVER (partition by c1.countryname order by r1.Rating DESC) rn
FROM
rest_data r1 INNER JOIN country_data c1
ON r1.countrycode=c1.countryid)
SELECT * FROM cte1 WHERE rn=1;
