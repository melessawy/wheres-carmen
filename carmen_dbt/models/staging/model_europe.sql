SELECT
  TRY_CAST(
    date_witness AS DATE
  ) AS date_witness,
  TRY_CAST(
    date_filed AS DATE
  ) AS date_agent,
  witness,
  agent,
  TRY_CAST(
    lat_ AS DOUBLE
  ) AS latitude,
  TRY_CAST(
    long_ AS DOUBLE
  ) AS longitude,
  city,
  country,
  region_hq,
  {{ parse_bool('"Armed?"') }} AS has_weapon,
  {{ parse_bool('"chapeau?"') }} AS has_hat,
  {{ parse_bool('"coat?"') }} AS has_jacket,
  observed_action AS behavior
FROM
  {{ ref("region_europe") }}
