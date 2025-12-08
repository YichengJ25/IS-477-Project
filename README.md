# IS-477-Project
Course project repository for IS 477. Includes project plan, datasets, workflows, and analysis following full data lifecycle and ethical data handling requirements.

Daily PM2.5 and Weather Data Integration for Chicago: Cleaning, Quality Assessment, and Visualization Pipeline 

Contributors 

Chien Yu 

Yicheng Jiang 

Summary 

This project implements an end-to-end data curation and analysis workflow that integrates daily PM2.5 air quality data with historical weather observations for the City of Chicago. Our goal is to build a single, well-documented dataset that can be used to explore how meteorological conditions relate to fine particulate matter (PM2.5) levels, and to demonstrate the full data lifecycle emphasized in INFO 477—from acquisition and integration through quality assessment, cleaning, analysis, and reproducibility. 

Fine particulate matter (PM2.5) is a key indicator of air quality and is closely linked to respiratory and cardiovascular health outcomes. However, pollutant concentrations are strongly shaped by weather: temperature affects atmospheric mixing, wind influences dispersion, humidity can affect particle growth, and precipitation can “wash out” particles. For that reason, we structured our project around the following guiding questions: 

How can we integrate daily PM2.5 measurements with daily weather data for Chicago into a single, analysis-ready dataset? 

What are the main data quality issues that arise when combining these sources, and how can we detect and correct them? 

Once cleaned, what patterns emerge in PM2.5 levels over time, and how do they relate to key meteorological variables such as temperature, humidity, precipitation, and wind? 

To address these questions, we began by acquiring two distinct datasets from trustworthy sources: a daily PM2.5 dataset for Chicago and a daily weather dataset obtained via a historical weather API. Data collection was done programmatically so that the process can be repeated in the future. We documented the acquisition steps and preserved the scripts in our repository to support transparency and reuse. 

The next major step was data integration. Because the air quality and weather data came from different providers with different schemas, we needed to harmonize them before analysis. This involved standardizing date formats, aligning time zones, ensuring both datasets represented the same geographic area, and resolving naming conventions so that variables had consistent and descriptive labels. The integrated dataset, saved as chicago_pm25_weather_daily.csv in the data/processed/ directory, provides one row per day with both PM2.5 and weather attributes. 

After integration, we focused on data quality and cleaning. Using Python (pandas) and OpenRefine, we profiled the dataset to identify missing values, out-of-range values, inconsistent units, potential duplicates, and logical inconsistencies. Examples include checking that humidity stays between 0 and 100 percent, that wind direction is between 0 and 360 degrees, and that PM2.5 minimum, mean, and maximum values follow the expected ordering (min ≤ mean ≤ max). We also verified that temperature minima did not exceed maxima and that each date appeared only once in the cleaned dataset. Data quality issues were either corrected (e.g., swapping misordered temperatures) or marked as missing when a safe correction was not possible. The cleaned dataset is stored as chicago_pm25_weather_daily_clean.csv in data/clean/, and the OpenRefine operation history is included as a JSON recipe for auditability. 

With a curated dataset in place, we carried out exploratory analysis and visualization. Summary statistics provide an overview of central tendencies and variability for both PM2.5 and weather variables. Time series plots illustrate how PM2.5 levels evolve over time, while scatter plots and correlation matrices highlight relationships between PM2.5 and factors such as temperature, humidity, precipitation, and wind speed. These visualizations suggest seasonal patterns in PM2.5 and intuitive associations with meteorological conditions (for example, higher wind speeds often coincide with lower PM2.5 concentrations). 

Finally, we wrapped the project in a reproducible workflow. All analysis and cleaning steps are implemented in Jupyter notebooks stored in the code/ directory, and dependencies are captured in a requirements.txt file generated via pip freeze. Because the datasets are shared via a Box folder rather than embedded directly in the repository, the README includes clear instructions on how to download the data from Box, where to place the files in the project structure, and how to re-run the notebooks to regenerate the cleaned dataset and all visualizations. We also experimented with a Snakemake-based workflow for automating notebook execution; in the current version, users need to adjust local file paths if they wish to use Snakemake, which is documented as a limitation and an opportunity for future improvement. 

