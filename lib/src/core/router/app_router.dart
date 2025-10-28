import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_form_screen.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_list_screen.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_detail_screen.dart';
import 'package:coupon_place/src/features/main_tab/main_tab_screen.dart';
import 'package:coupon_place/src/features/settings/screen/data_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      name: AppRoutes.mainTab.name,
      path: AppRoutes.mainTab.path,
      builder: (context, state) => const MainTabScreen(),
    ),
    GoRoute(
      name: AppRoutes.couponList.name,
      path: AppRoutes.couponList.path,
      builder: (context, state) {
        final folderId = state.pathParameters['folderId'];
        return CouponListScreen(folderId: folderId!);
      },
    ),
    GoRoute(
      name: AppRoutes.couponFormNew.name,
      path: AppRoutes.couponFormNew.path,
      builder: (context, state) => CouponFormScreen(),
    ),
    GoRoute(
      name: AppRoutes.couponDetail.name,
      path: AppRoutes.couponDetail.path,
      builder: (context, state) {
        final folderId = state.pathParameters['folderId']!;
        final couponId = state.pathParameters['couponId']!;
        return CouponDetailScreen(folderId: folderId, couponId: couponId);
      },
    ),
    GoRoute(
      name: AppRoutes.couponFormEdit.name,
      path: AppRoutes.couponFormEdit.path,
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
    GoRoute(
      name: AppRoutes.dataManagementSettings.name,
      path: AppRoutes.dataManagementSettings.path,
      builder: (context, state) => const DataManagementScreen(),
    ),
  ],
);
