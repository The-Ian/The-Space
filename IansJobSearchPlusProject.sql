
USE master;
if (select count(*) 
    from sys.databases where name = 'JobSearchPlus') > 0
BEGIN
	DROP DATABASE JobSearchPlus;
END

Create Database JobSearchPlus;
GO

Use JobSearchPlus;

exec sp_changedbowner 'sa'

Go
Create Table Sources
(	SourceID Int Not Null Identity(1,1),
	SourceName Varchar(75) Not Null,
	SourceType Varchar(35),
	SourceLink Varchar(255),
	[Description] Text
CONSTRAINT pk_Sources Primary KEY (SourceID),

)
CREATE UNIQUE INDEX indx_sources
ON Sources (SourceID, SourceName);
CREATE INDEX indx_sourcetype
ON Sources (SourceType);

Insert Into Sources 
(SourceName, SourceType, SourceLink, [Description])
Values
('Employ Florida', 'Online', 'https://www.employflorida.com/vosnet/jobbanks/jobdetails', 
'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.')

Insert Into Sources 
(SourceName, SourceType, SourceLink, [Description])
Values
('Monster', 'Online', 'https://job-openings.monster.com', 
'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, 
aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. 
In eleifend quam a odio. In hac habitasse platea dictumst. 
Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.')


Print 'Source Inserted'

Create Table BusinessTypes
(	BusinessType Varchar(50),
CONSTRAINT pk_BusinessTypes Primary KEY (BusinessType),

)
CREATE UNIQUE INDEX indx_businesstypes
ON BusinessTypes (BusinessType);

Insert Into BusinessTypes
(BusinessType)
Values
('Accounting'),
('Advertising/Marketing'),
('Agriculture'),
('Architecture'),
('Arts/Entertainment'),
('Aviation'),
('Beauty/Fitness'),
('Business Services'),
('Communications'),
('Computer/Hardware'),
('Computer/Services'),
('Computer/Software'),
('Computer/Training'),
('Construction'),
('Consulting'),
('Crafts/Hobbies'),
('Education'),
('Electrical'),
('Electronics'),
('Employment'),
('Engineering'),
('Environmental'),
('Fashion'),
('Financial'),
('Food/Beverage'),
('Government'),
('Health/Medicine'),
('Home & Garden'),
('Immigration'),
('Import/Export'),
('Industrial'),
('Industrial Medicine'),
('Information Services'),
('Insurance'),
('Internet'),
('Legal & Law'),
('Logistics'),
('Manufacturing'),
('Mapping/Surveying'),
('Marine/Maritime'),
('Motor Vehicle'),
('Multimedia'),
('Network Marketing'),
('News & Weather'),
('Non-Profit'),
('Petrochemical'),
('Pharmaceutical'),
('Printing/Publishing'),
('Real Estate'),
('Restaurants'),
('Restaurants Services'),
('Service Clubs'),
('Service Industry'),
('Shopping/Retail'),
('Spiritual/Religious'),
('Sports/Recreation'),
('Storage/Warehousing'),
('Technologies'),
('Transportation'),
('Travel'),
('Utilities'),
('Venture Capital'),
('Wholesale')

Create Table Companies 
(	CompanyID Int Not Null Identity(1,1),
	CompanyName Varchar(75) Not Null,
	Address1 Varchar(75) Not Null,
	Address2 Varchar(75),
	City Varchar(50),
	[State] Varchar(2),
	ZIP Varchar(10),
	Phone Varchar(14),
	Fax Varchar(14),
	Email Varchar(50),
	Website Varchar(50),
	[Description] Text,
	BusinessType Varchar(50),
	Agency Bit Default 0,
	CONSTRAINT fk_Companies_BusinessTypes FOREIGN KEY (BusinessType) REFERENCES BusinessTypes(BusinessType),
	CONSTRAINT pk_Companies Primary KEY (CompanyID)
)
CREATE UNIQUE INDEX indx_companies
ON Companies (CompanyID, CompanyName);
CREATE INDEX indx_companyaddress
ON Companies (City, [State], ZIP);

Insert Into Companies
(CompanyName, Address1, City, [State], ZIP, Website, [Description], BusinessType)
Values
('LGS Innovations LLC', '1559 Paget Junction', 'Tampa', 'FL', 33629, 'http://www.lgsinnovations.com', 'LGS Innovations is delivering 
next generation solutions that solve the most complex sensing, 
networking and communications challenges facing our U.S. Federal Government 
Customers, We are seeking the ''best and brightest'' with a 
passion to solve tough challenges through 
innovation and the application of science and technology to catalyze 
impactful solutions for our customers.', 'Computer/Software')

Insert Into Companies
(CompanyName, Address1, City, [State], ZIP, [Description], BusinessType)
Values
('EverBank', '5 Clyde Gallagher Trail', 'Jacksonville', 'FL', 32202, 'The future of banking just got a lot brighter for individuals, 
businesses and institutions across the country, 
as EverBank is now a proud part of the TIAA family. EverBank is an equal opportunity employer.', 'Computer/Software')

Insert Into Companies
(CompanyName, Address1, City, [State], ZIP, [Description], BusinessType)
Values
('Advanced Systems Design', '16426 Roxbury Road', 'Tallahassee', 'FL', 32309, 'Advanced Systems Design, Inc. is a leading 
Information Technology provider for Federal, State & Local government agencies and 
certified minority-owned small business government contractor', 'Computer/Software')

Insert Into Companies
(CompanyName, Address1, City, [State], ZIP, Website, [Description], BusinessType)
Values
('Rita Technology Services', '7021 Kingsford Junction', 'Tampa', 'FL', 13910, 'http://www.ritatech.com', 'Rita Technology Services is 
a leading IT Search & Consulting firm.', 'Computer/Software')

Insert Into Companies
(CompanyName, Address1, City, [State], ZIP, Website, [Description], BusinessType)
Values
('Matrix Resources', '20 Sauthoff Way', 'Temple Terrace', 'FL', 33637, 'http://www.matrixres.com/', 'MATRIX brings a true Agile 
perspective to technology staffing and solutions. 
This makes it easier for candidates to get great work and for clients to get great work done.', 
'Computer/Software')


Print 'Company Inserted'

Create Table Contacts 
(	ContactID Int Not Null Identity(1,1),
	CompanyID Int Not Null,
	CourtesyTitle Varchar(25),
	ContactFirstName Varchar(50),
	ContactLastName Varchar(50),
	Title Varchar(50),
	Phone Varchar(14),
	Extension Varchar(10),
	Fax Varchar(14),
	Email Varchar(50),
	Comments Varchar(255),
	Active Bit default -1,
CONSTRAINT pk_Contacts Primary KEY (ContactID),
CONSTRAINT CK_CourtesyTitle CHECK (CourtesyTitle In ('Mr.','Ms.','Miss', 
'Mrs.', 'Dr.', 'Rev.'))
)

CREATE UNIQUE INDEX indx_contactid
ON Contacts (ContactID);
CREATE INDEX indx_contacts
ON Contacts (CompanyID, ContactLastName, Title);

Insert Into Contacts
(CompanyID, CourtesyTitle, ContactFirstName, ContactLastName, Title, Phone, Email)
Values
(1, 'Mr.', 'Frank', 'Castle', 'Jr. Software Engineer', '(546) 788-9752', 'Th3Pun1sh3r@yahoo.com')

Insert Into Contacts
(CompanyID, CourtesyTitle, ContactFirstName, ContactLastName, Title, Phone, Email)
Values
(2, 'Dr.', 'Reed', 'Richards', 'Lead Developer', '(444) 899-7894', 'MrFantastic@gmail.com')

Insert Into Contacts
(CompanyID, CourtesyTitle, ContactFirstName, ContactLastName, Title, Phone, Email)
Values
(3, 'Miss', 'Diana', 'Prince', 'Project Manager', '(245) 436-1223', 'A_Wonderful_Woman@ymail.com')

Insert Into Contacts
(CompanyID, CourtesyTitle, ContactFirstName, ContactLastName, Title, Phone, Email)
Values
(4, 'Dr.', 'Otto', 'Octavius', 'Sr. Software Architect', '(416) 712-9669', 'DoctorCephalopod@hotmail.com')

Insert Into Contacts
(CompanyID, CourtesyTitle, ContactFirstName, ContactLastName, Title, Phone, Email)
Values
(5, 'Dr.', 'Steven', 'Strange', 'Sr. Project Manager', '(758) 256-6458', 'SorcSupreme@gmail.com')



Print 'Contact Inserted'

Go
Create Table Leads
(	LeadID Int Not Null Identity(1,1),
	RecordDate Date Not Null default getdate(),
	JobTitle Varchar(50),
	[Description] Text,
	EmploymentType Varchar(25),
	Location Varchar(50),
	Active Bit default -1,
	CompanyID Int Not Null,
	AgencyID Int Not Null,
	ContactID Int Not Null,
	SourceID Int Not Null,
	Selected Bit  default 0,
	ModifiedDate Date,
CONSTRAINT pk_Leads Primary KEY (LeadID),
CONSTRAINT fk_Leads_Companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
CONSTRAINT fk_Leads_Contacts FOREIGN KEY (ContactID) REFERENCES Contacts(ContactID),
CONSTRAINT fk_Leads_Sources FOREIGN KEY (SourceID) REFERENCES Sources(SourceID),
CONSTRAINT CK_RecordedDate CHECK ([RecordDate] <= GETDATE()),
CONSTRAINT CK_EmploymentType CHECK (EmploymentType In ('Full-time','Part-time','Contractor', 
'Temporary', 'Seasonal', 'Intern', 'Freelance', 'Volunteer'))
)


Go
CREATE UNIQUE INDEX indx_leadID
ON Leads (LeadID);
CREATE INDEX indx_leadstuff
ON Leads (RecordDate, EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID);

Go
Create Trigger trgLeadsModifiedDate
ON Leads
AFTER Insert, UPDATE
AS
BEGIN
UPDATE		L
	SET			L.ModifiedDate = GETDATE() 	
	FROM		Leads L
	INNER JOIN	inserted i
	ON			i.LeadID = L.LeadID
END;

Go
Insert Into Leads
(JobTitle, [Description], EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID)
Values
('Sr. Software Engineer', 'Independently design and implement application 
software for custom sensor and wireless communication systems.', 'Full-Time', 'Tampa, FL', 1
, 1, 1, 1)

Insert Into Leads
(JobTitle, [Description], EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID)
Values
('IT Software Developer On Base', 'Software Developers are responsible for implementation and creation 
of technology solutions to meet the requirements of EverBank''s products and services.', 'Full-Time', 'Jacksonville, FL', 2
, 0, 2, 1)

Insert Into Leads
(JobTitle, [Description], EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID)
Values
('Systems Analyst', 'The Systems Analyst is expected to perform the tasks and specific assignments 
given by the assigned Project Manager.', 'Full-Time', 'Tallahassee, FL', 3, 0, 3, 1)

Insert Into Leads
(JobTitle, [Description], EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID)
Values
('Software Architect', 'This is an enterprise software level Architect on frameworks. 
It is a hands-on role involving 50% design & architecture and 50% implementation.', 'Full-Time', 'Tampa, FL', 4
, 0, 4, 2)

Insert Into Leads
(JobTitle, [Description], EmploymentType, Location, CompanyID, AgencyID, ContactID, SourceID)
Values
('Software Application Tester', 'Developing and executing quality assurance test scripts, tests plans and checklists.', 
'Full-Time', 'Temple Terrace, FL', 5, 1, 5, 2)

Print 'Lead Inserted'

Go
Create Table Activities
(	ActivityID Int Not Null Identity(1,1),
	LeadID Int Not Null,
	ActivityDate Date Not Null default getdate(),
	ActivityType Varchar(25) Not Null,
	ActivityDetails Varchar(255),
	Complete Bit,
	ReferenceLink Varchar(255),
	ModifiedDate Date,
CONSTRAINT pk_Activities Primary KEY (ActivityID),
CONSTRAINT fk_Activities_Leads FOREIGN KEY (LeadID) REFERENCES Leads(LeadID),
CONSTRAINT CK_ActivityType CHECK (ActivityType In ('Inquiry','Application','Contact', 
'Interview', 'Follow-up', 'Correspondence', 'Documentation', 'Closure', 'Other'))
)

Go
Create Trigger trgActivitiesModifiedDate
ON Activities
AFTER Insert, UPDATE
AS
BEGIN
UPDATE		A
	SET			A.ModifiedDate = GETDATE() 	
	FROM		Activities A
	INNER JOIN	inserted I
	ON			I.ActivityID = A.ActivityID
END

Go
CREATE UNIQUE INDEX indx_activitiesID
ON Activities (ActivityID);
CREATE INDEX indx_activitystuff
ON Activities (LeadID, ActivityDate, ActivityType);


Insert Into Activities
(LeadID, ActivityType, ActivityDetails, Complete)
Values
(1, 'Documentation', 'Phasellus in felis. Donec semper sapien a libero. 
Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. 
Sed accumsan felis. Ut at dolor quis odio consequat varius.', 0)

Insert Into Activities
(LeadID, ActivityType, ActivityDetails, Complete)
Values
(2, 'Application', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', 1)

Insert Into Activities
(LeadID, ActivityType, ActivityDetails, Complete)
Values
(3, 'Interview', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 0)

Insert Into Activities
(LeadID, ActivityType, ActivityDetails, Complete)
Values
(4, 'Inquiry', 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', 1)

Insert Into Activities
(LeadID, ActivityType, ActivityDetails, Complete)
Values
(5, 'Closure', 'Duis aliquam convallis nunc.', 1)


Go
Print 'Activity Inserted'