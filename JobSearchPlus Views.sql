
	--Number of job leads per day.
	Create View [Number of job leads per day]
	As
Select	Max([Job Leads Per Day].[Average Leads Per Day of Month]) 'Amount of Leads',
		[Job Leads Per Day].[Day]
From 
	(Select Count(LeadID) [Average Leads Per Day of Month], Day(RecordDate) [Day]
	From Leads
	Group By Day(RecordDate)) [Job Leads Per Day]
Group By	[Job Leads Per Day].[Day]
Go
	--Number of job leads per week.
	Create View [Number of job leads per week]
	As
Select DateAdd(DW,1 - Datepart(dw,Max(RecordDate)),Max(RecordDate)) 'Week', Count(LeadID) 'Amount of Leads'
From Leads
Group By Datepart(WW, RecordDate)
Go
	--Active Leads
	Create View [Active Leads]
	As
Select JobTitle, CompanyName, (ContactFirstName + ' ' + ContactLastName) 'Contact',
Con.Phone, Con.Email, Datediff(Day, ModifiedDate, getdate()) 'Days Since Last Update'
From Leads L
Inner Join Companies C
On L.CompanyID = C.CompanyID
Inner Join Contacts Con
On L.ContactID = Con.ContactID
Where Datediff(Day, ModifiedDate, getdate()) >= 7
Go

	--Number of leads by Source.
	Create View [Number of leads by Source]
	As
Select Max(SourceName) 'Source', count(LeadID) 'Number of Leads'
From Leads L
Inner Join Sources S
On L.SourceID = S.SourceID
Group By L.SourceID
Go

	--Active Contacts
	Create View [Active Contacts]
	As
Select CompanyName, Agency, CourtesyTitle, ContactFirstName, ContactLastName,
Title, Con.Phone, Extension, Con.Fax, Con.Email, Comments 
From Contacts Con
Inner Join Companies C
On Con.CompanyID = C.CompanyID 
Where Active = 1
Go

	--Call List For Active Leads
	Create View [Call List For Active Leads]
	As
Select CompanyName 'Company', JobTitle 'Job Title', L.[Description], Location, (ContactFirstName + ' ' + ContactLastName) 'Contact',
C.Phone, C.Email, DateDiff(Day,ModifiedDate,Getdate()) 'Days Since Last Update'
From Leads L
Inner Join Contacts C
On C.ContactID = L.ContactID
Inner Join Companies Comp
On Comp.CompanyID = L.CompanyID
Go

	--Search Log
	Create View [Search Log]
	As
Select ActivityDate 'Activity Date', ActivityType 'Activity Type', JobTitle 'Job Title', 
CompanyName 'Company', Complete, Datediff(Day, ActivityDate, getdate()) 'Days Since The Last Activity'
From Activities A
Inner Join Leads L
On A.LeadID = L.LeadID
Inner Join Companies C
On C.CompanyID = L.LeadID
Where Datediff(Day, ActivityDate, getdate()) < 30
Go
	--Lead Report
	Create View [Lead Report]
	As
Select RecordDate 'Recorded Date', JobTitle 'Job Title', L.[Description], EmploymentType 'Employment Type', 
Location, L.Active, CompanyName 'Company', AgencyID, (ContactFirstName + ' ' + ContactLastName) 'Contact', Title,
Con.Phone, Con.Email, SourceName 'Source'
From Leads L
Inner Join Companies C
On L.CompanyID = C.CompanyID
Inner Join Contacts Con
On Con.ContactID = L.ContactID
Inner Join Sources S
On S.SourceID = L.SourceID
Go
