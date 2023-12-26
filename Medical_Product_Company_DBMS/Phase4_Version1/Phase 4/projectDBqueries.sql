-- Query1
--Reports for the optimal product and optimal concentration in terms of most sold/profit?
-- used 4 tables groupBy, join , orderby , over
WITH ProductConcentrationSales AS (
    SELECT
        m.productID,
        m.m_location,
        m.box_size,
        m.box_color,
        pc.compoundingID,
        pc.p_date,
        r.sales_price,
        r.num_sold,
        TO_NUMBER(r.num_sold) * TO_NUMBER(r.sales_price) AS total_profit
    FROM
        F23_S003_T7_Manufacturing m
        JOIN F23_S003_T7_To_Be_Packaged pc ON m.productID = pc.productID
        JOIN F23_S003_T7_Retail r ON m.productID = r.productID
)
, ProductConcentrationSummary AS (
    SELECT
        productID,
        m_location,
        box_size,
        box_color,
        compoundingID,
        p_date,
        SUM(num_sold) AS total_quantity_sold,
        SUM(total_profit) AS total_profit
    FROM
        ProductConcentrationSales
    GROUP BY
        productID,
        m_location,
        box_size,
        box_color,
        compoundingID,
        p_date
)
, RankedProducts AS (
    SELECT
        productID,
        m_location,
        box_size,
        box_color,
        compoundingID,
        p_date,
        total_quantity_sold,
        total_profit,
        RANK() OVER (PARTITION BY productID ORDER BY total_quantity_sold DESC, total_profit DESC) AS rank
    FROM
        ProductConcentrationSummary
)
SELECT
    r.productID,
    r.m_location,
    r.box_size,
    r.box_color,
    r.compoundingID,
    r.p_date,
    r.total_quantity_sold,
    r.total_profit,
    c.concentration,
    c.product_Name
FROM
    RankedProducts r, F23_S003_T7_Compounding c
WHERE
    rank = 1 and r.compoundingID=c.compoundingID;
	
--Output:	
-- PRODUCTID  M_LOCATION      BOX_S BOX_COLOR                      COMPOUNDIN P_DATE     TOTAL_QUANTITY_SOLD TOTAL_PROFIT CONCE PRODUCT_NAME
-- ---------- --------------- ----- ------------------------------ ---------- ---------- ------------------- ------------ ----- ---------------
-- 10101      Dallas          Fit   Bright Green                   3350       03-05-2023                 100         1210 2     Zaditor
-- 10102      Fort Worth      Fit   Bright Green                   3351       03-05-2023                 200         3000 2     Zaditor
-- 10103      Austin          Fit   Bright Green                   3353       03-05-2023                  75       918.75 2     Zaditor
-- 10104      Houston         Large Purple                         3354       03-05-2023                 150       3148.5 2     Zaditor
-- 10105      Sacremento      Fit   Bright Green                   3355       03-05-2023                  65         1365 5     zaditor
-- 10106      Fort Worth      Large Purple                         3356       03-05-2023                  90       2789.1 5     Zaditor
-- 10107      Houston         Fit   Bright Green                   3357       03-05-2023                 225       2812.5 5     Zaditor
-- 10108      Sacremento      Large Purple                         3358       03-05-2023                  70       1119.3 5     Zaditor
-- 10109      Dallas          Fit   Bright Green                   3359       03-05-2023                 750       7492.5 5     Zaditor

--9 rows selected.


-- Query 2
--	The manufacturing site and marketing technique with most output (product produced) and number of production delays?
-- used orderby and fetchby to get the interestng output
SELECT
    m.m_location,
    sm.marketing_technique,
    SUM(TO_NUMBER(m.quantity_of_output)) AS total_output,
    SUM(TO_NUMBER(m.no_of_delays)) AS total_delays
FROM
    F23_S003_T7_Manufacturing m
    JOIN F23_S003_T7_Sales_Marketing sm ON m.sales_prodID = sm.sales_productID
GROUP BY
    m.m_location, sm.marketing_technique
ORDER BY
    total_output DESC, total_delays DESC
FETCH FIRST 1 ROWS ONLY;


--Output:
-- M_LOCATION      MARKETING_TECHNIQUE       TOTAL_OUTPUT TOTAL_DELAYS
-- --------------- ------------------------- ------------ ------------
-- Sacremento      Google Ads                       74000            2


-- Query 3
--Out of different packaging designs, record which is the most bought/sold from its counterparts.
-- used groupby and having clasue
SELECT
    m.box_size,
    m.box_color,
    SUM(TO_NUMBER(r.num_sold)) AS total_quantity_sold
FROM
    F23_S003_T7_Manufacturing m
    JOIN F23_S003_T7_Retail r ON m.productID = r.productID
GROUP BY
    m.box_size,
    m.box_color
HAVING
    SUM(TO_NUMBER(r.num_sold)) = (
        SELECT
            MAX(total_quantity_sold)
        FROM
            (SELECT
                m.box_size,
                m.box_color,
                SUM(TO_NUMBER(r.num_sold)) AS total_quantity_sold
            FROM
                F23_S003_T7_Manufacturing m
                JOIN F23_S003_T7_Retail r ON m.productID = r.productID
            GROUP BY
                m.box_size,
                m.box_color) max_sales
    );

--Output:
-- BOX_S BOX_COLOR                      TOTAL_QUANTITY_SOLD
-- ----- ------------------------------ -------------------
-- Fit   Bright Green                                  1415


