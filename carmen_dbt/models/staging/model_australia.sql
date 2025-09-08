SELECT
  TRY_CAST(
    witnessed AS DATE
  ) AS date_witness,
  TRY_CAST(
    reported AS DATE
  ) AS date_agent,
  observer AS witness,
  field_chap AS agent,
  TRY_CAST(
    lat AS DOUBLE
  ) AS latitude,
  TRY_CAST(
    LONG AS DOUBLE
  ) AS longitude,
  place AS city,
  nation AS country,
  interpol_spot AS region_hq,
  {{ parse_bool('has_weapon') }} AS has_weapon,
  {{ parse_bool('has_hat') }} AS has_hat,
  {{ parse_bool('has_jacket') }} AS has_jacket,
  state_of_mind AS behavior
FROM
  {{ ref("region_australia") }}
