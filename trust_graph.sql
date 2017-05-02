WITH RECURSIVE trust_graph(confirmer_id, skill_claimant_id, skill_claim_id, depth, path, confirmations_in_graph) AS (
  SELECT
    conf1.confirmer_id,
    conf1.skill_claimant_id,
    conf1.skill_claim_id,
    1                                                   AS depth,
    ARRAY [conf1.confirmer_id, conf1.skill_claimant_id] AS path,
    ARRAY [conf1.id] AS confirmations_in_graph
  FROM confirmations conf1
  WHERE confirmer_id = 2
  UNION
  SELECT
    conf2.confirmer_id,
    conf2.skill_claimant_id,
    conf2.skill_claim_id,
    previous_results.depth + 1,
    previous_results.path || conf2.skill_claimant_id,
    previous_results.confirmations_in_graph || conf2.id
  FROM confirmations conf2, trust_graph previous_results
  WHERE conf2.confirmer_id = previous_results.skill_claimant_id
        AND depth < 3
        AND NOT conf2.skill_claimant_id = ANY (path)
        AND NOT conf2.id = ANY (previous_results.confirmations_in_graph)
        AND NOT (previous_results.path || conf2.skill_claimant_id) = previous_results.path
)
SELECT DISTINCT users.id, users.*
FROM trust_graph, users
WHERE users.id = skill_claimant_id;

-- SELECT DISTINCT trust_graph.skill_claimant_id
-- FROM trust_graph
-- WHERE skill_claim_id = 1;

-- SELECT DISTINCT path,
--   skill_claimant_id,
--   confirmer_id,
--   skill_id,
--   depth
-- FROM trust_graph
--   WHERE skill_id = 5
-- ORDER BY PATH;
