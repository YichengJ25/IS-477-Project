# IS-477-Project
Course project repository for IS 477. Includes project plan, datasets, workflows, and analysis following full data lifecycle and ethical data handling requirements.

## ⚠️ Note on Raw Data File Size and Reproducibility

One of the EPA raw data files (`daily_88101_2023.csv`) exceeded GitHub’s 100 MB file size limit.  
To keep the repository functional and reproducible, the file has been compressed into:

data/raw/epa/daily_88101_2023.zip

### How to reproduce the workflow
Before running any acquisition, extraction, or integration scripts, **please unzip the file**:

data/raw/epa/daily_88101_2023.zip

This will restore the original folder structure:

data/raw/epa/daily_88101_2023/
└── daily_88101_2023.csv

All Jupyter notebooks and Python scripts have been written to automatically read the **CSV**, not the ZIP.  
Once the file is unzipped, the entire project works end-to-end without any modification.

If you have questions or need clarification, please feel free to contact me. Thank you!
