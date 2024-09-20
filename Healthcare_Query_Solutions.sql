CREATE DATABASE Healthcare_db;
USE Healthcare_db;

-- IMPORTING THE DATA ( 9 TABLES)
SELECT * FROM FactTable;
SELECT * FROM dimPatient;
SELECT * FROM dimCptCode;
SELECT * FROM dimdate;
SELECT * FROM dimDiagnosisCode;
SELECT * FROM dimLocation;
SELECT * FROM dimPayer;
SELECT * FROM dimPhysician;
SELECT * FROM dimTransaction;

-- PRIMARY KEY
ALTER TABLE FactTable
ALTER COLUMN FactTablePK INT NOT NULL;

ALTER TABLE FactTable
ADD PRIMARY KEY(FactTablePK);

-- SOLVING THE QUERY QUESTIONS

-- Question 1. How many rows of data are in the FactTable that include a Gross Charge greater than $100?
SELECT 
   COUNT(FactTablePK) AS TOTAL_NO_OF_ROWS
FROM FactTable
WHERE GrossCharge > 100;

-- Question 2. How many unique patients exist is the Healthcare_DB?
SELECT 
   COUNT ( DISTINCT PatientNumber) AS TOTAL_PATIENTS
FROM  dimPatient

-- Question 3. How many CptCodes are in each CptGrouping?
SELECT 
   CptGrouping , 
   COUNT( DISTINCT dimCPTCodePK ) AS TOTAL_NO_OF_CptCodes
FROM dimCptCode
GROUP BY CptGrouping
ORDER BY TOTAL_NO_OF_CptCodes;

-- Question 4. How many physicians have submitted a Medicare insurance claim?
SELECT 
   COUNT (DISTINCT dimPhysicianPK) AS physicians_submitted_Medicare_claim
FROM FactTable
WHERE dimPayerPK = 98735;

/*
Question 5. Calculate the Gross Collection Rate (GCR) for each 
LocationName  
GCR = Payments divided GrossCharge 
Which LocationName has the highest GCR? 
*/
SELECT
   L.LocationName,
   ROUND(SUM(F.Payment)/SUM(F.GrossCharge),1) AS GCR
FROM FactTable F
INNER JOIN dimLocation L
ON F.dimLocationPK = L.dimLocationPK
GROUP BY L.LocationName
ORDER BY GCR DESC ;

-- Question 6. How many CptCodes have more than 100 units? 
SELECT 
   D.*,
   F.CPTUnits
FROM dimCptCode D INNER JOIN FactTable F
ON D.CptCode = D.CptCode
WHERE F.CPTUnits > 100;

-- Question 7. Find the physician specialty that has received the highest number of payments. Then show the payments by month for this group of physicians.
WITH HighestSpecialty AS 
(
SELECT TOP 1 
   P.ProviderSpecialty, 
   ROUND(SUM(F.Payment), 0) AS TOTAL_EARNINGS
FROM FactTable F
INNER JOIN dimPhysician P 
ON F.dimPhysicianPK = P.dimPhysicianPK
GROUP BY P.ProviderSpecialty
ORDER BY TOTAL_EARNINGS 
)
SELECT 
    P.ProviderSpecialty, 
    D.Year, 
    D.Month, 
    ROUND(SUM(F.Payment), 0) AS MonthlyEarnings
FROM FactTable F
INNER JOIN dimPhysician P ON F.dimPhysicianPK = P.dimPhysicianPK
INNER JOIN dimDate D ON F.dimDatePostPK = D.dimDatePostPK
INNER JOIN HighestSpecialty H ON P.ProviderSpecialty = H.ProviderSpecialty
GROUP BY P.ProviderSpecialty, D.Year, D.Month
ORDER BY D.Year, D.Month;

-- Question 8. How many CptUnits by DiagnosisCodeGroup are assigned to a "J code" Diagnosis (these are diagnosis codes with the letter J in the code)? 
SELECT 
   DC.DiagnosisCode, 
   SUM (F.CPTUnits) AS Total_CPT_Units
FROM FactTable F INNER JOIN dimDiagnosisCode DC
ON F.dimDiagnosisCodePK = DC.dimDiagnosisCodePK
WHERE DC.DiagnosisCode LIKE 'J%'
GROUP BY DC.DiagnosisCode
ORDER BY Total_CPT_Units;

