# SwipeEcho — ECHO

Minimalistyczna gra przeglądarkowa: unikaj świeżych ech swojej własnej trasy sprzed kilku sekund, a gdy dojrzeją i zamienią się w skarb — zbierz je, zanim znikną na zawsze.

Steruj palcem (dotyk) lub kursorem myszy.

Gra działa jako PWA — można ją zainstalować na telefonie lub pulpicie i grać offline.

## Rozgrywka

- Duży punkt (turkusowy) — to Ty.
- Fioletowe echo — świeża kopia Twojej trasy sprzed chwili. Dotknięcie kończy grę.
- Złote echo — dojrzałe echo, bezpieczne do zebrania, zanim zniknie.
- Żółta iskra — zbieraj po drodze dla dodatkowych punktów.

## Rozwój lokalny

Statyczna aplikacja — wystarczy otworzyć `index.html` w przeglądarce lub serwować katalog dowolnym serwerem HTTP.

```bash
python3 -m http.server 8000
```

## Deploy

Hostowane na GitHub Pages z gałęzi `main`.
