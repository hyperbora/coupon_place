/// 사용자가 설정 앱에서 선택하는 쿠폰 만료 알림 시점(일 단위)
/// 예: firstReminderDays = 7 → 만료 7일 전 알림
///     secondReminderDays = 1 → 만료 1일 전 알림
class UserReminderSetting {
  final int? firstReminderDays; // 1차 알림 (0 ~ 30)
  final int? secondReminderDays; // 2차 알림 (0 ~ 30)

  const UserReminderSetting({
    required this.firstReminderDays,
    required this.secondReminderDays,
  });

  /// 기본값: 7일 전 + 1일 전
  static const UserReminderSetting defaults = UserReminderSetting(
    firstReminderDays: 7,
    secondReminderDays: 1,
  );

  UserReminderSetting copyWith({
    int? firstReminderDays,
    int? secondReminderDays,
  }) {
    return UserReminderSetting(
      firstReminderDays: firstReminderDays ?? this.firstReminderDays,
      secondReminderDays: secondReminderDays ?? this.secondReminderDays,
    );
  }
}
