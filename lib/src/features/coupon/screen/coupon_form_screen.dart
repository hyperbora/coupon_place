import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:coupon_place/src/features/coupon/provider/coupon_list_provider.dart';
import 'package:coupon_place/src/shared/utils/icon_mapping.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/coupon/provider/coupon_register_provider.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CouponFormScreen extends ConsumerStatefulWidget {
  final String? couponId;
  final String? folderId;

  const CouponFormScreen({super.key, this.folderId, this.couponId});

  static final _formKey = GlobalKey<FormState>();

  @override
  ConsumerState<CouponFormScreen> createState() => _CouponFormScreenState();
}

class _CouponFormScreenState extends ConsumerState<CouponFormScreen> {
  Coupon? coupon;
  bool _initialized = false;

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<bool> _checkPermission(
    BuildContext context,
    ImageSource source,
  ) async {
    final Permission permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied || status.isDenied) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getPermissionDescription(source, AppLocalizations.of(context)!),
            ),
          ),
        );
      }
    }
    return false;
  }

  void _showPermissionDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(loc.needPermission),
            content: Text(loc.permissionDescription),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await openAppSettings();
                },
                child: Text(loc.goToSettings),
              ),
            ],
          ),
    );
  }

  String _getPermissionDescription(ImageSource source, AppLocalizations loc) {
    if (source == ImageSource.camera) {
      return loc.cameraUsageDescription;
    } else {
      return loc.photoLibraryUsageDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(couponRegisterProvider);
    final notifier = ref.read(couponRegisterProvider.notifier);
    final folders = ref.watch(folderProvider).folders;

    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.reset(); // build 완료 후에 안전하게 상태 초기화
        if (widget.couponId != null && widget.folderId != null) {
          final couponList =
              ref.read(couponListProvider(widget.folderId!)).coupons;
          final foundCoupon = couponList.firstWhere(
            (c) => c.id == widget.couponId,
          );
          coupon = foundCoupon;
          notifier.setName(foundCoupon.name);
          notifier.setCode(foundCoupon.code ?? '');
          notifier.setMemo(foundCoupon.memo ?? '');
          notifier.setValidDate(foundCoupon.validDate);
          notifier.setImagePath(foundCoupon.imagePath);
          notifier.setFolder(foundCoupon.folderId);
          notifier.setEnableAlarm(foundCoupon.enableAlarm);

          _nameController.text = foundCoupon.name;
          _codeController.text = foundCoupon.code ?? '';
          _memoController.text = foundCoupon.memo ?? '';
        } else if (widget.folderId != null) {
          notifier.setFolder(widget.folderId!);
        }
      });
      _initialized = true;
    }

    Future<void> pickImage() async {
      final source = await showDialog<ImageSource>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(loc.imageSelect),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(ImageSource.camera),
                  child: Text(loc.camera),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(ImageSource.gallery),
                  child: Text(loc.library),
                ),
              ],
            ),
      );

      if (source == null) return;

      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: source);

        if (pickedFile != null) {
          notifier.setImagePath(pickedFile.path);
        }
      } catch (e) {
        if (context.mounted) {
          await _checkPermission(context, source);
        }
      }
    }

    Future<void> pickDate() async {
      final initial =
          ref.read(couponRegisterProvider).validDate ?? DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(couponRegisterProvider.notifier).setValidDate(picked);
      }
    }

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Text(
          widget.couponId == null
              ? loc.couponRegisterTitle
              : loc.couponEditTitle,
        ),
        leading: TextButton(
          onPressed: () {
            notifier.reset();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(loc.cancel),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (!CouponFormScreen._formKey.currentState!.validate()) {
                return;
              }

              String? savedImagePath;
              if (state.imageFilePath != null &&
                  await FileHelper.isNotInAppDir(state.imageFilePath!)) {
                savedImagePath = await FileHelper.saveImageToAppDir(
                  state.imageFilePath!,
                );
              }

              final newCoupon =
                  widget.couponId == null
                      ? Coupon.create(
                        name: state.name,
                        code: state.code,
                        memo: state.memo,
                        validDate: state.validDate,
                        imagePath: savedImagePath,
                        folderId: state.folder!,
                        enableAlarm: state.enableAlarm,
                        order:
                            ref
                                .read(couponListProvider(state.folder!))
                                .coupons
                                .length,
                      )
                      : coupon!.copyWith(
                        name: state.name,
                        code: state.code,
                        memo: state.memo,
                        validDate: state.validDate,
                        imagePath: savedImagePath ?? coupon!.imagePath,
                        folderId: state.folder!,
                        enableAlarm: state.enableAlarm,
                      );
              if (widget.couponId == null) {
                ref
                    .read(couponListProvider(state.folder!).notifier)
                    .addCoupon(newCoupon, loc);
              } else {
                ref
                    .read(couponListProvider(state.folder!).notifier)
                    .updateCoupon(newCoupon, loc);
              }
              notifier.reset();

              if (context.mounted) {
                if (widget.folderId == null) {
                  Navigator.of(context).pop();
                  final folder = folders.firstWhere(
                    (f) => f.id == state.folder,
                  );
                  AppRoutes.couponList.push(
                    context,
                    pathParams: {'folderId': folder.id},
                    extra: folder.name,
                  );
                  return;
                }
                if (widget.folderId == state.folder) {
                  Navigator.of(context).pop();
                  return;
                }
                if (widget.folderId != state.folder) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.couponMovedFolderMessage)),
                  );
                  Navigator.of(context).pop();
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              }
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(loc.save),
          ),
        ],
        centerTitle: true,
      );
    }

    bool imageExists(String? path) {
      if (path == null) return false;
      final file = File(path);
      return file.existsSync();
    }

    Widget buildImagePicker() {
      final imagePath = state.imageFilePath ?? coupon?.imagePath;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GestureDetector(
          onTap: pickImage,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                imageExists(imagePath)
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        child: Image.file(
                          File(imagePath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                    : Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),
                Positioned(
                  top: 8,
                  right: 8,
                  child:
                      imageExists(imagePath)
                          ? GestureDetector(
                            onTap: () {
                              notifier.setImagePath(null);
                              coupon = coupon?.withImagePath(null);
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildFormFields() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: loc.couponNameLabel),
              onChanged: notifier.setName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.couponNameHint;
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: loc.validDateLabel,
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  state.validDate != null
                      ? state.validDate.toString().split(' ')[0]
                      : loc.validDateHint,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: loc.couponCodeLabel),
              onChanged: notifier.setCode,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _memoController,
              decoration: InputDecoration(labelText: loc.memoLabel),
              maxLines: 2,
              onChanged: notifier.setMemo,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: state.folder ?? widget.folderId,
              items:
                  folders
                      .map(
                        (folder) => DropdownMenuItem(
                          value: folder.id,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(folder.colorValue),
                                radius: 10,
                                child: Icon(
                                  iconMapping[folder.iconCodePoint],
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(folder.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              onChanged: notifier.setFolder,
              decoration: InputDecoration(labelText: loc.folderLabel),
              validator: (value) => value == null ? loc.folderHint : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loc.alarmLabel),
                Switch(
                  value: state.enableAlarm,
                  onChanged: notifier.setEnableAlarm,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: CouponFormScreen._formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        buildImagePicker(),
                        const SizedBox(height: 16),
                        buildFormFields(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
