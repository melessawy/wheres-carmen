WITH s AS (
  SELECT
    DATE_TRUNC(
      'month',
      fs.date_witness
    ) AS MONTH,
    ap.has_weapon,
    ap.has_jacket,
    ap.has_hat
  FROM
    {{ ref('fact_sighting') }}
    fs
    LEFT JOIN {{ ref('dim_appearance') }}
    ap
    ON fs.appearance_id = ap.appearance_id
  WHERE
    fs.date_witness IS NOT NULL
),
month_totals AS (
  SELECT
    MONTH,
    COUNT(*) AS total
  FROM
    s
  GROUP BY
    1
),
month_condition AS (
  SELECT
    MONTH,
    COUNT(*) AS condition_count
  FROM
    s
  WHERE
    has_weapon = TRUE
    AND has_jacket = TRUE
    AND (
      has_hat = FALSE
      OR has_hat IS NULL
    )
  GROUP BY
    1
)
SELECT
  t.month,
  COALESCE(
    C.condition_count,
    0
  ) AS condition_count,
  t.total,
  ROUND(
    CASE
      WHEN t.total = 0 THEN 0
      ELSE (
        C.condition_count :: DECIMAL / t.total
      )
    END,
    4
  ) AS probability_armed_jacket_no_hat
FROM
  month_totals t
  LEFT JOIN month_condition C
  ON t.month = C.month
ORDER BY
  t.month