Overall, this project demonstrates how multiple data sources can be combined into a coherent, quality-controlled dataset, and how a structured, well-documented pipeline supports transparent, reproducible environmental analysis. 

 

Data Profile 

This project integrates two independently sourced datasets representing daily air quality and daily weather conditions for Chicago in the year 2023. The datasets differ in format, structure, access method, and licensing, which makes this project a strong application of the concepts taught in INFO 477 around heterogeneous data integration, ethical data handling, reproducibility, and metadata documentation. 

1. EPA Air Quality System (AQS) Daily PM2.5 Dataset 

Source: U.S. Environmental Protection Agency (EPA) Air Quality System (AQS) Data Mart 

Access Method: Direct file download (HTTP) 

File Used: daily_88101_2023.csv (parameter code 88101 = PM2.5) 

Format: CSV 

License: U.S. federal data (public domain)  

The AQS dataset provides daily PM2.5 measurements collected from federally regulated air monitoring stations. We manually downloaded the EPA file for pollutant code 88101 (fine particulate matter, PM2.5) for the year 2023, and then filtered the dataset to include only monitoring stations located in Chicago. After filtering and aggregation, the dataset contained 128 valid daily PM2.5 observations. 

The raw EPA CSV includes dozens of variables that reflect station metadata, reporting method, units, timestamps, and quality flags. For our project, we extracted and retained only the variables necessary for daily-level integration and analysis, including: 

date_local  

arithmetic_mean (daily mean PM2.5)  

min_value, max_value  

sample_measurement_count  

station identifiers and location fields for filtering 

A key constraint is that EPA PM2.5 datasets often contain gaps due to incomplete monitoring or equipment downtime. Because our goal was to integrate PM2.5 values with corresponding daily weather data, we documented missing days and excluded dates without valid observations. This step is important for data quality and prevents misleading associations in later analysis. 

From an ethical and legal standpoint, EPA AQS data is in the public domain. No personal information is collected at the monitoring-station level; therefore, issues of privacy or confidentiality do not apply. The only obligation is proper attribution, which is included in the References section. 

The EPA dataset was loaded into a DuckDB relational database (data/db/project.duckdb) to support structured queries, filtering, and integration. The processed version used for integration is saved as part of our repository in data/processed/chicago_pm25_weather_daily.csv. 

 

2. NOAA / Open-Meteo Historical Weather Dataset 

Source: Open-Meteo Historical Weather API 

Access Method: Programmatic API request using Python requests 

Format: JSON (converted to CSV) 

Coordinates: Chicago (41.8781, −87.6298) 

Observations: 365 daily entries for 2023 

License: CC-BY 4.0 (requires attribution)  

The weather dataset was acquired programmatically using a Python script developed by our team. The script issues a REST API request to the Open-Meteo endpoint, retrieves a JSON file containing daily meteorological variables, and stores the raw response for reproducibility. A SHA-256 checksum was generated to verify download integrity and is recorded in the acquisition documentation. 

The variables selected for integration include: 

temperature_2m_max  

temperature_2m_min  

precipitation_sum  

shortwave_radiation_sum  

relative_humidity_2m_mean  

wind_speed_10m_max  

wind_direction_10m_dominant 

These variables form a representative summary of key atmospheric factors known to influence PM2.5 concentrations. Unlike the EPA dataset, weather data is typically complete for all days in the year, which made it a stable backbone for integration. After retrieval, the dataset was normalized and exported into a CSV file for compatibility with DuckDB and Pandas-based processing. 

The Open-Meteo API allows free academic use under a Creative Commons license. Attribution is required and provided in the final report. No personal or sensitive data is included, so no privacy concerns are present. 

 

3. Integration Rationale and Schema 

The two datasets were integrated on the shared key date, after standardizing date formats and ensuring both sources used local time for Chicago. Because the EPA dataset contains only 128 days of valid PM2.5 readings and the weather dataset contains 365 days, the merged dataset includes only days that appear in both sources. 

The integration process used a hybrid SQL/Pandas pipeline: 

EPA data loaded into DuckDB table epa_pm25_2023  

Weather data loaded into DuckDB table weather_chicago_2023  

SQL join performed on the date column  

Result exported for further cleaning 

The integrated dataset was saved to: 

