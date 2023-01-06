import 'package:auto_calendar_reminder/domain/domain_export.dart';

class FakeAppRepository extends AppRepository {
  bool throwGetError = false;
  bool returnEmpty = false;

  @override
  Future<bool> addOptions(CalendarEventOption option) async {
    return true;
  }

  @override
  Future<bool> deleteOptions(String optionId) async {
    return true;
  }

  @override
  Future<EventOptionList> getEventOptions() async {
    if (throwGetError) {
      throw Exception("An error occurred");
    } else {
      return returnEmpty
          ? []
          : [
              CalendarEventOption(
                optionName: "Name1",
                optionDescription: "Description1",
                icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
                id: "id1",
                dateTime: "12/10/2022",
              ),
              CalendarEventOption(
                optionName: "Name2",
                optionDescription: "Description2",
                icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
                id: "id2",
                dateTime: "22/12/2022",
              ),
              CalendarEventOption(
                optionName: "Name3",
                optionDescription: "Description3",
                icon: "https://cdn-icons-png.flaticon.com/512/1792/1792931.png",
                id: "id3",
                dateTime: "01/12/2022",
              ),
            ];
    }
  }
}
