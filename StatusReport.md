
# Status Report

## 1. Introduction
This status report provides a detailed update on our IS 477 Final Project, which investigates the relationship between **daily PM2.5 air quality levels** and **daily weather conditions** in **Chicago during 2023**. Over the past milestone, we completed the entire data acquisition, verification, storage, cleaning, and integration pipeline. This report documents all progress to date, references relevant artifacts in our repository, explains changes made to our project plan, provides an updated timeline, and summarizes each team member’s contributions.

The work completed so far represents the full data engineering foundation of the project—the layers required to ensure high-quality, reproducible analysis. Because our project depends heavily on correct and reliable environmental data, we devoted significant time to carefully documenting each step and verifying data integrity. The following sections present a comprehensive narrative of the work completed during this milestone.

---

## 2. Progress by Task

### **Task 1 — Project Setup (Completed - both)**
We completed the initial repository structure on GitHub using a clear and reproducible folder hierarchy:

```
IS-477-Project/
│── code/
│── data/
│   ├── raw/
│   ├── processed/
│   ├── db/
│   ├── checksums/
│── docs/
│── README.md
```

This setup ensured a systematic environment for the ETL process.  

---

### **Task 2 — Planning (Completed - both)**
We refined our scope to focus on **Chicago**, as well as limiting the pollutant of interest to **PM2.5**. This allowed for a cleaner and more feasible analysis within project constraints. The research questions were narrowed accordingly.

A fully updated plan appears in:  
✔ `ProjectPlan_restructured.md`

---

### **Task 3 — Data Acquisition (Completed - Yicheng)**

#### **EPA PM2.5 Data**
Steps performed:
- Identified EPA dataset: `daily_88101_2023.csv`
- Downloaded directly from https://aqs.epa.gov/aqsweb/airdata/
- Saved under: `data/raw/epa/`
- Generated SHA-256 checksum and stored it under: `data/checksums/epa_2023_sha256.txt`

#### **NOAA/Open-Meteo Weather Data**
Steps performed:
- Constructed API request for Chicago coordinates (41.8781, −87.6298)
- Used Python `requests` to fetch JSON data
- Saved raw JSON to: `data/raw/noaa/open_meteo_chicago_2023.json`
- Generated SHA-256 checksum stored under: `data/checksums/noaa_2023_sha256.txt`

All acquisition work is documented in:  
✔ `code/01_data_acquisition_and_verification.ipynb`

---

### **Task 4 — Storage & Organization (Completed -Yicheng)**
We selected **DuckDB** as our relational storage engine due to its:
- Single-file simplicity  
- High-speed analytics  
- Seamless Pandas integration  

We created:  
- Database file: `data/db/project.duckdb`  
- Tables: `epa_raw`, `weather_raw`

This ensures consistent access throughout the project.

Artifacts appear in:  
✔ `code/02_data_storage_organization_and_extraction.ipynb`

---

### **Task 5 — Extraction & Cleaning (Completed - Yicheng)**

#### **EPA PM2.5 Cleaning**
Performed steps:
1. Loaded CSV and converted date fields.
2. Filtered Chicago-only records based on state/county/city attributes.
3. Aggregated all monitoring sites for each date.
4. Computed:
   - `pm25_mean`
   - `pm25_min`
   - `pm25_max`
   - `n_measurements`
5. Produced clean dataset with **128 valid days**.

Output saved as:  
✔ `data/processed/epa_chicago_daily_clean.csv`

#### **Weather Data Cleaning**
Steps:
1. Converted JSON to DataFrame.
2. Extracted weather variables (temperature, precipitation, wind speed, humidity).
3. Converted timestamps to daily format.
4. Produced 365-day dataset.

Output saved as:  
✔ `data/processed/weather_chicago_daily_clean.csv`

All work handled in:  
✔ `code/02_data_storage_organization_and_extraction.ipynb`

---

### **Task 6 — Data Integration (Completed - Yicheng)**
We merged both cleaned datasets into a single analytical table.

Steps:
- Used DuckDB to perform inner join on `date`
- Created integrated table: `chicago_pm25_weather_daily`  
- Exported CSV:  
  ✔ `data/processed/chicago_pm25_weather_daily.csv`  
- Final row count: **128 rows**

Integration implemented in:  
✔ `code/03_data_integration.py`

This dataset will be used for all downstream analysis.

