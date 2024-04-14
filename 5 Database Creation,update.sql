-- DATABASE NORMALIZATION AND DATA INTEFRITY
Data integrity is accuracy and consistency of data over its lifecycle

-- ERD Diagram

-- Data type: Json,Spatial
# I want to know how many gluteen free items are in my store
 This are all json format
SELECT * FROM superstore_db.items
where properties->"$.gluten_free"=0;

SELECT * FROM superstore_db.items
where JSON_EXTRACT(properties,"$.color")="blue";

-- Primary Key
-- Foreign Key
-- Create a relationshio from entity relationship diagram( This are important 
need to see when i do work)


