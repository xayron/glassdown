import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:glass_down_v2/ui/views/apps/apps_view.dart';
import 'package:glass_down_v2/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const AppsView();
      case 1:
        return const SettingsView();
      default:
        return const AppsView();
    }
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: getViewForIndex(viewModel.currentIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          viewModel.setIndex(value);
        },
        selectedIndex: viewModel.currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apps),
            label: 'Apps',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
