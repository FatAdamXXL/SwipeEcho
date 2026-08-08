-- Run this once to raise the nickname length limit from 8 to 12 characters.
-- Both the table's CHECK constraint and the insert RLS policy enforce this
-- independently, so both need updating.

alter table public.swipeecho_scores
  drop constraint if exists swipeecho_scores_nickname_check;

alter table public.swipeecho_scores
  add constraint swipeecho_scores_nickname_check check (char_length(nickname) between 1 and 12);

drop policy if exists "swipeecho_scores_insert" on public.swipeecho_scores;

create policy "swipeecho_scores_insert"
  on public.swipeecho_scores for insert
  to anon
  with check (
    char_length(nickname) between 1 and 12
    and score >= 0
  );
