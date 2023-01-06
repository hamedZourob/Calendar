import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/main.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:auto_calendar_reminder/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

typedef OnObservation = Function(
    Route<dynamic> route, Route<dynamic>? previousRoute);

typedef _AppButtonStatePredicate = Function(
  Element element,
  AppButton appButton,
  RawMaterialButton rawMaterialButton,
  Widget? buttonChild,
);

class TestUtils {
  static Future<void> pumpApp(
    WidgetTester tester, {
    required AppRepository repository,
    bool navigateToScreen2 = false,
    NavigatorObserver? observer,
  }) async {
    await tester.pumpWidget(
      MyApp(
        dataController: AppDataController(repository: repository),
        navigatorObserver: observer,
      ),
    );

    if (navigateToScreen2) {
      await tester.tap(find.byType(FloatingActionButton));
    }
    await tester.pumpAndSettle();
  }
}

class TestNavigatorObserver extends NavigatorObserver {
  TestNavigatorObserver({this.onPushed, this.onPopped});

  OnObservation? onPushed;
  OnObservation? onPopped;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (onPushed != null) {
      onPushed!(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (onPopped != null) {
      onPopped!(route, previousRoute);
    }
  }
}

final appButtonFinder = _AppButtonFinder();

class _AppButtonFinder extends MatchFinder {
  @override
  String get description => "button: $AppButton";

  @override
  bool matches(Element candidate) =>
      candidate.widget is RawMaterialButton &&
      candidate.findAncestorWidgetOfExactType<AppButton>() != null;
}

/// A matcher that validates that button is in loading state used alongside [appButtonFinder]
const findsAppButtonInLoadingState = _AddButtonLoadingStateMatcher();

/// A matcher that validates that button is enabled used alongside [appButtonFinder]
const findsAppButtonInEnabledState = _AddButtonEnabledStateMatcher();

/// A matcher that validates that button is disabled used alongside [appButtonFinder]
const findsAppButtonInDisabledState = _AddButtonDisabledStateMatcher();

abstract class _AddButtonStateMatcher extends Matcher {
  const _AddButtonStateMatcher();

  @override
  Description describe(Description description) =>
      description.add(descriptionText);

  String get descriptionText;

  @override
  bool matches(covariant Finder finder, Map matchState) {
    final element = finder.evaluate().single;

    if (element.widget is! RawMaterialButton) return false;

    final rawMaterialButton = element.widget as RawMaterialButton;

    final appButton = element.findAncestorWidgetOfExactType<AppButton>();

    return appButtonStatePredicate(
      element,
      appButton!,
      rawMaterialButton,
      rawMaterialButton.child,
    );
  }

  _AppButtonStatePredicate get appButtonStatePredicate;

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    final element = finder.evaluate().single;

    if (element.widget is! RawMaterialButton) {
      mismatchDescription.add("Widget not RawMaterialButton");
    }

    final rawMaterialButton = element.widget as RawMaterialButton;

    final appButton = element.findAncestorWidgetOfExactType<AppButton>()!;

    if (!appButtonStatePredicate(
      element,
      appButton,
      rawMaterialButton,
      rawMaterialButton.child,
    )) {
      mismatchDescription.add(mismatchDescriptionText);
    }

    return mismatchDescription;
  }

  String get mismatchDescriptionText;
}

class _AddButtonLoadingStateMatcher extends _AddButtonStateMatcher {
  const _AddButtonLoadingStateMatcher();

  @override
  _AppButtonStatePredicate get appButtonStatePredicate =>
      (_, appButton, rawMaterialButton, buttonChild) =>
          !rawMaterialButton.enabled &&
          appButton.loading() &&
          buttonChild is Padding &&
          buttonChild.child is CircularProgressIndicator;

  @override
  String get descriptionText => 'AppButton in loading state';

  @override
  String get mismatchDescriptionText => 'AppButton not in loading state';
}

class _AddButtonEnabledStateMatcher extends _AddButtonStateMatcher {
  const _AddButtonEnabledStateMatcher();

  @override
  _AppButtonStatePredicate get appButtonStatePredicate =>
      (element, _, rawMaterialButton, buttonChild) =>
          rawMaterialButton.enabled &&
          rawMaterialButton.fillColor == Theme.of(element).primaryColor &&
          buttonChild is Text &&
          buttonChild.data == 'Save';

  @override
  String get descriptionText => 'AppButton in enabled state';

  @override
  String get mismatchDescriptionText => 'AppButton not in enabled state';
}

class _AddButtonDisabledStateMatcher extends _AddButtonStateMatcher {
  const _AddButtonDisabledStateMatcher();

  @override
  _AppButtonStatePredicate get appButtonStatePredicate =>
      (element, appButton, rawMaterialButton, buttonChild) =>
          !rawMaterialButton.enabled &&
          !appButton.loading() &&
          rawMaterialButton.fillColor == Colors.grey[300] &&
          buttonChild is Text &&
          buttonChild.data == 'Save';

  @override
  String get descriptionText => 'AppButton in disabled state';

  @override
  String get mismatchDescriptionText => 'AppButton not in disabled state';
}