/*
Question 9. You've been asked to put together a report that details Patient demographics. The report 
should group patients into three buckets- Under 18, between 18-65, & over 65. Please include the 
following columns: 
-First and Last name in the same column 
-Email 
-Patient Age 
-City and State in the same column 
*/
ALTER TABLE dimPatient
ALTER COLUMN patientAge INT;

-- UNDER 18 AGE GROUP
CREATE VIEW REPORT_1 AS
SELECT
   D.dimPatientPK,
   D.PatientNumber,
   CONCAT(D.FirstName,' ',D.LastName) AS Names,
   D.PatientAge,
   CONCAT(D.City,' ',D.State) AS Locations,
   D.Email
FROM dimPatient D
WHERE CAST (D.PatientAge AS INT) < 18;

-- AGE GROUP 18 - 65
CREATE VIEW REPORT_2 AS
SELECT
D.dimPatientPK,
D.PatientNumber,
CONCAT(D.FirstName,' ',D.LastName) AS Names,
D.PatientAge,
CONCAT(D.City,' ',D.State) AS Locations,
D.Email
FROM dimPatient D
WHERE CAST (D.PatientAge AS INT)  BETWEEN 18 AND 65;

-- ABOVE 65 AGE GROUP
CREATE VIEW REPORT_3 AS
SELECT
D.dimPatientPK,
D.PatientNumber,
CONCAT(D.FirstName,' ',D.LastName) AS Names,
D.PatientAge,
CONCAT(D.City,' ',D.State) AS Locations,
D.Email
FROM dimPatient D
WHERE CAST (D.PatientAge AS INT) > 65;

-- SIMPLE VIEW REPORTS
SELECT * FROM REPORT_1  -- UNDER 18 AGE GROUP
ORDER BY PatientAge;

SELECT * FROM REPORT_2  -- BETWEEN AGE GROUP 18 TO 65
ORDER BY PatientAge;

SELECT * FROM REPORT_3  -- ABOVE 65 AGE GROUP
ORDER BY PatientAge;

/*
Question 10. How many dollars have been written off (adjustments) due to credentialing (AdjustmentReason)? 
Which location has the highest number of credentialing adjustments? 
How many physicians at this location have been impacted by credentialing adjustments? What does this mean?
*/

SELECT TOP 1
    L.LocationName AS HIGHEST_ADJUSTMENT_LOCATION,
    SUM(F.Adjustment) AS AMOUNT_WRITTEN_OFF,
	COUNT(DISTINCT P.dimPhysicianPK) AS TOTAL_PHYSICIANS
FROM FactTable F 
INNER JOIN dimTransaction T
ON F.dimTransactionPK = T.dimTransactionPK
INNER JOIN dimLocation L
ON F.dimLocationPK = L.dimLocationPK
INNER JOIN dimPhysician P
ON F.dimPhysicianPK = P.dimPhysicianPK
WHERE T.AdjustmentReason = 'Credentialing'
GROUP BY L.LocationName
ORDER BY AMOUNT_WRITTEN_OFF;

-- Question 11. What is the average patient age by gender for patients seen at Big Heart Community Hospital with a Diagnosis that included Type 2 diabetes? And how many Patients are included in that average?
SELECT 
P.PatientGender,
AVG(P.PatientAge) AS AVERAGE_AGE,
COUNT(P.dimPatientPK) AS TOTAL_PATIENTS
FROM dimPatient P
INNER JOIN FactTable F
ON P.dimPatientPK = F.dimPatientPK
INNER JOIN dimDiagnosisCode DC
ON F.dimDiagnosisCodePK = DC.dimDiagnosisCodePK
WHERE F.dimLocationPK = 785724 AND DiagnosisCode = 'O244'
GROUP BY P.PatientGender

/*
Question 12. There are a two visit types that you have been asked to compare (use CptDesc). 
- Office/outpatient visit est 
- Office/outpatient visit new 
Show each CptCode, CptDesc and the assocaited CptUnits. What is the Charge per CptUnit? 
(Reduce to two decimals) What does this mean? 
*/
SELECT 
    D.CptCode,
    D.CptDesc,
    SUM(F.CptUnits) AS TotalCptUnits,
    ROUND(SUM(F.GrossCharge) / NULLIF(SUM(F.CptUnits), 0), 2) AS ChargePerCptUnit
