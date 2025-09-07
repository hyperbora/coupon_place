import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class FileHelper {
  static final String imagesRootDirName = 'images';
  static Future<String> saveImageToAppDir(String originPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final folderName = DateFormat('yyyyMMdd').format(DateTime.now());
    final fileName = const Uuid().v4();
    final folderDir = Directory(
      p.join(appDir.path, imagesRootDirName, folderName),
    );
    if (!await folderDir.exists()) {
      await folderDir.create(recursive: true);
    }
    final savedPath = p.join(folderDir.path, fileName);
    final savedFile = await File(originPath).copy(savedPath);
    return savedFile.path;
  }

  static Future<bool> isInAppDir(String filePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    return File(filePath).absolute.path.startsWith(appDir.path);
  }

  static Future<bool> isNotInAppDir(String filePath) async {
    return isInAppDir(filePath).then((value) => !value);
  }
}
