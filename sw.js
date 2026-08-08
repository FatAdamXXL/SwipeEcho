const CACHE_NAME = "swipeecho-dev-v30";

const SHELL_URLS = [
  "./",
  "index.html",
  "manifest.webmanifest",
  "icons/icon-192.png",
  "icons/icon-512.png",
  "icons/icon-maskable-512.png",
];

// ~5.5MB across 2 files — cached in the background after activation, not blocking
// install, so one slow/flaky download can't hold up the rest of the shell.
const AUDIO_URLS = [
  "assets/audio/menu-theme.mp3",
  "assets/audio/main-theme.mp3",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) =>
        Promise.all(SHELL_URLS.map((url) => fetch(url, { cache: "reload" }).then((response) => cache.put(url, response))))
      )
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
      .then(() => cacheAudioInBackground())
  );
});

function cacheAudioInBackground() {
  return caches.open(CACHE_NAME).then((cache) =>
    Promise.allSettled(
      AUDIO_URLS.map((url) =>
        cache.match(url).then((existing) => {
          if (existing) return;
          return fetch(url).then((response) => {
            if (response.ok) return cache.put(url, response);
          });
        })
      )
    )
  );
}

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return;
  if (new URL(event.request.url).origin !== self.location.origin) return;

  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        if (response.ok) {
          const copy = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        }
        return response;
      }).catch(() => cached);
    })
  );
});
