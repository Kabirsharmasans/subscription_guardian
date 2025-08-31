'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "618780ade93c91364b844ae9b3c5ae6a",
"assets/AssetManifest.bin.json": "a22c9ca87bb06c7a0fa24a9fa4fe5c82",
"assets/AssetManifest.json": "299775e959368f639edf67e1fe6c4874",
"assets/assets/icon/icon.ico": "cd81b80443dfdd28aab2aec75752636f",
"assets/assets/icon/icon.jpeg": "8d87c94ece6872b5c9d6c2789be0b588",
"assets/assets/logos/10-play.png": "7a660591b58a169de72905245a8e9f62",
"assets/assets/logos/7plus.png": "01aa836151d22067f599c7194857fcb8",
"assets/assets/logos/9now.png": "c13e3eb32fa6857f667abf613727cade",
"assets/assets/logos/abc-iview.png": "ac7fbf4c1164960b42d9cc428e1c38d3",
"assets/assets/logos/acorn-tv.png": "deb9e8b4f7a685b845167b8a4e48896c",
"assets/assets/logos/aha.png": "43bc087d6d6cad6e32cf96d77d12d9de",
"assets/assets/logos/amazon-prime-video.png": "afab7779c96f6a0f2c9b8dcfb09b0ab1",
"assets/assets/logos/amc+.png": "ffb9bf3c77cee2226ad91f3254f4186a",
"assets/assets/logos/apple-tv+.png": "237e2b5c4239f555004ada9be39ffc2e",
"assets/assets/logos/ard-mediathek.png": "4d23a21bbe7c24aaa351858439a14bf1",
"assets/assets/logos/atresplayer.png": "614171d43b160b944fe8676f6840c42c",
"assets/assets/logos/bbc-iplayer.png": "a0d77d20ebd920e32ff5cb519df51d5a",
"assets/assets/logos/binge.png": "48a68b45072f912c764dce4b6ce10dce",
"assets/assets/logos/blutv.png": "6f43631cd845742eeb4905476ae243c0",
"assets/assets/logos/britbox-uk.png": "afc4e4318f6b175dc9a8ad2f034b3786",
"assets/assets/logos/britbox.png": "f6fd935a498b5c4d9493ad1f9aa34d8b",
"assets/assets/logos/canal+-online.png": "9503bc2e70012d48ebbe3e12e3303ea3",
"assets/assets/logos/cbc-gem.png": "f7013922d80cfe1c92c757b7b5429580",
"assets/assets/logos/channel-4.png": "0734817914187c609a37c514605f0ec4",
"assets/assets/logos/chaupal.png": "e1bf288c5412d90fda095a5be3e8dd2f",
"assets/assets/logos/claro-video.png": "43949efe276ba3ee8be07ed058e96d12",
"assets/assets/logos/club-illico.png": "5e61cfd17fd943ea7e53f208cf6c311e",
"assets/assets/logos/coupang-play.png": "e54eb01ffd54123a4796f1be49557a83",
"assets/assets/logos/crave.png": "c9c0dad8892cdc88fc48b6f9be325ca8",
"assets/assets/logos/crunchyroll.png": "21fb73be3d1c9e404e0f9cfd59e16d53",
"assets/assets/logos/curiosity-stream.png": "ebce7ff9882e034c34c6a0991a859efe",
"assets/assets/logos/discovery+-in.png": "ed748cde6157e0730a5998bcf8b603d5",
"assets/assets/logos/discovery+-italy.png": "bcb767d13595c8d51b875aadc9d3e751",
"assets/assets/logos/discovery+-uk.png": "b1fa9d6517782dd3670f7eb975783597",
"assets/assets/logos/discovery+.png": "cd4ac4c103d7de0fbdf718a9789afca6",
"assets/assets/logos/disney+-hotstar.png": "e2f7d8066d63e4b7e17965673016b78f",
"assets/assets/logos/docubay.png": "30a1a6f8b749bf3ec9a777b685104bca",
"assets/assets/logos/epic-on.png": "007960bd760333369013a4d6f71256ab",
"assets/assets/logos/eros-now.png": "18feddd764a848ed53a6a0a39832cf13",
"assets/assets/logos/fandango-at-home.png": "cb89cfc3ecda15f35129c3e79bbaa90c",
"assets/assets/logos/filmin.png": "05b8951f9fe826f06b1dbe74230983a8",
"assets/assets/logos/flixol.png": "0d80111186b5718057480eb0f4e63c19",
"assets/assets/logos/foxtel-now.png": "b4ff1b08dfdfb89bbdfc7dbc4af18e5f",
"assets/assets/logos/globoplay.png": "ccc81afbb7d3b0855c124652d10f5c1a",
"assets/assets/logos/hidive.png": "748b6be7e2ae038bd08396fde10b8b12",
"assets/assets/logos/hoichoi.png": "9484b8500f65075a8ff2c31365bc244c",
"assets/assets/logos/hoopla.png": "600cb8b448306eec5a46ba68f7942d67",
"assets/assets/logos/hulu-japan.png": "9e4f6acb73105beac3c374b6cb60fb53",
"assets/assets/logos/hulu.png": "b992cab01bec3569d061277557b3d681",
"assets/assets/logos/hungama-play.png": "4ee0fbdda8e6730b111285cb19aa09c8",
"assets/assets/logos/iqiyi.png": "64669af3201307f0da725415635b6b09",
"assets/assets/logos/irokotv.png": "163d4dfc6e249918803246e6d4d89bbd",
"assets/assets/logos/itvx.png": "4d49f65c88ec43f9403461c2e91e3aef",
"assets/assets/logos/ivi.png": "55dcc9a64ce6b6b5e613fd9d7aa4506a",
"assets/assets/logos/joyn.png": "88478903e75a83b56353f0d6d1e917bd",
"assets/assets/logos/kanopy.png": "2d8080937435de46d52f19fc380775da",
"assets/assets/logos/kktv.png": "0335cc99a64cbae0db770255d40e4236",
"assets/assets/logos/klikfilm.png": "c7308bee22be2faf3600805cdfb5e3bf",
"assets/assets/logos/lemino.png": "260fec10f3d72d5836b27be40ce7a0b8",
"assets/assets/logos/lionsgate+.png": "acb648e0926069754beef4683d37cb9c",
"assets/assets/logos/looke.png": "04eb7a17d7f2535a50e3103759d47b68",
"assets/assets/logos/magentatv.png": "d58c5455c12fbae5b79ac8b21789102d",
"assets/assets/logos/manoramamax.png": "7dda71ba6d6033fd3453347aa5d749f4",
"assets/assets/logos/max.png": "85dbf5e26c4c5247cee1f70b3367d913",
"assets/assets/logos/mediaset-infinity.png": "fa41a6b670468ab405699a466603d379",
"assets/assets/logos/mgm+.png": "2420fbe4916bd7a25e68bf08fc1a48ec",
"assets/assets/logos/molotov.png": "4e765b34e89fb6af20205e7c6d89cc37",
"assets/assets/logos/monomax.png": "dc4a8b3111f7f025e146b16c957d9925",
"assets/assets/logos/movistar-plus+.png": "f11e78c405d6deb46836c2e570283385",
"assets/assets/logos/mubi.png": "add02b336ec08d1613bfddd32c9e1a01",
"assets/assets/logos/mx-player.png": "35e81dbf64c379c8d0d9bdc03ffe6fe9",
"assets/assets/logos/nammaflix.png": "c748bfeb8d0654f1e06306469ea508f4",
"assets/assets/logos/neon.png": "0fd3626ace45a0aba0d24c7f7c14e7d3",
"assets/assets/logos/netflix.png": "3a9f73c2b9251b1c3f7fd07ab284a95f",
"assets/assets/logos/nlziet.png": "a7ab8c358690a15ae7f4515e84e068e9",
"assets/assets/logos/now-it.png": "f6675f51aaa297bd8d24154ff00feedc",
"assets/assets/logos/now.png": "8bd3c71fed1ace0715b05604bf3ca6ea",
"assets/assets/logos/npo-start.png": "4b46845a21b052487552b4eddc54223b",
"assets/assets/logos/nrk-tv.png": "7d36902081b01155596fd3eda2b5eaa5",
"assets/assets/logos/osn+.png": "ec3d66c4c8869b9b3b130c1eb05fcf01",
"assets/assets/logos/paramount+-with-showtime.png": "45ec520d1f8cbc50c1934a41798bb2c7",
"assets/assets/logos/paramount+.png": "c3c087eedd82e9cfdacb14b85805d665",
"assets/assets/logos/path-thuis.png": "4485ed374b585d9441ad58312a767c6a",
"assets/assets/logos/pbs-passport.png": "03eac7dc61ef6ca80c075a908b673a88",
"assets/assets/logos/peacock.png": "75a509242c87979c35c3c3b4de8a4e5f",
"assets/assets/logos/philo.png": "6bdb1900bd34c8218759beca65463afa",
"assets/assets/logos/plex.png": "c6851a3788354de9aabba30eab4da27a",
"assets/assets/logos/pluto-tv.png": "44d3563e0c2db35b1c7524f51ba4d28a",
"assets/assets/logos/polsat-box-go.png": "d29116493a0e605b8c95178da8374203",
"assets/assets/logos/puhutv.png": "d1902a830d4d744f16c47874963de132",
"assets/assets/logos/rt-player.png": "17a90356ffbbeb4096f81f3eed33d806",
"assets/assets/logos/rtbf-auvio.png": "149dfc0bfcfb0a464cb5b4ba13ce8fd3",
"assets/assets/logos/rtl+.png": "b895f6e9b8291a2e9e029cf6adee27e9",
"assets/assets/logos/rtve-play.png": "7637747b5d3dc3e3aad47d5d6ecfaac4",
"assets/assets/logos/ruutu.png": "7e39be9cd005da2b8c809d69991f2595",
"assets/assets/logos/sbs-on-demand.png": "14980824373a44f41615af8f516953b4",
"assets/assets/logos/shahid.png": "8fe4291055fe4594e4add0c41bfe63ea",
"assets/assets/logos/shemaroome.png": "8fafdc7b8aa866d0fd903b61efc60405",
"assets/assets/logos/showmax.png": "e3161eeee953ca59bffe3b7d73909959",
"assets/assets/logos/shudder.png": "9b439fb2f21c8734cd4fe08397be4508",
"assets/assets/logos/sky-show.png": "5a3e1775e0a16cc0993583925e1d4fcf",
"assets/assets/logos/sky-sport-now.png": "6e59be6503eb8d945608a583e22c8ec6",
"assets/assets/logos/stacktv.png": "afffc444f874e0d62177b7a9595c7999",
"assets/assets/logos/stan.png": "e39c7fd2c33ababe53d005fdde1c5e5c",
"assets/assets/logos/starhub-tv+.png": "c2cccada68e16d3b9511f7c51e762814",
"assets/assets/logos/start.png": "4343d680b2056a3b04415d8ac44a3c7e",
"assets/assets/logos/starz.png": "6cacdab8fe9f1c1f745f0e19de838758",
"assets/assets/logos/starzplay-arabia.png": "44a722487a8efafd8a223990768a5186",
"assets/assets/logos/stv-player.png": "de8d536963bbb4f7237b23ff4183f527",
"assets/assets/logos/sun-nxt.png": "b5d32ff8bdcd6b51cff64482ea594599",
"assets/assets/logos/svt-play.png": "fec580c0c5102e915f2bce66aa67185e",
"assets/assets/logos/telecine.png": "412ba828a11db7728c82f19e919c957f",
"assets/assets/logos/telia-play.png": "5f33b65b31988be215c989439e9ba08b",
"assets/assets/logos/the-criterion-channel.png": "da00e2bc59b58121bddc8b34a39837ae",
"assets/assets/logos/threenow.png": "9d9d864085cdac426ea58f1e05f82239",
"assets/assets/logos/timvision.png": "c6da626d6066e4f18cf7a2cfab3069ed",
"assets/assets/logos/tod.png": "fe313f21aff41efd33e4584c8ba9356f",
"assets/assets/logos/tubi.png": "01bffbcc33145803e8ecad7bb716581d",
"assets/assets/logos/tv-2-play.png": "02839fbe9fea27c075709a784bf64070",
"assets/assets/logos/tv4-play.png": "2658b5c25ba901df967eb89d3543929a",
"assets/assets/logos/tving.png": "4b07659014bf4766aed19478b0aa11f4",
"assets/assets/logos/tvnz+.png": "c150dde3d039504ff87e99fc1279855f",
"assets/assets/logos/u-next.png": "cc65b179ae04ec87de8c91050a83ea53",
"assets/assets/logos/viaplay.png": "a3faca2921e7a07c2b545b51021f3161",
"assets/assets/logos/videoland.png": "570903fbffb963e0d9ef1f39d59fb87b",
"assets/assets/logos/vidio.png": "be849d302401436570ad463ed1cc79cb",
"assets/assets/logos/viu.png": "bacb99c970938eeb2ed54d2329fe04c5",
"assets/assets/logos/vix.png": "6a120372f4cfbb0c4cc1eef9c1fabb1e",
"assets/assets/logos/vrt-max.png": "9eb2c597b37fce70555fa4e63a45735e",
"assets/assets/logos/vudu.png": "0e1e2372a1d49c04fd0f90f56c955dc8",
"assets/assets/logos/watcha.png": "d70c1143e4bb135bc95da7998de58dff",
"assets/assets/logos/wavve.png": "418d2df3956c11677716147da5b47c82",
"assets/assets/logos/wetv.png": "fb1a890fb19c518156a9d45cadc790cf",
"assets/assets/logos/wowow-on-demand.png": "e02a888abad658615f5bd221c5046efd",
"assets/assets/logos/wwe-network.png": "c06ef2c76964361d46a92093092ddf79",
"assets/assets/logos/yle-areena.png": "1db092e9380cdbf49b6734d1dda3687b",
"assets/assets/logos/youtube-premium.png": "1b51084f032c6ff2852d953a3fd07635",
"assets/assets/logos/youtube-tv.png": "2432b9bb2d7afc24ab33cd04f87153d6",
"assets/assets/logos/zee5.png": "d4c4effb18427cbb3e145dd4d3e7fb73",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "c64ca45e37cdbc7d0447cf748e659c0f",
"assets/NOTICES": "8e14bfde68d94251c05b85550f6dbb43",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/window_manager/images/ic_chrome_close.png": "75f4b8ab3608a05461a31fc18d6b47c2",
"assets/packages/window_manager/images/ic_chrome_maximize.png": "af7499d7657c8b69d23b85156b60298c",
"assets/packages/window_manager/images/ic_chrome_minimize.png": "4282cd84cb36edf2efb950ad9269ca62",
"assets/packages/window_manager/images/ic_chrome_unmaximize.png": "4a90c1909cb74e8f0d35794e2f61d8bf",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "9da3197ac560dbb0442a73c525c22da7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "83b39205e5b36994e5fa5bc427d3a9f7",
"/": "83b39205e5b36994e5fa5bc427d3a9f7",
"main.dart.js": "bc666495c1d3b267e411df030a90020d",
"manifest.json": "0f69ff5f79fe4eab33215b25df0ee790",
"version.json": "faa1b5611ca7b552a9cace799ec1807f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
