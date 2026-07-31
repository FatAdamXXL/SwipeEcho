-- Run this once against the already-existing swipeecho_scores table to add branch
-- separation. All current rows predate this column and came from dev testing, so
-- they're backfilled as 'DEV'.

alter table public.swipeecho_scores
  add column branch text;

update public.swipeecho_scores set branch = 'DEV' where branch is null;

alter table public.swipeecho_scores
  alter column branch set not null,
  add constraint swipeecho_scores_branch_check check (branch in ('DEV', 'MAIN'));

create index swipeecho_scores_branch_score_idx on public.swipeecho_scores (branch, score desc);
