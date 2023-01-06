import 'package:auto_calendar_reminder/ext.dart';
import 'package:flutter/material.dart';

import '../../domain/calendar_event_option.dart';

class ItemReminderOption extends StatelessWidget {
  const ItemReminderOption({super.key, required this.option});

  final CalendarEventOption option;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Dismissible(
        key: Key(option.id),
        background: Container(
          color: Colors.red[300],
        ),
        onDismissed: (direction) =>
            context.actionsDataController.deleteEventOption(option.id),
        child: ListTile(
          tileColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(option.icon),
            radius: 20,
          ),
          title: Text(
            option.optionName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "${option.optionDescription}\n${option.dateTime}",
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
