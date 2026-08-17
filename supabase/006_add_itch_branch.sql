-- Run this once in the Supabase SQL Editor to allow 'ITCH' as a branch value,
-- giving the itch.io build its own separate leaderboard from dev/main. Existing
-- DEV/MAIN rows are unaffected.
alter table public.swipeecho_scores
  drop constraint swipeecho_scores_branch_check;

alter table public.swipeecho_scores
  add constraint swipeecho_scores_branch_check check (branch in ('DEV', 'MAIN', 'ITCH'));
