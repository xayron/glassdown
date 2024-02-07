import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/views/settings/items/about_app/about_app.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_architecture/app_architecture.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_theme/app_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/custom_theme/custom_theme.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_apps/delete_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/delete_logs/delete_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_bundles/exclude_bundles.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_unstable/exclude_unstable.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_apps/export_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/export_logs/export_logs.dart';
import 'package:glass_down_v2/ui/views/settings/items/import_apps/import_apps.dart';
import 'package:glass_down_v2/ui/views/settings/items/monet_theme/monet_theme.dart';
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
                children: const [
                  GroupHeader(name: 'Theme'),
                  AppTheme(),
                  MonetTheme(),
                  CustomTheme(),
                  GroupHeader(name: 'Filters'),
                  ExcludeBundles(),
                  ExcludeUnstable(),
                  AppArchitecture(),
                  PagesCount(),
                  GroupHeader(name: 'Apps'),
                  ImportApps(),
                  ExportApps(),
                  DeleteApps(),
                  GroupHeader(name: 'Logs'),
                  ExportLogs(),
                  DeleteLogs(),
                  GroupHeader(name: 'About'),
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
