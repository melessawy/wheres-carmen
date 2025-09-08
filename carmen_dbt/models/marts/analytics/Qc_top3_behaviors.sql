WITH b AS (
  SELECT
    b.behavior_id,
    b.behavior_normalized,
    COUNT(*) AS cnt
  FROM
    {{ ref('fact_sighting') }}
    fs
    JOIN {{ ref('dim_behavior') }}
    b
    ON fs.behavior_id = b.behavior_id
  GROUP BY
    1,
    2
)
SELECT
  behavior_id,
  behavior_normalized,
  cnt
FROM
  b
ORDER BY
  cnt DESC
LIMIT
  3
