import pandas as pd
from pathlib import Path
import re

xlsx = Path("carmen_sightings_20220629061307.xlsx")
out = Path("carmen_dbt/seeds/")
# out.mkdir(parents=True, exist_ok=True)

# Read all sheets
xls = pd.read_excel(xlsx, sheet_name=None, engine="openpyxl")

def slugify(s):
    s = s.strip().lower()
    s = re.sub(r'[^a-z0-9]+', '_', s)
    s = re.sub(r'(^_|_$)', '', s)
    return s or "sheet"

for sheet_name, df in xls.items():
    fname = f"region_{slugify(sheet_name)}.csv"
    path = out / fname
    df.to_csv(path, index=False)
    print(f"Wrote {path}")
