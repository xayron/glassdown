import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'delete_old_apks_dialog_model.dart';

class DeleteOldApksDialog extends StackedView<DeleteOldApksDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const DeleteOldApksDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    DeleteOldApksDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: const Text('Delete old APKs?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(viewModel.message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            completer(
              DialogResponse<void>(confirmed: false),
            );
          },
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () {
            completer(
              DialogResponse<void>(confirmed: true),
            );
          },
          child: const Text('Yes'),
        )
      ],
    );
  }

  @override
  DeleteOldApksDialogModel viewModelBuilder(BuildContext context) =>
      DeleteOldApksDialogModel();
}
