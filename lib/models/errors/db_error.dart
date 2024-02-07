import 'package:glass_down_v2/models/errors/app_error.dart';

final class DbError extends AppError {
  DbError(super.message, [super.reason]);
}
