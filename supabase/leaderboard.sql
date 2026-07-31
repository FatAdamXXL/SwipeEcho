-- SwipeEcho global leaderboard (top 25)
-- Run this once in the Supabase SQL Editor for the project.

create table public.swipeecho_scores (
  id bigint generated always as identity primary key,
  nickname text not null check (char_length(nickname) between 1 and 8),
  score integer not null check (score >= 0),
  created_at timestamptz not null default now()
);

create index swipeecho_scores_score_idx on public.swipeecho_scores (score desc);

alter table public.swipeecho_scores enable row level security;

-- anyone can read the leaderboard
create policy "swipeecho_scores_select"
  on public.swipeecho_scores for select
  to anon
  using (true);

-- anyone can add a score, but only within the nickname/score constraints above —
-- no update or delete policies exist, so entries can't be edited or removed via the API
create policy "swipeecho_scores_insert"
  on public.swipeecho_scores for insert
  to anon
  with check (
    char_length(nickname) between 1 and 8
    and score >= 0
  );
