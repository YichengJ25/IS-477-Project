# -----------------------------------------------------
# Snakemake Workflow
# End-to-end pipeline from acquisition to visualization
# Makes sure you change the working directory to the project root and change paths as needed.
# -----------------------------------------------------

# Final targets
RAW_INTEGRATED   = "data/processed/chicago_pm25_weather_daily.csv"
CLEAN_DAILY      = "data/clean/chicago_pm25_weather_daily_clean.csv"
ANALYSIS_MARKER  = "results/analysis_done.txt"

# Intermediate targets
EPA_CSV          = "data/raw/epa/daily_88101_2023/daily_88101_2023.csv"
EPA_SHA          = "data/checksums/epa_daily_88101_2023.sha256"
NOAA_JSON_SHA    = "data/checksums/noaa_open_meteo_2023_json.sha256"
NOAA_DAILY_SHA   = "data/checksums/open_meteo_chicago_2023_daily_csv.sha256"

EPA_DAILY_CLEAN  = "data/processed/epa_chicago_daily_clean.csv"
WX_DAILY_CLEAN   = "data/processed/weather_chicago_daily_clean.csv"
DB_FILE          = "data/db/project.duckdb"

# -----------------------------------------------------
# RULE: all
# Run the whole workflow with:
#     snakemake -j1
# -----------------------------------------------------
rule all:
    input:
        CLEAN_DAILY,
        ANALYSIS_MARKER


# -----------------------------------------------------
# RULE: acquire_and_verify
# Executes:
#   code/01_data_acquisition_and_verification.ipynb
#
# Produces:
#   - unzipped EPA CSV
#   - checksum files in data/checksums/
# -----------------------------------------------------
rule acquire_and_verify:
    input:
        "data/raw/epa/daily_88101_2023.zip",
        "data/raw/noaa/open_meteo_chicago_2023.json",
        "data/raw/noaa/open_meteo_chicago_2023_daily.csv"
    output:
        EPA_CSV,
        EPA_SHA,
        NOAA_JSON_SHA,
        NOAA_DAILY_SHA
    shell:
        """
        jupyter nbconvert --execute \
            --to notebook \
            --output 01_data_acquisition_and_verification_executed.ipynb \
            code/01_data_acquisition_and_verification.ipynb

        # Snakemake tracks these files as outputs; the notebook
        # actually creates them, so we just 'touch' to refresh times.
        touch {output}
        """


# -----------------------------------------------------
# RULE: storage_organization
# Executes:
#   code/02_data_storage_organization_and_extraction.ipynb
#
# Produces:
#   - daily EPA & weather tables in data/processed/
#   - DuckDB file in data/db/
# -----------------------------------------------------
rule storage_organization:
    input:
        EPA_CSV
    output:
        EPA_DAILY_CLEAN,
        WX_DAILY_CLEAN,
        DB_FILE
    shell:
        """
        jupyter nbconvert --execute \
            --to notebook \
            --output 02_data_storage_organization_and_extraction_executed.ipynb \
            code/02_data_storage_organization_and_extraction.ipynb

        touch {output}
        """


# -----------------------------------------------------
# RULE: integrate
# Executes:
#   code/03_data_integration.py
#
# Produces:
#   data/processed/chicago_pm25_weather_daily.csv
# -----------------------------------------------------
rule integrate:
    input:
        EPA_DAILY_CLEAN,
        WX_DAILY_CLEAN,
        DB_FILE
    output:
        RAW_INTEGRATED
    shell:
        """
        python code/03_data_integration.py
        """


# -----------------------------------------------------
# RULE: quality_and_clean
# Executes:
#   code/04_data_quality_and_clean.ipynb
#
# Produces:
#   data/clean/chicago_pm25_weather_daily_clean.csv
#   (and 04_data_quality_and_clean_executed.ipynb as a side effect)
# -----------------------------------------------------
rule quality_and_clean:
    input:
        RAW_INTEGRATED
    output:
        CLEAN_DAILY
    shell:
        """
        jupyter nbconvert --execute \
            --to notebook \
            --output 04_data_quality_and_clean_executed.ipynb \
            code/04_data_quality_and_clean.ipynb

        touch {output}
        """


# -----------------------------------------------------
# RULE: run_analysis
# Executes:
#   code/05_data_visualization.ipynb
#
# Produces:
#   - figures in results/ (created inside the notebook)
#   - results/analysis_done.txt (marker file)
# -----------------------------------------------------
rule run_analysis:
    input:
        CLEAN_DAILY
    output:
        ANALYSIS_MARKER
    shell:
        """
        mkdir -p results

        jupyter nbconvert --execute \
            --to notebook \
            --output 05_data_visualization_executed.ipynb \
            code/05_data_visualization.ipynb

        echo "analysis complete" > {output}
        """