FROM dimCptCode D
INNER JOIN FactTable F
ON D.dimCPTCodePK = F.dimCPTCodePK
WHERE D.CptDesc IN ('Office/outpatient visit est', 'Office/outpatient visit new')
GROUP BY D.CptCode, D.CptDesc
ORDER BY D.CptCode;

/*
Question 13. Similar to Question 12, you've been asked to analysis the PaymentperUnit (NOT ChargeperUnit). 
You've been tasked with finding the PaymentperUnit by PayerName.  
Do this analysis on the following visit type (CptDesc) 
- Initial hospital care 
Show each CptCode, CptDesc and associated CptUnits. (Note you will encounter a zero value error. Use isnull)
*/
SELECT
    D.CptCode,
    D.CptDesc,
    ISNULL(SUM(F.CptUnits), 0) AS TotalCptUnits,  -- Handle zero units
    ROUND(ISNULL(SUM(F.Payment), 0) / NULLIF(SUM(F.CptUnits), 0),1) AS PaymentperUnit  -- Handle zero division
FROM FactTable F
INNER JOIN dimCptCode D
ON F.dimCPTCodePK = D.dimCPTCodePK
WHERE  D.CptDesc = 'Initial hospital care'
GROUP BY D.CptCode, D.CptDesc
ORDER BY TotalCptUnits;

/*
Question 14. Within the FactTable we are able to see GrossCharges. 
You've been asked to find the NetCharge, which means Contractual adjustments need to be subtracted from the GrossCharge (GrossCharges - Contractual Adjustments). 
After you've found the NetCharge then calculate the Net Collection Rate (Payments/NetCharge) for each physician specialty. 
Which physician specialty has the worst Net Collection Rate with a NetCharge greater than $25,000?
What is happening here? Where are the other dollars and why aren't they being collected? What does this mean? 
*/
WITH PhysicianNetCharge AS 
(
SELECT 
   P.ProviderSpecialty, 
   SUM(F.GrossCharge) AS TotalGrossCharge,
   SUM(F.Adjustment) AS TotalAdjustment,
   SUM(F.GrossCharge - F.Adjustment) AS NetCharge,  -- NetCharge Calculation
   SUM(F.Payment) AS TotalPayments
FROM FactTable F
INNER JOIN dimPhysician P ON F.dimPhysicianPK = P.dimPhysicianPK
GROUP BY P.ProviderSpecialty
)
SELECT 
    PNC.ProviderSpecialty, 
    PNC.NetCharge, 
    ROUND((PNC.TotalPayments / PNC.NetCharge), 4) AS NetCollectionRate 
FROM PhysicianNetCharge PNC
WHERE PNC.NetCharge > 25000 
ORDER BY NetCollectionRate ASC;  

/*
Question 15. Build a Table that includes the following elements: 
- LocationName 
- CountofPhysicians 
- CountofPatients 
- GrossCharge 
- AverageChargeperPa
*/
CREATE TABLE dim_RequiredTable
(
LocationName TEXT,
Count_of_Physicians INT,
Count_of_Patients  INT,
GrossCharge INT,
AverageChargeperPa DEC(10,2)
);

SELECT * FROM dim_RequiredTable

INSERT INTO dim_RequiredTable (LocationName, Count_of_Physicians, Count_of_Patients, GrossCharge, AverageChargeperPa)
SELECT 
    L.LocationName,
    COUNT(DISTINCT P.dimPhysicianPK) AS CountofPhysicians,                                -- Count of unique physicians
    COUNT(DISTINCT PT.dimPatientPK) AS CountofPatients,                                   -- Count of unique patients
    SUM(F.GrossCharge) AS TotalGrossCharge,                                               -- Sum of gross charges
    ROUND(SUM(F.GrossCharge) / COUNT(DISTINCT PT.dimPatientPK), 2) AS AverageChargeperPa  -- Average charge per patient
FROM FactTable F
INNER JOIN dimPhysician P ON F.dimPhysicianPK = P.dimPhysicianPK
INNER JOIN dimPatient PT ON F.dimPatientPK = PT.dimPatientPK
INNER JOIN dimLocation L ON F.dimLocationPK = L.dimLocationPK
GROUP BY L.LocationName;

SELECT * FROM dim_RequiredTable;