/*
	Author	: Jonathan Durbin
	Course	: IST659
	Term	: April 2021
*/

-- Test case:
/*
A report that was filed yesterday was missing a subject, as they could not be tracked down until today. 
Using the procedure UpdateReport, a clerk runs the following statement
*/

EXEC AddReport 'Unknown Subject did a bad','Criminal Mischief','10/3/1995',10,default,default,'93446 Saint Paul Alley',default,'50'
GO

SELECT * FROM Report
LEFT JOIN ReportSubject ON ReportSubject.ReportID = Report.ReportID
WHERE Occurred = '10/3/1995'
GO

EXEC UpdateReport 151, 20, 'Jonathan', 'Durbin', default, default, default
GO

SELECT * FROM Report
LEFT JOIN ReportSubject ON ReportSubject.ReportID = Report.ReportID
WHERE Occurred = '10/3/1995'
GO