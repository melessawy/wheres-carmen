SELECT
  TRY_CAST(
    date_witness AS DATE
  ) AS date_witness,
  TRY_CAST(
    date_agent AS DATE
  ) AS date_agent,
  witness,
  agent,
  TRY_CAST(
    latitude AS DOUBLE
  ) AS latitude,
  TRY_CAST(
    longitude AS DOUBLE
  ) AS longitude,
  city,
  country,
  region_hq,
  {{ parse_bool('has_weapon') }} AS has_weapon,
  {{ parse_bool('has_hat') }} AS has_hat,
  {{ parse_bool('has_jacket') }} AS has_jacket,
  behavior
FROM
  {{ ref("region_indian") }}
