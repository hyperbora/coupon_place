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

  /// Map 변환 (저장용, 예: Firestore/SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'firstReminderDays': firstReminderDays,
      'secondReminderDays': secondReminderDays,
    };
  }

  /// Map에서 불러오기
  factory UserReminderSetting.fromMap(Map<String, dynamic> map) {
    final first =
        map.containsKey('firstReminderDays')
            ? map['firstReminderDays'] as int?
            : null;
    final second =
        map.containsKey('secondReminderDays')
            ? map['secondReminderDays'] as int?
            : null;

    // 키가 둘 다 없으면 기본 설정을 반환하도록 변경
    if (!map.containsKey('firstReminderDays') &&
        !map.containsKey('secondReminderDays')) {
      return UserReminderSetting.defaults;
    }

    return UserReminderSetting(
      firstReminderDays: first,
      secondReminderDays: second,
    );
  }

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
