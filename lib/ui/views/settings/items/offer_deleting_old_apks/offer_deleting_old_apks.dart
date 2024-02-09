import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'offer_deleting_old_apks_model.dart';

class OfferDeletingOldApks extends StackedView<OfferDeletingOldApksModel> {
  const OfferDeletingOldApks({super.key});

  @override
  Widget builder(
    BuildContext context,
    OfferDeletingOldApksModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () {
        viewModel.updateValue(!viewModel.offerRemoval);
      },
      child: ItemWrapper(
        mainText: 'Offer old versions deletion',
        secondaryText:
            'Ask for deletion of old APKs before downloading new one',
        trailingWidget: Switch(
          onChanged: (value) {
            viewModel.updateValue(value);
          },
          value: viewModel.offerRemoval,
        ),
      ),
    );
  }

  @override
  OfferDeletingOldApksModel viewModelBuilder(
    BuildContext context,
  ) =>
      OfferDeletingOldApksModel();
}
