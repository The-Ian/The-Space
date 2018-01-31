USE master;
if (select count(*) 
    from sys.databases where name = 'Veterinary') > 0
BEGIN
	DROP DATABASE Veterinary;
END

Create Database Veterinary;
GO
Print 'Veterinary Database Created'

Use Veterinary

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
AddressLine2 Varchar(50),
City Varchar(35) Not Null,
StateProvince Varchar(25) Not Null,
PostalCode Varchar(15) Not Null,
Phone Varchar(15) Not Null,
AltPhone Varchar(15),
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

Create Table VetEmployees
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
AltPhone Varchar(15),
EmployeeID Int Not Null,

CONSTRAINT pk_EmployeeContact Primary Key (AddressID),
CONSTRAINT fk_Employee  Foreign Key (EmployeeID) References VetEmployees(EmployeeID)
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
CONSTRAINT fk_Employees Foreign Key (EmployeeID) References VetEmployees(EmployeeID),
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
		

Insert Into ClientContacts 
		(ClientID, AddressType, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, Email) 

Values	(1, 2, '4897 Veith Crossing', '32 Russell Way', 'Topeka', 'Kansas', '66629', '785-624-6609', 'jizkovici0@mozilla.org'),
		(2, 2, '0 Boyd Parkway', '9 Arrowood Court', 'Laurel', 'Maryland', '20709', '410-171-1089', 'ltingle1@wordpress.org'),
		(3, 1, '432 Grayhawk Hill', '36904 Dexter Lane', 'Hyattsville', 'Maryland', '20784', '301-709-6071', 'lofearguise2@phpbb.com'),
		(4, 1, '2 Dovetail Junction', '5 Paget Avenue', 'Colorado Springs', 'Colorado', '80915', '719-799-7324', 'tlitt3@wisc.edu'),
		(5, 2, '58754 Jana Avenue', '80 Golf Point', 'Warren', 'Ohio', '44485', '330-434-8991', 'inattriss4@myspace.com')


Insert Into VetEmployees 
		(LastName, FirstName, HireDate, Title)	

Values	
		('Hulkes', 'Silvana', '04/05/2017', 'Receptionist'),
		('Row', 'Chrisse', '06/26/2017', 'Vet Assistant'),
		('Jertz', 'Joycelin', '10/26/2017', 'Veterinarian'), 
		('Doreward', 'Arte', '12/10/2017', 'Veterinarian'),
		('Vogl', 'Danika', '03/30/2017', 'Janitor'),
		('Gossan', 'Lorrie', '03/06/2017', 'Janitor'),
		('Vanyutin', 'Freedman', '03/03/2017', 'Janitor')



Insert Into EmployeeContactInfo 
		(AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, EmployeeID) 

Values	('74126 Hoard Terrace', '19516 Shopko Junction', 'Wichita', 'Kansas', '67230', '316-218-8350', 1),
		('98 Bellgrove Hill', '21612 Red Cloud Drive', 'Young America', 'Minnesota', '55564', '952-477-0962', 2),
		('00593 Hallows Crossing', '34 Arizona Road', 'Macon', 'Georgia', '31296', '478-898-6849', 3),
		('745 Anzinger Circle', '2936 Elgar Park', 'Birmingham', 'Alabama', '35295', '205-288-7963', 4),
		('827 Sunbrook Avenue', '82 Lillian Crossing', 'Indianapolis', 'Indiana', '46278', '317-833-9250', 5),
		('3766 Farmco Pass', '2 Northview Hill', 'Clearwater', 'Florida', '34615', '727-916-9217', 6),
		('2807 Ludington Circle', '86890 Marquette Parkway', 'Atlanta', 'Georgia', '30368', '404-645-6294', 7)


Insert Into Visits
		(StartTime, EndTime, Appointment, DiagnosisCode, ProcedureCode, VisitNotes, PatientID, EmployeeID)