data/processed/chicago_pm25_weather_daily.csv 

This file contains the following final fields: 

PM2.5 observations: mean, min, max, count  

Weather observations: temperature min/max, precipitation, humidity, radiation, wind speed, wind direction 

A conceptual integration model is documented in the project plan and describes the relationship between pollutant metrics and meteorological attributes. 

 

4. Constraints and Ethical Considerations 

EPA PM2.5 data is open and free but contains data-quality issues such as missing days and inconsistent monitoring.  

Open-Meteo weather data is licensed under CC-BY 4.0, requiring attribution.  

Both datasets contain no PII, thus posing minimal ethical risk.  

Redistribution of input data via GitHub is restricted; therefore all data files are stored in a Box folder, as required by the course.  

Users must download data from Box and place it into the specified folder structure (data/processed/ and data/clean/). 

 

5. Final Cleaned Dataset 

After integration and cleaning, the final dataset is stored as: 

 

Data Quality 

Ensuring high data quality was a central component of this project, because the EPA PM2.5 dataset and the Open-Meteo weather dataset differ substantially in structure, completeness, and measurement practices. Our goal was to transform two heterogeneous raw sources into a single, reliable, analysis-ready dataset representing daily environmental conditions in Chicago for 2023. To achieve this, we followed a structured quality assessment and cleaning workflow that combined automated checks in Python with interactive refinement in OpenRefine. The process addressed completeness, accuracy, consistency, validity, and integrity across both datasets. 

1. Profiling and Initial Assessment 

We began by profiling the integrated dataset using pandas to calculate summary statistics, identify missing values, inspect ranges, and validate variable types. This step allowed us to detect several common issues typical of environmental datasets: 

Missing PM2.5 observations on days when certain EPA monitoring stations did not report. 

Weather variables (such as humidity, radiation, or wind direction) occasionally containing blank or null entries. 

Raw datatypes inconsistently stored as strings instead of numerical values. 

Date fields requiring standardization to ISO 8601 format. 

Occasional anomalies in temperature ranges (e.g., minimum temperature exceeding maximum temperature). 

Environmental measurements falling outside expected domain constraints (e.g., humidity > 100, wind direction > 360). 

This profiling gave us a roadmap of which fields required cleaning and validation. 

2. Cleaning PM2.5 Data 

The EPA dataset presented the greatest variability because air quality monitors do not always record values daily. We removed rows with missing or non-numeric PM2.5 readings to prevent misleading averages. We ensured that the daily minimum, mean, and maximum PM2.5 values adhered to the logical ordering min ≤ mean ≤ max. When the EPA file included rows for locations outside Chicago or containing outdated metadata fields, we filtered them out based on county and site identifiers. 

Values identified as extreme outliers—those significantly exceeding historical Chicago norms—were evaluated for plausibility. When outliers corresponded to legitimate high-pollution events, they were retained; otherwise, they were corrected or removed. Through these steps, the PM2.5 portion of the dataset became internally consistent and structurally sound. 

3. Cleaning Weather Data 

Weather data from Open-Meteo was generally complete for all 365 days of 2023, but still required uniform cleaning. Missing values in precipitation, humidity, or radiation were handled appropriately depending on the variable’s characteristics. For example, rare missing humidity observations were filled using forward/backward interpolation, while missing radiation or wind measurements were left as NaN when imputation risked distorting natural seasonal patterns. 

All numeric fields were converted from strings to floats, and we enforced validity constraints:  

humidity between 0 and 100,  

wind direction between 0 and 360 degrees,  

temperature_min ≤ temperature_max. 

Invalid values were corrected when reasonable or removed entirely. 

4. Date Standardization and Dataset Alignment 

Both datasets measured conditions on a daily basis, but their date formats differed. We standardized all date values using pandas to_datetime and ensured Chicago local time alignment. After cleaning, we confirmed that each date in the final dataset appeared exactly once. 

Because weather data contains 365 daily entries while EPA reports only 128 days with valid PM2.5 readings, we aligned the datasets by performing an inner join on the shared date field. This ensured that all retained days contained complete information from both sources. Removing unmatched days prevents analytic bias and maintains temporal integrity. 

5. OpenRefine Interactive Cleaning 

