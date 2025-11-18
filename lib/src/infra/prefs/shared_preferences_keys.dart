enum SharedPreferencesKeys {
  reminderFirstDaysKey('reminder_first_days'),
  reminderSecondDaysKey('reminder_second_days'),
  reminderHourKey('reminder_hour'),
  reminderMinuteKey('reminder_minute'),
  firstLaunchKey('first_launch_key');

  final String value;
  const SharedPreferencesKeys(this.value);
}
