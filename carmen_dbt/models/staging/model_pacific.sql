SELECT
  TRY_CAST(
    sight_on AS DATE
  ) AS date_witness,
  TRY_CAST(
    file_on AS DATE
  ) AS date_agent,
  sighter AS witness,
  filer AS agent,
  TRY_CAST(
    lat AS DOUBLE
  ) AS latitude,
  TRY_CAST(
    LONG AS DOUBLE
  ) AS longitude,
  town AS city,
  nation AS country,
  report_office AS region_hq,
  {{ parse_bool('has_weapon') }} AS has_weapon,
  {{ parse_bool('has_hat') }} AS has_hat,
  {{ parse_bool('has_jacket') }} AS has_jacket,
  behavior
FROM
  {{ ref("region_pacific") }}
