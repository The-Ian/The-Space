
/*

Answer the following questions from the article
"Questions about Primary and Foreign Keys You Were To Shy To Ask"

https://www.red-gate.com/simple-talk/sql/t-sql-programming/questions-about-primary-and-foreign-keys-you-were-too-shy-to-ask
Insert the answers after the questions and turn them in with this file.


What purpose does the primary key of a table serve?

What purpose do primary key values serve?

Can a table have unique values other than the primary key?

Can a primary key column contain NULL values (certification question)?

What is a composite primary key?

What is a clustered index?

If a clustered index is already present on the table when the primary key is created, 
what type of index is created on the primary key?

A foreign key is a type of __________ placed on one or more columns in a table.

How does the foreign key enforce referential integrity between tables?

Research:  What is the recommended limit of outgoing foreign keys per table?

Research:  How many incoming foreign key references can a table support?

A primary key is defined as nullable by default. True or False.

What is a surrogate key?

What is an advantage to using the IDENTITY field as a primary key.

What is a GUID?

How do composite primary keys affect performance?

What is a natural key?

What are the advantages and disadvantages for natural keys?

How you you specify a nonclustered index for the primary key?

Why is the primary key often matched with the clustered index in a table?

What are the requirments for a foreign key?

What are the four options that can be set for a foreign key to affect what 
happens if the parent row is deleted?  What do these options do?

What two SQL operations use the CASCADE option on the foreign key?

Does SQL Server automatically create indexes on foreign keys?

How do you disable and re-enable foreign keys on a table?

What is the name of the system view used to view information on all primary and 
foreign keys in the database?



SQL Exercise

At the bottom of this file, write a script that does the following in the specified order.
The script must run a single time without error.  Use comments and the PRINT statement to
indicate each step in the script.

Create a new database called Homework and run the rest of the commands in that database.

Create the Countries table with the following fields:

CountryID, INT
CountryName, VARCHAR(50) (Indexed)
Population, BIGINT  
Currency, VARCHAR(50) 

Add CountryID as the primary key and name the key pk_Country.

Create the Cities table with the following fields:

CityID, INT, PRIMARY KEY
CityName, VARCHAR(50) (Indexed)
CountryID, INT (Indexed)
Population, BIGINT 

Specify CityID as the primary key using the simplest syntax available and 
let the database give it a name automatically.

Create the Books table with the following fields:

ISBN, VARCHAR(15)
DatePurchased, DATE 
Title, VARCHAR(255) (Indexed)
AuthorID, INT (Indexed)

AFTER the CREATE TABLE statement, add a composite, NONclustered primary key to 
the table on the ISBN and DatePurchased fields.

Drop the primary key that you added in the last step and use an ALTER TABLE 
statement to add the following field to the table:

BookID, INT, PRIMARY KEY

Write a SELECT statement that returns the record for this new primary key 
from the sys.key_constraints view.

Use the ALTER TABLE statement to add a foreign key to Cities that links the CountryID 
field in that table to the CountryID field in Countries.  
Use the CASCADE option that will delete all cities within a given country when that 
country is deleted from the Countries table.

Write statements to insert three records into each of the tables you created above.
Write UPDATE statements to increase the population of each of the countries and 
cities you've added by 15%.



*/

USE master;
if (select count(*) 
    from sys.databases where name = 'Homework') > 0
BEGIN
	DROP DATABASE Homework;
END

Create Database Homework;
GO
Print 'Homework Database Created'

Use Homework;

exec sp_changedbowner 'sa'

Create Table Countries
(
	CountryID INT Not Null Identity(1,1),
	CountryName VARCHAR(50),
	[Population] BIGINT,  
	Currency VARCHAR(50)

CONSTRAINT pk_Country Primary Key (CountryID)
)

Print 'Countries Table Created'

Go
CREATE INDEX indx_countryname
ON Countries (CountryName);

Go
Print 'Country Name Index Created'

Go
Create Table Cities
(
	CityID INT Not Null Identity(1,1) PRIMARY KEY,
	CityName VARCHAR(50),
	CountryID INT,
	[Population] BIGINT 
)

Print 'Cities Table Created'

CREATE INDEX indx_cityname
ON Cities (CityName);
CREATE INDEX indx_countryid
ON Cities (CountryID);

Go
Print 'City Name and Country ID Indexs Created'

Go
Create Table Books
(
	ISBN VARCHAR(15),
	DatePurchased DATE,
	Title Varchar(255),
	AuthorID INT	
	CONSTRAINT pk_Book Primary Key (ISBN, DatePurchased)
)

Print 'Books Table Created'

Print 'Primary Keys ISBN and DatePurchased Added'


Go
Alter Table Books
Drop Constraint pk_Book;

Print 'Primary Keys ISBN and DatePurchased Dropped'

Go
Alter Table Books
Add BookID Int Not Null Identity(1,1) ;
Alter Table Books
Add CONSTRAINT pk_BookID Primary Key (BookID);

Print 'Added BookID as the Primary Key'

Select * From sys.key_constraints
Where Name = 'pk_BookID'

go
CREATE INDEX indx_booktitle
ON Books (Title, AuthorID);

Print 'Book Title Index Created'

Go
Alter Table Cities
ADD CONSTRAINT fk_CountryID
Foreign Key (CountryID) References Countries(CountryID)
On Delete Cascade;

Print 'Added CountryID as a Foreign Key for Cities'

Insert Into Countries 
(CountryName, [Population], Currency)
Values 
('Japan', 50000000, 'Yen'),
('United States', 300000000, 'United States Dollar'),
('Russia', 100000000, 'Rubles')

Print 'Countries Inserted'

Insert Into Cities 
(CityName, CountryID, [Population])
Values 
('Tokyo', 1, 100000),
('California', 2, 27000000),
('Moscow', 3, 500000)

Print 'Cities Inserted'

Insert Into Books 
(ISBN, DatePurchased, Title, AuthorID)
Values 
('9783161484100', '12-15-2017', 'Just Another Day...', 1),
('9998001456910', '12-16-2017', '1337; A Deep Look Into Gaming and It''s Competitive Scene', 2),
('9101014523691', '12-17-2017', 'House Decor and What It Should Mean To You', 3)

Print 'Books Inserted'


Update Countries
Set [Population] = [Population]*1.15 

Print 'Country Populations have been multiplied by 15%.'

Update Cities
Set [Population] = [Population]*1.15 

Print 'City Populations have been multiplied by 15%.'