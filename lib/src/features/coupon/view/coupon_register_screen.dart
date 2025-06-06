import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class CouponRegisterScreen extends StatefulWidget {
  const CouponRegisterScreen({super.key});

  @override
  State<CouponRegisterScreen> createState() => _CouponRegisterScreenState();
}

class _CouponRegisterScreenState extends State<CouponRegisterScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(
                  _imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
                : const Text('쿠폰을 등록하세요.'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _pickImage, child: const Text('이미지 선택')),
          ],
        ),
      ),
    );
  }
}
