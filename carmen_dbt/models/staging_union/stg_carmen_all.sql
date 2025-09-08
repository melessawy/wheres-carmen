WITH all_rows AS (
  SELECT
    *,
    'Africa' AS region_source
  FROM
    {{ ref('model_africa') }}
  UNION ALL
  SELECT
    *,
    'America' AS region_source
  FROM
    {{ ref('model_america') }}
  UNION ALL
  SELECT
    *,
    'Asia' AS region_source
  FROM
    {{ ref('model_asia') }}
  UNION ALL
  SELECT
    *,
    'Atlantic' AS region_source
  FROM
    {{ ref('model_atlantic') }}
  UNION ALL
  SELECT
    *,
    'Australia' AS region_source
  FROM
    {{ ref('model_australia') }}
  UNION ALL
  SELECT
    *,
    'Europe' AS region_source
  FROM
    {{ ref('model_europe') }}
  UNION ALL
  SELECT
    *,
    'Indian' AS region_source
  FROM
    {{ ref('model_indian') }}
  UNION ALL
  SELECT
    *,
    'Pacific' AS region_source
  FROM
    {{ ref('model_pacific') }}
)
SELECT
  date_witness,
  date_agent,
  witness,
  agent,
  latitude,
  longitude,
  city,
  country,
  city_agent,
  has_weapon,
  has_hat,
  has_jacket,
  behavior,
  region_source
FROM
  all_rows
