USE master;
if (select count(*) 
    from sys.databases where name = 'Veteninary') > 0
BEGIN
	DROP DATABASE Veteninary;
END

Create Database Veteninary;
GO
Print 'Veteninary Database Created'

Use Veteninary

If (Select Count(*) 
	From master.sys.syslogins Where name = 'VetManager') > 0
BEGIN
	DROP Login VetManager;
END

Create Login VetManager
	With Password = '222'
Go

Print 'VetManager Login Added'
Go

If (Select Count(*) 
	From master.sys.syslogins Where name = 'VetClerk') > 0
BEGIN
	DROP Login VetClerk;
END

Create Login VetClerk
	With Password = '111'
Go

Print 'VetClerk Login Added'
Go

exec sp_changedbowner 'sa'

Create Table Clients
(
ClientID Int Not Null Identity(1,1),
FirstName Varchar(25) Not Null,
LastName Varchar(25) Not Null,
MiddleName Varchar(25),
CreateDate Date Not Null Default(Getdate()),

CONSTRAINT pk_Client Primary Key (ClientID)
)

Create Table ClientContacts 
(
AddressID Int Not Null Identity(1,1),
ClientID Int Not Null,
AddressType Int Not Null,
AddressLine1 Varchar(50) Not Null,
AddressLine2 Varchar(50) Not Null,
City Varchar(35) Not Null,
StateProvince Varchar(25) Not Null,
PostalCode Varchar(15) Not Null,
Phone Varchar(15) Not Null,
AltPhone Varchar(15) Not Null,
Email Varchar(35) Not Null,


CONSTRAINT pk_ClientContact Primary Key (AddressID),
CONSTRAINT fk_Client  Foreign Key (ClientID) References Clients(ClientID),
CONSTRAINT chk_ClientContactAddressType Check (AddressType = 1 Or AddressType = 2)
)

Create Table AnimalTypeReference
(
AnimalTypeID Int Not Null Identity(1,1),
Species Varchar(35) Not Null,
Breed Varchar(35) Not Null,

Constraint pk_AnimalType Primary Key (AnimalTypeID)
)

Create Table Patients
(
PatientID Int Not Null Identity(1,1),
ClientID Int Not Null,
Name Varchar(35) Not Null,
AnimalType Int Not Null,
Color Varchar(25) Not Null,
Gender Varchar(2) Not Null,
BirthYear Varchar(4),
[Weight] Decimal(4) Not Null,
[Description] Varchar(1024),
GeneralNotes Varchar(2048) Not Null,
Chipped Bit Not Null,
RabiesVacc DateTime,

CONSTRAINT pk_Patient Primary Key (PatientID),
CONSTRAINT fk_Clients  Foreign Key (ClientID) References Clients(ClientID),
CONSTRAINT fk_AnimalType  Foreign Key (AnimalType) References AnimalTypeReference(AnimalTypeID)
)

Create Table Employees
(
EmployeeID Int Not Null Identity(1,1),
LastName Varchar(25) Not Null,
FirstName Varchar(25) Not Null,
MiddleName Varchar(25),
HireDate Date Not Null,
Title Varchar(50) Not Null,

Constraint pk_Employee Primary Key (EmployeeID)
)

Create Table EmployeeContactInfo
(
AddressID Int Not Null Identity(1,1),
AddressLine1 Varchar(50) Not Null,
AddressLine2 Varchar(50) Not Null,
City Varchar(35) Not Null,
StateProvince Varchar(25) Not Null,
PostalCode Varchar(15) Not Null,
Phone Varchar(15) Not Null,
AltPhone Varchar(15) Not Null,
EmployeeID Int Not Null,

CONSTRAINT pk_EmployeeContact Primary Key (AddressID),
CONSTRAINT fk_Employee  Foreign Key (EmployeeID) References Employees(EmployeeID)
)

Create Table Visits
(
VisitID Int Not Null Identity(1,1),
StartTime DateTime Not Null,
EndTime DateTime Not Null,
Appointment Bit Not Null,
DiagnosisCode Varchar(12) Not Null,
ProcedureCode Varchar(12) Not Null,
VisitNotes Varchar(2048) Not Null,
PatientID Int Not Null,
EmployeeID Int Not Null,

CONSTRAINT pk_Visit Primary Key (VisitID),
CONSTRAINT fk_Patient Foreign Key (PatientID) References Patients(PatientID),
CONSTRAINT fk_Employees Foreign Key (EmployeeID) References Employees(EmployeeID),
CONSTRAINT chk_VisitEndTime Check(EndTime > StartTime)
)

