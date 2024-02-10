import 'package:flutter_test/flutter_test.dart';
import 'package:glass_down_v2/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CheckUpdatesModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
