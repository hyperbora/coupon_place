import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  mainTab(name: 'mainTab', path: '/'),
  couponList(name: 'folderDetail', path: '/folder/:folderId'),
  couponDetail(name: 'couponDetail', path: '/coupon/:folderId/:couponId'),
  couponFormNew(name: 'couponFormNew', path: '/coupon/new/:folderId?'),
  couponFormEdit(
    name: 'couponFormEdit',
    path: '/coupon/:folderId/:couponId/edit',
  ),
  dataManagementSettings(
    name: 'dataManagementSettings',
    path: '/settings/dataManagement',
  );

  String buildPath(Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll(':$key?', value);
      result = result.replaceAll(':$key', value);
    });
    return result;
  }

  void go(
    BuildContext context, {
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    context.goNamed(
      name,
      pathParameters: pathParams ?? const {},
      queryParameters: queryParams ?? const {},
      extra: extra,
    );
  }

  void push(
    BuildContext context, {
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
    Object? extra,
  }) {
    context.pushNamed(
      name,
      pathParameters: pathParams ?? const {},
      queryParameters: queryParams ?? const {},
      extra: extra,
    );
  }

  const AppRoutes({required this.name, required this.path});

  final String name;
  final String path;
}
