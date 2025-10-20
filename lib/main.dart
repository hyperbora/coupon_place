import 'package:coupon_place/src/app.dart';
import 'package:coupon_place/src/infra/startup/app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}
