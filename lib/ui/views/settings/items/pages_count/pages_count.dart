import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'pages_count_model.dart';

class PagesCount extends StackedView<PagesCountModel> {
  const PagesCount({super.key});

  @override
  Widget builder(
    BuildContext context,
    PagesCountModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => viewModel.handleTap(),
      child: ItemWrapper(
        mainText: 'Pages amount',
        secondaryText: 'Amount of pages to fetch',
        trailingWidget: MenuAnchor(
          controller: viewModel.controller,
          builder: (_, __, child) => child!,
          menuChildren: [
            for (var i = 1; i < 4; i++)
              MenuItemButton(
                child: Text(i.toString()),
                onPressed: () => viewModel.updateValue(i),
              )
          ],
          child: FilledButton.tonal(
            onPressed: () => viewModel.handleTap(),
            child: Text(
              viewModel.pagesAmount.toString(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  PagesCountModel viewModelBuilder(
    BuildContext context,
  ) =>
      PagesCountModel();
}
