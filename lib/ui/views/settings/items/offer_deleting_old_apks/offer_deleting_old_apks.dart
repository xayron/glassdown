import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/settings/common/item_wrapper.dart';
import 'package:stacked/stacked.dart';

import 'offer_deleting_old_apks_model.dart';

class OfferDeletingOldApks extends StackedView<OfferDeletingOldApksModel> {
  const OfferDeletingOldApks({
    super.key,
    this.rounded = false,
  });

  final bool rounded;

  @override
  Widget builder(
    BuildContext context,
    OfferDeletingOldApksModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      borderRadius: rounded ? BorderRadius.circular(16) : null,
      onTap: !viewModel.autoRemove
          ? () {
              viewModel.updateValue(!viewModel.offerRemoval);
            }
          : null,
      child: ItemWrapper(
        enabled: !viewModel.autoRemove,
        mainText: 'Offer deleting old versions',
        secondaryText:
            'Ask for deletion of old APKs before downloading new one',
        trailingWidget: Switch(
          onChanged: !viewModel.autoRemove
              ? (value) {
                  viewModel.updateValue(value);
                }
              : null,
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
