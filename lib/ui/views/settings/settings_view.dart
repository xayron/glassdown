import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/views/settings/items/about_app/about_app.dart';
import 'package:glass_down_v2/ui/views/settings/items/apk_save_path/apk_save_path.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_architecture/app_architecture.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_theme/app_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/check_updates/check_updates.dart';
import 'package:glass_down_v2/ui/views/settings/items/custom_theme/custom_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_apps/delete_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_logs/delete_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_old_versions/delete_old_versions.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_bundles/exclude_bundles.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_unstable/exclude_unstable.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_apps/export_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_logs/export_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/import_apps/import_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/import_font/import_font.dart';
import 'package:glass_down_v2/ui/views/settings/items/monet_theme/monet_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/offer_deleting_old_apks/offer_deleting_old_apks.dart';
import 'package:glass_down_v2/ui/views/settings/items/pages_count/pages_count.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/group_header.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 90,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const GroupHeader(name: 'Theme'),
                  const AppTheme(),
                  const MonetTheme(),
                  const CustomTheme(),
                  const GroupHeader(name: 'Filters'),
                  const ExcludeBundles(),
                  const ExcludeUnstable(),
                  const AppArchitecture(),
                  const PagesCount(),
                  const GroupHeader(name: 'Apps'),
                  const DeleteOldVersions(),
                  const OfferDeletingOldApks(),
                  const ApkSavePath(),
                  const ImportApps(),
                  const ExportApps(),
                  const DeleteApps(),
                  const GroupHeader(name: 'Logs'),
                  const ExportLogs(),
                  const DeleteLogs(),
                  const GroupHeader(name: 'About'),
                  if (viewModel.devOptions) const ImportFont(),
                  const CheckUpdates(),
                  const AboutApp(),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();
}
