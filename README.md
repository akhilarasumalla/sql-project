# 🌍 Worldwide Energy Consumption Analysis (SQL Project)

## 📌 Project Overview

This project focuses on analyzing **global energy consumption patterns** and their relationship with **population, GDP, energy production, and emissions** across countries and years using **SQL**. The goal is to derive meaningful insights from real-world data by answering analytical questions commonly faced by data analysts.

---

## 🎯 Objectives

* Analyze worldwide energy consumption and production trends
* Understand the relationship between **population, GDP, and emissions**
* Calculate **per-capita metrics** and **ratio-based insights**
* Identify **top contributing countries** to global emissions
* Perform **year-wise global analysis** using SQL

---

## 🗂️ Dataset Description

The project uses multiple relational tables:

* **country** – country master table
* **population** – population data by country and year
* **gdp_3** – GDP values by country and year
* **emission_3** – emission data by energy type, country, and year
* **consumption** – energy consumption data
* **production** – energy production data

Each table is connected using **country and year**, forming a relational data model.

---

## 🧩 Database Design

* Designed normalized relational tables
* Established relationships using **primary and foreign keys**
* Created an **ER Diagram** to visualize table relationships

---

## 🔍 Key Analysis Performed

* 🌐 Global and country-wise **energy consumption & production analysis**
* 📊 **Population vs emissions** comparison
* 👤 **Per-capita analysis** (emissions, consumption, production)
* 📈 **Trend analysis over time**
* ⚖️ **Energy-to-GDP** and **Emission-to-GDP ratios**
* 🔝 Top countries by **population, emissions, and energy usage**
* 🌎 **Global averages and totals by year**
* ♻️ Countries that **reduced per-capita emissions** over time

---

## 🛠️ SQL Concepts Used

* `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
* `INNER JOIN`, self-joins
* Aggregate functions: `SUM()`, `AVG()`
* Subqueries
* Window functions: `LAG()`
* Grouping and filtering using `GROUP BY` and `HAVING`

---

## 📌 Sample Insights

* Highly populated countries contribute significantly to global emissions
* Some countries show reduced per-capita emissions despite economic growth
* Energy-intensive economies tend to have higher energy-to-GDP ratios
* Clean energy adoption helps decouple GDP growth from emissions

---

## 📽️ Project Walkthrough

A video walkthrough is included demonstrating:

* SQL query execution
* Key analytical queries
* Insights derived from the data

---

## 🚀 Tools & Technologies

* **SQL (MySQL)**
* Relational Database Design
* GitHub for version control and project hosting

---

## 📚 Learning Outcomes

* Improved SQL querying and optimization skills
* Hands-on experience with real-world analytical questions
* Strong understanding of per-capita and ratio-based analysis
* Practical exposure to time-series and trend analysis

---

