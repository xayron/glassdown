import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/bottom_sheets/change_filters/change_filters_model.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:glass_down_v2/ui/views/settings/items/app_architecture/app_architecture.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_bundles/exclude_bundles.dart';
import 'package:glass_down_v2/ui/views/settings/items/exclude_unstable/exclude_unstable.dart';
import 'package:glass_down_v2/ui/views/settings/items/pages_count/pages_count.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Future<T?> showChangeFiltersSheet<T>({bool showPagesCount = false}) {
  return showModalBottomSheet(
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      return ViewModelBuilder.reactive(
        viewModelBuilder: () => ChangeFiltersModel(),
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
                  'Change filters',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpaceMedium,
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const ExcludeBundles(),
                      const ExcludeUnstable(),
                      const AppArchitecture(),
                      if (showPagesCount) const PagesCount(),
                    ],
                  ),
                ),
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
