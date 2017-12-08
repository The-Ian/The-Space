
USE master;
if (select count(*) 
    from sys.databases where name = 'TheLibrary') > 0
BEGIN
	DROP DATABASE TheLibrary;
END

Create Database TheLibrary;
GO

Use TheLibrary


Go
Create Table Publishers
(	PubID int Not Null Identity(1,1),
	Name Varchar(50) Not Null,
	AddressLine Varchar(50) Not Null,
	City Varchar(50) Not Null,
	[State] Varchar(50),
	ZIP Varchar(10) Not Null,
	CONSTRAINT pk_Publishers PRIMARY KEY (PubID)
)

CREATE UNIQUE INDEX indx_pubID
ON Publishers (PubID);
CREATE INDEX indx_pubstuff
ON Publishers (Name, AddressLine, City)

Go
Create Table Titles
(	TitleID int Not Null Identity(1,1),
	Title Varchar(30) Not Null,
	Subtitle Varchar(30) Not Null,
	TitleDesc text Not Null,
	PubID int Not Null,
	PubDate Date Not Null,
	Genre Varchar(30) Not Null,
	CONSTRAINT pk_Titles PRIMARY KEY (TitleID),
	CONSTRAINT fk_Titles_Publishers FOREIGN KEY (PubID) REFERENCES Publishers(PubID)
)
Go
Create Table Authors
(	au_id int Not Null Identity(1,1),
	FName Varchar(30) Not Null,
	LName Varchar(30) Not Null,
	AddressLine1 Varchar(30) Not Null,
	AddressLine2 Varchar(30),
	City Varchar(50) Not Null,
	[State] Varchar(50),
	Country Varchar(50) Not Null,
	ZIP Varchar(10) Not Null,
	Phone Varchar(15) Not Null,
	TitleID Int Not Null,
	CONSTRAINT pk_Authors PRIMARY KEY (au_id),
	CONSTRAINT fk_Authors_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID)
)
Go
Create Table Books
(	ISBN int Not Null Identity(1,1),
	Invoice# int Not Null,
	TitleID int Not Null,
	Available bit,
	CONSTRAINT pk_Books PRIMARY KEY (ISBN),
	CONSTRAINT fk_Books_TitleAuthor FOREIGN KEY (TitleID) REFERENCES Titles(TitleID)
)
Go
Create Table Jobs
(	JobID int Not Null Identity(1,1),
	JobTitle Varchar(50) Not Null,
	JobDesc Text,
	CONSTRAINT pk_Jobs PRIMARY KEY (JobID)
)

CREATE UNIQUE INDEX indx_jobID
ON Jobs (JobID);
CREATE INDEX indx_jobtitle
ON Jobs (JobTitle)

Go
Create Table Employees
(	EmpID int Not Null Identity(1,1),
	Fname Varchar(30) Not Null,
	Lname Varchar(30) Not Null,
	HireDate Date Not Null,
	AddressLine1 Varchar(50) Not Null,
	AddressLine2 Varchar(50),
	City Varchar(50) Not Null,
	[State] Varchar(50),
	Country Varchar(50) Not Null,
	ZIP Varchar(10) Not Null,
	Phone Varchar(15) Not Null,
	JobID int Not Null,
	ModifiedDate Date,
	ModifiedBy Varchar(60)
	CONSTRAINT pk_Employees PRIMARY KEY (EmpID),
	CONSTRAINT fk_Employees_Jobs FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
)
GO
Create Trigger [dbo].[TrgEmployeesModified]
On [dbo].[Employees]
After Update
As
Begin
 Update E
 Set			E.ModifiedDate = GETDATE(),
				E.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Employees E
	INNER JOIN	inserted i
	ON			i.EmpID = E.EmpID
End

