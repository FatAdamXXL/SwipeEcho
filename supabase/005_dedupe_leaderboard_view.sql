-- Run this once in the Supabase SQL Editor to add a deduplicated view of the
-- leaderboard: repeat submissions of the same nickname at the same score
-- (accidental double-submits, or just replaying into an identical result)
-- collapse down to the most recent row. The app now reads from this view
-- instead of the raw table for the leaderboard display.
--
-- security_invoker makes the view enforce RLS as the querying role instead of
-- the view owner's — the underlying select policy is fully public either way,
-- but this matches Supabase's recommendation and avoids its "Security
-- Definer view" advisory. Re-running this file (e.g. if you already applied
-- an earlier version without this option) is safe — create or replace view
-- just updates it in place.
create or replace view public.swipeecho_leaderboard
  with (security_invoker = true) as
select distinct on (branch, platform, nickname, score)
  id, nickname, score, branch, platform, created_at
from public.swipeecho_scores
order by branch, platform, nickname, score, created_at desc;

grant select on public.swipeecho_leaderboard to anon;
