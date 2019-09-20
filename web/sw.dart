import 'package:service_worker/worker.dart' as w;

const cacheName = "kn-cache-v2";

const cacheResources = [
  // page data
  ".",
  "index.html",
  "styles.css",
  "main.dart.js",
  "manifest.json",

  // icons
  "icons/favicon.png",
  "icons/pwa-icon-192.png",
  "icons/pwa-icon-512.png",
  "icons/pwa-icon-ios.png",

  // fonts
  "https://fonts.googleapis.com/css?family=Arimo&display=fallback",
  "https://fonts.gstatic.com/s/arimo/v13/P5sMzZCDf9_T_10ZxCE.woff2",
  "https://fonts.gstatic.com/s/arimo/v13/P5sMzZCDf9_T_10axCF8jA.woff2",
];

void main() {
  w.onInstall.listen((evt) async {
    //print("ServiceWorker installed");

    evt.waitUntil(() async {
      try {
        var cache = await w.caches.open(cacheName);
        await cache.addAll(cacheResources);

        print("Finished caching resources");
      } on Error catch (e) {
        print("big oof on the servizzle workizzle: $e");
        rethrow;
      }
    }());
  });

  w.onActivate.listen((evt) {
    //print("ServiceWorker activated");

    evt.waitUntil(() async {
      var futures = <Future>[];
      for (var cache in await w.caches.keys()) {
        if (cache != cacheName) {
          futures.add(w.caches.delete(cache));
        }
      }
      await Future.wait(futures);
    }());
  });

  w.onFetch.listen((evt) {
    evt.respondWith(w.caches.match(evt.request).then((res) {
      //print(evt.request.url);
      //print("res is $res");
      return res ?? w.fetch(evt.request);
    }));
  });
}
