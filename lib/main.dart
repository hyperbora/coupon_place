import 'package:coupon_place/src/app.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/prefs/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Hive.initFlutter();
  Hive.registerAdapter(CouponAdapter());
  Hive.registerAdapter(FolderAdapter());
  await Hive.openBox<Coupon>('coupons');
  await Hive.openBox<Folder>('folders');
  await addDefaultFolderIfPossible();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> addDefaultFolderIfPossible() async {
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
