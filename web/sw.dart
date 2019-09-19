import 'package:service_worker/worker.dart' as w;

const cacheName = "appCahce";

const cacheResources = [
  ".",
  "index.html",
  "styles.css",
  "main.dart.js",
  "favicon.png",
];

void main() {
  w.onInstall.listen((evt) async {
    print("ServiceWorker installed");

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
    print("ServiceWorker activated");
  });

  w.onFetch.listen((evt) {
    evt.respondWith(
        w.caches.match(evt.request).then((res) {
          print(evt.request.url);
          print("res is $res");
          return res ?? w.fetch(evt.request);
        }));
  });
}
