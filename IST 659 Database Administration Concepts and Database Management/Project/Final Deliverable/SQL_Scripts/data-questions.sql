/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/

-- How many reports of larceny are there?
SELECT COUNT(ReportID) FROM AllReports WHERE ReportType = 'Larceny'

-- What is the distribution of jobs in all the people in the database?
SELECT 
	COUNT(*) AS [Total Jobs],
	Job
FROM Person
GROUP BY Job


-- Which vehicles have weapons in them (and which weapons are they)?
SELECT
	Vehicle.VehicleID,
	WeaponID,
	WeaponName
FROM Vehicle
JOIN Weapon ON Vehicle.VehicleID = Weapon.VehicleID


-- What is the distribution of report types?
SELECT 
	COUNT(*) AS [Total Report Types],
	ReportType
FROM Report
GROUP BY ReportType


-- Find all Judges.
SELECT * FROM Person WHERE Job = 'Judge'