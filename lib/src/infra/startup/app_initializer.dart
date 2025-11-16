import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/features/settings/model/user_reminder_setting.dart';
import 'package:coupon_place/src/infra/local_db/box_names.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/notification/user_reminder_repository.dart';
import 'package:coupon_place/src/infra/prefs/shared_preferences_keys.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 실행 시 필요한 모든 초기화 과정을 담당합니다.
/// - 최초 실행 시 기본 폴더 및 사용자 설정 생성
class AppInitializer {
  /// 앱 전체 초기화 (앱 시작 시 1회 호출)
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait([
      _initDotenv(),
      _initNotifications(),
      _initFileHelder(),
      _initHive(),
      _initAdmob(),
    ]);

    await _configureFirstLaunch();
  }

  static Future<void> _initDotenv() async {
    await dotenv.load(fileName: ".env");
  }

  /// 로컬 알림 초기화
  static Future<void> _initNotifications() async {
    await initNotifications();
  }

  static Future<void> _initFileHelder() async {
    await FileHelper.init();
  }

  /// Hive 초기화 및 어댑터 등록
  static Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CouponAdapter());
    Hive.registerAdapter(FolderAdapter());

    await Future.wait(
      BoxNames.values.map((boxName) {
        if (boxName.type == Coupon) {
          return Hive.openBox<Coupon>(boxName.value);
        } else if (boxName.type == Folder) {
          return Hive.openBox<Folder>(boxName.value);
        } else {
          throw Exception('Unknown box type: ${boxName.type}');
        }
      }),
    );
  }

  static Future<void> _initAdmob() async {
    await MobileAds.instance.initialize();
  }

  /// 앱 최초 실행 시 기본 폴더 및 기본 설정 생성
  static Future<void> _configureFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch =
        prefs.getBool(SharedPreferencesKeys.firstLaunchKey.value) ?? true;

    if (!isFirstLaunch) return;

    await prefs.setBool(SharedPreferencesKeys.firstLaunchKey.value, false);

    await _addDefaultFolder();
    await _setDefaultUserReminder();
  }

  /// 기본 폴더 생성
  static Future<void> _addDefaultFolder() async {
    final container = ProviderContainer();
    container
        .read(folderProvider.notifier)
        .addFolder('My Folder', Colors.blue, Icons.folder);
  }

  /// 사용자 기본 알림 설정 등록
  static Future<void> _setDefaultUserReminder() async {
    final defaultSetting = UserReminderSetting(
      firstReminderDays: 7,
      secondReminderDays: 1,
      reminderHour: 9,
      reminderMinute: 0,
    );

    final userReminderRepository = UserReminderRepository();
    await userReminderRepository.save(defaultSetting);
  }
}
