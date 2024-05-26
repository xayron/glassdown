import 'package:glass_down_v2/models/revanced/mapped_names.dart';

class RevancedApp {
  RevancedApp(
    this._packageName,
    this._mapperData,
    Set<String>? versions,
  ) {
    if (versions != null) {
      _versions.addAll(versions);
    }
  }

  final String _packageName;
  String get packageName => _packageName;

  final MapperData? _mapperData;
  MapperData? get mapperData => _mapperData;

  final Set<String> _versions = {};
  Set<String> get versions => _versions;

  bool? checkSupportedVersion(String version) {
    return _versions.contains(version);
  }

  void addVersions(List<String>? versions) {
    if (versions != null) {
      _versions.addAll(versions);
    }
  }
}
