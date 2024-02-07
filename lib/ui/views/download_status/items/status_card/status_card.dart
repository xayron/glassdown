import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/common/nok_chip.dart';
import 'package:glass_down_v2/ui/widgets/common/ok_chip.dart';
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
      leading: CircularProgressIndicator(
        value: switch (complete) {
          null => null,
          true => 1.0,
          false => 1.0,
        },
        color: switch (complete) {
          null => Theme.of(context).colorScheme.primary,
          true => Colors.lightGreen,
          false => Colors.redAccent,
        },
      ),
      trailing: switch (complete) {
        null => null,
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
