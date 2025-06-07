import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class CouponRegisterScreen extends StatefulWidget {
  const CouponRegisterScreen({super.key});

  @override
  State<CouponRegisterScreen> createState() => _CouponRegisterScreenState();
}

class _CouponRegisterScreenState extends State<CouponRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _memoController = TextEditingController();
  String? _selectedFolder;
  bool _enableAlarm = false;
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('이미지 선택'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: const Text('카메라'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: const Text('라이브러리'),
              ),
            ],
          ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("쿠폰등록"),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('취소'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(); // 이후 저장 로직 연결
              }
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('저장'),
          ),
        ],
      ),
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
                        GestureDetector(
                          onTap: _pickImage,
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  _imageFile != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _imageFile!,
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
                                        _imageFile != null
                                            ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black45,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            )
                                            : SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: '쿠폰 이름',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '쿠폰 이름을 입력하세요';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: _pickDate,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: '유효기간',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Text(
                                    _selectedDate != null
                                        ? _selectedDate.toString().split(' ')[0]
                                        : '날짜를 선택하세요',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _codeController,
                                decoration: const InputDecoration(
                                  labelText: '쿠폰 코드',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _memoController,
                                decoration: const InputDecoration(
                                  labelText: '메모',
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedFolder,
                                items:
                                    ['카페', '편의점', '영화'].map((folder) {
                                      return DropdownMenuItem(
                                        value: folder,
                                        child: Text(folder),
                                      );
                                    }).toList(),
                                onChanged:
                                    (value) =>
                                        setState(() => _selectedFolder = value),
                                decoration: const InputDecoration(
                                  labelText: '폴더 선택',
                                ),
                                validator:
                                    (value) =>
                                        value == null ? '폴더를 선택하세요' : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text('유효기간 알림 설정'),
                                  Switch(
                                    value: _enableAlarm,
                                    onChanged: (value) {
                                      setState(() {
                                        _enableAlarm = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
