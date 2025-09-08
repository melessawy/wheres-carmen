WITH sightings AS (
  SELECT
    DATE_TRUNC(
      'month',
      date_witness
    ) AS MONTH,
    region_source
  FROM
    {{ ref('fact_sighting') }}
  WHERE
    date_witness IS NOT NULL
),
counts AS (
  SELECT
    MONTH,
    region_source,
    COUNT(*) AS cnt
  FROM
    sightings
  GROUP BY
    1,
    2
),
ranked AS (
  SELECT
    MONTH,
    region_source,
    cnt,
    ROW_NUMBER() over (
      PARTITION BY MONTH
      ORDER BY
        cnt DESC
    ) AS rn
  FROM
    counts
)
SELECT
  MONTH,
  region_source AS most_likely_region,
  cnt AS sightings_count
FROM
  ranked
WHERE
  rn = 1
ORDER BY
  MONTH
