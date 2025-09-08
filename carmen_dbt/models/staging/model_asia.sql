SELECT
  TRY_CAST(
    sighting AS DATE
  ) AS date_witness,
  TRY_CAST(
    "报道" AS DATE
  ) AS date_agent,
  citizen AS witness,
  officer AS agent,
  TRY_CAST(
    "纬度" AS DOUBLE
  ) AS latitude,
  TRY_CAST(
    "经度" AS DOUBLE
  ) AS longitude,
  city,
  nation AS country,
  city_interpol AS region_hq,
  {{ parse_bool('has_weapon') }} AS has_weapon,
  {{ parse_bool('has_hat') }} AS has_hat,
  {{ parse_bool('has_jacket') }} AS has_jacket,
  behavior
FROM
  {{ ref("region_asia") }}