After automated cleaning in Python, we used OpenRefine to conduct a second pass focused on structural consistency and human-detectable issues. In OpenRefine, we: 

Verified column types and converted any incorrectly typed fields.  

Identified and removed duplicate rows.  

Checked for inconsistent formatting (e.g., whitespace, capitalization).  

Validated outlier cases visually.  

Ensured column names followed consistent, descriptive conventions. 

The OpenRefine operation history (JSON “recipe”) is stored in: docs/openrefine/openrefine_history.json 

 

 

 

This provides full transparency and allows anyone to reapply the same transformations. 

  

 

6. Final Validation   

Before finalizing the dataset, we performed a comprehensive validation: 

  

- No missing PM2.5 values remained.   

- All weather variables were numeric, with valid domains.   

- Date range matched the expected 2023 period.   

- All remaining rows corresponded to true Chicago conditions.   

- Column schema was fully standardized. 

  

We also inspected correlations, distribution plots, and summary statistics to verify that the cleaned dataset behaved realistically and did not contain artifacts introduced by the cleaning process. 

  

7. Final Output   

After all cleaning steps, we exported the final dataset to: data/clean/chicago_pm25_weather_daily_clean.csv 

 

This file contains the fully validated variables used in the analysis and visualization phase. The cleaned dataset is compact, consistent, and reproducible, with clear lineage back to the raw sources through checksums, metadata, and documented cleaning scripts. 

  

The combination of code-based cleaning, schema validation, OpenRefine refinement, and integrity checks ensures that the final dataset meets INFO 477's requirements for transparency, quality, and reproducibility. 

 

Findings 

The cleaned, integrated dataset allows us to explore how daily PM2.5 concentrations relate to weather patterns in Chicago during 2023. Our analysis combined descriptive statistics, time-series visualizations, and cross-variable comparisons to reveal several meaningful environmental relationships. 

1. General Pollution Patterns 

Across the 128 days for which valid PM2.5 readings were available, daily mean PM2.5 averaged 10.19 µg/m³, with values ranging from 1.9 µg/m³ to 49.27 µg/m³. These statistics reflect typical Chicago patterns, where most days remain within moderate EPA air quality ranges but occasional spikes occur, particularly during stagnant winter periods or regional smoke events. The interquartile range (IQR) for PM2.5 mean values (5.99–12.34 µg/m³) suggests moderate day-to-day variability even outside of major pollution episodes. 

2. Temperature and PM2.5 

Temperature data show strong seasonal variation, with daily maximum temperatures ranging from –8.2°C to 34.6°C. Visual inspection of scatterplots revealed a weak negative association between temperature and PM2.5: colder days tended to have higher PM2.5 concentrations. This pattern aligns with typical atmospheric behavior—winter months often experience temperature inversions and reduced mixing height, trapping pollutants closer to the surface. Conversely, warmer days promote vertical air movement and pollutant dispersion. The median temperature range (6.55–15.45°C) brackets the majority of PM2.5 observations, reinforcing that transitional seasons (spring and fall) show the most stable pollution levels. 

3. Humidity and PM2.5 

Relative humidity averaged 74.86%, with values spanning from 44% to 98%. Higher-pollution days frequently coincided with humidity levels above 80%, which may be due to two mechanisms: (1) hygroscopic particle growth that increases measured PM2.5 mass, and (2) humid, stagnant air masses that prevent pollutant dispersion. The upper quartile humidity value (82%) overlaps with periods showing elevated PM2.5. This relationship is also visible in your correlation heatmap. 

4. Precipitation Effects 

Precipitation showed a highly skewed distribution: the median was only 0.10 mm, and many days recorded 0 mm, but extreme events reached 137.8 mm. The visualizations indicated that on days with significant precipitation, PM2.5 tended to drop sharply due to wet deposition (“washout”). However, because PM2.5 data covered only 128 days, heavy rainfall events did not always overlap with recorded pollutant measurements. Still, the few overlapping events demonstrated a notable downward effect on PM2.5. 

5. Wind Speed and Direction 

Wind speeds ranged from 11.4 km/h to 45.7 km/h, with higher winds generally associated with lower PM2.5 levels. This finding matches established atmospheric science: strong winds dilute pollutants. Your scatterplot showed a clear downward slope in PM2.5 at wind speeds above 30 km/h. 

