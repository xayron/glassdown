class RevancedApp {
  RevancedApp(
    this._name,
    this._mappedName,
    this._logoUrl,
    this._versions,
  );

  final String _name;
  String get name => _name;

  final String? _mappedName;
  String? get mappedName => _mappedName;

  final String? _logoUrl;
  String? get logoUrl => _logoUrl;

  final Set<String> _versions;
  Set<String> get versions => _versions;
  bool checkSupportedVersion(String version) {
    return _versions.contains(version);
  }

  void addVersions(List<String> versions) {
    _versions.addAll(versions);
  }
}
