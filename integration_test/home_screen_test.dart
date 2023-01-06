import 'package:auto_calendar_reminder/data/fake_app_repository_impl.dart';
import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/ext.dart';
import 'package:auto_calendar_reminder/presentation/create_option_screen.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:auto_calendar_reminder/presentation/home_screen.dart';
import 'package:auto_calendar_reminder/presentation/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_util.dart';

class HomeScreenTestCases {
  HomeScreenTestCases(this.repository);

  final FakeAppRepository repository;

  Future<void> testProvidersInjected(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(AppProvider<ActionsDataController>), findsOneWidget);
    expect(find.byType(AppProvider<AppDataController>), findsOneWidget);
  }

  Future<void> testLoadingState(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    final dataController =
        tester.state(find.byType(HomeScreen)).context.appDataController;

    dataController.state = UIState<EventOptionList>(data: [], loading: true);

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testErrorState(WidgetTester tester) async {
    repository.throwGetError = true;

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text("An error occurred"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text("No events found"), findsNothing);
    expect(find.byType(ListView), findsNothing);
  }

  Future<void> testEmptyState(WidgetTester tester) async {
    repository.returnEmpty = true;

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.text("No events found"), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testDataLoadedState(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(ListView), findsOneWidget);

    for (var id in ['id1', 'id2', 'id3']) {
      expect(find.byKey(Key(id)), findsOneWidget);
    }

    expect(find.text("No events found"), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(MaterialBanner), findsNothing);
  }

  Future<void> testMaterialBannerDismissedOnCancelPressed(
      WidgetTester tester) async {
    repository.throwGetError = true;

    await TestUtils.pumpApp(tester, repository: repository);

    expect(find.byType(MaterialBanner), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));

    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsNothing);
    expect(find.text("An error occurred"), findsNothing);
  }

  Future<void> testFABPressed(WidgetTester tester) async {
    List<String> navigatorEntries = [];

    TestNavigatorObserver navigatorObserver = TestNavigatorObserver()
      ..onPushed = (route, _) {
        navigatorEntries.add(route.settings.name ?? '');
      };

    await TestUtils.pumpApp(
      tester,
      repository: repository,
      observer: navigatorObserver,
    );

    await tester.tap(find.byType(FloatingActionButton));

    await tester.pumpAndSettle();

    expect(navigatorEntries.isNotEmpty, true);
    expect(navigatorEntries, ['/', CreateOptionScreen.pageName]);
  }

  Future<void> testOnItemDraggedDelete(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    await tester.drag(find.byKey(const Key("id1")), const Offset(-700, 0));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key("id2")), findsOneWidget);
    expect(find.byKey(const Key("id3")), findsOneWidget);

    expect(find.byKey(const Key("id1")), findsNothing);
  }
}
