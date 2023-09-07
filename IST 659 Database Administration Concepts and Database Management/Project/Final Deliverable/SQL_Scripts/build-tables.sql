/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/

/*
Independent Table: Does not have foreign keys
Dependent Table: Has foreign keys
*/

-- Dependent Tables
DROP TABLE IF EXISTS ReportSubject
DROP TABLE IF EXISTS ReportLocation
DROP TABLE IF EXISTS PersonReport
DROP TABLE IF EXISTS WeaponReport
DROP TABLE IF EXISTS VehicleReport
DROP TABLE IF EXISTS Warrant
DROP TABLE IF EXISTS Weapon

-- Independent Tables
DROP TABLE IF EXISTS Person
DROP TABLE IF EXISTS Report
DROP TABLE IF EXISTS Vehicle

GO

-- Independent Tables
CREATE TABLE Person (
	PersonID int identity,
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
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
	FingerPrintInfo varchar(100),
	CONSTRAINT PK_Person PRIMARY KEY (PersonID)
)

CREATE TABLE Report (
	ReportID int identity,
	Content varchar(500) not null,
	ReportType varchar(50) not null,
	Occurred datetime,
	Recorded datetime default GetDate()
	CONSTRAINT PK_Report PRIMARY KEY (ReportID)
)

CREATE TABLE Vehicle (
	VehicleID int identity,
	VehicleNumber varchar(5) not null,
	VehicleRegistration varchar(20) not null,
	License varchar(10) not null,
	CONSTRAINT PK_Vehicle PRIMARY KEY (VehicleID),
	CONSTRAINT U1_Vehicle UNIQUE (VehicleNumber)
)

-- Dependent Tables
CREATE TABLE Weapon (
	WeaponID int identity,
	VehicleID int,
	WeaponRegistration varchar(20) not null,
	WeaponName varchar(30) not null,
	CONSTRAINT PK_Weapon PRIMARY KEY (WeaponID),
	CONSTRAINT FK_Weapon_Vehicle FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
	CONSTRAINT U1_Weapon UNIQUE (WeaponRegistration)
)

CREATE TABLE Warrant (
	WarrantID int identity,
	SuspectID int not null,
	JudgeID int not null,
	DateReceived datetime not null,
	CONSTRAINT PK_Warrant PRIMARY KEY (WarrantID),
	CONSTRAINT FK_Warrant_Suspect FOREIGN KEY (SuspectID) REFERENCES Person(PersonID),
	CONSTRAINT FK_Warrant_Judge FOREIGN KEY (JudgeID) REFERENCES Person(PersonID)
)

CREATE TABLE VehicleReport (
	VehicleReportID int identity,
	VehicleID int not null,
	ReportID int not null,
	CONSTRAINT PK_VehicleReport PRIMARY KEY (VehicleReportID),
	CONSTRAINT FK_VehicleReport_Vehicle FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
	CONSTRAINT FK_VehicleReport_Report FOREIGN KEY (ReportID) REFERENCES Report(ReportID)
)

CREATE TABLE WeaponReport (
	WeaponReportID int identity,
	WeaponID int not null,
	ReportID int not null,
	CONSTRAINT PK_WeaponReport PRIMARY KEY (WeaponReportID),
	CONSTRAINT FK_WeaponReport_Weapon FOREIGN KEY (WeaponID) REFERENCES Weapon(WeaponID),
	CONSTRAINT FK_WeaponReport_Report FOREIGN KEY (ReportID) REFERENCES Report(ReportID)
)

CREATE TABLE PersonReport (
	PersonReportID int identity,
	PersonID int not null,
	ReportID int not null,
	CONSTRAINT PK_PersonReport PRIMARY KEY (PersonReportID),
	CONSTRAINT FK_PersonReport_Person FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT FK_PersonReport_Report FOREIGN KEY (ReportID) REFERENCES Report(ReportID)
)

CREATE TABLE ReportLocation (
	ReportLocationID int identity,
	ReportID int not null,
	LocationDescription varchar(100) not null,
	CONSTRAINT PK_ReportLocation PRIMARY KEY (ReportLocationID),
	CONSTRAINT FK_ReportLocation FOREIGN KEY (ReportID) REFERENCES Report(ReportID)
)

CREATE TABLE ReportSubject (
	ReportSubjectID int identity,
	ReportID int not null,
	SubjectID int,
	SubjectFirstName varchar(30) not null,
	SubjectLastName varchar(30) not null,
	CONSTRAINT PK_ReportSubject PRIMARY KEY (ReportSubjectID),
	CONSTRAINT FK_ReportSubject_Report FOREIGN KEY (ReportID) REFERENCES Report(ReportID),
	CONSTRAINT FK_ReportSubject_Person FOREIGN KEY (SubjectID) REFERENCES Person(PersonID)
)

GO
