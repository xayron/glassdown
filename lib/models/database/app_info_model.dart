import 'package:isar/isar.dart';

part 'app_info_model.g.dart';

@collection
class AppInfoModel {
  Id id = Isar.autoIncrement;

  late String name;

  late String appUrl;

  late String? logoUrl;
}
