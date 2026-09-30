# E-Commerce Sales Data Analysis

## Project Overview

This project performs Exploratory Data Analysis (EDA) on an e-commerce transaction dataset using Python.

The objective is to clean the transaction data, analyze sales performance, identify customer and product trends, and generate useful business insights.

## Tools & Technologies

* Python
* Pandas
* NumPy
* Matplotlib
* Seaborn
* Jupyter Notebook

## Dataset

The dataset contains e-commerce transaction records with information such as:

* Invoice Number
* Product Code
* Product Description
* Quantity
* Invoice Date
* Unit Price
* Customer ID
* Country

The raw dataset is stored in the `01_Raw_Data` folder.

## Project Workflow

1. Loaded the raw e-commerce dataset using Pandas.
2. Performed initial data exploration.
3. Checked missing values and duplicate records.
4. Converted transaction dates into datetime format.
5. Identified non-positive quantity transactions.
6. Calculated transaction-level sales using Quantity × Unit Price.
7. Created business KPIs.
8. Analyzed monthly sales trends.
9. Analyzed sales by country.
10. Identified top-performing products.
11. Analyzed customer sales contribution.
12. Analyzed returns and cancellations.
13. Analyzed sales by day of the week.
14. Generated business insights and visualizations.

## Key KPIs

The analysis calculates:

* Total Sales
* Total Quantity Sold
* Total Orders
* Unique Products
* Unique Customers
* Average Order Value

## Key Analysis

### Monthly Sales Analysis

Analyzed sales trends across different months to identify periods with higher and lower sales activity.

### Country Analysis

Compared sales performance across countries and identified the countries contributing the highest sales.

### Product Analysis

Identified the products generating the highest sales.

### Customer Analysis

Analyzed customer-level sales contribution and identified high-value customers.

### Returns & Cancellations

Analyzed transactions with non-positive quantities and identified cancelled transactions using the invoice number indicator.

### Day-of-Week Analysis

Compared sales across different days of the week to identify sales patterns.

## Project Structure

```text
E-Commerce-Sales-EDA/
│
├── 01_Raw_Data/
│   └── OnlineRetail.csv
│
├── 02_Python/
│   └── 01_ECommerce_EDA.ipynb
│
├── 03_Cleaned_Data/
│   └── ECommerce_Sales_Cleaned.csv
│
├── 04_Visuals/
│   ├── monthly_sales.png
│   ├── country_sales.png
│   ├── top_products.png
│   ├── top_customers.png
│   ├── day_of_week_sales.png
│   └── order_status.png
│
├── 05_Documentation/
│   ├── README.md
│   └── INTERVIEW_GUIDE.md
│
└── requirements.txt
```

## Business Value

This project demonstrates how Python can be used to transform raw transaction data into meaningful business insights.

The analysis can help businesses understand:

* Sales trends
* Product performance
* Customer contribution
* Geographic sales distribution
* Cancellation and return patterns
* Weekly sales behavior

## Skills Demonstrated

* Data Cleaning
* Exploratory Data Analysis
* Data Transformation
* Business KPI Analysis
* Customer Analysis
* Product Analysis
* Time-Series Analysis
* Data Visualization
* Python Programming
* Pandas and NumPy
* Matplotlib and Seaborn

## Author

**Govardhan**

Aspiring Data Analyst with experience in SQL, Python, Excel, Power BI, data validation, and operational data analysis.
