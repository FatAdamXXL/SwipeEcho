# SwipeEcho

Minimalistyczna gra przeglądarkowa: unikaj echa swojej własnej trasy sprzed kilku sekund, zanim Cię dogoni. Im dłużej przeżyjesz, tym szybciej echo się porusza.

Steruj palcem (dotyk) lub kursorem myszy.

Gra działa jako PWA — można ją zainstalować na telefonie lub pulpicie i grać offline.

## Rozgrywka

- Duży punkt (turkusowy) — to Ty.
- Fioletowe echo — kopia Twojej trasy sprzed chwili. Dotknięcie kończy grę. Z czasem porusza się coraz szybciej, aż w końcu zniknie.
- Żółta iskra — zbieraj po drodze dla dodatkowych punktów.

## Rozwój lokalny

Statyczna aplikacja — wystarczy otworzyć `index.html` w przeglądarce lub serwować katalog dowolnym serwerem HTTP.

```bash
python3 -m http.server 8000
```

## Deploy

Hostowane na GitHub Pages z gałęzi `main`.
