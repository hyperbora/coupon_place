import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/src/features/coupon/provider/coupon_register_provider.dart';

class CouponRegisterScreen extends ConsumerWidget {
  const CouponRegisterScreen({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(couponRegisterProvider);
    final notifier = ref.read(couponRegisterProvider.notifier);

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

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        notifier.setImage(File(pickedFile.path));
      }
    }

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        notifier.setValidDate(picked);
      }
    }

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        title: Text(loc.couponRegisterTitle),
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
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              // 저장 로직 작성
              notifier.reset();
              Navigator.of(context).pop();
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

    Widget buildImagePicker() {
      return GestureDetector(
        onTap: pickImage,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                state.imageFile != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        state.imageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                    : Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                        size: 200,
                      ),
                    ),
                Positioned(
                  top: 8,
                  right: 8,
                  child:
                      state.imageFile != null
                          ? GestureDetector(
                            onTap: () => notifier.setImage(null),
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
              initialValue: state.name,
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
              initialValue: state.code,
              decoration: InputDecoration(labelText: loc.couponCodeLabel),
              onChanged: notifier.setCode,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: state.memo,
              decoration: InputDecoration(labelText: loc.memoLabel),
              maxLines: 2,
              onChanged: notifier.setMemo,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: state.folder,
              items:
                  ['카페', '편의점', '영화'].map((folder) {
                    return DropdownMenuItem(value: folder, child: Text(folder));
                  }).toList(),
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
                    key: _formKey,
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
