import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glass_down_v2/ui/bottom_sheets/updater/update_sheet_model.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Future<T?> showUpdaterSheet<T>() {
  return showModalBottomSheet<T>(
    useSafeArea: true,
    useRootNavigator: true,
    isScrollControlled: true,
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      return ViewModelBuilder.reactive(
        viewModelBuilder: () => UpdateSheetModel(),
        onViewModelReady: (viewModel) => viewModel.checkUpdates(),
        builder: (context, viewModel, child) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (viewModel.updateInfo != null) ...[
                  Text(
                    viewModel.updateInfo?.version ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: Material(
                      type: MaterialType.card,
                      surfaceTintColor: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Markdown(data: viewModel.updateInfo!.changelog),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<PickedVersion>(
                          value: PickedVersion.arm64,
                          groupValue: viewModel.pickedVersion,
                          onChanged: (value) => viewModel.updateVersion(value),
                          title: Text(
                              viewModel.updateInfo?.arm64.name ?? 'Loading...'),
                        ),
                        RadioListTile<PickedVersion>(
                          value: PickedVersion.arm32,
                          groupValue: viewModel.pickedVersion,
                          onChanged: (value) => viewModel.updateVersion(value),
                          title: Text(
                              viewModel.updateInfo?.arm32.name ?? 'Loading...'),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.started) ...[
                    verticalSpaceSmall,
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: LinearProgressIndicator(
                              value: viewModel.progress.toInt() / 100,
                            ),
                            trailing: Text(
                              '${viewModel.progress.toStringAsFixed((0))}%',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      horizontalSpaceMedium,
                      FilledButton(
                        onPressed: () => viewModel.downloadUpdate(),
                        child: const Text('Update'),
                      )
                    ],
                  )
                ] else ...[
                  const Text(
                    'App update',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  verticalSpaceMedium,
                  const Card(
                    child: ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Loading new version details...'),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      );
    },
  );
}