Values
		('2017-12-04 20:54:24', '2017-12-04 23:00:10', 1, 385, 09510, 'Morbi vel lectus in quam fringilla rhoncus.', 1, 1),
		('2017-09-19 16:17:17', '2017-09-19 19:59:32', 0, 944, 95845, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', 2, 2),
		('2017-11-15 10:22:27', '2017-11-15 11:05:41', 1, 9, 44709, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 3, 3),
		('2017-07-05 15:05:06', '2017-07-05 20:00:55', 1, 41451, 420, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 4, 4),
		('2017-04-02 06:30:27', '2017-04-02 08:30:00', 0, 355, 30275, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', 5, 5)


Insert Into Billing
		(BillDate, ClientID, VisitID, Amount)

Values
		('2017-12-04', 1, 1, 150),
		('2017-09-19', 2, 2, 120),
		('2017-11-15', 3, 3, 50),
		('2017-07-05', 4, 4, 300),
		('2017-04-02', 5, 5, 100)

Insert Into Payment
		(PaymentDate, BillID, Amount)

Values
		('2017-12-05', 1, 150),
		('2017-09-20', 2, 120),
		('2017-11-16', 3, 50),
		('2017-07-06', 4, 300),
		('2017-04-03', 5, 100)


-- Stored Procedures
Go
Create Proc uspSpeciesReturn (@Value as Varchar(Max))
As
	
	Select	FirstName, LastName, Name AddressType, 
			AddressLine1, AddressLine2, City, 
			StateProvince, PostalCode, Phone, Email
	From Clients C
	Inner Join ClientContacts CC
	On C.ClientID = CC.ClientID
	Inner Join Patients P
	On P.ClientID = C.ClientID
	Inner Join AnimalTypeReference ATR
	On ATR.AnimalTypeID = P.AnimalType
	Where Species Like '%' + @Value + '%'

	--Exec uspSpeciesReturn Dog
	
Go
Create Proc uspBreedReturn (@Value as Varchar(Max))
As

	Select	FirstName, LastName, Name AddressType, 
			AddressLine1, AddressLine2, City, 
			StateProvince, PostalCode, Phone, Email
	From Clients C
	Inner Join ClientContacts CC
	On C.ClientID = CC.ClientID
	Inner Join Patients P
	On P.ClientID = C.ClientID
	Inner Join AnimalTypeReference ATR
	On ATR.AnimalTypeID = P.AnimalType
	Where Breed Like '%' + @Value + '%'


	--Exec uspBreedReturn Mouse
Go	
Create Proc uspPayDate (@ClientID as Int)
As
	Select PaymentDate, EndTime, P.Amount 
	From Payment P
	Inner Join Billing B
	On B.BillID = P.BillID
	Inner Join Visits V
	On B.VisitID = V.VisitID
	Where ClientID = @ClientID

	--Exec uspPayDate 5
Go
Create Proc uspMailList 
As
	Select	Concat(LastName, ',', ' ', FirstName) 'Employee',  
			AddressLine1, AddressLine2, City, StateProvince 'State', 
			PostalCode 'ZIP', Phone
	From VetEmployees VE
	Inner Join EmployeeContactInfo ECI
	On VE.EmployeeID = ECI.EmployeeID

	--Exec uspMailList 
Go
Create Proc uspNewClient
(
@FirstName as Varchar(50),
@LastName as Varchar(50),
@AddressType as int, 
@AddressLine1 as Varchar(50), 
@AddressLine2 as Varchar(50), 
@City as Varchar(50), 
@StateProvince as Varchar(50), 
@PostalCode as Varchar(50), 
@Phone as Varchar(50), 
@Email as Varchar(50),
@ClientID int Output
)
As
 
	Insert Into Clients
			(FirstName, LastName)

	Values	(@FirstName, @LastName)

	Insert Into ClientContacts 
		(AddressType, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, Email) 

	Values	(@AddressType, @AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Phone, @Email)

	Select @ClientID = SCOPE_IDENTITY() From Clients

Go
Create Proc uspNewEmployee
(
@LastName As Varchar(50), 
@FirstName As Varchar(50), 
@HireDate As Varchar(50), 
@Title As Varchar(50),
@AddressLine1 As Varchar(50), 
@AddressLine2 As Varchar(50), 
@City As Varchar(50), 
@StateProvince As Varchar(50), 
@PostalCode As Varchar(50), 
@Phone As Varchar, 
@EmployeeID As int, 
@NewEmpID int Output
)
As 
	Insert Into VetEmployees 
		(LastName, FirstName, HireDate, Title)	

	Values	
		(@Lastname, @FirstName, @HireDate, @Title)


	Insert Into EmployeeContactInfo 
			(AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, EmployeeID) 

	Values	(@AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Phone, @EmployeeID)
	
	Select @NewEmpID = SCOPE_IDENTITY()
	From VetEmployees

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
	Grant Exec On uspSpeciesReturn To VetClerk;
	Grant Exec On uspBreedReturn To VetClerk;
	Grant Exec On uspPayDate To VetClerk;
	Grant Exec On uspMailList To VetClerk;
	Grant Exec On uspNewClient To VetClerk;
	Grant Exec On uspNewEmployee To VetClerk;

	Grant Exec On uspSpeciesReturn To VetManager;
	Grant Exec On uspBreedReturn To VetManager;
	Grant Exec On uspPayDate To VetManager;
	Grant Exec On uspMailList To VetManager;
	Grant Exec On uspNewClient To VetManager;
	Grant Exec On uspNewEmployee To VetManager;