Go
Create Table Members
(	MemberID int Not Null Identity(1,1),
	Fname Varchar(30) Not Null,
	Lname Varchar(30) Not Null,
	LabCard# int,
	BirthDate Date Not Null,
	Restricted Bit Not Null,
	AddressLine1 Varchar(50) Not Null,
	AddressLine2 Varchar(50),
	City Varchar(50) Not Null,
	[State] Varchar(50),
	Country Varchar(50) Not Null,
	ZIP Varchar(15) Not Null,
	Phone Varchar(15) Not Null,
	CONSTRAINT pk_Members PRIMARY KEY (MemberID)
	
)
Go
Create Table Fees
(	FeeID int Not Null Identity(1,1),
	Check_Out DateTime Not Null,
	Check_In DateTime,
	DueDate DateTime Not Null,
	OverdueFees Money,
	Condition bit Not Null,
	DamageFees Money,
	MemberID int Not Null,
	EmpID int Not Null,
	CONSTRAINT pk_Fees PRIMARY KEY (FeeID),
	CONSTRAINT fk_Fees_Employees FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
	CONSTRAINT fk_Fees_Members FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
)
Go
Create Table Magazines
(	MagID int Not Null Identity(1,1),
	Publisher Varchar(50) Not Null,
	Issue Varchar(10) Not Null,
	Name Varchar(75) Not Null,
	MagDesc Text Not Null,
	Available bit,
	Primary Key (MagID)
)
Go
Create Table Media
(	MediaID Int Not Null Identity(1,1),
	Name Varchar(75) Not Null,
	MediaDesc Text Not Null,
	Genre Varchar(50) Not Null,
	Available bit,
	Primary Key (MediaID)
)
Go
Create Table Music
(	MusicID int Not Null Identity(1,1),
	CD Varchar(50) Not Null,
	Artist Varchar(75) Not Null,
	Available bit,
	Primary Key (MusicID)
)

Insert Into Publishers
(Name, AddressLine, City, [State], ZIP)
Values
('Shueisha', '1925 Shonen Jumnp Drive', 'Chiyoda', 'Tokyo', '67571')

Insert Into Publishers
(Name, AddressLine, City, [State], ZIP)
Values
('DC Comics', '32 Action Comics Pine', 'Burbank', 'Californa', '78455')

Insert Into Publishers
(Name, AddressLine, City, [State], ZIP)
Values
('Marvel Comics', '39 Amazing Fantasy Peak', 'New York City', 'New York', '74452')

Print 'Publishers Inserted'

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Dragon Ball Z', 'Cell Saga', 'Aliquam augue quam, sollicitudin vitae, 
consectetuer eget, rutrum at, lorem.', 
1, '04-27-1984', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('One Piece', 'Marineford War', 'Vestibulum ante ipsum primis in faucibus orci 
luctus et ultrices posuere cubilia Curae; 
Duis faucibus accumsan odio. 
Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. 
Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, 
rhoncus sed, vestibulum sit amet, cursus id, turpis. 
Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, 
vel accumsan tellus nisi eu orci.', 
1, '06-15-1988', 'Shonen/Adventure')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Bleach', 'The Espada Arc', 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. 
Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. 
Sed accumsan felis. Ut at dolor quis odio consequat varius.', 
1, '01-01-1995', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Naruto', 'The 4th Great Ninja War', 'Suspendisse ornare consequat lectus. In est risus, 
auctor sed, tristique in, tempus sit amet, sem.', 
1, '08-03-1991', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('X-Men', 'House of M', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. 
Sed accumsan felis. Ut at dolor quis odio consequat varius. 
Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. 
Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, 
a suscipit nulla elit ac nulla.', 
3, '10-06-2010', 'Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Captain America', 'The First Avenger', 'Phasellus in felis. Donec semper sapien a libero. 
Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 
3, '09-10-1988', 'Shonen/Fantasy')


