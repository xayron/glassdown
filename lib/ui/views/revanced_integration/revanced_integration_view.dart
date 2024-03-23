import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/group_header.dart';
import 'package:stacked/stacked.dart';

import 'revanced_integration_viewmodel.dart';

class RevancedIntegrationView
    extends StackedView<RevancedIntegrationViewModel> {
  const RevancedIntegrationView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RevancedIntegrationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: Text(
              'Revanced Integration',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            automaticallyImplyLeading: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              ListView(
                padding: const EdgeInsets.only(bottom: 30),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  GroupHeader(
                    name: 'Here will be page with Revanced Integration options',
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  RevancedIntegrationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RevancedIntegrationViewModel();
}
