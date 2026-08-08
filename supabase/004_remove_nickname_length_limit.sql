-- Removes the nickname length limit at the database level entirely — the 12-char
-- cap is enforced app-side only (input maxlength + client-side truncation before
-- insert). Both the table's CHECK constraint and the insert RLS policy previously
-- enforced a length limit independently, so both need updating here.

alter table public.swipeecho_scores
  drop constraint if exists swipeecho_scores_nickname_check;

drop policy if exists "swipeecho_scores_insert" on public.swipeecho_scores;

create policy "swipeecho_scores_insert"
  on public.swipeecho_scores for insert
  to anon
  with check (score >= 0);
