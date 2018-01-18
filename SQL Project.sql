Select E.BusinessEntityID, LastName 'Last Name', FirstName 'First Name', Gender, JobTitle 'Job Title', HireDate 'Hire Date'
Into #TempEmployee
From HumanResources.Employee E
Inner Join Person.Person P
On E.BusinessEntityID = P.BusinessEntityID
Order By [Hire Date] Desc

Select *
From #TempEmployee



Select EPH.BusinessEntityID, Max(RateChangeDate) 'Rate Change Date', Max(Rate) 'Rate'
Into #TempEmployeePayHistory 
From HumanResources.EmployeePayHistory EPH
Inner Join HumanResources.Employee E 
On E.BusinessEntityID = EPH.BusinessEntityID
Where CurrentFlag <> 0
Group By EPH.BusinessEntityID

Select * From #TempEmployeePayHistory
 
 Select [Last Name] + ',' + ' ' + [First Name] 'Employee', 
		Gender, [Job Title], Rate, [Rate Change Date]
 From #TempEmployee E
 Inner Join #TempEmployeePayHistory EPH
 On E.BusinessEntityID = EPH.BusinessEntityID
 


 Declare RecentPurchaseOrders  Cursor Static Scroll 
  For Select Top 25 * From Purchasing.PurchaseOrderHeader Order By PurchaseOrderID Desc

  Open RecentPurchaseOrders
  
  Fetch First From RecentPurchaseOrders
  
  While @@FETCH_STATUS = 0 
	
	Begin 
		Fetch Next From RecentPurchaseOrders
	End
  Close RecentPurchaseOrders
  Deallocate RecentPurchaseOrders


  Update Purchasing.PurchaseOrderHeader
  Set RevisionNumber = 5
  Where PurchaseOrderID = 4012



 Alter Table Sales.SalesOrderHeader
 Drop Constraint [DF_SalesOrderHeader_OrderDate]

 
 Select Top 20000 Concat(AddressLine1, ',' , AddressLine2, ',' , ' ' ,City , ',' , ' ' , SP.Name , ',' , ' ' , CR.Name)
 From Person.[Address] A
 Inner Join Person.StateProvince SP
 On SP.StateProvinceID = A.StateProvinceID
 Inner Join Person.CountryRegion CR
 On CR.CountryRegionCode = SP.CountryRegionCode
 
Alter Function Person.fnFullAddress (@PersonID Int)
 Returns Varchar(Max)
 As
 Begin
 Declare @PersonAddress Varchar(Max)

 Set @PersonAddress =(Select Concat(AddressLine1, ',', AddressLine2,  ',', ' ', City, ',', ' ' , SP.Name,  ',' , ' ' , CR.Name)
 From Person.[Address] A
 Inner Join Person.StateProvince SP
 On SP.StateProvinceID = A.StateProvinceID
 Inner Join Person.CountryRegion CR
 On CR.CountryRegionCode = SP.CountryRegionCode
 Inner Join Person.BusinessEntityAddress BEA
 On BEA.AddressID = A.AddressID
 Inner Join Person.Person P
 On P.BusinessEntityID = BEA.BusinessEntityID
 Where P.BusinessEntityID = @PersonID)

 Return @PersonAddress
 End

 Select Top 2000 Person.fnFullAddress(P.BusinessEntityID), P.BusinessEntityID
 From Person.Person P
 Order By P.BusinessEntityID