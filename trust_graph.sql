WITH RECURSIVE search_graph(claimant_id, user_id, depth, path, cycle) AS (
  SELECT
    g.claimant_id,
    g.user_id,
    1,
    ARRAY [g.claimant_id, g.user_id],
    FALSE
  FROM confirmations g
  WHERE claimant_id = 15
  UNION
  SELECT
    g.claimant_id,
    g.user_id,
    sg.depth + 1,
    path || g.user_id,
    g.id = ANY (path)
  FROM confirmations g, search_graph sg
  WHERE g.claimant_id = sg.user_id
        AND NOT cycle
)
SELECT DISTINCT
  path,
  claimant_id,
  user_id,
  depth
FROM search_graph
WHERE depth <= 3
ORDER BY PATH;