Create Table Billing
(
BillID Int Not Null Identity(1,1),
BillDate Date Not Null,
ClientID Int Not Null,
VisitID Int Not Null,
Amount Decimal Not Null,

CONSTRAINT pk_Bill Primary Key (BillID),
CONSTRAINT fk_Clientelle Foreign Key (ClientID) References Clients(ClientID),
CONSTRAINT fk_Visits Foreign Key (VisitID) References Visits(VisitID),
CONSTRAINT chk_BillDate Check (BillDate < Getdate())
)

Create Table Payment
(
PaymentID Int Not Null Identity(1,1),
PaymentDate Date Not Null,
BillID Int,
Notes Varchar(2048),
Amount Decimal Not Null,

CONSTRAINT pk_Payment Primary Key (PaymentID),
CONSTRAINT fk_Bill Foreign Key (BillID) References Billing(BillID),
CONSTRAINT chk_PaymentDate Check (PaymentDate < Getdate())
)
-- Insert Statements
Insert Into Clients
		(FirstName, LastName)

Values	('Jack', 'Warner'),
		('Thomas', 'Ghent'),
		('Saxton', 'Hale'),
		('Jade', 'Wulong'),
		('Vendara', 'Pelton')

Insert Into AnimalTypeReference
		(Species, Breed)

Values	('Dog', 'Chihuahua'),
		('Cat', 'Persian'),
		('Marsupial', 'Kangaroo'),
		('Bear', 'Panda'),
		('Primate', 'Orangutan'),
		('Bird', 'Falcon'),
		('Rodent', 'Mouse'),
		('Dog','Dotson'),
		('Dog','Poodle'),
		('Bird','Parakeet'),
		('Dog','American Bulldog'),
		('Cat', 'Saiamese'),
		('Rodent','Mouse')


Insert Into Patients
		(ClientID, Name, AnimalType, Color, Gender, BirthYear, [Weight], GeneralNotes, Chipped)

Values	(1, 'Rock', 1, 'Black/Brown', 'M', 2010, 15, 'It is a small doggie.', 1),
		(2, 'Gypsy', 2, 'White/Black', 'F', 2012, 13, 'It is indeed a kitty.', 0),
		(3, 'Jackie', 3, 'Brown', 'F', 2008, 250, 'Very unusual to see a pet Kangaroo.', 0),
		(4, 'Po', 4, 'White/Reddish Brown', 'M', 2005, 600, 'First time seeing a pet Panda.', 0),
		(4, 'Sunny', 5, 'Orange', 'M', 2001, 155, 'At this point, seeing a pet Orangutan isn''t the weirdest thing.', 1),
		(5, 'Red Baron', 6, 'Brown/White', 'F', 2013, 42, 'This birdie is pretty cool.', 0),
		(5, 'Dexter', 7, 'White', 'M', 2017, 2, 'A tiny lab mouse.', 1),
		(1, 'Frank', 8, 'Brown', 'M', 2011, 18, 'Tis a small hotdog.', 1),
		(1, 'Fluffy', 9, 'White', 'F', 2013, 25, 'A French Poodle is always nice to see.', 0),
		(5, 'Flyboy', 10, 'Red/Yellow', 'M', 2015, 10, 'A nice colorful Parakeet.', 0),
		(1, 'Wrecker', 11, 'Gray', 'M', 2014, 35, 'A grand old American Bulldog.', 1),
		(2, 'Ronin', 12, 'Black', 'M,', 2018, 17, 'At least its not furless.', 0),
		(5, 'Mandark', 13, 'Black', 'M', 2017, 2, 'Another tiny lab mouse.', 1)

		
Go
-- Users
Create User VetManager For Login VetManager
Go

Alter Role db_datareader Add Member [VetManager]
Go

Alter Role db_datawriter Add Member [VetManager]
Go

Create User VetClerk For Login VetClerk
Go

Alter Role db_datareader Add Member [VetClerk]
Go

	Deny Select On ClientContacts To VetClerk;
	Deny Select On EmployeeContactInfo To VetClerk;
