import 'dart:io';
import 'package:coupon_place/src/infra/config/env_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? dotenv.env[EnvKey.admobBannerIdAndroid.value] ?? ''
          : 'ca-app-pub-3940256099942544/9214589741';
    } else if (Platform.isIOS) {
      return kReleaseMode
          ? dotenv.env[EnvKey.admobBannerIdIos.value] ?? ''
          : 'ca-app-pub-3940256099942544/2435281174';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
