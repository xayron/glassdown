import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/widgets/common/nok_chip.dart';
import 'package:glass_down_v2/ui/widgets/common/ok_chip.dart';
import 'package:stacked/stacked.dart';

import 'progress_card_model.dart';

class ProgressCard extends StackedView<ProgressCardModel> {
  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.complete,
    this.subTitle,
  });

  final String title;
  final double? progress;
  final String? subTitle;
  final bool complete;

  @override
  Widget builder(
    BuildContext context,
    ProgressCardModel viewModel,
    Widget? child,
  ) {
    final progressValue = progress != null ? progress!.toInt() / 100 : null;
    final colorValue = progress == 100
        ? Colors.lightGreen
        : Theme.of(context).colorScheme.primary;
    final trailingValue = progress == 100
        ? const OkChip()
        : progress != null
            ? Text('${progress?.toStringAsFixed(1)}%')
            : null;

    return ListTile(
      subtitle: subTitle != null ? Text(subTitle!) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(title),
      leading: CircularProgressIndicator(
        value: complete ? progressValue : 1.0,
        color: complete ? colorValue : Colors.redAccent,
      ),
      trailing: complete ? trailingValue : const NokChip(),
    );
  }

  @override
  ProgressCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProgressCardModel();
}
