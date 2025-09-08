WITH locs AS (
  SELECT
    DISTINCT city,
    country,
    latitude,
    longitude
  FROM
    {{ ref('stg_carmen_all') }}
  WHERE
    city IS NOT NULL
    AND country IS NOT NULL
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      country,
      city
  ) AS location_id,
  city,
  country,
  latitude,
  longitude
FROM
  locs
