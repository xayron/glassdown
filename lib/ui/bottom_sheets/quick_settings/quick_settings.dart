import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/bottom_sheets/quick_settings/quick_settings_model.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_architecture/app_architecture.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_bundles/exclude_bundles.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_unstable/exclude_unstable.dart';
import 'package:glass_down_v2/ui/views/settings/items/offer_deleting_old_apks/offer_deleting_old_apks.dart';
import 'package:glass_down_v2/ui/views/settings/items/pages_count/pages_count.dart';
import 'package:glass_down_v2/ui/views/settings/items/shizuku_installer/shizuku_installer.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/group_header.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../views/settings/items/delete_old_versions/delete_old_versions.dart';

Future<T?> showQuickSettingsSheet<T>() {
  return showModalBottomSheet(
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      return ViewModelBuilder.reactive(
        viewModelBuilder: () => QuickSettingsModel(),
        builder: (context, viewModel, child) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Quick settings',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpaceMedium,
                Expanded(
                  child: Material(
                    type: MaterialType.card,
                    surfaceTintColor: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 1,
                    child: Scrollbar(
                      interactive: true,
                      child: SingleChildScrollView(
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          clipBehavior: Clip.antiAlias,
                          shrinkWrap: true,
                          children: const [
                            GroupHeader(name: 'Filters'),
                            ExcludeBundles(rounded: true),
                            ExcludeUnstable(rounded: true),
                            AppArchitecture(rounded: true),
                            PagesCount(rounded: true),
                            GroupHeader(name: 'Apps'),
                            DeleteOldVersions(rounded: true),
                            OfferDeletingOldApks(rounded: true),
                            GroupHeader(name: 'Others'),
                            ShizukuInstaller(rounded: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
