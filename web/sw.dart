import 'package:service_worker/worker.dart' as w;

const cacheName = 'kn-cache-v9';

const cacheGeneralResources = [
  // page data
  '.',
  'index.html',
  'styles.css',
  'main.dart.js',
  'manifest.json',

  // icons
  'icons/favicon.png',
  'icons/pwa-icon-192.png',
  'icons/pwa-icon-512.png',
  'icons/pwa-icon-ios.png',
];

const cacheFontSheets = [
  'https://fonts.googleapis.com/css?family=Arimo&display=fallback',
];

final woffUrl = RegExp('https://.*\\.woff2?');

void main() {
  w.onInstall.listen((evt) async {
    //print('ServiceWorker installed');

    evt.waitUntil(() async {
      try {
        var cache = await w.caches.open(cacheName);

        await Future.wait([
          cache.addAll(cacheGeneralResources),
          for (var fontSheet in cacheFontSheets)
            cache.add(fontSheet).then((_) async {
              var sheetBody = await (await cache.match(fontSheet)).text();
              var fontWoffs =
                  woffUrl.allMatches(sheetBody).map((m) => m.group(0)).toList();
              await cache.addAll(fontWoffs);
            })
        ]);

        print('Finished caching resources');
      } on Error catch (e) {
        print('big oof on the servizzle workizzle: $e');
        rethrow;
      }
    }());
  });

  w.onActivate.listen((evt) {
    //print('ServiceWorker activated');

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
      //print('res is $res');
      return res ?? w.fetch(evt.request);
    }));
  });
}
