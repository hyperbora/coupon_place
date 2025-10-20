import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/prefs/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 시작 시 수행되는 모든 초기화 로직을 담당합니다.
/// - 최초 실행 시 기본 폴더 생성
class AppInitializer {
  static Future<void> initAll() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initNotifications();
    await _initHive();
    await _openHiveBoxes();
    await _addDefaultFolderIfNeeded();
  }

  static Future<void> _initNotifications() async {
    await initNotifications();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CouponAdapter());
    Hive.registerAdapter(FolderAdapter());
  }

  static Future<void> _openHiveBoxes() async {
    await Hive.openBox<Coupon>('coupons');
    await Hive.openBox<Folder>('folders');
  }

  static Future<void> _addDefaultFolderIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch =
        prefs.getBool(SharedPreferencesKeys.firstLaunchKey) ?? true;

    if (isFirstLaunch) {
      final container = ProviderContainer();
      container
          .read(folderProvider.notifier)
          .addFolder('My Folder', Colors.blue, Icons.folder);

      await prefs.setBool(SharedPreferencesKeys.firstLaunchKey, false);
    }
  }
}