---

### **Task 7 — Data Quality & Cleaning (Completed - Chien)**

steps:
- Outlier detection for PM2.5 spikes  
- Identification of extreme weather patterns  
- Missing value treatment  
- OpenRefine recipe creation, if needed  

These steps ensure high data reliability.

Output saved as:  
✔ `data/clean/chicago_pm25_weather_daily_clean.csv`

All work handled in:  
✔ `code/04_data_quality_and_clean.ipynb`

---

### **Task 8 — Analysis & Visualization (Upcoming - Chien)**
Planned tasks:
- Exploratory analysis  
- Summary statistics  
- Correlation analysis  
- Time-series trend plots  
- Scatterplots: PM2.5 vs. temp, humidity, wind, precipitation  
- Possible regression model (time permitting)

Artifacts will include:  
📌 `04_analysis_and_visualization.ipynb`  

---

### **Task 9 — Workflow Automation (Upcoming - Chien)**
We will implement:
- Snakemake pipeline **or**
- A consolidated Python "Run All" script

This will automate:
- Acquisition → Cleaning → Integration → Export

---

### **Task 10 — Reproducibility Package (Upcoming - both)**
| Column Name           | Description                                                  | Data Type           | Units / Notes                        |
| --------------------- | ------------------------------------------------------------ | ------------------- | ------------------------------------ |
| **date**              | The calendar date of the observation.                        | string (YYYY-MM-DD) | —                                    |
| **pm25_mean**         | Daily average PM2.5 concentration (fine particulate matter). | float               | µg/m³                                |
| **pm25_min**          | Minimum recorded PM2.5 level for the day.                    | float               | µg/m³                                |
| **pm25_max**          | Maximum recorded PM2.5 level for the day.                    | float               | µg/m³                                |
| **n_measurements**    | Number of PM2.5 measurements taken on that date.             | integer             | count                                |
| **temp_max**          | Maximum daily temperature.                                   | float               | °C                                   |
| **temp_min**          | Minimum daily temperature.                                   | float               | °C                                   |
| **precip_sum**        | Total daily precipitation.                                   | float               | mm                                   |
| **shortwave_rad_sum** | Total daily shortwave solar radiation.                       | float               | J/m² or W/m²·s (depending on source) |
| **humidity_mean**     | Average daily relative humidity.                             | float               | %                                    |
| **wind_speed_max**    | Maximum wind speed recorded on that day.                     | float               | m/s                                  |
| **wind_dir_dominant** | Dominant wind direction for the day.                         | string / float      | degrees (0–360)                      |


## Reproducing This Project

Follow the steps below to fully reproduce all data cleaning and analysis results for this project.

