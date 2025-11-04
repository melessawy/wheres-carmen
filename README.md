# Carmen Sandiego — dbt Assessment (Data Engineer Role)
Repository of the source problem is [here](https://github.com/cascadedebt/skills-assessment-data-engineer).

**Author:** Mohammed El Essawy  
**DB:** DuckDB 

---

## Objective

Engineer the `carmen_sightings_20220629061307.xlsx` Excel dataset into a dbt project. Build staging models, a normalized schema (>1NF), and analytical views to answer four questions about sightings of Carmen Sandiego.

---

## Design summary

- **Ingest**: Each Excel sheet exported to CSV and placed in `seeds/region_<name>.csv`. These are dbt seeds.
- **Staging**: 8 staging views (`models/staging/model_*.sql`) that map region-specific column names to a canonical schema:
  - `date_witness`, `date_agent`, `witness`, `agent`, `latitude`, `longitude`, `city`, `country`, `region_hq`,`has_weapon`, `has_hat`, `has_jacket`, `behavior`.
- **Union**: `stg_carmen_all` unions the eight views and adds the field `region_source`.
- **Normalization (>1NF)**: Persisted tables in `normalized` schema:
  - `dim_agent`, `dim_witness`, `dim_location`, `dim_appearance`, `dim_behavior`, `fact_sighting`.
- **Analytics**: Four analytical views in `analytics` schema answering the requested questions.

---

## ER Diagram

![ER Diagram](https://i.ibb.co/Kx5Y4RDw/erd.png)


---

## DBT Lineage Graph

![DBT Lineage Graph](https://i.ibb.co/rK6CtNSd/lineage.png)




---

## How to run (locally with DuckDB)

1. Export each sheet in `carmen_sightings_20220629061307.xlsx` to `seeds/region_<sheetname>.csv`. You can use the included python script `excel_to_csv.py` to perform that mission.
2. Install dbt-core and dbt-duckdb:
   `pip install dbt-core dbt-duckdb`
3. Copy profiles.yml.example to ~/.dbt/profiles.yml and adjust if necessary.
4. Run the below commands in order:
`dbt seed`,
`dbt run`,
`dbt test`,
`dbt docs generate`,
and `dbt docs serve`.
5. Inspect the analytics schema views: `Qa_month_region_most_likely`, `Qb_month_prob_armed_jacket_no_hat`, `Qc_top3_behaviors`, and `Qd_month_prob_top3_behaviors`.

## Analytical answers 
### a) For each month, which agency region is Carmen Sandiego most likely to be found?
The logic is to count sightings by region_source grouped by `date_trunc('month', date_witness)` and pick the region with the max count per month. A sample answer is below, but the full result can be inspected in the analytics table `Qa_month_region_most_likely`.

![Qa_month_region_most_likely sample](https://i.ibb.co/5Wc2ytmK/qa.png)

### b) For each month, probability Ms. Sandiego is armed AND wearing a jacket, but NOT a hat?
The logic is to compute the rows `where has_weapon = true AND has_jacket = true AND has_hat = false` then divide it by total signtings in the month.

Note: In the model, I assumed that a missing value of has_hat means NOT wearing a hat.

A sample answer is below, but the full result can be inspected in the analytics table `Qb_month_prob_armed_jacket_no_hat`.

Observations: The highest number of sightings with a weapon, jacket, and no hat was 148, occurring in May 2000, representing 17.3%. The lowest count was 15 sightings in December 1985, accounting for 1.7%.

![Qb_month_prob_armed_jacket_no_hat sample](https://i.ibb.co/dwnhxdgy/qb.png)

### c) 3 most occurring behaviours?
The logic is to normalise behaviour text by lowering the case and removing punctuation, count frequencies and pick the top three.

A screenshot of the output in `Qc_top3_behaviors` is provided below.

![Qc_top3_behaviors sample](https://i.ibb.co/d4gqDQWS/qc.png)


### d) For each month, probability Ms. Sandiego exhibits one of her three most occurring behaviours?

The logic is to count sightings whose normalised behaviour is in the top-3 list, then divide it by the total sightings for that month.

A sample answer is below, but the full result can be inspected in the analytics table `Qd_month_prob_top3_behaviors`.

![Qd_month_prob_top3_behaviors sample](https://i.ibb.co/jPKk1Fxg/qd.png)
