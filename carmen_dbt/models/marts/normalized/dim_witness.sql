WITH witnesses AS (
  SELECT
    DISTINCT witness
  FROM
    {{ ref('stg_carmen_all') }}
  WHERE
    witness IS NOT NULL
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      witness
  ) AS witness_id,
  witness AS witness_name
FROM
  witnesses
