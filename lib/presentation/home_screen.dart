import 'package:auto_calendar_reminder/ext.dart';
import 'package:auto_calendar_reminder/presentation/create_option_screen.dart';
import 'package:flutter/material.dart';

import 'data_controllers.dart';
import 'provider.dart';
import 'widgets/item_reminder_option.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

@visibleForTesting
class HomeScreenState extends State<HomeScreen> {
  late final _actionsDataController =
      ActionsDataController(controller: context.appDataController);

  @override
  void initState() {
    context.appDataController.loadEventOptions();
    _actionsDataController.addListener(() {
      final state = context.appDataController.state;

      if (state.successText != null) {
        context.showBanner(state.successText!);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider<ActionsDataController>(
      dataController: _actionsDataController,
      child: Scaffold(
        appBar: AppBar(title: const Text("Events Options")),
        body: AnimatedBuilder(
            animation: context.appDataController,
            builder: (context, _) {
              final state = context.appDataController.state;

              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                context.showBanner(state.error!);
                return const SizedBox.shrink();
              }

              final options = state.data;

              if (options.isEmpty) {
                return const Center(child: Text("No events found"));
              }

              return ListView.builder(
                itemCount: options.length,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemBuilder: (context, index) =>
                    ItemReminderOption(option: options[index]),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, CreateOptionScreen.pageName),
          child: const Icon(
            Icons.add,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _actionsDataController.dispose();
    super.dispose();
  }
}