-- Query 4
--The location/region which orders the most.
-- used rollup operation , groupby and having
SELECT
    r.r_location,
    SUM(TO_NUMBER(s.order_qty)) AS total_order_qty
FROM
    F23_S003_T7_Retail r
    JOIN F23_S003_T7_Shipped s ON r.retailerID = s.retailerID
GROUP BY
    ROLLUP(r.r_location)
HAVING
    GROUPING(r.r_location) = 0
ORDER BY
    total_order_qty DESC
FETCH FIRST 1 ROWS ONLY;

--Output:
-- R_LOCATION           TOTAL_ORDER_QTY
-- -------------------- ---------------
-- Sacramento                       592


--Query 5
--The best marketing technique that leads to the most increase in sales for our products?
-- used divison and over clause
WITH MarketingSales AS (
    SELECT
        sm.marketing_technique,
        SUM(TO_NUMBER(r.num_sold)) AS total_quantity_sold
    FROM
        F23_S003_T7_Manufacturing m
        JOIN F23_S003_T7_Retail r ON m.productID = r.productID
        JOIN F23_S003_T7_Sales_Marketing sm ON m.sales_prodID = sm.sales_productID
    GROUP BY
        sm.marketing_technique
)
, MarketingPercentage AS (
    SELECT
        marketing_technique,
        total_quantity_sold / LAG(total_quantity_sold, 1, total_quantity_sold) OVER (ORDER BY total_quantity_sold DESC) AS percentage_increase
    FROM
        MarketingSales
)
SELECT
    marketing_technique
FROM
    MarketingPercentage
ORDER BY
    percentage_increase DESC
FETCH FIRST 1 ROWS ONLY;

--Output:
-- MARKETING_TECHNIQUE
-- -------------------------
-- Newspaper


--Query 6
--The Sales product ID with least rating.
-- used groupby, orderby and fetch
WITH RankedProducts AS (
    SELECT
        feedback.sales_prodID,
        MIN(feedback.rating) AS least_rating
    FROM
        F23_S003_T7_Feedback feedback
        JOIN F23_S003_T7_Sales_Marketing fs ON feedback.sales_prodID = fs.sales_productID
    GROUP BY
        feedback.sales_prodID
)
SELECT
    sales_prodID,
    least_rating
FROM
    RankedProducts
ORDER BY
    least_rating
FETCH FIRST 1 ROWS ONLY;

--Output:
-- SALES_PROD LEAST
-- ---------- -----
-- 132        2


--Query 7
-- get the retailer location name starting with 'D' who orderd the most quantity of the products
-- used like , groupby 
WITH AggregatedData AS (
    SELECT
        r.r_location,
        SUM(TO_NUMBER(s.order_qty)) AS total_ordered
    FROM
        F23_S003_T7_Retail r
    JOIN
        F23_S003_T7_Shipped s ON r.retailerID = s.retailerID
    WHERE
        r.r_location LIKE 'D%'
    GROUP BY
        r.r_location
)
SELECT
    r_location,
    total_ordered
FROM
    AggregatedData
ORDER BY
    total_ordered DESC;

--Output:
-- R_LOCATION           TOTAL_ORDERED
-- -------------------- -------------
-- Dallas                         486


--Query 8
--Which top 10 site and product has the most # of delays
-- used CUBE
select  m.m_location, 
        c.product_Name, 
        m.no_of_delays
from    F23_S003_T7_Compounding c, 
        F23_S003_T7_Manufacturing m
GROUP BY CUBE(m.m_location, c.product_Name, m.no_of_delays)
Having m.no_of_delays is not null
ORDER BY m.no_of_delays DESC fetch first 10 rows only

--output:
-- M_LOCATION      PRODUCT_NAME    NO_OF_DELA
-- --------------- --------------- ----------
-- Austin          Nevanc          2
-- Dallas          Nevanc          2
-- Fort Worth      Nevanc          2
-- Austin          Naphcon         2
-- Dallas          Naphcon         2
-- Fort Worth      Naphcon         2
-- Austin          Nevanac         2
-- Dallas          Nevanac         2
-- Fort Worth      Nevanac         2
-- Austin          Systane         2

-- 10 rows selected.

--Query 9
--Display the count of marketing techniques used for manufacturing products that have a rating of 5.
-- used Rollup
with rp AS (
    select  F23_S003_T7_To_Be_Packaged.compoundingID, 
            F23_S003_T7_To_Be_Packaged.productID, 
            F23_S003_T7_Retail.num_sold
    From    F23_S003_T7_Retail
    JOIN    F23_S003_T7_To_Be_Packaged ON 
            F23_S003_T7_Retail.productID = F23_S003_T7_To_Be_Packaged.productID)
    select  c.product_Name, 
            SUM(rp.num_sold)
    From    F23_S003_T7_Compounding c
    JOIN rp ON c.compoundingID = rp.compoundingID
    Group by Rollup(c.product_Name);

--output:
-- PRODUCT_NAME    SUM(RP.NUM_SOLD)
-- --------------- ----------------
-- Zaditor                     1660
-- zaditor                       65
--                             1725

--Query 10
--Which site has the most # of delays
-- used CUBE
select m.m_location, SUM(m.no_of_delays) AS Total_num_of_delays
from F23_S003_T7_Manufacturing m
GROUP BY CUBE(m.m_location)
ORDER BY Total_num_of_delays;

--output:
-- M_LOCATION      TOTAL_NUM_OF_DELAYS
-- --------------- -------------------
-- Houston                           1
-- Sacremento                        2
-- Dallas                            3
-- Fort Worth                        5
-- Austin                            7
--                                  18

-- 6 rows selected.