import 'calendar_event_option.dart';

abstract class AppRepository {
  Future<bool> addOptions(CalendarEventOption option);

  Future<bool> deleteOptions(String optionId);

  Future<EventOptionList> getEventOptions();
}
