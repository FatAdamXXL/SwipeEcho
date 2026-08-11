-- SwipeEcho global leaderboard (top 25)
-- Run this once in the Supabase SQL Editor for the project.

-- Free-tier Supabase has no branch/preview databases, so dev and main share this one
-- table. The "branch" column keeps their scores separate — the app filters by it.
-- Nickname length isn't constrained here — the 12-char cap is enforced app-side only
-- (input maxlength + client-side truncation before insert).
create table public.swipeecho_scores (
  id bigint generated always as identity primary key,
  nickname text not null,
  score integer not null check (score >= 0),
  branch text not null check (branch in ('DEV', 'MAIN')),
  -- MOBILE vs PC, detected client-side (touch/coarse-pointer heuristic). Nullable —
  -- rows from before this column existed can't be attributed after the fact.
  platform text check (platform in ('MOBILE', 'PC')),
  created_at timestamptz not null default now()
);

create index swipeecho_scores_branch_score_idx on public.swipeecho_scores (branch, score desc);
create index swipeecho_scores_branch_platform_score_idx on public.swipeecho_scores (branch, platform, score desc);

alter table public.swipeecho_scores enable row level security;

-- anyone can read the leaderboard
create policy "swipeecho_scores_select"
  on public.swipeecho_scores for select
  to anon
  using (true);

-- anyone can add a score, but only a valid one — no update or delete policies
-- exist, so entries can't be edited or removed via the API
create policy "swipeecho_scores_insert"
  on public.swipeecho_scores for insert
  to anon
  with check (score >= 0);

-- deduplicated read view: repeat submissions of the same nickname at the same
-- score collapse down to the most recent row. The app reads from this view
-- instead of the raw table for the leaderboard display.
-- security_invoker makes the view enforce RLS as the querying role instead of
-- the view owner's — the select policy above is fully public either way, but
-- this matches Supabase's recommendation and avoids its "Security Definer
-- view" advisory.
create or replace view public.swipeecho_leaderboard
  with (security_invoker = true) as
select distinct on (branch, platform, nickname, score)
  id, nickname, score, branch, platform, created_at
from public.swipeecho_scores
order by branch, platform, nickname, score, created_at desc;

grant select on public.swipeecho_leaderboard to anon;
