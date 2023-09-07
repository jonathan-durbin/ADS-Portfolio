/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/

/*
Procedures:
	Update a report
	Create a new report
	Update a Person's record
	Create a new Person record
	Add a new vehicle
	Add a new weapon
	Add a new warrant
	Remove a warrant
*/

-- Function to update a report after it's been written. 
--   (or while it's being written for the first time)
CREATE OR ALTER PROCEDURE UpdateReport(
	@ReportID int,
	@PersonResponsible int,
	@SubjectFirstName varchar(30) = NULL, 
	@SubjectLastName varchar(30) = NULL,
	@Location varchar(100) = NULL,
	@WeaponRegistration varchar(20) = NULL,
	@VehicleNumber varchar(5) = NULL
	) AS
BEGIN
	-- update ReportSubject Table
	IF (@SubjectFirstName IS NOT NULL OR @SubjectLastName IS NOT NULL)
		BEGIN
			DECLARE @s_id int
			-- Assume the firstname, lastname combination for the subject accurately matches
			--   the correct name in the persons database.
			-- This is a naive assumption - some people have the same name.
			SELECT @s_id = PersonID 
			FROM Person 
			WHERE 
				FirstName = @SubjectFirstName AND
				LastName = @SubjectLastName

			INSERT INTO ReportSubject 
				(ReportID, SubjectID, SubjectFirstName, SubjectLastName)
			-- SubjectID could be null, but that's okay. 
			-- Not all people will be in the Person table.
			VALUES 
				(@ReportID, @s_id, @SubjectFirstName, @SubjectLastName)
		END

	-- Update ReportLocation Table
	IF (@Location IS NOT NULL)
		BEGIN
			INSERT INTO ReportLocation
				(ReportID, LocationDescription)
			VALUES 
				(@ReportID, @Location)
		END

	-- Update WeaponReport Table
	IF (@WeaponRegistration IS NOT NULL)
		BEGIN
			DECLARE @w_id int
			SELECT @w_id = WeaponID 
			FROM Weapon 
			WHERE WeaponRegistration = @WeaponRegistration

			INSERT INTO WeaponReport
				(WeaponID, ReportID)
			VALUES
				(@w_id, @ReportID)
		END

	-- Update VehicleReport Table
	IF (@VehicleNumber IS NOT NULL)
		BEGIN
			DECLARE @v_id int
			SELECT @v_id = VehicleID 
			FROM Vehicle 
			WHERE VehicleNumber = @VehicleNumber

			INSERT INTO VehicleReport
				(VehicleID, ReportID)
			VALUES
				(@v_id, @ReportID)
		END

	-- Update PersonReport Table (Person updating the report)
	INSERT INTO PersonReport
		(ReportID, PersonID)
	VALUES
		(@ReportID, @PersonResponsible)
END
GO

-- Create a new report - the user can specify as much information as they have now
--   or come back at a later time and update the report with "UpdateReport"
CREATE OR ALTER PROCEDURE AddReport(
	@Content varchar(500),
	@ReportType varchar(50),
	@Occurred datetime,
	@PersonResponsible int,
	@SubjectFirstName varchar(30) = NULL,
	@SubjectLastName varchar(30) = NULL,
	@Location varchar(100) = NULL,
	@WeaponRegistration varchar(20) = NULL,
	@VehicleNumber varchar(5) = NULL
	) AS
BEGIN
	-- Update the Report table with the body of the report
	INSERT INTO Report (Content, ReportType, Occurred)
	VALUES (@Content, @ReportType, @Occurred)

	DECLARE @s_id int
	SELECT @s_id = SCOPE_IDENTITY()

	-- Update the associative tables with the relevant information
	EXEC UpdateReport
		@ReportID = @s_id,
		@PersonResponsible = @PersonResponsible,
		@SubjectFirstName = @SubjectFirstName,
		@SubjectLastName = @SubjectLastName,
		@Location = @Location,
		@WeaponRegistration = @WeaponRegistration,
		@VehicleNumber = @VehicleNumber
END
GO


-- Update a Person's information
CREATE OR ALTER PROCEDURE UpdatePerson (
	@PersonID int,
	@Job varchar(100) = NULL,
	@PhysicalDescription varchar(100) = NULL,
	@DateOfBirth datetime = NULL,
	@Religion varchar(50) = NULL,
	@DriversLicenseNumber varchar(20) = NULL,
	@AddressLine1 varchar(30) = NULL,
	@AddressLine2 varchar(30) = NULL,
	@AddressCity varchar(30) = NULL,
	@AddressState varchar(30) = NULL,
	@AddressZipCode varchar(30) = NULL,
	@PhoneNumber varchar(10) = NULL,
	@FingerPrintInfo varchar(100) = NULL
	) AS
BEGIN
	-- This seems repetive, but I think I need to check 
	--   each parameter individually
	--   because I don't want to update a row with null values
	--   when it already has non-null values in it.
    IF (@Job IS NOT NULL)
        UPDATE Person SET Job = @Job WHERE PersonID = @PersonID
    IF (@PhysicalDescription IS NOT NULL)
        UPDATE Person SET PhysicalDescription = @PhysicalDescription WHERE PersonID = @PersonID
    IF (@DateOfBirth IS NOT NULL)
        UPDATE Person SET DateOfBirth = @DateOfBirth WHERE PersonID = @PersonID
    IF (@Religion IS NOT NULL)
        UPDATE Person SET Religion = @Religion WHERE PersonID = @PersonID
    IF (@DriversLicenseNumber IS NOT NULL)
        UPDATE Person SET DriversLicenseNumber = @DriversLicenseNumber WHERE PersonID = @PersonID
    IF (@AddressLine1 IS NOT NULL)
        UPDATE Person SET AddressLine1 = @AddressLine1 WHERE PersonID = @PersonID
    IF (@AddressLine2 IS NOT NULL)
        UPDATE Person SET AddressLine2 = @AddressLine2 WHERE PersonID = @PersonID
    IF (@AddressCity IS NOT NULL)
        UPDATE Person SET AddressCity = @AddressCity WHERE PersonID = @PersonID
    IF (@AddressState IS NOT NULL)
        UPDATE Person SET AddressState = @AddressState WHERE PersonID = @PersonID
    IF (@AddressZipCode IS NOT NULL)
        UPDATE Person SET AddressZipCode = @AddressZipCode WHERE PersonID = @PersonID
    IF (@PhoneNumber IS NOT NULL)
        UPDATE Person SET PhoneNumber = @PhoneNumber WHERE PersonID = @PersonID
    IF (@FingerPrintInfo IS NOT NULL)
        UPDATE Person SET FingerPrintInfo = @FingerPrintInfo WHERE PersonID = @PersonID
END
GO

-- Create a new Person record
CREATE OR ALTER PROCEDURE AddPerson (
	@FirstName varchar(30),
	@LastName varchar(30),
	@Job varchar(100) = NULL,
	@PhysicalDescription varchar(100) = NULL,
	@DateOfBirth datetime = NULL,
	@Religion varchar(50) = NULL,
	@DriversLicenseNumber varchar(20) = NULL,
	@AddressLine1 varchar(30) = NULL,
	@AddressLine2 varchar(30) = NULL,
	@AddressCity varchar(30) = NULL,
	@AddressState varchar(30) = NULL,
	@AddressZipCode varchar(30) = NULL,
	@PhoneNumber varchar(10) = NULL,
	@FingerPrintInfo varchar(100) = NULL
	) AS
BEGIN
    INSERT INTO Person (FirstName, LastName)
    VALUES (@FirstName, @LastName)

	DECLARE @s_id int
	SELECT @s_id = SCOPE_IDENTITY()

	-- Fill in the rest of the information as provided (if provided)
	EXEC UpdatePerson
		@PersonID = @s_id,
		@Job = @Job,
		@PhysicalDescription = @PhysicalDescription,
		@DateOfBirth = @DateOfBirth,
		@Religion = @Religion,
		@DriversLicenseNumber = @DriversLicenseNumber,
		@AddressLine1 = @AddressLine1,
		@AddressLine2 = @AddressLine2,
		@AddressCity = @AddressCity,
		@AddressState = @AddressState,
		@AddressZipCode = @AddressZipCode,
		@PhoneNumber = @PhoneNumber,
		@FingerPrintInfo = @FingerPrintInfo
END
GO


-- Add new vehicle
CREATE OR ALTER PROCEDURE AddVehicle (
	@VehicleNumber varchar(5),
	@Registration varchar(20),
	@License varchar(10)
	) AS
BEGIN
	INSERT INTO Vehicle (VehicleNumber, VehicleRegistration, License)
	VALUES (@VehicleNumber, @Registration, @License)
END
GO


-- Add new weapon
CREATE OR ALTER PROCEDURE AddWeapon (
	@VehicleID int = NULL,
	@Registration varchar(20),
	@WeaponName varchar(30)
	) AS
BEGIN
	IF (@VehicleID IS NULL) 
	BEGIN
		INSERT INTO Weapon (WeaponRegistration, WeaponName)
		VALUES (@Registration, @WeaponName)
	END
	ELSE
	BEGIN
		INSERT INTO Weapon (VehicleID, WeaponRegistration, WeaponName)
		VALUES (@VehicleID, @Registration, @WeaponName)
	END
END
GO


-- Add a new warrant
CREATE OR ALTER PROCEDURE AddWarrant (
	@SuspectID int,
	@JudgeID int,
	@DateReceived datetime
	) AS
BEGIN
	INSERT INTO Warrant (SuspectID, JudgeID, DateReceived)
	VALUES (@SuspectID, @JudgeID, @DateReceived)
END
GO

-- Remove a warrant
CREATE OR ALTER PROCEDURE RemoveWarrant (
	@WarrantID int
	) AS
BEGIN
	DELETE FROM Warrant
	WHERE WarrantID = @WarrantID
END
GO

