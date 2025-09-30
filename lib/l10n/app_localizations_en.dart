// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Coupon Place';

  @override
  String get homeTitle => 'Home';

  @override
  String get couponRegisterTitle => 'Add Coupon';

  @override
  String get couponEditTitle => 'Edit Coupon';

  @override
  String get myCouponsTitle => 'My Coupons';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get couponRegisterTooltip => 'Add Coupon';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get couponNameLabel => 'Coupon Name';

  @override
  String get couponNameHint => 'Enter coupon name';

  @override
  String get validDateLabel => 'Valid Date';

  @override
  String get validDateHint => 'Select a date';

  @override
  String get couponCodeLabel => 'Coupon Code';

  @override
  String get memoLabel => 'Memo';

  @override
  String get folderLabel => 'Select Folder';

  @override
  String get folderHint => 'Please select a folder';

  @override
  String get alarmLabel => 'Enable Expiry Alarm';

  @override
  String get imageSelect => 'Select Image';

  @override
  String get camera => 'Camera';

  @override
  String get library => 'Library';

  @override
  String get registerCouponPlaceholder => 'Register your coupon.';

  @override
  String get folderAdd => 'Add Folder';

  @override
  String get folderSelect => 'Select Folder';

  @override
  String get folderNameHint => 'Folder Name';

  @override
  String get folderNameEmptyError => 'Please enter a folder name';

  @override
  String get folderCreateFirst => 'Please create a folder first.';

  @override
  String get deleteCouponTitle => 'Delete Coupon';

  @override
  String get deleteCouponContent => 'Are you sure you want to delete this coupon?';

  @override
  String get cameraUsageDescription => 'This app needs camera access to register coupons.';

  @override
  String get photoLibraryUsageDescription => 'This app needs photo library access to select coupon images.';

  @override
  String get needPermission => 'Permission Needed';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get permissionDescription => 'To continue using, please allow permissions in settings.';

  @override
  String get couponDetailTitle => 'Coupon Detail';

  @override
  String get couponNotFound => 'Coupon not found.';

  @override
  String get couponDetailCodeLabel => 'Code';

  @override
  String get couponDetailMemoLabel => 'Memo';

  @override
  String get couponDetailValidDateLabel => 'Valid Until';

  @override
  String get selectModeTooltip => 'Select Mode';

  @override
  String get deleteFolderTitle => 'Delete Folder';

  @override
  String get deleteFolderMessage => 'Are you sure you want to delete this folder?';

  @override
  String get enableAlarmLabel => 'Enable Alarm';

  @override
  String reminder(int days) {
    return 'Your coupon will expire in $days day(s).';
  }

  @override
  String get reminder_0d => 'Your coupon expires today!';

  @override
  String get couponExpireNotificationTitle => 'Coupon Expiration Reminder';

  @override
  String get firstAlarmLabel => 'Alarm';

  @override
  String get secondAlarmLabel => 'Second Alarm';

  @override
  String get noAlarmDropdownItem => 'None';

  @override
  String daysBeforeDropdownItem(int days) {
    return '$days day(s) before';
  }

  @override
  String get onTheDayDropdownItem => 'On the day';

  @override
  String get settingsReminderTitle => 'Expiration Reminder';

  @override
  String get settingsDataManagementTitle => 'Data Management';

  @override
  String get noCouponsDescription => 'No coupons yet.\nTap the + button to add one.';

  @override
  String get dataManagementTitle => 'Data Management';

  @override
  String get clearAllDataLabel => 'Clear All Data';

  @override
  String get deleteAllDataDialogTitle => 'Delete All Data?';

  @override
  String get deleteAllDataDialogMessage => 'This will permanently delete all your coupons and folders. This action cannot be undone.';

  @override
  String get allDataDeletedMessage => 'All data has been deleted.';
}
