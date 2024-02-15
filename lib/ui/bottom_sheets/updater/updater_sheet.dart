import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'updater_sheet_model.dart';

class UpdaterSheet extends StackedView<UpdaterSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;
  const UpdaterSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    UpdaterSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
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
                    title:
                        Text(viewModel.updateInfo?.arm64.name ?? 'Loading...'),
                  ),
                  RadioListTile<PickedVersion>(
                    value: PickedVersion.arm32,
                    groupValue: viewModel.pickedVersion,
                    onChanged: (value) => viewModel.updateVersion(value),
                    title:
                        Text(viewModel.updateInfo?.arm32.name ?? 'Loading...'),
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
                        '${viewModel.progress.toStringAsFixed((1))}%',
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
                    if (completer != null) {
                      completer!(SheetResponse<void>());
                    }
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
  }

  @override
  UpdaterSheetModel viewModelBuilder(BuildContext context) =>
      UpdaterSheetModel();

  @override
  void onViewModelReady(UpdaterSheetModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.checkUpdates();
  }
}
