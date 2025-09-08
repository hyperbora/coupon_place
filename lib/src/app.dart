import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_form_screen.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_list_screen.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_detail_screen.dart';
import 'package:coupon_place/src/features/main_tab/main_tab_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.mainTab,
          builder: (context, state) => const MainTabScreen(),
        ),
        GoRoute(
          path: AppRoutes.folderDetail,
          builder: (context, state) {
            final folderId = state.pathParameters['folderId'];
            final folderName = state.extra as String? ?? '';
            return CouponListScreen(
              folderId: folderId!,
              folderName: folderName,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.couponFormNew,
          builder: (context, state) => CouponFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.couponDetail,
          builder: (context, state) {
            final folderId = state.pathParameters['folderId']!;
            final couponId = state.pathParameters['couponId']!;
            return CouponDetailScreen(folderId: folderId, couponId: couponId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final folderId = state.pathParameters['folderId']!;
                final couponId = state.pathParameters['couponId']!;
                return CouponFormScreen(
                  folderId: folderId,
                  couponId: couponId,
                  key: ValueKey(couponId),
                );
              },
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Coupon Place',
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepPurple,
        useMaterial3: true,
      ).copyWith(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko'), Locale('en')],
    );
  }
}
