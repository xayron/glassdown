import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'permissions_viewmodel.dart';

class PermissionsView extends StackedView<PermissionsViewModel> {
  const PermissionsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PermissionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(viewModel.description),
                    ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      color: !viewModel.storage
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : null,
                      child: ListTile(
                        onTap: () => viewModel.requestStoragePermission(),
                        title: const Text('Storage'),
                        subtitle: const Text(
                          'Needed for importing/exporting app list, deleting already downloaded APKs etc.',
                        ),
                        trailing: !viewModel.storage
                            ? const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                                size: 30,
                              )
                            : const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30,
                              ),
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      color: !viewModel.install
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : null,
                      elevation: 1,
                      child: ListTile(
                        onTap: () => viewModel.requestInstallPermission(),
                        title: const Text('Install packages'),
                        subtitle: const Text(
                          'Needed for installing newer version of this app from GitHub',
                        ),
                        trailing: !viewModel.install
                            ? const Icon(
                                Icons.close,
                                color: Colors.redAccent,
                                size: 30,
                              )
                            : const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30,
                              ),
                      ),
                    ),
                    if (viewModel.install && viewModel.storage)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => viewModel.goHome(),
                              child: const Text('Finish'),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PermissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PermissionsViewModel();

  @override
  void onViewModelReady(PermissionsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.init();
  }
}