### 1. Clone the repository
```bash
git clone https://github.com/YichengJ25/IS-477-Project.git
cd IS-477-Project

Includes:
- `requirements.txt`
- `pip freeze`
- A structured Box folder with all necessary data files
- Data-use/license notes for EPA and Open-Meteo  

---

### **Task 11 — Metadata & Documentation (Upcoming - both)**

## Data Access

Because parts of the dataset cannot be redistributed directly through GitHub, all input and output data files are stored in a shared Box folder:

**[INSERT BOX LINK HERE]**

After downloading the files from Box, place them into the following folders inside the project directory:



We will produce:
- Complete data dictionary  
- Schema.org or DataCite metadata  
- Updated project documentation  

---

### **Task 12 — Final Report & Submission (Upcoming - both)**
Final deliverables include:
- Final `README.md`
- Workflow diagram
- GitHub release  
- Final integrated dataset  

---

## 3. Updated Timeline

| Phase | Task | Lead | Status | New Target |
|-------|------|------|--------|------------|
| Setup | Repo + environment | Both | Done | — |
| Planning | RQs & design | Both | Done | — |
| Acquisition | EPA + NOAA | **Yicheng** | Done | — |
| Acquisition Docs | Checksum + logs | **Yicheng** | Done | — |
| Storage | DuckDB schema | **Yicheng** | Done | — |
| Extraction & Cleaning | EPA + NOAA | **Yicheng** | Done | — |
| Integration | Weather + PM2.5 | **Yicheng** | Done | — |
| Data Quality | Outliers, OpenRefine | **Chien** | Done | Nov 20 |
| Analysis | EDA + visuals | **Chien** | Pending | Nov 25 |
| Automation | Pipeline build | Chien | Pending | Dec 5 |
| Reproducibility | reqs + Box | Both | Pending | Dec 7 |
| Metadata | Dictionary + docs | Both | Pending | Dec 8 |
| Final Report | README + release | Both | Pending | Dec 10 |

---

## 4. Changes to Project Plan

### 1. Geographic Scope Reduced  
Originally multiple cities; now **Chicago-only**.

### 2. Pollutant Reduced  
Originally multiple pollutants; now **PM2.5-only**.

### 3. Single Year Only  
To keep the project manageable, only **2023** is used.

### 4. Data Availability Constraints  
EPA dataset includes only **128 valid reporting days**, requiring:
- Inner join instead of outer join  
- Adjusted analysis expectations  

### 5. Shift to DuckDB  
Selected for superior performance over SQLite.

### 6. Standardized Naming  
New filenames added throughout pipeline:
- `epa_chicago_daily_clean.csv`
- `weather_chicago_daily_clean.csv`
- `chicago_pm25_weather_daily.csv`

---

## 5. Summary For Team Member Contributions

### **Yicheng — Lead for Data Acquisition to Data Integration**  
Yicheng completed all steps from **data acquisition through data integration**, including:
- Downloading EPA & NOAA data  
- Building API requests  
- Generating all checksums  
- Designing directory structure  
- Implementing all Python acquisition scripts  
- Creating DuckDB schema  
- Cleaning EPA PM2.5 data  
- Cleaning NOAA weather data  
- Building the integrated dataset  
- Writing all notebooks:
  - `01_data_acquisition_and_verification.ipynb`
  - `02_data_storage_organization_and_extraction.ipynb`
- Writing the integration script:
  - `03_data_integration.py`

---

### **Chien — Upcoming Work Lead (Data Quality + Analysis)**
Chien will now take over the post-integration stages, including:
- Data quality assessment  
- Outlier identification  
- OpenRefine cleanup  
- Exploratory analysis  
- Visualization  
- Workflow automation  
- Reproducibility documentation
- Writing Data Clean notebooks
   - `04_data_quality_and_clean.ipynb`  

These steps will build directly on the integrated dataset Yicheng prepared.

---
<<<<<<< HEAD
## References

**EPA Air Quality Data (PM2.5)**
U.S. Environmental Protection Agency. (2025). Air Quality System (AQS) Data Mart. Retrieved from https://www.epa.gov/aqs

**Open-Meteo Weather API**
Open-Meteo. (2025). Historical Weather API. Retrieved from https://open-meteo.com/

**Pandas Library**
The Pandas Development Team. (2024). pandas-dev/pandas: Powerful Python data analysis toolkit. https://pandas.pydata.org/

**Matplotlib Library**
Hunter, J. D. (2007). Matplotlib: A 2D graphics environment. Computing in Science & Engineering, 9(3), 90–95.

**Seaborn Library**
Waskom, M. et al. (2020). Seaborn: Statistical data visualization. https://seaborn.pydata.org/

**Statsmodels Library**
Seabold, S. & Perktold, J. (2010). Statsmodels: Econometric and statistical modeling with Python. https://www.statsmodels.org/
=======

## 6. Summary For The Project Progress And Limit
Overall, our project is progressing smoothly and remains fully on schedule. During this milestone, we successfully completed all tasks from data acquisition through data integration, establishing the entire foundational pipeline needed for downstream analysis. Because we intentionally scoped the project to focus on one city (Chicago) and one year (2023), the final dataset is naturally limited in size. The EPA PM2.5 monitoring stations in Chicago did not report measurements on all 365 days of the year, resulting in only 128 valid EPA daily entries, while the NOAA dataset contains a complete 365-day weather record. After performing an inner join on the date field, our integrated dataset contains only the dates where both weather and PM2.5 data were reported. This explains why the final analytic dataset includes approximately 128 rows—a realistic outcome that reflects normal gaps and inconsistencies in real-world environmental monitoring. Despite the smaller size, the dataset is sufficient for meaningful exploratory analysis, correlation studies, and weather-pollution relationship evaluation. Our next steps will focus on data quality assessment, outlier handling, exploratory analysis, and visualization, ensuring that the integrated dataset yields valid insights for our research questions.
>>>>>>> 677ffb05407bd7366e664a80ca94fbbc4e2551c5
