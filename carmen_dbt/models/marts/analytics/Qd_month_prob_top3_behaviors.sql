WITH top3 AS (
  SELECT
    behavior_id
  FROM
    {{ ref('Qc_top3_behaviors') }}
),
sightings AS (
  SELECT
    DATE_TRUNC(
      'month',
      fs.date_witness
    ) AS MONTH,
    fs.behavior_id
  FROM
    {{ ref('fact_sighting') }}
    fs
  WHERE
    fs.date_witness IS NOT NULL
),
month_totals AS (
  SELECT
    MONTH,
    COUNT(*) AS total
  FROM
    sightings
  GROUP BY
    1
),
month_top3 AS (
  SELECT
    s.month,
    COUNT(*) AS top3_count
  FROM
    sightings s
    JOIN top3 t
    ON s.behavior_id = t.behavior_id
  GROUP BY
    s.month
)
SELECT
  mt.month,
  mt.total,
  COALESCE(
    m3.top3_count,
    0
  ) AS top3_count,
  ROUND(
    CASE
      WHEN mt.total = 0 THEN 0
      ELSE (
        m3.top3_count :: DECIMAL / mt.total
      )
    END,
    4
  ) AS probability_top3
FROM
  month_totals mt
  LEFT JOIN month_top3 m3
  ON mt.month = m3.month
ORDER BY
  mt.month
