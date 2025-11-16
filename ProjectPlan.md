# Project Plan

## Overview
Our project aims to explore the relationship between weather conditions and air quality levels in major U.S. cities. By combining datasets from two distinct sources—EPA Air Quality System (AQS) and NOAA’s Open-Meteo Weather API—we will examine how variables such as temperature, humidity, and wind speed influence concentrations of key pollutants like PM2.5.

This project aligns with the data lifecycle framework discussed in class:

Collection — acquiring air quality and weather data from reliable APIs;

Storage and Organization — loading and storing the data in a relational database for structured access;

Integration and Cleaning — joining datasets on common attributes (city, date) using SQL and Pandas;

Analysis and Visualization — performing exploratory analysis in Python and visualizing temporal and spatial trends;

Reproducibility — creating an automated, end-to-end workflow that can be re-run using documented scripts and metadata.

We also address ethical and legal constraints by complying with all open data licenses and documenting consent, privacy, and terms-of-use considerations.

Ultimately, the project seeks to demonstrate the value of integrated environmental datasets for understanding local pollution dynamics and supporting informed public decision-making.

## Research Question(s)
- Question 1: Are PM2.5 levels higher during days with low wind speed or temperature inversions? 
- Question 2: Can simple statistical models predict short-term air quality based on recent weather trends?
- Question 3: Does humidity influence PM2.5 differently in the Midwest versus the West Coast?

## Team

- **Member A: Chien Y — Lead Developer (Python)**  

Responsible for Python development across all stages of the project.  
Will write programmatic acquisition scripts for EPA and NOAA data, including generating SHA-256 checksums and documenting all acquisition steps.  
Will build extraction and enrichment scripts in Python (e.g., variable extraction, format normalization).  
Will lead the development of data cleaning scripts, including outlier detection and OpenRefine recipe export.  
Will create all analysis notebooks, statistical models, and visualizations.  
Will also build workflow automation using Snakemake or a “Run All” script and ensure the project is fully reproducible.  
Will assist with the reproducibility package, including requirements.txt and pip freeze.

---

- **Member B: Yicheng J — Data Engineer (SQL)**  

Responsible for database architecture and data integration.  
Will design and implement the relational database schema (DuckDB/SQLite), define the filesystem structure, and maintain consistent naming conventions.  
Will write SQL queries for profiling, integration, aggregation, and quality assessment.  
Will lead the data integration phase by joining EPA and NOAA datasets using SQL/Pandas and developing the conceptual integration model.  
Will generate detailed data quality reports and assist with data cleaning.  
Will lead metadata documentation, including the data dictionary, descriptive metadata (DataCite/Schema.org), and license documentation.  
Will help prepare the reproducibility package and Box data folder structure.

---

Both members will collaborate on the final analysis design, interpretation of results, report writing, and final GitHub release.


## Datasets
- **Dataset 1**: EPA Air Quality System (AQS) Data

Source: U.S. Environmental Protection Agency (https://aqs.epa.gov/aqsweb/airdata/download_files.html
)

Description: Provides daily air quality measurements, including PM2.5, O₃, NO₂, and SO₂, from monitoring stations across the U.S.

Format: CSV files downloadable by year and pollutant type.

Access Method: Direct file download (HTTP).

Schema (simplified):

Date_Local (date)

City_Name (text)

State_Name (text)

Parameter_Name (text)

Arithmetic_Mean (float)

Units_of_Measure (text)

License: Public domain (U.S. federal data, no restrictions).

Use: Serves as the main dataset for pollutant concentrations. 

- **Dataset 2**: NOAA Open-Meteo Historical Weather API

Source: https://open-meteo.com/

Description: Provides daily weather variables (temperature, humidity, precipitation, wind speed, etc.) by latitude and longitude.

Format: JSON via REST API.

Access Method: API request using Python’s requests module.

Schema (simplified):

date

temperature_2m_max

temperature_2m_min

precipitation_sum

windspeed_10m

relativehumidity_2m

License: Open data under CC-BY 4.0.

Use: Provides contextual weather features corresponding to air quality dates and locations.

## Timeline

| **Phase**                        | **Task**                                                                                   | **Lead**  | **Start Date** | **Due Date** | **Status**  |
|----------------------------------|--------------------------------------------------------------------------------------------|-----------|----------------|--------------|-------------|
| **1. Project Setup**             | Form team, create GitHub repo, set up environment                                          | Both      | Sept 26        | Oct 1        | Done        |
| **2. Planning**                  | Define research questions, identify datasets, design schema                                | Both      | Oct 1          | Oct 14       | Done        |
| **3. Data Acquisition**          | Write Python scripts to download EPA CSV + NOAA API JSON data; generate SHA-256 checksums  | Yicheng   | Oct 14         | Oct 25       | Done        |
| **3b. Acquisition Documentation**| Document acquisition steps, API parameters, file checksums                                 | Yichneg   | Oct 20         | Oct 25       | Pending     |
| **4. Storage & Organization**    | Write python to load data into a relational database with consitent  structure & naming    | Yicheng   | Oct 25         | Nov 1        | Pending     |
| **5. Extraction & Cleaning**     | Extract key variables, normalize formats preparing for integration                         | Yichneg   | Nov 1          | Nov 5        | Pending     |
| **6. Data Integration**          | Join weather + EPA data via SQL/Pandas; build conceptual integration model                 | Yichneg   | Nov 5          | Nov 10       | Pending     |
| **7. Data Quality & Cleaning**   | Detect missing/outliers; apply cleaning scripts; export OpenRefine recipe                  | Chien     | Nov 10         | Nov 15       | Pending     |
| **8. Analysis & Visualization**  | Run statistical analysis; create visualizations; document analysis steps                   | Chien     | Nov 11         | Nov 25       | Pending     |
| **9. Workflow Automation**       | Build Snakemake or “Run All” workflow; ensure end-to-end reproducibility                   | Chien     | Nov 25         | Dec 5        | Pending     |
| **10. Reproducibility Package**  | Create requirements.txt, document reproducibility steps, prepare Box data folder link      | Both      | Nov 25         | Dec 7        | Pending     |
| **11. Metadata & Documentation** | Create data dictionary, descriptive metadata (DataCite/Schema.org), license documentation  | Both      | Dec 1          | Dec 8        | Pending     |
| **12. Final Report & Submission**| Write final README.md, finalize citations, create final GitHub release                     | Both      | Dec 5          | Dec 10       | Pending     |


## Constraints
Data Availability:
Some air quality monitors have missing or inconsistent records. We will handle this by filtering for stations with sufficient data coverage and documenting imputation or exclusion steps.

API Rate Limits:
The Open-Meteo API limits request frequency; we will include delays or use batch requests to comply.

Integration Complexity:
Matching EPA monitoring station data with city-level weather data may require coordinate-based joins or fuzzy matching.

Ethical and Legal Compliance:
Both datasets are open and public. Nevertheless, we will include license attributions and clarify that the data are used for academic research only.

## Gaps
Predictive Modeling:
While correlation and regression analysis are planned, a predictive model (e.g., linear regression) may be added later if time permits.

Visualization Tools:
We will initially rely on Matplotlib and Seaborn but may explore additional tools such as Plotly if time allows.

Reproducibility Environment:
A Dockerfile or requirements.txt file will be created closer to completion once dependencies are finalized.

-
---
