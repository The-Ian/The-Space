/*
Create Function  fnProdName	(@CertainProduct Varchar(Max))
Returns Table
As
Return
	Select	ProductID, 
			Name, 
			ProductNumber 
	From Production.Product	
	Where Name Like @CertainProduct


	Select	ProductID, Name, ProductNumber 
	From dbo.fnProdName('%Tube%')


Create Function fnNumberOfOrders (@Number Int)
Returns Table
As
Return

	Select Top (@Number) SalesOrderID, [Status], OrderDate 
	From Sales.SalesOrderHeader 
	Order By OrderDate Desc

	Select SalesOrderID, [Status], OrderDate
	From Dbo.fnNumberOfOrders(40)


Create Function  fnPeopleWithSamePhone	(@PhoneNumb Varchar(Max))
Returns Table
As
Return

	Select	FirstName, 
			LastName, 
			PhoneNumber
	From Person.PersonPhone PH
	Inner Join Person.Person P
	On PH.BusinessEntityID = P.BusinessEntityID
	Where PhoneNumber Like '%' + @PhoneNumb + '%'


	Select Concat(FirstName, ' ', LastName) 'Person', PhoneNumber 'Phone Number'
	From dbo.fnPeopleWithSamePhone(235)
*/


Create Function fnPrime (@StartNumber Int , @PrimeCount BigInt)
Returns Table
As
Returns
Declare @Number Int = @StartNumber
Declare @Count Int = 1
Declare @Limit Int = 1000
Declare @Prime Bit = 1

While @Number <= @Limit
	Begin 
	While @Count !> Sqrt(@Number)
		Begin

		If (@Number % @Count = 0)
			Begin
				Set @Prime = 0
				Break
			End
		Set @Count = @Count + 1
		End

	If @Prime != 0
		Print @Number

	Set @Number = @Number + 1
	Set @Prime = 1
	Set @Count = 2
	End
