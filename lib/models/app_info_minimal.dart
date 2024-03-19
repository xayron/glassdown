import 'package:dart_mappable/dart_mappable.dart';

part 'app_info_minimal.mapper.dart';

@MappableClass()
class AppInfoMinimal with AppInfoMinimalMappable {
  AppInfoMinimal(
    this.name,
    this.appUrl, {
    this.imageUrl,
  });

  final String name;
  final String appUrl;
  final String? imageUrl;

  static const fromMap = AppInfoMinimalMapper.fromMap;
  static const fromJson = AppInfoMinimalMapper.fromJson;
}
