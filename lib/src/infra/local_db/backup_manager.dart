import 'dart:convert';
import 'dart:io';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/infra/local_db/backup_status.dart';
import 'package:coupon_place/src/infra/local_db/box_names.dart';
import 'package:coupon_place/src/infra/prefs/shared_preferences_keys.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  static const _sharedPreferencesJsonFile = "SharedPreferences.json";

  static Future<BackupStatus> createBackupAndSave(
    String saveBackupDialogTitle,
  ) async {
    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final String backupFileName = 'coupon_place_backup_$timestamp.zip';
    final internalZipPath = '${appDir.path}/$backupFileName';
    final tempDir = Directory('${appDir.path}/backup_temp');
    try {
      if (tempDir.existsSync()) await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);

      for (final boxName in BoxNames.values) {
        if (boxName.type == Coupon) {
          await _exportBoxJson<Coupon>(boxName.value, tempDir);
        } else if (boxName.type == Folder) {
          await _exportBoxJson<Folder>(boxName.value, tempDir);
        } else {
          throw Exception('Unknown box type: ${boxName.type}');
        }
      }

      final imagesDir = Directory(
        '${appDir.path}/${FileHelper.imagesRootDirName}',
      );
      if (imagesDir.existsSync()) {
        final target = Directory(
          '${tempDir.path}/${FileHelper.imagesRootDirName}',
        );
        await _copyDirectory(imagesDir, target);
      }

      await _exportSharedPreferences(tempDir);

      final zipFile = File(internalZipPath);

      await ZipFile.createFromDirectory(
        sourceDir: tempDir,
        zipFile: zipFile,
        includeBaseDirectory: false,
        recurseSubDirs: true,
      );

      final bytes = await zipFile.readAsBytes();

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: saveBackupDialogTitle,
        fileName: backupFileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: bytes,
      );

      if (savePath != null && savePath.isNotEmpty) {
        return BackupStatus.success;
      } else {
        return BackupStatus.cancelled;
      }
    } catch (e) {
      return BackupStatus.error;
    } finally {
      await tempDir.delete(recursive: true);
      final zipFile = File(internalZipPath);
      if (zipFile.existsSync()) await zipFile.delete();
    }
  }

  static Future<void> _exportBoxJson<T>(
    String boxName,
    Directory targetDir,
  ) async {
    final box = Hive.box<T>(boxName);
    final jsonList =
        box.values.map((e) {
          if (e is Coupon) {
            return e.toJson();
          } else if (e is Folder) {
            return e.toJson();
          } else {
            return e;
          }
        }).toList();

    final file = File('${targetDir.path}/$boxName.json');
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<void> _exportSharedPreferences(Directory targetDir) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> rawJsonMap = {};

    for (final key in SharedPreferencesKeys.values) {
      final value = prefs.get(key.value);
      rawJsonMap[key.value] = value;
    }

    final file = File('${targetDir.path}/$_sharedPreferencesJsonFile');
    await file.writeAsString(jsonEncode(rawJsonMap));
  }

  static Future<void> _copyDirectory(Directory src, Directory dst) async {
    await dst.create(recursive: true);

    await for (var entity in src.list(recursive: false)) {
      if (entity is Directory) {
        final newDir = Directory('${dst.path}/${entity.uri.pathSegments.last}');
        await _copyDirectory(entity, newDir);
      } else if (entity is File) {
        final newFile = File('${dst.path}/${entity.uri.pathSegments.last}');
        await newFile.writeAsBytes(await entity.readAsBytes());
      }
    }
  }
}
