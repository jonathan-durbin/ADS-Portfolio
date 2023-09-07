/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/

-- View: All Vehicles
-- View: All Weapons / Assigned Vehicle
-- View: All reports
-- View: All Warrants


CREATE OR ALTER VIEW AllVehicles AS
	SELECT *
	FROM Vehicle
GO

CREATE OR ALTER VIEW AllVehiclesWeapons AS
	SELECT 
		Vehicle.VehicleID,
		Weapon.WeaponRegistration,
		Weapon.WeaponName,
		Vehicle.VehicleNumber,
		Vehicle.VehicleRegistration,
		Vehicle.License
	FROM Vehicle
	LEFT JOIN Weapon ON Vehicle.VehicleID = Weapon.VehicleID
	WHERE WeaponRegistration IS NOT NULL AND WeaponName IS NOT NULL
GO


CREATE OR ALTER VIEW AllReports AS
	SELECT 
		Report.ReportID,
		Report.ReportType,
		Person.PersonID AS PersonResponsibleID,
		Person.FirstName AS PersonResponsibleFirstName,
		Person.LastName AS PersonResponsibleLastName,
		ReportSubject.SubjectFirstName,
		ReportSubject.SubjectLastName,
		ReportLocation.LocationDescription,
		Weapon.WeaponName,
		Weapon.WeaponRegistration,
		Vehicle.VehicleNumber AS RespondingVehicle,
		Report.Content
	FROM Report
	LEFT JOIN ReportLocation ON ReportLocation.ReportID = Report.ReportID
	LEFT JOIN ReportSubject ON ReportSubject.ReportID = Report.ReportID
	LEFT JOIN VehicleReport ON VehicleReport.ReportID = Report.ReportID
		LEFT JOIN Vehicle ON VehicleReport.VehicleID = Vehicle.VehicleID
	LEFT JOIN WeaponReport ON WeaponReport.ReportID = Report.ReportID
		LEFT JOIN Weapon ON WeaponReport.WeaponID = Weapon.WeaponID
	LEFT JOIN PersonReport ON PersonReport.ReportID = Report.ReportID
		LEFT JOIN Person ON PersonReport.PersonID = Person.PersonID
GO

CREATE OR ALTER VIEW AllWarrants AS
	SELECT 
		WarrantID,
		CONVERT(varchar(20), CONVERT(date, DateReceived)) AS DateReceived,
		JudgeID,
		CONCAT(Judge.FirstName, ' ', Judge.Lastname) AS [Judge Name],
		SuspectID, 
		CONCAT(Suspect.FirstName, ' ', Suspect.Lastname) AS [Suspect Name],
		Suspect.Job, 
		Suspect.PhysicalDescription, 
		Suspect.DateOfBirth, 
		Suspect.Religion, 
		Suspect.DriversLicenseNumber,
		dbo.GetPersonAddress(Suspect.PersonID) AS [Suspect Address],
		Suspect.PhoneNumber,
		Suspect.FingerPrintInfo
	FROM Warrant
	JOIN Person as Judge
	ON Warrant.JudgeID = Judge.PersonID
	JOIN Person as Suspect
	ON Warrant.SuspectID = Suspect.PersonID
GO