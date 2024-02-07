import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:glass_down_v2/ui/dialogs/add_app/add_app_dialog.form.dart';
import 'package:glass_down_v2/ui/widgets/form/validation_error_message.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'add_app_dialog_model.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'appName',
      validator: AddAppDialogValidators.validateAppName,
    ),
    FormTextField(
      name: 'appUrl',
      validator: AddAppDialogValidators.validateAppUrl,
    ),
  ],
)
class AddAppDialog extends StackedView<AddAppDialogModel> with $AddAppDialog {
  final DialogRequest<void> request;
  final Function(DialogResponse) completer;

  const AddAppDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    AddAppDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: const Text('Add new app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(viewModel.message),
          RichText(
            text: TextSpan(
              text: viewModel.message,
              children: [
                TextSpan(
                  text: viewModel.urlMessage,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: viewModel.appMessage,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
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
                url: viewModel.appUrlValue!.trim(),
              );
              viewModel.clearForm();
              completer(
                DialogResponse<VersionLink>(confirmed: true, data: data),
              );
            },
            child: const Text('Add'),
          )
        else
          const FilledButton(onPressed: null, child: Text('Add')),
      ],
    );
  }

  @override
  AddAppDialogModel viewModelBuilder(BuildContext context) =>
      AddAppDialogModel();

  @override
  void onViewModelReady(AddAppDialogModel viewModel) {
    super.onViewModelReady(viewModel);
    syncFormWithViewModel(viewModel);
  }
}
