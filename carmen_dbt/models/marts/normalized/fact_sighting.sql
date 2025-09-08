WITH s AS (
  SELECT
    *
  FROM
    {{ ref('stg_carmen_all') }}
),
agent_map AS (
  SELECT
    agent_id,
    agent_name
  FROM
    {{ ref('dim_agent') }}
),
witness_map AS (
  SELECT
    witness_id,
    witness_name
  FROM
    {{ ref('dim_witness') }}
),
loc_map AS (
  SELECT
    location_id,
    city,
    country,
    latitude,
    longitude
  FROM
    {{ ref('dim_location') }}
),
appearance_map AS (
  SELECT
    appearance_id,
    has_weapon,
    has_hat,
    has_jacket
  FROM
    {{ ref('dim_appearance') }}
),
behavior_map AS (
  SELECT
    behavior_id,
    behavior_normalized
  FROM
    {{ ref('dim_behavior') }}
),
joined AS (
  SELECT
    s.*,
    A.agent_id,
    w.witness_id,
    l.location_id,
    ap.appearance_id,
    b.behavior_id,
    LOWER(
      TRIM(REGEXP_REPLACE(s.behavior, '[^a-z0-9 ]', '', 'ig'))
    ) AS behavior_normalized
  FROM
    s
    LEFT JOIN agent_map A
    ON A.agent_name = s.agent
    LEFT JOIN witness_map w
    ON w.witness_name = s.witness
    LEFT JOIN loc_map l
    ON l.city = s.city
    AND l.country = s.country
    LEFT JOIN appearance_map ap
    ON ap.has_weapon IS NOT DISTINCT
  FROM
    s.has_weapon
    AND ap.has_hat IS NOT DISTINCT
  FROM
    s.has_hat
    AND ap.has_jacket IS NOT DISTINCT
  FROM
    s.has_jacket
    LEFT JOIN behavior_map b
    ON b.behavior_normalized = LOWER(
      TRIM(REGEXP_REPLACE(s.behavior, '[^a-z0-9 ]', '', 'ig'))
    )
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      date_witness,
      AGENT,
      witness
  ) AS sighting_id,
  date_witness,
  date_agent,
  agent_id,
  witness_id,
  location_id,
  appearance_id,
  behavior_id,
  region_source,
  behavior AS raw_behavior_text
FROM
  joined
