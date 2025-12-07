# -----------------------------------------------------
# INFO 477 – Snakemake Workflow
# End-to-end pipeline using Jupyter Notebooks
# -----------------------------------------------------

RAW = "data/processed/chicago_pm25_weather_daily.csv"
CLEAN = "data/clean/chicago_pm25_weather_daily_clean.csv"
ANALYSIS_MARKER = "results/analysis_done.txt"

# -----------------------------------------------------
# RULE: all
# This is what Snakemake builds when you run:
#     snakemake -j1
# -----------------------------------------------------
rule all:
    input:
        CLEAN,
        ANALYSIS_MARKER


# -----------------------------------------------------
# RULE: quality_and_clean
# Executes the notebook:
#   code/04_data_quality_and_clean.ipynb
# and produces:
#   data/clean/chicago_pm25_weather_daily_clean.csv
# -----------------------------------------------------
rule quality_and_clean:
    input:
        RAW
    output:
        CLEAN
    shell:
        """
        jupyter nbconvert --execute \
            --to notebook \
            --output 04_data_quality_and_clean_executed.ipynb \
            code/04_data_quality_and_clean.ipynb

        # Touch output so Snakemake knows it was (re)generated
        touch {output}
        """

# -----------------------------------------------------
# RULE: run_analysis
# Executes the notebook:
#   code/05_data_visualization.ipynb
# and creates:
#   results/*.png (inside the notebook)
#   results/analysis_done.txt
# -----------------------------------------------------
rule run_analysis:
    input:
        CLEAN
    output:
        ANALYSIS_MARKER
    shell:
        """
        jupyter nbconvert --execute \
            --to notebook \
            --output 05_data_visualization_executed.ipynb \
            code/05_data_visualization.ipynb

        # Touch the marker file
        echo "analysis complete" > {output}
        """
