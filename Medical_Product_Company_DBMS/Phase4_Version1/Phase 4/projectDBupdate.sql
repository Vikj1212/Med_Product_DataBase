UPDATE F23_S003_T7_Feedback SET rating = '1' WHERE customerID = 131 AND sales_prodID = 131;
UPDATE F23_S003_T7_Feedback SET rating = '5' WHERE customerID = 140 AND sales_prodID = 132;
UPDATE F23_S003_T7_Feedback SET rating = '5' WHERE sales_prodID = 128;

UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '5000' WHERE productID = '10131';
UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '20000' WHERE productID = '10130';
UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '50000' WHERE productID = '10132';
UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '5000' WHERE productID = '10131';
UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '15000' WHERE productID = '10135';
UPDATE F23_S003_T7_Manufacturing SET quantity_of_output = '25000' WHERE productID = '10138';
UPDATE F23_S003_T7_Manufacturing SET no_of_delays = '4' WHERE productID = '10138';
 
DELETE FROM F23_S003_T7_Manufacturing WHERE m_location = 'Austin';
INSERT INTO F23_S003_T7_Manufacturing VALUES('24', 'Austin', '10153', '25000', '0', '130', 'Large', 'White');