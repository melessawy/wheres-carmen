WITH raw AS (
  SELECT
    DISTINCT behavior
  FROM
    {{ ref('stg_carmen_all') }}
  WHERE
    behavior IS NOT NULL
),
normalized AS (
  SELECT
    behavior,
    LOWER(
      TRIM(REGEXP_REPLACE(behavior, '[^a-z0-9 ]', '', 'ig'))
    ) AS behavior_normalized
  FROM
    raw
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      behavior_normalized
  ) AS behavior_id,
  behavior_normalized,
  behavior AS behavior_example
FROM
  normalized
