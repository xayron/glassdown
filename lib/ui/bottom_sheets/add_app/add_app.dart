import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/bottom_sheets/add_app/add_app_model.dart';
import 'package:glass_down_v2/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Future<T?> showAddAppSheet<T>() {
  return showModalBottomSheet<T>(
    useSafeArea: true,
    useRootNavigator: true,
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      return ViewModelBuilder.reactive(
        viewModelBuilder: () => AddAppSheetModel(),
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
                  'Add app',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: viewModel.appNameController,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onFieldSubmitted: (value) {
                            viewModel.searchApp(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search app',
                            filled: true,
                            isDense: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceTint
                                .withAlpha(50),
                            hintStyle: const TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(75),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            suffixIcon: IconButton(
                              onPressed: () {
                                viewModel.appNameController.clear();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      if (!viewModel.loading)
                        IconButton.filled(
                          icon: const Icon(Icons.search),
                          iconSize: 32,
                          constraints: const BoxConstraints.expand(
                            height: 55,
                            width: 55,
                          ),
                          onPressed: () {
                            viewModel.searchApp(
                              viewModel.appNameController.text,
                            );
                          },
                        )
                      else
                        const SizedBox(
                          height: 55,
                          width: 55,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Expanded(
                  child: ListView(
                    children: [
                      verticalSpaceSmall,
                      for (final searchResult in viewModel.results)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          surfaceTintColor:
                              Theme.of(context).colorScheme.primary,
                          child: ListTile(
                            onTap: () => viewModel.addApp(searchResult),
                            enabled: !viewModel.addingApp &&
                                !viewModel.showProgress(searchResult),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  Image.network(searchResult.imgLink).image,
                            ),
                            trailing: viewModel.addingApp &&
                                    viewModel.showProgress(searchResult)
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.add),
                            title: Text(searchResult.name),
                          ),
                        ),
                    ],
                  ),
                ),
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
