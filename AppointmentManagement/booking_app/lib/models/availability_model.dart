class TimeSlot {
  final String startTime; // "09:00"
  final String endTime;   // "17:00"

  const TimeSlot({required this.startTime, required this.endTime});

  Map<String, dynamic> toMap() => {
    'startTime': startTime,
    'endTime': endTime,
  };

  factory TimeSlot.fromMap(Map<String, dynamic> map) => TimeSlot(
    startTime: map['startTime'],
    endTime: map['endTime'],
  );
}

class AvailabilityModel {
  final String providerId;
  final Map<String, List<TimeSlot>> weeklySchedule;
  // Keys: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'
  // Value: list of available time slots (empty list = day off)
  final List<DateTime> blockedDates; // specific dates that are blocked
  final String timezone;

  AvailabilityModel({
    required this.providerId,
    required this.weeklySchedule,
    this.blockedDates = const [],
    this.timezone = 'UTC',
  });

  static AvailabilityModel defaultSchedule(String providerId) {
    return AvailabilityModel(
      providerId: providerId,
      weeklySchedule: {
        'monday': [const TimeSlot(startTime: '09:00', endTime: '17:00')],
        'tuesday': [const TimeSlot(startTime: '09:00', endTime: '17:00')],
        'wednesday': [const TimeSlot(startTime: '09:00', endTime: '17:00')],
        'thursday': [const TimeSlot(startTime: '09:00', endTime: '17:00')],
        'friday': [const TimeSlot(startTime: '09:00', endTime: '17:00')],
        'saturday': [],
        'sunday': [],
      },
    );
  }

  bool isDayAvailable(String dayName) {
    return weeklySchedule[dayName.toLowerCase()]?.isNotEmpty ?? false;
  }

  Map<String, dynamic> toFirestore() {
    final scheduleMap = <String, dynamic>{};
    weeklySchedule.forEach((day, slots) {
      scheduleMap[day] = slots.map((s) => s.toMap()).toList();
    });
    return {
      'providerId': providerId,
      'weeklySchedule': scheduleMap,
      'blockedDates': blockedDates.map((d) => d.toIso8601String()).toList(),
      'timezone': timezone,
    };
  }

  factory AvailabilityModel.fromFirestore(Map<String, dynamic> data) {
    final scheduleData = data['weeklySchedule'] as Map<String, dynamic>? ?? {};
    final schedule = <String, List<TimeSlot>>{};
    scheduleData.forEach((day, slots) {
      schedule[day] = (slots as List)
          .map((s) => TimeSlot.fromMap(s as Map<String, dynamic>))
          .toList();
    });

    return AvailabilityModel(
      providerId: data['providerId'] ?? '',
      weeklySchedule: schedule,
      blockedDates: (data['blockedDates'] as List? ?? [])
          .map((d) => DateTime.parse(d as String))
          .toList(),
      timezone: data['timezone'] ?? 'UTC',
    );
  }
}
