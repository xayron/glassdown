import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/views/types/items/type_card/type_card.dart';
import 'package:stacked/stacked.dart';

import 'types_viewmodel.dart';

class TypesView extends StackedView<TypesViewModel> {
  const TypesView({super.key, required this.app});

  final AppInfo app;

  @override
  Widget builder(
    BuildContext context,
    TypesViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) => viewModel.cancel(),
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 90,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
              title: Text(
                app.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          if (viewModel.isBusy)
            const SliverToBoxAdapter(
              child: LinearProgressIndicator(),
            ),
          if (viewModel.hasError)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      title: Text(
                        viewModel.modelError is DioException
                            ? viewModel.modelError.message
                            : viewModel.modelError.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (viewModel.appTypes != null)
            SliverList(
              delegate: SliverChildListDelegate([
                ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final appTypes in viewModel.appTypes!.types!)
                      TypeCard(
                        app: app,
                        type: appTypes,
                      )
                  ],
                ),
              ]),
            ),
        ],
      )),
    );
  }

  @override
  TypesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TypesViewModel();

  @override
  void onViewModelReady(TypesViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.fetchTypes(app);
  }
}
