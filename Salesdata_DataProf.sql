---- Sales Data Analysis (From DataProfessionals channel)---
---Merging all Tables--
---Combining all 6 diferent countrie data in a single table using UNION ALL Function---
Create table public."Salesdata" as
Select * from public."SalesCanada"
Union All
Select * from public."SalesChina"
Union All
Select * from public."SalesIndia"
Union All
Select * from public."SalesNigeria"
Union All
Select * from public."SalesUk"
Union All
Select * from public."SalesUs";
--Viewing newly created main table--
Select * from public."Salesdata";


---Data Cleaning Process---
--Checking for Missing values-- Checking only for tricky columns--
Select *
from public."Salesdata"
where "Transaction ID" is null
or "Date" is null
or "Product ID" is null
or "Price Per Unit" is null
or "Quantity Purchased" is null
or "Cost Price" is null
or "Discount Applied" is null;

---Importing/updating missing values---
Update public."Salesdata"
Set "Quantity Purchased" = 3
where "Transaction ID" ='00a30472-89a0-4688-9d33-67ea8ccf7aea';

Update public."Salesdata"
Set "Price Per Unit" = (
		Select Avg("Price Per Unit")
		from public."Salesdata"
		where "Price Per Unit" is not null
)
where "Transaction ID" = '001898f7-b696-4356-91dc-8f2b73d09c63';

---Checking for Duplicates---
Select "Transaction ID", Count(*)
from public."Salesdata"
group by "Transaction ID" 
having Count(*)>1;



---Adding Calculated Columns for further Analysis---
---Calculating Total Amount Spent--
Alter table public."Salesdata"
add column "TotalAmount" numeric(10,2);--Adding New Column--

Update public."Salesdata"
set "TotalAmount" = ("Price Per Unit" * "Quantity Purchased") - "Discount Applied";--Updating vaues--

Select * from public."Salesdata";




---Data Analysis Part----
--- Adding Calculated Column----
---Calculating Total Profit----
Alter table public."Salesdata"
add column "Profit" numeric (10,2);

update public."Salesdata"
set "Profit" = "TotalAmount" - ("Cost Price" + "Quantity Purchased");

Select * from public."Salesdata";

---Sales Revenue and Profit By Country---
Select "Country",
sum("TotalAmount")as TotalRevenue,
sum("Profit")as TotalProfit
from public."Salesdata"
where "Date" between '2025-01-01' AND '2025-01-31'
group by "Country"
order by TotalRevenue desc;

---Top 5 Selling Product during the Period--
Select "Product Name",
sum("TotalAmount") as TotalRevenue,
sum("Profit") as TotalProfit
from public."Salesdata"
where "Date" between '2025-01-01' AND '2025-01-31'
group by "Product Name"
order by TotalRevenue desc
Limit 5;

---Best/Top 5 Sales Representatives for the period---
Select "Sales Representative",
sum("TotalAmount") as TotalRevenue
from public."Salesdata"
where "Date" between '2025-01-01' AND '2025-01-31'
group by "Sales Representative"
order by TotalRevenue desc
Limit 5;

--Which Store Genereated the Highest Sales for the period---
Select "Store Location",
sum("TotalAmount") as TotalRevenue
from public."Salesdata"
where "Date" between '2025-01-01' AND '2025-01-31'
group by "Store Location"
order by TotalRevenue desc
Limit 5;


---which age group Customer Purchsed more--
Select "Customer Age Group",
Count("Transaction ID") as PurchaseCount
from public."Salesdata"
group by "Customer Age Group"
order by PurchaseCount desc;

---What are all the Distinct Category names--
Select distinct "Category"
from public."Salesdata";

---Category wise Highest Sale--
Select "Category",
sum("TotalAmount")as TotalRevenue
from public."Salesdata"
group by "Category"
order by TotalRevenue desc;

---Which Payment mode is mostly used or customer goto option--
Select "Payment Method",
Count("Transaction ID") as TotalCount
from public."Salesdata"
group by "Payment Method"
order by TotalCount desc;

---What are the key sales and profit insights over the year--
Select 
Max("TotalAmount")as MaxSales,
Min("TotalAmount")as MinSales,
Sum("TotalAmount")as TotalSales,
Avg("TotalAmount")as AvgSales,
Max("Profit")as MaxProfit,
Min("Profit")as MinProfti,
Sum("Profit")as TotalProfit,
Avg("Profit")as AvgProfit
from public."Salesdata"
where Extract (year from "Date") = '2025';
