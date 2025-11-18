import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class FileHelper {
  static final String imagesRootDirName = 'coupon_images';
  static final String _imageNamePrefix = 'cp_';

  // 캐싱된 디렉토리
  static Directory? _cachedImagesDir;

  /// 앱 실행 시 반드시 한 번 호출
  static Future<void> init() async {
    _cachedImagesDir = await getImagesDirectory();
  }

  static Future<Directory> getImagesDirectory() async {
    if (_cachedImagesDir != null) {
      return _cachedImagesDir!;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory(p.join(appDir.path, imagesRootDirName));
    return imagesDirectory;
  }

  static bool existsImageInApp(String? fileName) {
    if (fileName == null) {
      return false;
    }
    if (_cachedImagesDir == null) {
      return false;
    }

    final file = File(p.join(_cachedImagesDir!.path, fileName));
    return file.existsSync();
  }

  static String getImageAbsolutePath(String imagePath) {
    if (isNotInAppDir(imagePath)) {
      return imagePath;
    }
    if (_cachedImagesDir == null) {
      return imagePath;
    }
    return p.join(_cachedImagesDir!.path, imagePath);
  }

  static Future<String> _getNewImageFileName(String path) async {
    final extension = p.extension(path);
    return _imageNamePrefix + Uuid().v4() + extension;
  }

  static Future<String> saveImageToAppDir(String originPath) async {
    if (!File(originPath).existsSync()) {
      return '';
    }
    if (FileHelper.isInAppDir(originPath)) {
      return originPath;
    }
    final fileName = await _getNewImageFileName(originPath);
    final imagesDirectory = await getImagesDirectory();
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }
    final savedPath = p.join(imagesDirectory.path, fileName);

    await File(originPath).copy(savedPath);
    return fileName;
  }

  static void deleteFile(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  static bool isInAppDir(String filePath) {
    return filePath.startsWith(_imageNamePrefix);
  }

  static bool isNotInAppDir(String filePath) {
    return !isInAppDir(filePath);
  }

  static void deleteImageFile(String? filePath) {
    if (filePath == null) {
      return;
    }
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
    final imagePath = getImageAbsolutePath(filePath);
    final imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      imageFile.deleteSync();
    }
  }
}
