import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/presentation/widgets/item_reminder_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Ensure event data set on widget', (WidgetTester tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ItemReminderOption(
              option: CalendarEventOption(
                optionName: "Coffee Break",
                optionDescription: "Description",
                icon: "iconUrl",
                id: "id",
                dateTime: "Oct 14, 2022",
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key("id")), findsOneWidget);
    expect(find.text("Coffee Break"), findsOneWidget);
    expect(find.text("Description\nOct 14, 2022"), findsOneWidget);

    final circleAvatarFinder = find.byType(CircleAvatar);
    expect(circleAvatarFinder, findsOneWidget);
    expect(
      (tester.widget(circleAvatarFinder) as CircleAvatar).backgroundImage,
      const NetworkImage("iconUrl"),
    );
  });
}
