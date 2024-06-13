# GlassDown

Flutter app which simplifies process of downloading APK files from APKMirror.

You add app you're interested in by tapping "Add app" button. Then you search for i.e. Reddit and tap search icon. After results are visible, you tap on the app name, which then is added to the main screen. From this point, you tap on app name on main screen, which opens a view with list of available version. Tapping on particular version moves you to screen where you pick APK type (since APKMirror offers different DPIs, plain APKs vs bundles and so on). Tapping on type moves you to screen where link for downloading are scraped and app is downloaded. Done!

Besides that, on main screen you can go to Revanced section. There you can see all apps which has patches available in Revanced/revanced Extended. Tapping on one of them also adds it to the main screen, from which you can download the app, but this time on Versions screen you'll see small information, that particular version is supported by latest version of Revanced patches.

In settings page you can browse logs, set theming (app supports Material You, light and dark theme as well as custom colors for people with Android below 12), pick a path where APK should be downloaded, change font used by the app (because sadly Flutter doesn't support system font) as well as option to delete previously downloaded versions of APKs and a few more.

App also includes updater which will notify you when there's new version available.

App asks for following permissions, they're fully optional:
- Managing all files:
  - it's used to pick any folder of your choice to save GlassDown files - downloaded APKs, updates, logs and app list if you've exported it
- Install all packages:
  - this one is used if you want to be prompted to install GlassDown updates from within the app as well as install downloaded APKs
- Shizuku:
  - if you wish to use Shizuku to install downloaded APKs, this permission will allow it
- Updates prompting:
  - it's not a permission per se, but you can disable showing prompt with GlassDown updates to download from this GitHub page

Please feel free to post issues if you have any suggestions or bugs to report. PRs are also welcomed.

## Features
- Adding app from APKMirror within the app
- Pick specifics of APK file you want to download (architecture, DPI etc.)
- Manage filters within settings/quick settings
- Material You theme
- Supports light/dark theme, as well as automatic switching between them synchronized with system theme
- Override app font with the one of your choice
- Revanced/Extended patches integration
  - Import apps supported by Revanced and get info which version from APKMirror is supported by Revanced
- Control removal of previously downloaded APKs
- Import/Export settings
- See logs directly in the app
- Get notified about GlassDown updates & download it directly in the app
- No tracking
- Open source (GPLv3)
- Minimal permissions

### App Showcase (outdated)
https://drive.google.com/file/d/15OP87NYJt68f5eZLtENHIJ0ISsHlQsp3/view?usp=sharing

### Screenshots
https://imgur.com/a/te0hzeE