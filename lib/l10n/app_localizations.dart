import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// The title of the app
  ///
  /// In en, this message translates to:
  /// **'Coupon Place'**
  String get appTitle;

  /// The title for the home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// The title for the coupon registration screen
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get couponRegisterTitle;

  /// The title for the coupon editing screen
  ///
  /// In en, this message translates to:
  /// **'Edit Coupon'**
  String get couponEditTitle;

  /// The title for the user's coupons list
  ///
  /// In en, this message translates to:
  /// **'My Coupons'**
  String get myCouponsTitle;

  /// The title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Tooltip for the add coupon button
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get couponRegisterTooltip;

  /// Label for a confirmation button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Label for a cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for a save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for an edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Label for a delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for the coupon name input field
  ///
  /// In en, this message translates to:
  /// **'Coupon Name'**
  String get couponNameLabel;

  /// Hint text for the coupon name input field
  ///
  /// In en, this message translates to:
  /// **'Enter coupon name'**
  String get couponNameHint;

  /// Label for the coupon's valid date
  ///
  /// In en, this message translates to:
  /// **'Valid Date'**
  String get validDateLabel;

  /// Hint text for selecting a valid date
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get validDateHint;

  /// Label for the coupon code input field
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCodeLabel;

  /// Label for the memo input field
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memoLabel;

  /// Label for the folder selection field
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get folderLabel;

  /// Hint text for selecting a folder
  ///
  /// In en, this message translates to:
  /// **'Please select a folder'**
  String get folderHint;

  /// Label for enabling or disabling the expiry alarm
  ///
  /// In en, this message translates to:
  /// **'Enable Expiry Alarm'**
  String get alarmLabel;

  /// Label or button to select an image
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get imageSelect;

  /// Label for the camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Label for the photo library option
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Placeholder text for registering a coupon
  ///
  /// In en, this message translates to:
  /// **'Register your coupon.'**
  String get registerCouponPlaceholder;

  /// Label for adding a new folder
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get folderAdd;

  /// Label for managing folders
  ///
  /// In en, this message translates to:
  /// **'Manage Folders'**
  String get folderManage;

  /// Hint text for entering a folder name
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get folderNameHint;

  /// Error message when folder name is left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder name'**
  String get folderNameEmptyError;

  /// Prompt to create a folder before proceeding
  ///
  /// In en, this message translates to:
  /// **'Please create a folder first.'**
  String get folderCreateFirst;

  /// Title for the delete coupon confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Coupon'**
  String get deleteCouponTitle;

  /// Content message for the delete coupon confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this coupon?'**
  String get deleteCouponContent;

  /// Description explaining why camera access is needed
  ///
  /// In en, this message translates to:
  /// **'This app needs camera access to register coupons.'**
  String get cameraUsageDescription;

  /// Description explaining why photo library access is needed
  ///
  /// In en, this message translates to:
  /// **'This app needs photo library access to select coupon images.'**
  String get photoLibraryUsageDescription;

  /// Title indicating that a permission is required
  ///
  /// In en, this message translates to:
  /// **'Permission Needed'**
  String get needPermission;

  /// Button label to navigate to device settings
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// Message prompting the user to allow permissions
  ///
  /// In en, this message translates to:
  /// **'To continue using, please allow permissions in settings.'**
  String get permissionDescription;

  /// Title for the coupon detail screen
  ///
  /// In en, this message translates to:
  /// **'Coupon Detail'**
  String get couponDetailTitle;

  /// Message displayed when a coupon cannot be found
  ///
  /// In en, this message translates to:
  /// **'Coupon not found.'**
  String get couponNotFound;

  /// Label for the coupon code in the detail view
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get couponDetailCodeLabel;

  /// Label for the memo in the coupon detail view
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get couponDetailMemoLabel;

  /// Label for the valid date in the coupon detail view
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get couponDetailValidDateLabel;

  /// Tooltip for the select mode button
  ///
  /// In en, this message translates to:
  /// **'Select Mode'**
  String get selectModeTooltip;

  /// Title for the delete folder confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get deleteFolderTitle;

  /// Message for the delete folder confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder?'**
  String get deleteFolderMessage;

  /// Label for enabling the alarm feature
  ///
  /// In en, this message translates to:
  /// **'Enable Alarm'**
  String get enableAlarmLabel;

  /// Notification message for coupon expiring in a certain number of days
  ///
  /// In en, this message translates to:
  /// **'Your coupon will expire in {days} day(s).'**
  String reminder(int days);

  /// Notification message for coupon expiring today
  ///
  /// In en, this message translates to:
  /// **'Your coupon expires today!'**
  String get reminder_0d;

  /// Title for the coupon expiration notification
  ///
  /// In en, this message translates to:
  /// **'Coupon Expiration Reminder'**
  String get couponExpireNotificationTitle;

  /// first alarm setting label
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get firstAlarmLabel;

  /// second alarm setting label
  ///
  /// In en, this message translates to:
  /// **'Second Alarm'**
  String get secondAlarmLabel;

  /// Label indicating no alarm is set
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noAlarmDropdownItem;

  /// Label indicating the number of days before an event
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) before'**
  String daysBeforeDropdownItem(int days);

  /// Label indicating the event occurs on the day itself
  ///
  /// In en, this message translates to:
  /// **'On the day'**
  String get onTheDayDropdownItem;

  /// Title for the coupon expiration reminder section in settings screen
  ///
  /// In en, this message translates to:
  /// **'Expiration Reminder'**
  String get settingsReminderTitle;

  /// Title for the data management section in settings screen
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsDataManagementTitle;

  /// Message displayed when there are no coupons available
  ///
  /// In en, this message translates to:
  /// **'No coupons yet.\nTap the + button to add one.'**
  String get noCouponsDescription;

  /// Title for the data management screen
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagementTitle;

  /// Label for the button to clear all data
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllDataLabel;

  /// Title for the delete all data confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete All Data?'**
  String get deleteAllDataDialogTitle;

  /// Message for the delete all data confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your coupons and folders. This action cannot be undone.'**
  String get deleteAllDataDialogMessage;

  /// Message displayed after all data has been successfully deleted
  ///
  /// In en, this message translates to:
  /// **'All data has been deleted.'**
  String get allDataDeletedMessage;

  /// Text for the data backup button
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get dataBackupLabel;

  /// Title of the data backup dialog
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get dataBackupDialogTitle;

  /// Message shown in the data backup confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Would you like to back up all coupons, folders, and settings data in the app?'**
  String get dataBackupDialogMessage;

  /// Text for the data restore button
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get dataRestoreLabel;

  /// Title of the data restore dialog
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get dataRestoreDialogTitle;

  /// Message shown in the data restore confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Would you like to load the backup and overwrite existing data?'**
  String get dataRestoreDialogMessage;

  /// Message displayed after data restore is complete
  ///
  /// In en, this message translates to:
  /// **'Data restore completed successfully.'**
  String get dataRestoreDoneMessage;

  /// Label for the button to mark a coupon as used
  ///
  /// In en, this message translates to:
  /// **'Mark as used'**
  String get markAsUsedLabel;

  /// Label for the button to cancel the used status of a coupon
  ///
  /// In en, this message translates to:
  /// **'Cancel used status'**
  String get restoreUseLabel;

  /// Message displayed after a coupon has been marked as used
  ///
  /// In en, this message translates to:
  /// **'Coupon marked as used'**
  String get couponUseMarkedMessage;

  /// Message displayed after the use of a coupon has been cancelled
  ///
  /// In en, this message translates to:
  /// **'Coupon marked as unused'**
  String get couponUseRestoredMessage;

  /// Label for setting the reminder time
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeLabel;

  /// Placeholder text for selecting a time
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTimePlaceholder;

  /// Tooltip for the edit folder button
  ///
  /// In en, this message translates to:
  /// **'Edit Folder'**
  String get editFolderTooltip;

  /// Label for the coupon expiry date on the coupon detail screen
  ///
  /// In en, this message translates to:
  /// **'Valid Date: {date}'**
  String couponListItemExpiryLabel(String date);

  /// Label for the coupon memo on the coupon detail screen
  ///
  /// In en, this message translates to:
  /// **'memo: {memo}'**
  String couponListItemMemoLabel(String memo);

  /// Message shown when a coupon is moved to another folder and is no longer visible in the detail screen
  ///
  /// In en, this message translates to:
  /// **'The coupon has been moved to another folder.'**
  String get couponMovedFolderMessage;

  /// Backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Save Backup'**
  String get saveBackupDialogTitle;

  /// Message shown to the user when the backup file has been created and saved successfully.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully.'**
  String get backupSuccess;

  /// Message displayed when the user cancels the save dialog during the backup process.
  ///
  /// In en, this message translates to:
  /// **'Backup was cancelled.'**
  String get backupCancelled;

  /// Message shown when an error occurs during file creation, compression, or saving.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during backup.'**
  String get backupError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
