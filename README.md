# Med_Product_DataBase
Essentially, this is a DBMS for a company that creates and sells medical eyecare products. The DBMS keeps track of the whole process of production and the interactions between the various steps as well as the interaction of wholesale.

## Phase 1
The Phase 1 document outlines the purpose of this Database Management System. It lists all the participants(entities) and their associated attributes. This will aid in constructing the Extended Entity Relationship (EER) diagram. The purpose of DBS for a business is to provide data to analyze and enhance its practices to improve as business. The document also contains business goals which are findings that the business can use to make judgements about their business model.

## Phase 2
The Phase 2 file contains the EER diagram that is created from the outline from phase 1.

## Phase 3
Phase 3 contains the Relational Schema, a doc with candidate key and functional dependencies which are then used to create a normalized schema in BCNF configuration.

## Phase 4
Phase 4 contains the SQL files to create the data for the Database. This was performed on Oracle.
### ```projectDBCreate.sql```
This file creates the Database schema using sql statements. This includes the tables with their constraints.
### ```projectDBdrop.sql```
This file drops all the tables that have been created. This will be useful to start from a clean slate after some inserts and deletes have been done, to check the correctness of ad-hoc queries.
### ```projectDBinsert.sql```
This file contains INSERT statements that populate the tables created in projectDBCreate.sql. This script will contain SQL commands to fill data in the tables.
### ```projectDBqueries.sql```
This file is a script with ad-hoc queries on the database that provides data to answer the business goals. Currently, there are 7 queries that answer a portion of the business goals.
### ```projectDBupdate```
This script will update the database through a series of insertions, deletes, and updates. This will allow you to verify the correctness of your queries when the database is updated/changed.