Wind direction had extremely wide variability (5°–351°), representing the full annual cycle of urban airflow. While direction alone did not show a direct relationship with PM2.5, it provides contextual insight into pollution transport patterns. 

6. Overall Relationships 

These results together create a coherent environmental narrative: 

Cold + humid + stagnant conditions → higher PM2.5  

Warm + dry + windy conditions → lower PM2.5  

Precipitation events reduce PM2.5 via atmospheric cleansing 

The dataset’s range, quartiles, and maxima/minima support these trends, and your visualizations (time series, scatterplots, and correlation heatmap) reinforce them. Despite having only 128 valid pollutant days, the relationships are clear and consistent with meteorological expectations. 

In summary, the integrated dataset successfully reveals how Chicago’s daily weather patterns shape PM2.5 levels. These insights highlight the importance of multi-source environmental integration and demonstrate the analytical value of the cleaned, curated dataset prepared in this project. 

 

 

 

Future Work 

While this project successfully integrates daily PM2.5 and weather data for Chicago and provides meaningful exploratory insights, there are several opportunities to expand, refine, and strengthen the analysis. These enhancements would improve both the scientific value of the dataset and the technical maturity of the overall data pipeline. Below, we outline several directions for future work, grouped into methodological, analytical, and reproducibility-focused improvements. 

1. Expand Dataset Coverage and Temporal Scope 

A major limitation of the current dataset is the restricted set of 128 days with valid PM2.5 measurements in 2023. This constraint resulted from EPA monitoring gaps and the specific availability of parameter 88101 data for Chicago. Extending the temporal range to include multiple years—such as 2015–2024—would create a more robust time-series suitable for trend analysis and seasonal decomposition. Additional years of data would also allow for detecting long-term pollution patterns, policy impacts (e.g., Clean Air Act interventions), and interannual variability driven by climate cycles. 

Similarly, expanding the spatial scope to include nearby cities (e.g., Milwaukee, Detroit, Indianapolis) or multiple neighborhoods within Chicago would support comparative analysis and reveal regional pollution transport patterns. This is feasible because both EPA and Open-Meteo provide consistent multi-location coverage. 

2. Enhance Predictive Modeling and Statistical Analysis 

Our current work focuses on descriptive trends and visual associations. A natural next step is to introduce more advanced modeling techniques. Possible directions include: 

Multiple linear regression to quantify the influence of temperature, humidity, wind, and precipitation on PM2.5 levels. 

Time-series modeling (ARIMA, Prophet) to forecast daily PM2.5. 

Machine learning models (Random Forests, Gradient Boosting) to capture nonlinear relationships. 

Causal inference approaches, such as difference-in-differences for specific meteorological or emission-related events. 

These approaches would deepen the project's scientific value by moving beyond correlation toward explanation and prediction. Because environmental relationships are nonlinear and involve interaction effects (e.g., humidity × temperature), machine learning may significantly improve predictive accuracy. 

3. Incorporate Additional Environmental Variables 

The current dataset uses PM2.5 as the sole pollutant. However, the EPA AQS system includes many other pollutants—such as ozone (O₃), nitrogen dioxide (NO₂), and sulfur dioxide (SO₂)—that exhibit distinct relationships with weather. 

Integrating these pollutants would enable: 

Multi-pollutant regression models  

Smog/ozone episode detection  

Air quality clustering and principal component analysis  

Analysis of pollutant interactions under extreme weather events 

Furthermore, including NOAA’s additional meteorological variables (pressure, dew point, cloud cover) would provide richer environmental context. 

4. Improve Data Quality Validation Procedures 

Although the project implemented strong Python- and OpenRefine-based cleaning, future work could adopt more advanced and standardized quality frameworks, such as: 

Great Expectations or Pandera for automated schema validation  

Custom anomaly detectors for environmental variables  

Cross-referencing multiple weather APIs for verification  

More rigorous outlier detection (e.g., z-score or IQR-based methods) 

Establishing automated validation rules would strengthen reproducibility and ensure future datasets meet consistent quality standards. 

5. Strengthen Workflow Automation 

