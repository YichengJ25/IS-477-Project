# Project Plan

## Overview
Our project aims to explore the relationship between weather conditions and air quality levels in major U.S. cities. By combining datasets from two distinct sources—EPA Air Quality System (AQS) and NOAA’s Open-Meteo Weather API—we will examine how variables such as temperature, humidity, and wind speed influence concentrations of key pollutants like PM2.5 and ozone.

This project aligns with the data lifecycle framework discussed in class:

Collection — acquiring air quality and weather data from reliable APIs;

Storage and Organization — loading and storing the data in a relational database for structured access;

Integration and Cleaning — joining datasets on common attributes (city, date) using SQL and Pandas;

Analysis and Visualization — performing exploratory analysis in Python and visualizing temporal and spatial trends;

Reproducibility — creating an automated, end-to-end workflow that can be re-run using documented scripts and metadata.

Ultimately, the project seeks to demonstrate the value of integrated environmental datasets for understanding local pollution dynamics and supporting informed public decision-making.

## Research Question(s)
- Question 1: Are PM2.5 levels higher during days with low wind speed or temperature inversions? 
- Question 2: Can simple statistical models predict short-term air quality based on recent weather trends?
- Question 3: Does humidity influence PM2.5 differently in the Midwest versus the West Coast?

## Team
- **Member A (Name)**: Chien Y – Lead Developer (Python)

Responsible for writing Python scripts for data collection, cleaning, and integration.

Will develop automated workflows and ensure reproducibility through notebooks and scripts.

Will also manage final documentation and GitHub organization.
- **Member B (Name)**: Yicheng J – Data Engineer (SQL)

Responsible for designing and managing the database schema for storing the integrated datasets.

Will write SQL queries for data profiling, aggregation, and analysis.

Will assist in creating data quality reports and handling metadata documentation.

Both members will collaborate on analysis design, visualization, and report writing.

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
| **Phase**                        | **Task**                                                    | **Lead** | **Start Date** | **Due Date** | **Status**  |
| -------------------------------- | ----------------------------------------------------------- | -------- | -------------- | ------------ | ----------- |
| **1. Project Setup**             | Form team, create GitHub repo, setup environment            | Both     | Sept 26        | Oct 1        | Done          |
| **2. Planning**                  | Define research questions, identify datasets, design schema | Both     | Oct 1          | Oct 14       | In progress |
| **3. Data Acquisition**          | Write Python scripts to download and store both datasets    | Chien    | Oct 14         | Oct 25       | Pending     |
| **4. Data Storage/Organization** | Create SQL schema (DuckDB or SQLite)                        | Yicheng  | Oct 25         | Nov 1        | Pending     |
| **5. Integration & Cleaning**    | Merge datasets, handle missing data                         | Both     | Nov 1          | Nov 10       | Pending     |
| **6. Analysis & Visualization**  | Explore correlations and build regression model             | Both     | Nov 11         | Nov 25       | Pending     |
| **7. Workflow Automation**       | Build “Run All” script and document workflow                | Chien    | Nov 25         | Dec 5        | Pending     |
| **8. Final Report & Submission** | Write final README.md and upload to GitHub                  | Both     | Dec 5          | Dec 10       | Pending     |


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

---
