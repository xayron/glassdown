import 'package:flutter/material.dart';
import 'package:glass_down_v2/models/app_info.dart';
import 'package:glass_down_v2/ui/widgets/common/chips/type_chip.dart';
import 'package:stacked/stacked.dart';

import 'type_card_model.dart';

class TypeCard extends StackedView<TypeCardModel> {
  const TypeCard({
    super.key,
    required this.app,
    required this.type,
  });

  final AppInfo app;
  final TypeInfo type;

  @override
  Widget builder(
    BuildContext context,
    TypeCardModel viewModel,
    Widget? child,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        onTap: () {
          final pickedTypeApk = app.copyWith(pickedType: type);
          viewModel.openDownloadView(pickedTypeApk);
        },
        subtitle: Text(type.archDpi),
        title: Text(type.title),
        trailing: TypeChip(isBundle: type.isBundle),
      ),
    );
  }

  @override
  TypeCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      TypeCardModel();
}
