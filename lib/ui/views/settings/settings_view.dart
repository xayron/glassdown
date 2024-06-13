import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/views/settings/items/about_app/about_app.dart';
import 'package:glass_down_v2/ui/views/settings/items/apk_save_path/apk_save_path.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_architecture/app_architecture.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_theme/app_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/check_updates/check_updates.dart';
import 'package:glass_down_v2/ui/views/settings/items/custom_font_list/custom_font_list.dart';
import 'package:glass_down_v2/ui/views/settings/items/custom_theme/custom_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_apps/delete_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_logs/delete_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_old_versions/delete_old_versions.dart';
import 'package:glass_down_v2/ui/views/settings/items/disable_updates/disable_updates.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_bundles/exclude_bundles.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_unstable/exclude_unstable.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_apps/export_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_logs/export_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/import_apps/import_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/import_font/import_font.dart';
import 'package:glass_down_v2/ui/views/settings/items/monet_theme/monet_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/offer_deleting_old_apks/offer_deleting_old_apks.dart';
import 'package:glass_down_v2/ui/views/settings/items/pages_count/pages_count.dart';
import 'package:glass_down_v2/ui/views/settings/items/shizuku_installer/shizuku_installer.dart';
import 'package:glass_down_v2/ui/views/settings/items/show_logs/show_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/show_permissions/show_permissions.dart';
import 'package:glass_down_v2/ui/widgets/common/divider.dart';
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
            centerTitle: true,
            title: Text(
              'Settings',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            automaticallyImplyLeading: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              ListView(
                padding: const EdgeInsets.only(bottom: 30),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  GroupHeader(name: 'Theme'),
                  AppTheme(),
                  MonetTheme(),
                  CustomTheme(),
                  ImportFont(),
                  CustomFontList(),
                  ItemDivider(),
                  GroupHeader(name: 'Filters'),
                  ExcludeBundles(),
                  ExcludeUnstable(),
                  AppArchitecture(),
                  PagesCount(),
                  ItemDivider(),
                  GroupHeader(name: 'Apps'),
                  ShizukuInstaller(),
                  DeleteOldVersions(),
                  OfferDeletingOldApks(),
                  ApkSavePath(),
                  ImportApps(),
                  ExportApps(),
                  DeleteApps(),
                  ItemDivider(),
                  GroupHeader(name: 'Logs'),
                  ShowLogs(),
                  ExportLogs(),
                  DeleteLogs(),
                  ItemDivider(),
                  GroupHeader(name: 'About'),
                  ShowPermissions(),
                  DisableUpdates(),
                  CheckUpdates(),
                  AboutApp(),
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
