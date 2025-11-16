from pathlib import Path
import duckdb

# ---------------------------------------------------
# Project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data"
RAW_DIR = DATA_DIR / "raw"
PROCESSED_DIR = DATA_DIR / "processed"
DB_DIR = DATA_DIR / "db"

DB_PATH = DB_DIR / "project.duckdb"
INTEGRATED_CSV = PROCESSED_DIR / "chicago_pm25_weather_daily.csv"
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

# ---------------------------------------------------
# Connect to DuckDB
con = duckdb.connect(str(DB_PATH))
print("Connected to DuckDB at:", DB_PATH)


# ---------------------------------------------------
# quick check
print("\nChecking table row counts...")

epa_count = con.execute("SELECT COUNT(*) FROM epa_chicago_daily;").fetchone()[0]
weather_count = con.execute("SELECT COUNT(*) FROM weather_chicago_daily;").fetchone()[0]

print(f"EPA daily rows:      {epa_count}")
print(f"Weather daily rows:  {weather_count}")


# ---------------------------------------------------
# Create integrated dataset
print("\nCreating integrated table chicago_pm25_weather_daily...")

con.execute("""
    CREATE OR REPLACE TABLE chicago_pm25_weather_daily AS
    SELECT
        e.date                        AS date,
        e.pm25_mean,
        e.pm25_min,
        e.pm25_max,
        e.n_measurements,

        w.temp_max,
        w.temp_min,
        w.precip_sum,
        w.shortwave_rad_sum,
        w.humidity_mean,
        w.wind_speed_max,
        w.wind_dir_dominant

    FROM epa_chicago_daily AS e
    JOIN weather_chicago_daily AS w
        ON e.date = w.date
    ORDER BY date;
""")

integrated_count = con.execute("SELECT COUNT(*) FROM chicago_pm25_weather_daily;").fetchone()[0]
print(f"Integrated row count: {integrated_count}")


# ---------------------------------------------------
# Export integrated table to CSV
print("\nExporting integrated CSV...")

con.execute(f"""
    COPY chicago_pm25_weather_daily
    TO '{INTEGRATED_CSV.as_posix()}'
    (HEADER, DELIMITER ',');
""")

print("Export complete!")
print("File saved to:", INTEGRATED_CSV)


# ---------------------------------------------------
# preview of the data
print("\nPreview of integrated table:")
df_preview = con.execute("SELECT * FROM chicago_pm25_weather_daily LIMIT 5;").df()
print(df_preview)
