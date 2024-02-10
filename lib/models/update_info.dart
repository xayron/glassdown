typedef AppReleaseInfo = ({String? name, String? url});

class UpdateInfo {
  UpdateInfo({
    required this.version,
    required this.arm64,
    required this.arm32,
    required this.changelog,
  });

  final String version;
  final AppReleaseInfo arm64;
  final AppReleaseInfo arm32;
  final String changelog;
}
