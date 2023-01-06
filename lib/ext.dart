import 'package:auto_calendar_reminder/presentation/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'presentation/data_controllers.dart';

extension BuildContextExt on BuildContext {
  AppDataController get appDataController =>
      AppProvider.of<AppDataController>(this);

  ActionsDataController get actionsDataController =>
      AppProvider.of<ActionsDataController>(this);

  void showBanner(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(this).showMaterialBanner(
        MaterialBanner(
          content: Text(text),
          actions: [
            Builder(builder: (context) {
              return InkWell(
                  onTap: () =>
                      ScaffoldMessenger.of(context).clearMaterialBanners(),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.close),
                  ));
            })
          ],
          backgroundColor: Theme.of(this).splashColor,
        ),
      );
    });
  }

  void popScreen() => Navigator.pop(this);
}

extension DateTimExt on DateTime {
  String get toFormattedDate => DateFormat.yMMMMd().format(this);
}
