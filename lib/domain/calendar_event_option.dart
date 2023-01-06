import 'dart:convert';

class CalendarEventOption {
  CalendarEventOption({
    required this.optionName,
    required this.optionDescription,
    required this.icon,
    required this.id,
    required this.dateTime,
  });

  final String optionName;
  final String optionDescription;
  final String icon;
  final String id;
  final String dateTime;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarEventOption &&
        other.optionName == optionName &&
        other.optionDescription == optionDescription &&
        other.icon == icon &&
        other.id == id &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode =>
      optionName.hashCode ^
      optionDescription.hashCode ^
      icon.hashCode ^
      id.hashCode ^
      dateTime.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'optionName': optionName,
      'optionDescription': optionDescription,
      'icon': icon,
      'id': id,
      'dateTime': dateTime,
    };
  }

  factory CalendarEventOption.fromMap(Map<String, dynamic> map) {
    return CalendarEventOption(
      optionName: map['optionName'] ?? '',
      optionDescription: map['optionDescription'] ?? '',
      icon: map['icon'] ?? '',
      id: map['id'] ?? '',
      dateTime: map['dateTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarEventOption.fromJson(String source) =>
      CalendarEventOption.fromMap(json.decode(source));
}

typedef EventOptionList = List<CalendarEventOption>;
