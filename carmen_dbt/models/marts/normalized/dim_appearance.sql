WITH combos AS (
  SELECT
    DISTINCT has_weapon,
    has_hat,
    has_jacket
  FROM
    {{ ref('stg_carmen_all') }}
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      has_weapon DESC,
      has_jacket DESC,
      has_hat DESC
  ) AS appearance_id,
  has_weapon,
  has_hat,
  has_jacket
FROM
  combos
