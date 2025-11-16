import 'package:coupon_place/src/features/coupon/provider/coupon_list_provider.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataClearManager {
  static Future<void> clearAll(WidgetRef ref) async {
    await ref.read(allCouponsProvider.notifier).clearAll();
    await ref.read(folderProvider.notifier).clearAll();
    final imageDirectory = await FileHelper.getImagesDirectory();
    imageDirectory.deleteSync(recursive: true);
  }
}