The Snakemake workflow in this project works but currently relies on local file paths, requiring users to modify them manually. A fully portable workflow should: 

Use relative paths based on PROJECT_ROOT  

Adopt environment modules or conda environments  

Automatically download raw data from EPA and Open-Meteo  

Regenerate all intermediate files, visualizations, and final outputs with one command 

A fully automated “run-all” system would significantly increase reproducibility and reduce user error. The project could also containerize the environment using Docker, ensuring that all dependencies are isolated and portable across operating systems. 

6. Deploy an Interactive Dashboard 

The static plots created in the current analysis are effective but limited. Future work could include a full interactive dashboard using: 

Plotly Dash  

Streamlit  

Bokeh  

Observable notebooks 

Such a dashboard could allow users to explore PM2.5 trends by month, filter weather attributes, or highlight specific pollution events interactively. This would greatly increase the project's usability for public audiences, policymakers, or researchers. 

7. Create a Richer Metadata and Documentation Package 

While the current version includes a data dictionary and basic metadata, future versions could adopt formal metadata standards such as: 

DataCite Metadata Schema  

DCAT (Data Catalog Vocabulary)  

Schema.org Dataset markup 

Following these standards would allow the dataset to be indexed in data repositories and increase its findability and reuse potential. 

8. Publish the Dataset with a Persistent Identifier 

Finally, the project could be deposited into an archival repository such as Zenodo, Harvard Dataverse, or Figshare. This would generate a DOI, making the dataset citable in academic research and compliant with FAIR (Findable, Accessible, Interoperable, Reusable) principles. This step would also satisfy INFO 477’s optional FAIR excellence criteria. 

Reproducibility 

In summary, while the current project successfully integrates and analyzes daily PM2.5 and weather data for Chicago, numerous opportunities exist to expand its scope, analytic depth, and technical rigor. These improvements would enhance the pipeline’s scientific relevance, public value, and long-term maintainability. 

 

To ensure that the full workflow of this project can be reproduced by others, we developed a structured and transparent set of procedures that follow the entire data lifecycle. Anyone attempting to reproduce our results should begin by cloning our GitHub repository and installing the Python dependencies listed in our requirements.txt, which was generated using pip freeze to guarantee an exact snapshot of our computational environment. Because the datasets used in this project cannot be redistributed directly through GitHub due to size and licensing considerations, all raw, processed, and cleaned data files are stored in a shared Box folder. Users must download these files and place them into the correct directory structure within the project folder, following the documented data/raw, data/processed, and data/clean layout. This ensures that the notebooks and scripts can locate their inputs without modification. 

The reproduction process begins with the data acquisition and verification stage, which is optional if the user already has the Box-supplied files. The first notebook demonstrates how the EPA PM2.5 dataset and the Open-Meteo weather dataset were originally obtained. It includes code that unzips the EPA archive, loads both raw files, and computes SHA-256 checksums to validate file integrity. These checksums allow users to confirm that their downloaded files match the versions used in our analysis. The second notebook handles storage and extraction. It loads both raw datasets into a DuckDB database, standardizes formats, and exports cleaned daily-level tables for Chicago. This relational organization ensures consistent access to both datasets and provides a controlled environment for integration. 

Next, users must reproduce the integration step, which combines the EPA and weather data. This step can be executed using the integration script provided in the repository. The script performs the necessary joins on the shared date field and saves the integrated dataset in the data/processed directory. Following integration, the main cleaning and quality-assessment notebook must be run. This notebook performs all data profiling, type corrections, missing value handling, and domain validations. It also applies the transformations captured in our OpenRefine JSON history file, ensuring that the cleaning process is fully transparent and repeatable. The result is the cleaned dataset stored in data/clean/chicago_pm25_weather_daily_clean.csv. 

Once the cleaned dataset has been generated, users can run the visualization notebook, which produces all figures used in the analysis. These include time-series plots, scatterplots exploring pollutant–weather relationships, and a correlation heatmap. Running this notebook will recreate the full set of plots in the results/ folder. Together, the notebooks form the core reproducible workflow of the project and enable users to regenerate all outputs from scratch. 

