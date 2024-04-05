import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'bundled_apk_info_dialog_model.dart';

class BundledApkInfoDialog extends StackedView<BundledApkInfoDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const BundledApkInfoDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    BundledApkInfoDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: const Text('Opening APK bundle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(viewModel.message),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            completer(
              DialogResponse<void>(confirmed: true),
            );
          },
          child: const Text('OK'),
        )
      ],
    );
  }

  @override
  BundledApkInfoDialogModel viewModelBuilder(BuildContext context) =>
      BundledApkInfoDialogModel();
}
