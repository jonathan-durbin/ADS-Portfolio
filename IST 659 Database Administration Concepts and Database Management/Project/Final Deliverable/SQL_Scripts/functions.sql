/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/


-- Get person's record by first name / last name / DOB
CREATE OR ALTER FUNCTION dbo.SearchPerson (
	@PersonID int = NULL,
	@FirstName varchar(30) = NULL,
	@LastName varchar(30) = NULL,
	@DateOfBirth datetime = NULL
	) 
	RETURNS @returnPerson TABLE (
		PersonID int,
		FirstName varchar(30),
		LastName varchar(30),
		Job varchar(100),
		PhysicalDescription varchar(100),
		DateOfBirth datetime,
		Religion varchar(50),
		DriversLicenseNumber varchar(20),
		AddressLine1 varchar(30),
		AddressLine2 varchar(30),
		AddressCity varchar(30),
		AddressState varchar(30),
		AddressZipCode varchar(30),
		PhoneNumber varchar(10),
		FingerPrintInfo varchar(100)
	) 
AS
BEGIN
	INSERT INTO @returnPerson
	SELECT * FROM Person
	WHERE 
		PersonID = @PersonID OR
		FirstName = @FirstName OR
		LastName = @LastName OR
		DateOfBirth = @DateOfBirth
	RETURN
END
GO

-- Get warrants for a person (connected to dbo.SearchPerson)
CREATE OR ALTER FUNCTION SearchCriminalWarrants (
	@PersonID int = NULL,
	@FirstName varchar(30) = NULL,
	@LastName varchar(30) = NULL,
	@DateOfBirth datetime = NULL
	) 
	RETURNS @returnWarrants TABLE (
		WarrantID int,
		SuspectID int,
		JudgeID int,
		DateReceived datetime
	)
AS
BEGIN
	-- List of person ID's
	DECLARE @person TABLE (
		p_id int
	)
	-- Fill with values from dbo.SearchPerson function
	INSERT INTO @person 
		SELECT PersonID 
		FROM dbo.SearchPerson(
			default,
			@FirstName,
			@LastName,
			@DateOfBirth
		)

	INSERT INTO @returnWarrants
	SELECT * 
	FROM Warrant
	WHERE 
		SuspectID = @PersonID OR
		SuspectID IN (SELECT * FROM @person)
	RETURN
END
GO


-- Total Number of People
CREATE OR ALTER FUNCTION dbo.TotalPeople ()
RETURNS int AS
BEGIN
	DECLARE @returnValue int
	SELECT @returnValue = COUNT(PersonID) FROM Person
	RETURN @returnValue
END
GO


-- Look up a person's address given their ID
CREATE OR ALTER FUNCTION dbo.GetPersonAddress (@PersonID int)
RETURNS varchar(150) AS
BEGIN
	DECLARE @returnValue varchar(150)
	SELECT 
		@returnValue = CONCAT(
			AddressLine1, ' ',
			AddressLine2, ' ',
			AddressCity, ', ',
			AddressState, ' ',
			AddressZipCode
		) 
	FROM Person 
	WHERE PersonID = @PersonID

	RETURN @returnValue
END
GO
