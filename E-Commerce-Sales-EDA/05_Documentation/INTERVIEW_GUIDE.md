# E-Commerce Sales EDA — Interview Guide

## 1. How to Introduce the Project

I worked on an E-Commerce Sales Data Analysis project using Python.

The main objective was to analyze transaction data and understand sales trends, product performance, customer contribution, and cancellation patterns.

I used Pandas and NumPy for data cleaning and analysis, and Matplotlib and Seaborn for visualization.

---

## 2. What Was Your Role?

I handled the complete analysis workflow:

* Loaded the raw dataset using Python.
* Performed data quality checks.
* Removed duplicate records.
* Converted date columns into the correct format.
* Created a Sales column using Quantity and Unit Price.
* Performed exploratory data analysis.
* Created business KPIs.
* Analyzed sales by month, country, product, customer, and day of week.
* Analyzed cancellation and return-related transactions.
* Created visualizations to communicate the findings.

---

## 3. What Data Cleaning Did You Perform?

I performed several data quality checks.

First, I checked for duplicate records and removed duplicate rows.

Then I converted the InvoiceDate column from text format into datetime format so that I could perform time-based analysis.

I also checked for missing values and checked for non-positive quantities.

I did not automatically remove negative quantities because they can represent returns or cancelled transactions.

---

## 4. How Did You Calculate Sales?

I created a new Sales column using:

```text
Sales = Quantity × Unit Price
```

This allowed me to calculate sales at the transaction level and then aggregate the values for different business analyses.

---

## 5. What KPIs Did You Calculate?

The main KPIs were:

* Total Sales
* Total Quantity Sold
* Total Orders
* Unique Products
* Unique Customers
* Average Order Value

Average Order Value was calculated as:

```text
Average Order Value = Total Sales / Total Orders
```

---

## 6. What Analysis Did You Perform?

I performed several analyses.

### Monthly Sales

I analyzed sales by month to identify sales trends and high-performing periods.

### Country Analysis

I compared sales across countries to understand geographic sales contribution.

### Product Analysis

I identified the products generating the highest sales.

### Customer Analysis

I analyzed customer-level sales to identify high-value customers.

### Day-of-Week Analysis

I compared sales across different days of the week to identify weekly sales patterns.

### Cancellation Analysis

I identified cancelled transactions using the invoice number indicator and analyzed their contribution.

---

## 7. What Was the Most Important Business Insight?

One important finding was that sales were not evenly distributed across time, products, customers, or countries.

The analysis helped identify high-performing periods, products, and customers that contributed significantly to overall sales.

This type of analysis can help businesses focus their sales and customer strategies on the areas generating the most value.

---

## 8. Why Did You Use Pandas?

I used Pandas because it provides efficient tools for:

* Data loading
* Data cleaning
* Filtering
* Grouping
* Aggregation
* Date manipulation
* Data transformation

It made it easier to work with a large transaction dataset.

---

## 9. Why Did You Use Matplotlib and Seaborn?

I used Matplotlib and Seaborn to convert the analysis results into visualizations.

This made it easier to identify trends and communicate findings to business stakeholders.

---

## 10. What Challenges Did You Face?

One challenge was handling special characters in the dataset.

The CSV contained the British pound symbol, so the default UTF-8 encoding caused a reading error.

I solved this by loading the dataset using:

```python
encoding="latin1"
```

Another consideration was negative quantities.

Instead of immediately deleting them, I investigated them because they can represent returns or cancellations.

---

## 11. What Would You Do Next?

If this were a real business project, I would extend the analysis by:

* Creating customer segmentation.
* Performing RFM analysis.
* Analyzing repeat customers.
* Building a sales forecasting model.
* Adding an interactive dashboard using Power BI.
* Automating the reporting process.

---

## 12. One-Minute Interview Explanation

I worked on an E-Commerce Sales Data Analysis project using Python.

I started by loading and exploring the transaction dataset using Pandas. I performed data quality checks, removed duplicate records, handled date formats, and investigated non-positive quantities.

I then created a transaction-level Sales column using Quantity multiplied by Unit Price.

After cleaning the data, I calculated important KPIs such as total sales, total orders, unique customers, unique products, and average order value.

I also analyzed monthly sales trends, country performance, top products, customer contribution, cancellation patterns, and sales by day of the week.

Finally, I created visualizations using Matplotlib and Seaborn to communicate the findings.

The project helped me strengthen my practical skills in Python, Pandas, data cleaning, exploratory data analysis, visualization, and business-oriented analysis.
