-- Run this once against the already-existing swipeecho_scores table to split the
-- leaderboard by device. Existing rows predate this column and can't be attributed
-- after the fact, so they're left NULL — they simply won't show up under either the
-- Telefon or PC view (the app always filters by platform), but stay in the table.

alter table public.swipeecho_scores
  add column platform text check (platform in ('MOBILE', 'PC'));

create index swipeecho_scores_branch_platform_score_idx
  on public.swipeecho_scores (branch, platform, score desc);
