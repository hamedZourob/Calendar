import 'package:flutter/material.dart';

import 'data_controllers.dart';

class AppProvider<T extends BaseDataController> extends InheritedWidget {
  const AppProvider(
      {super.key, required this.dataController, required super.child});

  final T dataController;

  static T of<T extends BaseDataController>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<AppProvider<T>>();

    assert(element != null, "$T not found");

    return (element!.widget as AppProvider<T>).dataController;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      oldWidget.dataController != dataController;
}
