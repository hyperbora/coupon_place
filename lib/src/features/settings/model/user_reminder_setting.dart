/// 사용자가 설정 앱에서 선택하는 쿠폰 만료 알림 시점(일 단위) 및 알림 시간(시, 분)
/// 예: firstReminderDays = 7 → 만료 7일 전 알림
///     secondReminderDays = 1 → 만료 1일 전 알림
///     reminderHour = 9, reminderMinute = 0 → 오전 9시 정각에 알림
class UserReminderSetting {
  final int? firstReminderDays; // 1차 알림 (0 ~ 30)
  final int? secondReminderDays; // 2차 알림 (0 ~ 30)
  final int? reminderHour; // 알림 시 (0 ~ 23)
  final int? reminderMinute; // 알림 분 (0 ~ 59)

  const UserReminderSetting({
    required this.firstReminderDays,
    required this.secondReminderDays,
    required this.reminderHour,
    required this.reminderMinute,
  });

  /// 기본값: 7일 전 + 1일 전, 오전 9시 정각
  static const UserReminderSetting defaults = UserReminderSetting(
    firstReminderDays: 7,
    secondReminderDays: 1,
    reminderHour: 9,
    reminderMinute: 0,
  );

  UserReminderSetting copyWith({
    int? firstReminderDays,
    int? secondReminderDays,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserReminderSetting(
      firstReminderDays: firstReminderDays ?? this.firstReminderDays,
      secondReminderDays: secondReminderDays ?? this.secondReminderDays,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}
