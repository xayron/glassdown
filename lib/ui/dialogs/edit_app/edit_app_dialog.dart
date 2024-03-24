import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:glass_down_v2/ui/dialogs/edit_app/edit_app_dialog.form.dart';
import 'package:glass_down_v2/ui/widgets/form/validation_error_message.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'edit_app_dialog_model.dart';

typedef IsEdit = bool;

@FormView(
  fields: [
    FormTextField(
      name: 'appName',
      validator: EditAppDialogValidators.validateAppName,
    ),
    FormTextField(
      name: 'appUrl',
      validator: EditAppDialogValidators.validateAppUrl,
    ),
  ],
)
class EditAppDialog extends StackedView<EditAppDialogModel>
    with $EditAppDialog {
  final DialogRequest<dynamic> request;
  final Function(DialogResponse) completer;

  const EditAppDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    EditAppDialogModel viewModel,
    Widget? child,
  ) {
    final app = (request.data != null && request.data is AppInfo)
        ? request.data as AppInfo
        : null;

    return AlertDialog(
      title: Text(app != null ? 'Edit app' : 'Add new app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (app == null) ...[
            RichText(
              text: TextSpan(
                text: viewModel.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                children: [
                  TextSpan(
                    text: viewModel.urlMessage,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  TextSpan(
                    text: viewModel.appMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
          ],
          TextFormField(
            controller: appNameController,
            decoration: const InputDecoration(
              label: Text('App name'),
              filled: true,
              isDense: true,
            ),
          ),
          if (viewModel.hasAppNameValidationMessage) ...[
            verticalSpaceTiny,
            ValidationErrorMessage(viewModel.appNameValidationMessage!),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: appUrlController,
            decoration: const InputDecoration(
              label: Text('App url'),
              filled: true,
              isDense: true,
            ),
          ),
          if (viewModel.hasAppUrlValidationMessage) ...[
            verticalSpaceTiny,
            ValidationErrorMessage(viewModel.appUrlValidationMessage!),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            viewModel.clearForm();
            completer(
              DialogResponse<VersionLink?>(confirmed: true, data: null),
            );
          },
          child: const Text('Cancel'),
        ),
        if (!viewModel.hasAnyValidationMessage)
          FilledButton(
            onPressed: () {
              final VersionLink data = (
                name: viewModel.appNameValue!.trim(),
                url: viewModel.appUrlValue!.trim().toLowerCase(),
              );
              viewModel.clearForm();
              completer(
                DialogResponse<VersionLink>(confirmed: true, data: data),
              );
            },
            child: Text(app != null ? 'Edit' : 'Add'),
          )
        else
          FilledButton(
            onPressed: null,
            child: Text(app != null ? 'Edit' : 'Add'),
          ),
      ],
    );
  }

  @override
  EditAppDialogModel viewModelBuilder(BuildContext context) =>
      EditAppDialogModel();

  @override
  void onViewModelReady(EditAppDialogModel viewModel) {
    super.onViewModelReady(viewModel);
    final app = (request.data != null && request.data is AppInfo)
        ? request.data as AppInfo
        : null;
    if (app != null) {
      appNameController.text = app.name;
      appUrlController.text = app.appUrl;
    }
    syncFormWithViewModel(viewModel);
  }
}
