typedef MapperData = ({String url, String fullName});

final class RevancedMapper {
  RevancedMapper._();

  static final Map<String, MapperData> _mapper = {
    'com.google.android.youtube': (url: 'youtube', fullName: 'YouTube'),
    'com.strava': (url: 'strava-running-and-cycling-gps', fullName: 'Strava'),
    'com.awedea.nyx': (url: 'nyx-music-player', fullName: 'Nyx Music Player'),
    'com.ss.android.ugc.trill': (url: 'tik-tok', fullName: 'TikTok'),
    'tv.twitch.android.app': (url: 'twitch', fullName: 'Twitch'),
    'com.zombodroid.memegenerator': (
      url: 'meme-generator-free',
      fullName: 'Meme Generator'
    ),
    'com.laurencedawson.reddit_sync': (
      url: 'sync-for-reddit',
      fullName: 'Sync For Reddit'
    ),
    'com.backdrops.wallpapers': (
      url: 'backdrops-wallpapers',
      fullName: 'Backdrops'
    ),
    'tv.trakt.trakt': (url: 'trakt', fullName: 'Trakt'),
    'com.sony.songpal.mdr': (
      url: 'sony-headphones-connect',
      fullName: 'Sony Headphones Connect'
    ),
    'ginlemon.iconpackstudio': (
      url: 'icon-pack-studio',
      fullName: 'Icon Pack Studio'
    ),
    'io.yuka.android': (url: 'yuka-food-cosmetic-scan', fullName: 'Yuka'),
    'com.microblink.photomath': (url: 'photomath', fullName: 'PhotoMath'),
    'eu.faircode.netguard': (
      url: 'netguard-no-root-firewall',
      fullName: 'NetGuard'
    ),
    'com.google.android.apps.recorder': (
      url: 'google-recorder',
      fullName: 'Google Record'
    ),
    'com.facebook.katana': (url: 'facebook', fullName: 'Facebook'),
    'com.instagram.android': (
      url: 'instagram-instagram',
      fullName: 'Instagram'
    ),
    'com.candylink.openvpn': (url: 'candylink-vpn', fullName: 'Candylink VPN'),
    'com.nis.app': (url: 'inshorts-news-in-60-words-2', fullName: 'InShorts'),
    'pl.solidexplorer2': (
      url: 'solid-explorer-beta',
      fullName: 'Solid Explorer'
    ),
    'co.windyapp.android': (
      url: 'windy-wind-weather-forecast',
      fullName: 'Windy'
    ),
    'com.xiaomi.wearable': (
      url: 'mi-wear-小米穿戴',
      fullName: 'Mi Fitness (Xiaomi Wear)'
    ),
    'com.reddit.frontpage': (url: 'reddit', fullName: 'Reddit'),
    'com.onelouder.baconreader': (
      url: 'baconreader-for-reddit',
      fullName: 'BaconReader For Reddit'
    ),
    'com.rubenmayayo.reddit': (
      url: 'boost-for-reddit',
      fullName: 'Boost For Reddit'
    ),
    'ml.docilealligator.infinityforreddit': (
      url: 'infinity-for-reddit',
      fullName: 'Infinity For Reddit'
    ),
    'io.syncapps.lemmy_sync': (
      url: 'sync-for-lemmy',
      fullName: 'Sync For Lemmy'
    ),
    'me.ccrama.redditslide': (
      url: 'slide-for-reddit',
      fullName: 'Slide For Reddit'
    ),
    'com.andrewshu.android.reddit': (
      url: 'reddit-is-fun',
      fullName: 'rif is fun for Reddit'
    ),
    'free.reddit.news': (
      url: 'relay-for-reddit-2',
      fullName: 'Relay For Reddit'
    ),
    'com.ticktick.task': (
      url: 'ticktick-to-do-list-with-reminder-day-planner',
      fullName: 'TickTick'
    ),
    'com.facebook.orca': (url: 'messenger', fullName: 'Messenger'),
    'com.myfitnesspal.android': (
      url: 'calorie-counter-myfitnesspal',
      fullName: 'MyFitnessPal'
    ),
    'jp.pxv.android': (url: 'pixiv', fullName: 'Pixiv'),
    'com.google.android.apps.youtube.music': (
      url: 'youtube-music',
      fullName: 'YouTube Music'
    ),
    'de.dwd.warnapp': (url: 'warnwetter', fullName: 'WarnWetter'),
    'com.adobe.lrmobile': (url: 'lightroom', fullName: 'Adobe Lightroom'),
    'com.tumblr': (url: 'tumblr', fullName: 'Tumblr'),
    'com.twitter.android': (url: 'twitter', fullName: 'Twitter'),
    'net.binarymode.android.irplus': (
      url: 'irplus-infrared-remote',
      fullName: 'irplus - Infrared Remote'
    ),
    'com.amazon.mshop.android.shopping': (
      url: 'amazon-shopping',
      fullName: 'Amazon Shopping'
    )
  };

  static MapperData? getMappedAppName(String packageName) {
    return _mapper[packageName.toLowerCase()];
  }
}
