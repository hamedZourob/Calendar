import 'package:auto_calendar_reminder/data/app_repository_impl.dart';
import 'package:auto_calendar_reminder/presentation/create_option_screen.dart';
import 'package:auto_calendar_reminder/presentation/home_screen.dart';
import 'package:auto_calendar_reminder/presentation/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/data_controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPref = await SharedPreferences.getInstance();
  final dataController =
      AppDataController(repository: AppRepositoryImpl(sharedPref));

  runApp(MyApp(dataController: dataController));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.dataController,
    this.navigatorObserver,
  });

  final AppDataController dataController;
  final NavigatorObserver? navigatorObserver;

  @override
  Widget build(BuildContext context) {
    return AppProvider<AppDataController>(
      dataController: dataController,
      child: MaterialApp(
        title: 'Auto Calendar',
        navigatorObservers: [if (navigatorObserver != null) navigatorObserver!],
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.orange,
        ),
        home: const HomeScreen(),
        routes: {
          CreateOptionScreen.pageName: (context) => const CreateOptionScreen()
        },
      ),
    );
  }
}
