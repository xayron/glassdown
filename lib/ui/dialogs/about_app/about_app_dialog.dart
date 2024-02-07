import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'about_app_dialog_model.dart';

class AboutAppDialog extends StackedView<AboutAppDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AboutAppDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    AboutAppDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: const Text('GlassDown'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: viewModel.message,
            ),
          ),
        ],
      ),
    );
  }

  @override
  AboutAppDialogModel viewModelBuilder(BuildContext context) =>
      AboutAppDialogModel();
}
