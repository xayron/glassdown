import 'package:dart_mappable/dart_mappable.dart';

part 'app_info.mapper.dart';

typedef VersionLink = ({String name, String url});
typedef TypeInfo = ({
  String title,
  String archDpi,
  bool isBundle,
  String versionUrl,
});

@MappableClass()
class AppInfo with AppInfoMappable {
  AppInfo(
    this.name,
    this.appUrl,
    this.links,
    this.dbId, {
    this.pickedVersion,
    this.imageUrl,
    this.types,
    this.pickedType,
  });

  final String name;
  final String appUrl;
  final List<VersionLink> links;
  final int dbId;
  final VersionLink? pickedVersion;
  final String? imageUrl;
  final List<TypeInfo>? types;
  final TypeInfo? pickedType;

  static const fromMap = AppInfoMapper.fromMap;
  static const fromJson = AppInfoMapper.fromJson;
}
