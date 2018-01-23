if Object_ID ('dbo.fnCardExpFinder') > 0
BEGIN
	DROP Function dbo.fnCardExpFinder;
END

Go
Create Function fnCardExpFinder
	(
		@Cardnumber As BigInt
	)
	Returns Date
	As
	Begin 
	Declare @Eom Date

	Set @Cardnumber = (Select Cardnumber from Sales.CreditCard Where CardNumber = @Cardnumber)

	Declare @ExpYY Int
	Set @ExpYY = (Select ExpYear From Sales.CreditCard Where CardNumber = @Cardnumber)

	Declare @ExpMM Int
	Set @ExpMM = (Select ExpMonth From Sales.CreditCard Where CardNumber = @Cardnumber)

	Set @Eom = Eomonth(DateFromParts(@ExpYY,@ExpMM,1))
	Return @Eom
		End

		--Select CreditcardID, CardType, dbo.fnCardExpFinder(CardNumber) From Sales.CreditCard
		

Go
		if Object_ID ('dbo.fnTaxRateReturn') > 0
BEGIN
	DROP Function dbo.fnTaxRateReturn;
END

Go
Create Function fnTaxRateReturn 
	(
		@StateProvID Int, @TaxTypeID TinyInt
	)
	Returns SmallMoney
	As
	Begin
	Declare @Taxrate smallmoney

	Set @Taxrate = (Select Taxrate From Sales.SalesTaxRate Where StateProvinceID = @StateProvID and TaxType = @TaxTypeID)
	If @Taxrate is null
		Begin
		Set @Taxrate = 0
		End
	Return @Taxrate
	End

		 
Go

if Object_ID ('dbo.fnInchesToCentimeters') > 0
BEGIN
	DROP Function dbo.fnInchesToCentimeters;
END

Go
Create Function fnInchesToCentimeters
	(
	 @Inch As Decimal(10,2)
	)
	Returns Decimal(10,2)
	As
	Begin
	Return (@Inch * 2.54)
	End

--Select dbo.fnInchsToCentimeters(1)
Go
if Object_ID ('dbo.fnGallonsToLiters') > 0
BEGIN
	DROP Function dbo.fnGallonsToLiters;
END

Go
Create Function fnGallonsToLiters
	(
	 @Gallon As Decimal(10,2)
	)
	Returns Decimal(10,2)
	As
	Begin
	Return (@Gallon * 3.78541)
	End

--Select Dbo.fnGallonsToLiters(1)

Go
if Object_ID ('dbo.fnPoundsToKilos') > 0
BEGIN
	DROP Function dbo.fnPoundsToKilos;
END

Go
Create Function fnPoundsToKilos
	(
	 @Pound As Decimal(10,2)
	)
	Returns Decimal(10,2)
	As
	Begin
	Return (@Pound * 0.453592)
	End

--Select Dbo.fnPoundsToKilos(1)
