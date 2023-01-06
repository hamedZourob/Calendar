import 'package:auto_calendar_reminder/domain/app_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/calendar_event_option.dart';

class AppRepositoryImpl extends AppRepository {
  AppRepositoryImpl(this.sharedPref);

  final SharedPreferences sharedPref;

  @override
  Future<bool> addOptions(CalendarEventOption option) {
    return sharedPref.setString(option.id.toString(), option.toJson());
  }

  @override
  Future<EventOptionList> getEventOptions() async {
    final list = <CalendarEventOption>[];

    for (String key in sharedPref.getKeys()) {
      final json = sharedPref.getString(key);

      if (json != null) {
        final item = CalendarEventOption.fromJson(json);
        list.add(item);
      }
    }

    return list;
  }

  @override
  Future<bool> deleteOptions(String optionId) {
    return sharedPref.remove(optionId);
  }
}
