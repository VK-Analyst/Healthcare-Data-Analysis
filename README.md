# Healthcare-Data-Analysis

## 👋 Introduction
I have been assigned a project on Healthcare sector, where I am responsible for writing SQL queries to address the following business scenarios based on the dataset in the Complete_Healthcare_Dataset Excel:
   
## 📋 Requests:
    
1. How many rows of data are in the FactTable that include a Gross Charge greater than $100? 

2. How many unique patients exist is the Healthcare_DB? 

3. How many CptCodes are in each CptGrouping? 

4. How many physicians have submitted a Medicare insurance claim? 

5. Calculate the Gross Collection Rate (GCR) for each LocationName  
GCR = (Payments divided GrossCharge) and
Which LocationName has the highest GCR? 

6. How many CptCodes have more than 100 units? 

7. Find the physician specialty that has received the highest number of payments. Then show the payments by month for this group of physicians.  

8. How many CptUnits by DiagnosisCodeGroup are assigned to a "J code" Diagnosis (these are diagnosis codes with the letter J in the code)? 

9. You've been asked to put together a report that details Patient demographics. 
The report should group patients into three buckets- Under 18, between 18-65, & over 65.
Please include the following columns: -First and Last name in the same column -Email -Patient Age -City and State in the same column

10. How many dollars have been written off (adjustments) due to credentialing 
(AdjustmentReason)? Which location has the highest number of credentialing adjustments? How 
many physicians at this location have been impacted by credentialing adjustments? What does this 
mean? 

11. What is the average patientage by gender for patients seen at Big Heart Community 
Hospital with a Diagnosis that included Type 2 diabetes? And how many Patients are included in that 
average?

12. There are a two visit types that you have been asked to compare (use CptDesc). - Office/outpatient visit est - Office/outpatient visit new 
Show each CptCode, CptDesc and the assocaited CptUnits. What is the Charge per CptUnit? 
(Reduce to two decimals) What does this mean?  

13.  you've been asked to analysis the PaymentperUnit (NOT 
ChargeperUnit). You've been tasked with finding the PaymentperUnit by PayerName.  Do this analysis on the following visit type (CptDesc) - Initial hospital care 
Show each CptCode, CptDesc and associated CptUnits.(Note you will encounter a zero value error. Use isnull )

14. Within the FactTable we are able to see GrossCharges. You've been asked to find the 
NetCharge, which means Contractual adjustments need to be subtracted from the GrossCharge 
(GrossCharges - Contractual Adjustments). After you've found the NetCharge then calculate the Net 
Collection Rate (Payments/NetCharge) for each physician specialty. Which physician specialty has the 
worst Net Collection Rate with a NetCharge greater than $25,000? What is happening here? Where 
are the other dollars and why aren't they being collected? What does this mean? 

15. Build a Table that includes the following elements: 
- LocationName 
- CountofPhysicians
- CountofPatients
- GrossCharge
- AverageChargeperPatients 

# Healthcare Dashboard

![Dashboard](https://github.com/user-attachments/assets/034b17b1-50cb-4c01-a288-e98ea3f8d26a)

## 📊 Features

1. **Patients and Physicians per Location**  
   Shows the number of patients and physicians available in each location.

2. **Gross Collection Rate (GCR) per Location**  
   Displays the GCR for each location.

3. **Net Charge by Provider Specialty**  
   A bar chart showing the total net charges grouped by provider specialty.

4. **Net Charge by Month**  
   Line chart visualizing monthly trends in net charges over time.

---
