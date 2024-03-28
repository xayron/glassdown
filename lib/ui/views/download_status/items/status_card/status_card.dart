import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/common/chips/in_progress_chip.dart';
import 'package:glass_down_v2/ui/widgets/common/chips/nok_chip.dart';
import 'package:glass_down_v2/ui/widgets/common/chips/ok_chip.dart';
import 'package:stacked/stacked.dart';

import 'status_card_model.dart';

class StatusCard extends StackedView<StatusCardModel> {
  const StatusCard({
    super.key,
    required this.title,
    required this.complete,
    this.subTitle,
  });

  final String title;
  final bool? complete;
  final String? subTitle;

  @override
  Widget builder(
    BuildContext context,
    StatusCardModel viewModel,
    Widget? child,
  ) {
    return ListTile(
      subtitle: subTitle != null ? Text(subTitle!) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title),
      trailing: switch (complete) {
        null => const InProgressChip(),
        true => const OkChip(),
        false => const NokChip(),
      },
    );
  }

  @override
  StatusCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      StatusCardModel();
}
