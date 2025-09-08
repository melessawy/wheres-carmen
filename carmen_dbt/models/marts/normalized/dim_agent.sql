WITH agents AS (
  SELECT
    DISTINCT AGENT,
    city
  FROM
    {{ ref('stg_carmen_all') }}
  WHERE
    AGENT IS NOT NULL
)
SELECT
  ROW_NUMBER() over (
    ORDER BY
      AGENT
  ) AS agent_id,
  AGENT AS agent_name,
  city AS agenct_city
FROM
  agents
