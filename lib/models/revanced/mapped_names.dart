final class RevancedMapper {
  RevancedMapper._();

  static final Map<String, String> _mapper = {
    'com.google.android.youtube': 'youtube'
  };

  static String? getMappedAppName(String packageName) {
    return _mapper[packageName];
  }
}
