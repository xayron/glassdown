import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProgressCardModel extends BaseViewModel {
  double? calcIndicatorProgress(double? progress) {
    return progress != null ? progress.toInt() / 100 : null;
  }

  Color getColorForProgress(double? progress, BuildContext context) {
    return progress == 100
        ? Colors.lightGreen
        : Theme.of(context).colorScheme.primary;
  }
}
