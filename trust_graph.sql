WITH RECURSIVE search_graph(confirmer_id, skill_claimaint_id, depth, path, cycle) AS (
  SELECT
    g.confirmer_id,
    g.skill_claimaint_id,
    1,
    ARRAY [g.confirmer_id, g.skill_claimaint_id],
    FALSE
  FROM confirmations g
  WHERE confirmer_id = 15
  UNION
  SELECT
    g.confirmer_id,
    g.skill_claimaint_id,
    sg.depth + 1,
    path || g.skill_claimaint_id,
    g.id = ANY (path)
  FROM confirmations g, search_graph sg
  WHERE g.confirmer_id = sg.skill_claimaint_id
        AND NOT cycle
)
SELECT DISTINCT
  path,
  confirmer_id,
  skill_claimaint_id,
  depth
FROM search_graph
WHERE depth <= 3
ORDER BY PATH;