We also include a Snakemake workflow to demonstrate workflow automation. However, because this workflow was developed using absolute local file paths, anyone attempting to use Snakemake must edit the file paths inside the Snakefile to match their own machine. Once these paths have been updated, the Snakemake pipeline can automatically execute the cleaning and visualization notebooks and generate the corresponding outputs. This limitation is documented clearly to maintain transparency about the current portability of the automated workflow. 

Finally, the project includes a complete metadata package containing the data dictionary, descriptive metadata following DataCite guidelines, and checksum files for integrity verification. With the repository structure, Box-hosted data, notebooks, scripts, and automation components in place, the project provides a fully traceable and reproducible workflow that reflects best practices in data curation and analysis. 

Box Link 

All input and output data required to reproduce this project are hosted in a shared Box folder, as required by the course policy prohibiting raw or large data files from being committed directly to GitHub. Users must download the complete dataset package from the following link: https://uofi.box.com/s/nx5x1z7f9bagtzc1daf0ibits9sexmey. After downloading, the contents should be extracted and placed into the appropriate directories within the project structure, including data/raw/, data/processed/, and data/clean/. The project’s notebooks and scripts expect this structure, and the pipeline will not execute correctly unless the files are placed in their designated locations. A full description of the required directory layout is provided in the Reproducibility section. This Box folder must remain accessible to graders and anyone attempting to re-run the workflow. 

 

References 

This project relies on several open data sources, tools, and software packages. The primary air quality data were obtained from the U.S. Environmental Protection Agency’s Air Quality System (AQS), which provides publicly accessible historical pollutant measurements collected from monitoring stations across the United States. These data are released as part of the federal government’s public domain resources and may be freely reused with attribution. Weather data were retrieved from the Open-Meteo Historical Weather API, an open, academic-friendly service licensed under Creative Commons (CC-BY 4.0). The API offers global meteorological variables, which we accessed programmatically to obtain daily temperature, humidity, radiation, precipitation, and wind measurements for Chicago. Both datasets form the foundation of the integrated environmental dataset used in our analysis. 

To support storage, extraction, and data integration, we used DuckDB, an in-process analytical database engine designed for efficient columnar data queries. DuckDB enabled us to load, clean, and restructure the EPA and weather data before exporting them into CSV format for downstream processing. OpenRefine was used during the cleaning process to identify type inconsistencies, remove duplicates, and apply standardized transformations across fields. The OpenRefine transformation history is included with the project as part of the reproducibility documentation. 

All analysis, integration, visualization, and workflow scripts were written in Python using widely adopted open-source packages, including pandas for data manipulation, NumPy for array-based operations, Matplotlib and Seaborn for visualization, and Requests for API calls. These libraries together supported the full computational workflow and ensured that our results could be reproduced in any Python 3.10+ environment. 

A complete set of formal citations is included below. 

 

Full Citation List (APA Style) 

U.S. Environmental Protection Agency. (2023). Air Quality System (AQS) Data Mart: Daily PM2.5 Data (Parameter 88101). https://aqs.epa.gov/aqsweb/airdata/download_files.html 

Open-Meteo. (2023). Open-Meteo Historical Weather API. https://open-meteo.com/en/docs/historical-weather-api 

DuckDB Foundation. (2023). DuckDB: An In-Process Analytical Database. https://duckdb.org/ 

OpenRefine. (2023). OpenRefine (Version 3.7). https://openrefine.org/ 

van Rossum, G., & The Python Development Team. (2023). Python (Version 3.10). https://www.python.org/ 

McKinney, W. (2010). pandas: Data Structures for Statistical Computing in Python. https://pandas.pydata.org/ 

Virtanen, P., et al. (2020). SciPy: Fundamental Algorithms for Scientific Computing in Python. https://scipy.org/ 

Hunter, J. D. (2007). Matplotlib: A 2D Graphics Environment. https://matplotlib.org/ 

Waskom, M. (2021). Seaborn: Statistical Data Visualization. https://seaborn.pydata.org/ 

The Requests Project. (2023). Requests: HTTP for Humans. https://requests.readthedocs.io/ 

The Jupyter Project. (2023). Jupyter Notebook. https://jupyter.org/ 

Snakemake Community. (2023). Snakemake Workflow Management System. https://snakemake.readthedocs.io/ 

 