('Batman', 'The Dark Knight Returns', 'Maecenas tristique, est et tempus semper, 
est quam pharetra magna, ac consequat metus sapien ut nunc. 
Vestibulum ante ipsum primis in faucibus orci luctus et 
ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. 
Suspendisse potenti. Nullam porttitor lacus at turpis.', 
2, '12-25-1988', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Game of Thrones', 'Fire and Ice', 'Duis bibendum, felis sed interdum venenatis, 
turpis enim blandit mi, in porttitor pede justo eu massa. 
Donec dapibus. Duis at velit eu est congue elementum. 
In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, 
diam erat fermentum justo, nec condimentum neque sapien placerat ante.', 
2, '07-01-1988', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('Hunter X Hunter', 'The Hunter Association', 'Nam congue, risus semper porta volutpat, 
quam pede lobortis ligula, sit amet eleifend pede libero quis orci. 
Nullam molestie nibh in lectus. Pellentesque at nulla.', 
1, '05-20-1988', 'Shonen/Fantasy')

Insert Into Titles
(Title, Subtitle, TitleDesc, PubID, PubDate, Genre)
Values
('JoJo''s Bizzare Adventure', 'Battle Tendency', 'Pellentesque at nulla. Suspendisse potenti. 
Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient 
montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et 
magnis dis parturient montes, nascetur ridiculus mus.', 
1, '02-14-1985', 'Shonen/Fantasy')

Print 'Titles Inserted'

Insert Into Authors
(FName, LName, AddressLine1, City, Country, ZIP, Phone, TitleID)
Values
('Akira', 'Toriyama', '88 Genki Dama 30th Drive', 'Tokyo', 'Japan', '75145', '(352) 785-7813', 1)

Insert Into Authors
(FName, LName, AddressLine1, City, Country, ZIP, Phone, TitleID)
Values
('Eichiro', 'Oda', '425th Marineford', 'Kyoto', 'Japan', '13274', '(352) 412-6897', 2)

Insert Into Authors
(FName, LName, AddressLine1, City, Country, ZIP, Phone,TitleID)
Values
('Tite', 'Kubo', 'Spirit NW Bankai Ave.', 'Saitama', 'Japan', '64478', '(352) 654-7155', 3)

Insert Into Authors
(FName, LName, AddressLine1, City, Country, ZIP, Phone, TitleID)
Values
('Masashi', 'Kishimoto', 'Hashirama SR', 'Hokage', 'Japan', '65515', '(352) 126-0297', 4)

Insert Into Authors
(FName, LName, AddressLine1, City, [State], Country, ZIP, Phone, TitleID)
Values
('Stan', 'Lee', '1960 S Marvel St.', 'New York City','New York', 'USA', '48120', '(352) 642-8972', 5)

Insert Into Authors
(FName, LName, AddressLine1, City, [State], Country, ZIP, Phone, TitleID)
Values
('Jack', 'Kirby', '40 Captain America Rd.', 'Orlando','Florida', 'USA', '98423', '(352) 785-7813', 6)

Insert Into Authors
(FName, LName, AddressLine1, City, [State], Country, ZIP, Phone, TitleID)
Values
('Mark', 'Miller', '784 Wayne St.', 'Queens', 'New York', 'USA', '75641', '(352) 975-4123', 7) 

Insert Into Authors
(FName, LName, AddressLine1, City, [State], Country, ZIP, Phone, TitleID)
Values
('George', 'Martin', '894 White Walker Cir.', 'Chicago', 'Illinois','USA', '68895', '(352) 462-7511', 8)

Insert Into Authors
(FName, LName, AddressLine1, City, Country, ZIP, Phone, TitleID)
Values
('Yoshihiro', 'Togashi', 'World Tree Rd.', 'Meteor City', 'Japan', '31147', '(352) 984-4515', 9)

Insert Into Authors
(FName, LName, AddressLine1, City, [State], Country, ZIP, Phone, TitleID)
Values
('Horohiko', 'Araki', '74 JoJos Bizzare Blvd.', 'Boston','Massachusetts', 'USA', '21235', '(352) 714-6234', 10)

Print 'Authors Inserted'



Insert Into Jobs
(JobTitle, JobDesc)
Values
('Librarian', 'Management of staff, including recruitment, 
training and/or supervisiory duties; 
Selecting, developing, 
cataloguing and classifying library resources; Managing budgets and resources;
Promoting the library''s resources to users, etc.')

Insert Into Jobs
(JobTitle, JobDesc)
Values
('Janitor', 'Clean building floors by sweeping, mopping, scrubbing, or vacuuming them; 
Make adjustments and minor repairs to heating, cooling, ventilating, plumbing, and electrical systems; 
Move heavy furniture, equipment, and supplies, either manually or by using hand trucks, etc.')

Insert Into Jobs
(JobTitle, JobDesc)
Values
('Library Assistant', 'He or she helps patrons select materials 
but refers requests for more in-depth research to librarians; 
Check in and out material at the circulation desk; 
Receive payments for fines; 
shelve books when patrons return them and help process new material; 
They are also called library clerks, library technical assistants and library circulation assistants.')

Print 'Jobs Inserted'

Insert Into Magazines
(Publisher, Issue, Name, MagDesc)
Values
('Time Inc', '#549', 'Year of the Snake; Who not to Trust in the Office.', 'Nullam varius. Nulla facilisi. 
Cras non velit nec nisi vulputate nonummy. 
Maecenas tincidunt lacus at velit. 
Vivamus vel nulla eget eros elementum pellentesque.')

Insert Into Magazines
(Publisher, Issue, Name, MagDesc)
Values
('National Geographic Society', '#200', 'Lions, Tigers and Bears! Oh my.', 'Nulla justo. 
Aliquam quis turpis eget elit sodales scelerisque. 
Mauris sit amet eros. 
Suspendisse accumsan tortor quis turpis.')

Insert Into Magazines
(Publisher, Issue, Name, MagDesc)
Values
('Outdoor Sportsman', '#20', 'Shooting Times', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. 
Cum sociis natoque penatibus et magnis dis parturient montes,
nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.')

Print 'Magazines Inserted'

Insert Into Media
(Name, MediaDesc, Genre)
Values
('Matrix', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. 
In est risus, auctor sed, tristique in, tempus sit amet, sem. 
Fusce consequat. Nulla nisl.', 'Action|Sci-Fi|Thriller')

Insert Into Media
(Name, MediaDesc, Genre)
Values
('Saving Private Ryan', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Action|Drama|War')

Insert Into Media
(Name, MediaDesc, Genre)
Values
('Chronicle', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, 
ac consequat metus sapien ut nunc. 
Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; 
Mauris viverra diam vitae quam.	', 'Action|Fantasy|Dark')

Insert Into Media
(Name, MediaDesc, Genre)
Values
('Horton Hears A Who', 'In est risus, auctor sed, tristique in, 
tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. 
Duis bibendum, felis sed interdum venenatis, 
turpis enim blandit mi, in porttitor pede justo eu massa.', 'Animation|Family Friendly|Comedy')

Insert Into Media
(Name, MediaDesc, Genre)
Values
('Spirited Away', 'One of Studio Ghibli''s Finest animated movies.', 'Animation|Fantasy|Foreign')

Print 'Media Inserted'

Insert Into Music
(CD, Artist)
Values
('TPAB', 'Kendrick Lamar')

Insert Into Music
(CD, Artist)
Values
('Beethoven''s 5th Symphony', 'Beethoven')

Insert Into Music
(CD, Artist)
Values
('Puppet Master', 'Metallica')

Insert Into Music
(CD, Artist)
Values
('Johnny Cash''s Greatest Hits', 'Johnny Cash')

Insert Into Music
(CD, Artist)
Values
('Disturbia', 'Green Day')

Insert Into Music
(CD, Artist)
Values
('Queen''s Greatest Hits', 'Queen')

Print 'Music Inserted'

Insert Into Employees
(Fname, Lname, HireDate, AddressLine1, City, [State], Country, ZIP, Phone, JobID)
Values
('Ian', 'McKiver', '11-10-2017', '1577 Knutson Park.', 'Ocala','Florida', 'USA', '34122', '(352) 715-4263', 1)

Insert Into Employees
(Fname, Lname, HireDate, AddressLine1, City, [State], Country, ZIP, Phone, JobID)
Values
('Arthur', 'Wright', '11-11-2017', '65 Forest Terrace', 'Ocala','Florida', 'USA', '34122', '(352) 032-1210', 3)

Insert Into Employees
(Fname, Lname, HireDate, AddressLine1, City, [State], Country, ZIP, Phone, JobID)
Values
('Todd', 'Mills', '11-20-2017', '482 Lakeland Trail', 'Ocala','Florida', 'USA', '34122', '(352) 156-2301', 3)

Insert Into Employees
(Fname, Lname, HireDate, AddressLine1, City, [State], Country, ZIP, Phone, JobID)
Values
('Hope', 'Demotropulous', '11-25-2017', '1997 Sugar Lane', 'Ocala','Florida', 'USA', '34122', '(352) 151-6596', 3)

Insert Into Employees
(Fname, Lname, HireDate, AddressLine1, City, [State], Country, ZIP, Phone, JobID)
Values
('Garret', 'Landreth', '11-29-2017', '02 Kingsford Point', 'Ocala','Florida', 'USA', '34122', '(352) 253-4566', 2)

Print 'Employees Inserted'


 Insert Into Members
 (Fname, Lname, BirthDate, Restricted, AddressLine1, City, State, Country, ZIP, Phone)
Values
  ('James', 'Cordette', '10-7-1976', 0, '21888 Northport Plaza', 'Ocala', 'FL', 'USA', 23293, '(804) 864-5180')

Insert Into Members
 (Fname, Lname, BirthDate, Restricted, AddressLine1, City, State, Country, ZIP, Phone)
Values
  ('Merrin', 'Kending', '10-7-1985', 1, '3680 Center Place', 'Ocala', 'FL', 'USA', 20709, '(591) 425-5884')

Insert Into Members
 (Fname, Lname, BirthDate, Restricted, AddressLine1, City, State, Country, ZIP, Phone)
Values
  ('Harold', 'Smith', '10-7-1960', 0, '43927 Homewood Way', 'Ocala', 'FL', 'USA', 90020, '(352) 751-1524')

Insert Into Members
 (Fname, Lname, BirthDate, Restricted, AddressLine1, City, State, Country, ZIP, Phone)
Values
  ('Alice', 'Tetch', '10-7-1990', 0, '64 Marcy Center', 'Ocala', 'FL', 'USA', 10469, '(454) 110-9623')

Insert Into Members
 (Fname, Lname, BirthDate, Restricted, AddressLine1, City, State, Country, ZIP, Phone)
Values
  ('Quentin', 'Quire', '10-7-1995', 2, '526 Toban Terrace', 'Ocala', 'FL', 'USA', 71130, '(600) 789-3032')

  Print 'Members Inserted'

  Insert Into Fees
 (Check_Out, Check_In, DueDate, OverdueFees, Condition, DamageFees, MemberID, EmpID)
Values
  ('05-05-17', '05-12-17', '05-15-17', 0, 1, 0, 1, 2)

Insert Into Fees
 (Check_Out, Check_In, DueDate, OverdueFees, Condition, DamageFees, MemberID, EmpID)
Values
  ('07-20-17', '08-01-17', '07-30-17', 0.50, 2, 0, 2, 2)

Insert Into Fees
 (Check_Out, Check_In, DueDate, OverdueFees, Condition, DamageFees, MemberID, EmpID)
Values
  ('09-12-17', '09-16-17', '09-22-17', 0, 1, 0, 3, 4)

Insert Into Fees
 (Check_Out, Check_In, DueDate, OverdueFees, Condition, DamageFees, MemberID, EmpID)
Values
  ('04-01-17', '04-10-17', '04-11-17', 0, 1, 0, 4, 3)

Insert Into Fees
 (Check_Out, Check_In, DueDate, OverdueFees, Condition, DamageFees, MemberID, EmpID)
Values
  ('06-10-17', '06-30-17', '06-20-17', 2.50, 3, 30.00, 5, 2)

Print 'Fees Inserted'

Insert Into Books 
(Invoice#, TitleID, Available)
Values
( 1, 1, 1)

Insert Into Books 
(Invoice#, TitleID, Available)
Values
( 2, 2, 0)

Insert Into Books 
(Invoice#, TitleID, Available)
Values
( 3, 3, 1)

Print 'Books Inserted'