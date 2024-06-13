import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      child: ListTile(
                        onTap: () => viewModel.requestStoragePermission(),
                        title: const Text('Storage'),
                        subtitle: const Text(
                          'Needed if you want a different file system localisation for importing/exporting app list, deleting already downloaded APKs etc. than default one (Downloads/GlassDown)',
                        ),
                        tileColor: !viewModel.storage
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceTint
                                .withAlpha(20)
                            : Colors.lightGreenAccent.withAlpha(40),
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
                    verticalSpaceTiny,
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      child: ListTile(
                        onTap: () => viewModel.requestInstallPermission(),
                        title: const Text('Install packages'),
                        subtitle: const Text(
                          'Needed for installing newer version of this app from GitHub',
                        ),
                        tileColor: !viewModel.install
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceTint
                                .withAlpha(20)
                            : Colors.lightGreenAccent.withAlpha(40),
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
                    verticalSpaceTiny,
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      child: ListTile(
                        onTap: () => viewModel.requestShizukuPermission(),
                        title: const Text('Shizuku installer'),
                        subtitle: const Text(
                          'Needed for installing APKs without user interaction',
                        ),
                        tileColor: !viewModel.shizuku
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceTint
                                .withAlpha(20)
                            : Colors.lightGreenAccent.withAlpha(40),
                        trailing: !viewModel.shizuku
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
                    verticalSpaceSmall,
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
                    // if (viewModel.storage)
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
    viewModel.init();
  }
}
