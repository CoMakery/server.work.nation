WITH RECURSIVE search_graph(confirmer_id, skill_claimant_id, depth, path, cycle) AS (
  SELECT
    g.confirmer_id,
    g.skill_claimant_id,
    1 as depth,
    ARRAY [g.confirmer_id, g.skill_claimant_id] as path,
    FALSE as cycle
  FROM confirmations g
  WHERE confirmer_id = 1
  UNION
  SELECT
    g.confirmer_id,
    g.skill_claimant_id,
    sg.depth + 1,
    path || g.skill_claimant_id,
    g.confirmer_id = ANY (path)
  FROM confirmations g, search_graph sg
  WHERE g.confirmer_id = sg.skill_claimant_id
  AND NOT cycle
)
SELECT DISTINCT
  path,
  skill_claimant_id,
  confirmer_id,
  depth
FROM search_graph
WHERE depth <= 4
ORDER BY PATH;
